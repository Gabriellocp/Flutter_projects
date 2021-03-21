import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messagechat/chat_message.dart';
import 'package:messagechat/text_composer.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseUser _currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<FirebaseUser> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount accountGoogle = await googleSignIn.signIn();

      final GoogleSignInAuthentication authenticationGoogle =
          await accountGoogle.authentication;

      final AuthCredential credentialGoogle = GoogleAuthProvider.getCredential(
          idToken: authenticationGoogle.idToken,
          accessToken: authenticationGoogle.accessToken);

      final AuthResult firebaseAuth =
          await FirebaseAuth.instance.signInWithCredential(credentialGoogle);

      final FirebaseUser user = firebaseAuth.user;

      return user;
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String text, PickedFile imgFile}) async {
    final FirebaseUser user = await _getUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Login falhou",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ));
    }
    Map<String, dynamic> _uploadData = {
      "uid": user.uid,
      "senderPhotoUrl": user.photoUrl,
      "senderName": user.displayName,
      "time": Timestamp.now(),
    };

    if (imgFile != null) {
      setState(() {
        _isLoadingImage = true;
      });
      StorageUploadTask _uploadPicture = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imgFile.path));
      StorageTaskSnapshot _getImgInfo = await _uploadPicture.onComplete;
      String _imgURL = await _getImgInfo.ref.getDownloadURL();
      _uploadData['img'] = _imgURL;
      print(_imgURL);
    }
    setState(() {
      _isLoadingImage = false;
    });
    if (text != null) {
      _uploadData['msg'] = text;
    }
    Firestore.instance.collection("messages").add(_uploadData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_currentUser != null
              ? 'Olá ${_currentUser.displayName}'
              : 'Faça Login'),
          centerTitle: true,
          actions: [
            _currentUser != null
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      googleSignIn.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Você saiu',
                        textAlign: TextAlign.center,
                      )));
                    })
                : Container()
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("messages")
                    .orderBy('time')
                    .snapshots(), //Return a QuerySnapshot
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case (ConnectionState.none):
                    case (ConnectionState.waiting):
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default: //Connection Succeeded
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents.reversed.toList();
                      return ListView.builder(
                          itemCount: documents.length,
                          reverse: true, //Mensagens DOWN-TOP
                          itemBuilder: (contex, index) {
                            return ChatMessage(
                                documents[index].data,
                                documents[index].data['uid'] ==
                                    _currentUser?.uid);
                          });
                  }
                },
              ),
            ),
            _isLoadingImage ? LinearProgressIndicator() : Container(),
            TextComposer(_sendMessage),
          ],
        ));
  }
}

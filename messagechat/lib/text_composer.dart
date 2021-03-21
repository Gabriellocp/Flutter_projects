import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  Function({String text, PickedFile imgFile}) sendMessage;
  TextComposer(this.sendMessage);
  //Same thing as above might be
  //TextComposer(this.sendMessage)
  //What it does here is that, when create the TextComposer(foo) object
  //it already attribute it's parameter foo to the sendMessage function
  //on the class

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _hasMessage = false;
  final _controller = TextEditingController();

  void _resetSendButton() {
    setState(() {
      _controller.clear();
      _hasMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          RawMaterialButton(
              child: Icon(Icons.camera_alt),
              shape: CircleBorder(),
              fillColor: Colors.white,
              splashColor: Colors.blue,
              onPressed: () async {
                PickedFile imgPickedFile =
                    await ImagePicker().getImage(source: ImageSource.camera);
                if (imgPickedFile == null) return;
                widget.sendMessage(imgFile: imgPickedFile);
              }),
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration.collapsed(
              hintText: "Nova Mensagem",
            ),
            onChanged: (text) {
              setState(() {
                _hasMessage = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.sendMessage(text: text);
              _resetSendButton();
            },
          )),
          RawMaterialButton(
              child: Icon(Icons.send),
              shape: CircleBorder(),
              fillColor: Colors.white,
              splashColor: Colors.blue,
              onPressed: _hasMessage
                  ? () {
                      widget.sendMessage(text: _controller.text);
                      _resetSendButton();
                    }
                  : null)
        ],
      ),
    );
  }
}

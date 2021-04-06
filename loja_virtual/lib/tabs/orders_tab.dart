import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';

class OrderTab extends StatelessWidget {
  final PageController _pageController;
  OrderTab(this._pageController);
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      return Scaffold(
        appBar: AppBar(
          title: Text("Meus Pedidos"),
          centerTitle: true,
        ),
        drawer: CustomDrawer(_pageController),
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .collection("orders")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs
                      .map((doc) => OrderTile(doc.id))
                      .toList()
                      .reversed
                      .toList(),
                );
              }
            }),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Meus Pedidos"),
          centerTitle: true,
        ),
        drawer: CustomDrawer(_pageController),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.view_list,
                size: 90.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Faça o Login para acompanhar",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      );
    }
  }
}

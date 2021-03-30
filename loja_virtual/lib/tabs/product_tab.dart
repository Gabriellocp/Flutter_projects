import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/products_tile.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';

class ProductTab extends StatelessWidget {
  final PageController _pageController;
  ProductTab(this._pageController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        centerTitle: true,
      ),
      drawer: CustomDrawer(_pageController),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("produtcts").get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var dividedTiles = ListTile.divideTiles(
                      tiles: snapshot.data.docs
                          .map((doc) => ProductTile(doc))
                          .toList(),
                      color: Colors.grey)
                  .toList();
              return ListView(
                children: dividedTiles,
              );
            }
          }),
    );
  }
}

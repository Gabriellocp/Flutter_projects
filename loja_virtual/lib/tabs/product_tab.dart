import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/products_tile.dart';

class ProductTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
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
        });
  }
}

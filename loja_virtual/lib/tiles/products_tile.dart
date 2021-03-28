import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/products_screen.dart';

class ProductTile extends StatelessWidget {
  final DocumentSnapshot _actuaProduct;
  ProductTile(this._actuaProduct);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(_actuaProduct.get("icon")),
      ),
      title: Text(_actuaProduct.get("title")),
      trailing: Icon(Icons.arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductScreen(_actuaProduct)));
      },
    );
  }
}

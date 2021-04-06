import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class MapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Digite seu CEP",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "CEP"),
                initialValue: "",
                onFieldSubmitted: (text) {}),
          )
        ],
      ),
    );
  }
}

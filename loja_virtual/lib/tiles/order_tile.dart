import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String id;
  OrderTile(this.id);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .doc(id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                int status = snapshot.data["status"];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Código do pedido: ${snapshot.data.id}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      _buildProductsText(snapshot.data),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Status do Pedido:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _circleBuilder("1", "Preparação", status, 1),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey,
                        ),
                        _circleBuilder("2", "Transporte", status, 2),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey,
                        ),
                        _circleBuilder("3", "Entrega", status, 3),
                      ],
                    )
                  ],
                );
              }
            },
          ),
        ));
  }

  String _buildProductsText(DocumentSnapshot snap) {
    String productText = "Descrição:\n";
    for (LinkedHashMap product in snap.get("products")) {
      productText +=
          "${product["quant"]} x ${product["product"]["title"]} -> R\$ ${product["price"].toStringAsFixed(2)} \n";
    }
    productText += "Total: R\$ ${snap.get("totalPrice").toStringAsFixed(2)}";
    return productText;
  }

  Widget _circleBuilder(
      String title, String subtitle, int status, int thisStat) {
    Color backColor;
    Widget child;

    if (status < thisStat) {
      backColor = Colors.grey;
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStat) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}

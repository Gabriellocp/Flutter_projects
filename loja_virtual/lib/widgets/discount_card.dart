import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "CUPOM"),
              initialValue: CartModel.of(context).discountCode ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection("cupons")
                    .doc(text)
                    .get()
                    .then((doc) {
                  if (doc.exists) {
                    CartModel.of(context).setCoupon(text, doc.get("percent"));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      "Cupom de ${doc.get("percent")}% aplicado!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )));
                  } else {
                    CartModel.of(context).setCoupon(null, 0);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      "CUPOM INVÁLIDO!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

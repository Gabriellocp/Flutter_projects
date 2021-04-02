import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_produtct.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct product;
  CartTile(this.product);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: 120.0,
            child: Image.network(
              product.productData.image[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.productData.title,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "Tamanho: ${product.size}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    "R\$ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: product.quantity > 1
                            ? () {
                                CartModel.of(context).decCartItem(product);
                              }
                            : null,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text("${product.quantity}"),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            CartModel.of(context).incCartItem(product);
                          },
                          color: Theme.of(context).primaryColor),
                      TextButton(
                          onPressed: () {
                            CartModel.of(context).removeCartItem(product);
                          },
                          child: Text("Remover"))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("produtcts")
                  .doc(product.category)
                  .collection("items")
                  .doc(product.productid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData = ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              })
          : _buildContent(),
    );
  }
}

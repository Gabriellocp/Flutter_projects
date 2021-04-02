import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_produtct.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  List<CartProduct> products = [];
  bool isLoading = false;
  void addCartItem(CartProduct product) {
    products.add(product);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .add(product.toMap())
        .then((doc) {
      product.id = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct product) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .doc(product.id)
        .delete();
    products.remove(product);
    notifyListeners();
  }

  void decCartItem(CartProduct product) {
    product.quantity--;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .doc(product.productid)
        .update(product.toMap());
    notifyListeners();
  }

  void incCartItem(CartProduct product) {
    product.quantity++;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .doc(product.productid)
        .update(product.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .get();
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_produtct.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  String discountCode;
  int discountPercentage = 0;
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
        .doc(product.id)
        .update(product.toMap());
    notifyListeners();
  }

  void incCartItem(CartProduct product) {
    product.quantity++;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .doc(product.id)
        .update(product.toMap());
    notifyListeners();
  }

  void setCoupon(String code, int percentage) {
    this.discountCode = code;
    this.discountPercentage = percentage;
  }

  double getPrices() {
    double totalPrice = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        totalPrice += c.quantity * c.price;
      }
    }
    return totalPrice;
  }

  double getDiscount() {
    return (getPrices() * (discountPercentage / 100));
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productsPrice = getPrices();
    double discount = getDiscount();
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientID": user.firebaseUser.uid,
      "products": products.map((product) => product.toMap()).toList(),
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount,
      "status": 1,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({"order": refOrder.id});

    QuerySnapshot productsOnCart = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in productsOnCart.docs) {
      doc.reference.delete();
    }

    products.clear();
    discountCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.id;
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

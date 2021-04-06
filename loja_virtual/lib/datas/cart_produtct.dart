import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  String id;
  String category;
  String productid;
  double price;
  int quantity;
  String size;
  ProductData productData;
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    category = snapshot.get("category");
    productid = snapshot.get("pid");
    quantity = snapshot.get("quant");
    price = snapshot.get("price");
    size = snapshot.get("size");
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": productid,
      "quant": quantity,
      "size": size,
      "price": price,
      "product": productData.toResumedMap(),
    };
  }
}

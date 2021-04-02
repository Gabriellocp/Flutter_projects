import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String description;
  List image;
  String title;
  String id;

  List price;
  List sizes;
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    description = snapshot.get("description");
    image = snapshot.get("image");
    title = snapshot.get("title");
    price = snapshot.get("price");
    sizes = snapshot.get("sizes");
    _convertToDouble();
  }

  void _convertToDouble() {
    for (int i = 0; i < price.length; i++) {
      price[i] += 0.0;
    }
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}

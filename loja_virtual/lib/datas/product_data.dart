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
  }
}

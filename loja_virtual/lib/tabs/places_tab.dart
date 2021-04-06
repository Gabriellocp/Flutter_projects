import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/place_tile.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';

class PlaceTab extends StatelessWidget {
  final PageController _pageController;
  PlaceTab(this._pageController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lojas"),
          centerTitle: true,
        ),
        drawer: CustomDrawer(_pageController),
        body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection("places").get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children:
                      snapshot.data.docs.map((doc) => PlaceTile(doc)).toList(),
                );
              }
            }));
  }
}

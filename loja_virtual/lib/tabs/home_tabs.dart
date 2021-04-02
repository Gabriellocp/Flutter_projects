import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/products_screen.dart';
import 'package:loja_virtual/screens/products_show_screen.dart';
import 'package:loja_virtual/tabs/product_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTabs extends StatelessWidget {
  final PageController _pageController;
  HomeTabs(this._pageController);
  Widget _buildBackgroundGradient() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CartButton(),
      drawer: CustomDrawer(_pageController),
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text("Novidades"),
                  centerTitle: true,
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return SliverStaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: .7,
                      crossAxisSpacing: 1.0,
                      staggeredTiles: snapshot.data.docs
                          .map((doc) =>
                              StaggeredTile.count(doc.get("x"), doc.get("y")))
                          .toList(),
                      children: snapshot.data.docs
                          .map(
                            (doc) => GestureDetector(
                              onTap: () {
                                _pageController.jumpToPage(1);
                              },
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: doc.get("url"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                },
                future: FirebaseFirestore.instance
                    .collection("imagens")
                    .orderBy("pos")
                    .get(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

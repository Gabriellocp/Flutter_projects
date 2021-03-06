import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/tabs/home_tabs.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/product_tab.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomeTabs(_pageController),
        ProductTab(_pageController),
        PlaceTab(_pageController),
        OrderTab(_pageController),
      ],
    );
  }
}

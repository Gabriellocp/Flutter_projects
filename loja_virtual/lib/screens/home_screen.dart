import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tabs.dart';
import 'package:loja_virtual/widgets/customdrawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTabs(),
          drawer: CustomDrawer(),
        )
      ],
    );
  }
}

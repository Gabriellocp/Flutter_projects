import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/drawertile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;
  CustomDrawer(this._pageController);
  Widget _buildBackgroundGradient() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(children: [
        _buildBackgroundGradient(),
        ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              padding: EdgeInsets.all(10.0),
              height: 170.0,
              child: Stack(
                children: [
                  Positioned(
                    top: 8.0,
                    left: 0.0,
                    child: Text(
                      "Loja\nVirtual",
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bem-vindo!",
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.indigo[900]),
                        ),
                        GestureDetector(
                          child: Text(
                            "Entre ou cadastre-se >",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            DrawerTile(Icons.home, "Início", _pageController, 0),
            DrawerTile(Icons.list, "Produtos", _pageController, 1),
            DrawerTile(Icons.location_on, "Lojas", _pageController, 2),
            DrawerTile(Icons.playlist_add_check, "Pedidos", _pageController, 3),
          ],
        ),
      ]),
    );
  }
}

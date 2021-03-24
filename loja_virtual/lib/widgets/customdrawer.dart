import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
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
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}

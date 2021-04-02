import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return CartScreen();
          }),
        );
      },
      child: Icon(Icons.shopping_cart_outlined),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

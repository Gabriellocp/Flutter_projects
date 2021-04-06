import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;
  OrderScreen(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            size: 120.0,
            color: Colors.green,
          ),
          Text(
            "Pedido realizado com sucesso!",
            style: TextStyle(fontSize: 25.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            "ID: $orderId",
            style: TextStyle(fontSize: 25.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

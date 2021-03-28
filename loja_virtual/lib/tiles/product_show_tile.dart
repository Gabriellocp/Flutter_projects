import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/products_show_screen.dart';

class ProductShowTile extends StatelessWidget {
  final String display;
  final ProductData product;
  ProductShowTile(this.display, this.product);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProducShowScreen(product)));
      },
      child: Card(
          child: display == "grid"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        product.image[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text("R\$ ${product.price[0].toStringAsFixed(2)}")
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    Flexible(
                      child: Image.network(
                        product.image[0],
                        fit: BoxFit.cover,
                        height: 200.0,
                      ),
                      flex: 1,
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text("R\$ ${product.price[0].toStringAsFixed(2)}")
                          ],
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                )),
    );
  }
}

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_produtct.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProducShowScreen extends StatefulWidget {
  final ProductData product;
  ProducShowScreen(this.product);
  @override
  _ProducShowScreenState createState() => _ProducShowScreenState(product);
}

class _ProducShowScreenState extends State<ProducShowScreen> {
  final ProductData product;
  String size;
  int index = 0;
  _ProducShowScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.image.map((url) => NetworkImage(url)).toList(),
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.blue,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  "R\$ ${product.price[index].toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 22.0, color: primaryColor),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 40,
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0),
                    itemCount: product.sizes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = product.sizes[index];
                            this.index = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            border: Border.all(
                                color: size == product.sizes[index]
                                    ? primaryColor
                                    : Colors.grey[300],
                                width: 3.0),
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(
                            product.sizes[index],
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 30.0,
                  child: ElevatedButton(
                    onPressed: size != null
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct product = CartProduct();
                              product.price = this.product.price[index];
                              product.size = size;
                              product.quantity = 1;
                              product.productid = this.product.id;
                              product.category = this.product.category;
                              CartModel.of(context).addCartItem(product);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Descrição do produto",
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Observações",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Observações do produto",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

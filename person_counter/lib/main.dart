import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Contador de Pessoas",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  //Variaveis
  int _people = 0;
  int _maxp = 25;
  String _tableAv = "";
  void updateChanges(int val, bool isCapacity) {
    setState(() {
      if (!isCapacity) {
        if (_people > 0 || (_people == 0 && val > 0)) {
          _people += val;
        } else if (_people == 0 && val < 0) {
          _people = 0;
        }

        if (_people <= _maxp) {
          _tableAv = "Lugares disponíveis";
        } else {
          _tableAv = "Restaurante cheio";
        }
      } else {
        if (_maxp == 0 && val < 0) {
          _maxp = 0;
        } else {
          _maxp += val;
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Capacidade Máxima: $_maxp",
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        updateChanges(1, true);
                      },
                      child: Text(
                        "+",
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        updateChanges(-1, true);
                      },
                      child: Text(
                        "-",
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
            Text(
              "Pessoas: $_people",
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                      onPressed: () {
                        updateChanges(-1, false);
                      },
                      child: Text(
                        "-1",
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                      onPressed: () {
                        updateChanges(1, false);
                      },
                      child: Text(
                        "+1",
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      )),
                ),
              ],
            ),
            Text(
              _tableAv,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}

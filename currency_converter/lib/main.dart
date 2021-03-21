import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=9cf06589';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.black,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        )),
  ));
}

Future<Map> getValues() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _actualValue = TextEditingController();
  TextEditingController _comparativeValue = TextEditingController();

  var _dropDownValues = ["USD", "EUR"];
  List<double> _oftoValues = [0.0, 0.0];

  //Itens do DropDown Menu
  var itemList = [
    DropdownMenuItem(
      child: Text(
        "Reais",
      ),
      value: "BRL",
    ),
    DropdownMenuItem(
      child: Text(
        "Dólar",
      ),
      value: "USD",
    ),
    DropdownMenuItem(
      child: Text(
        "Euro",
      ),
      value: "EUR",
    ),
  ];

  // Função que atualiza o campo do valor atual de câmbio
  void _actualChanged(String value) {
    double _actualValue = double.parse(value);
    var _thisval = _oftoValues[0];
    var _thatval = _oftoValues[1];

    _comparativeValue.text =
        ((_actualValue * _thisval) / _thatval).toStringAsFixed(2);
  }

  // Função que atualiza o campo do valor a ser comparado
  void _comparativeChanged(String value) {
    double _comparativeValue = double.parse(value);
    var _thisval = _oftoValues[0];
    var _thatval = _oftoValues[1];

    _actualValue.text =
        ((_comparativeValue * _thisval) / _thatval).toStringAsFixed(2);
  }

  void _clearAll() {
    _actualValue.text = "";
    _comparativeValue.text = "";
  }

  Widget dropDownMenuBuilder(var index, var snapshot) {
    if (_dropDownValues[index] != "BRL") {
      _oftoValues[index] =
          snapshot.data["results"]["currencies"][_dropDownValues[index]]["buy"];
    } else {
      _oftoValues[index] = 1.0;
    }
    return DropdownButton(
      items: itemList,
      dropdownColor: Colors.black,
      style: TextStyle(color: Colors.white, fontSize: 15.0),
      value: _dropDownValues[index],
      onChanged: (value) {
        setState(() {
          _dropDownValues[index] = value;
          if (value != "BRL") {
            _oftoValues[index] = snapshot.data["results"]["currencies"]
                [_dropDownValues[index]]["buy"];
          } else {
            _oftoValues[index] = 1.0;
          }
          _clearAll();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        title: Text(
          "Conversor de Câmbio",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getValues(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Icon(Icons.monetization_on, size: 150.0),
                      dropDownMenuBuilder(0, snapshot),
                      textFieldBuilder(
                          _actualValue, _dropDownValues[0], _actualChanged),
                      Divider(),
                      dropDownMenuBuilder(1, snapshot),
                      textFieldBuilder(_comparativeValue, _dropDownValues[1],
                          _comparativeChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget textFieldBuilder(
    TextEditingController controller, String label, Function _doChanges) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
    ),
    onChanged: (text) {
      if (text.isNotEmpty) {
        _doChanges(text);
      }
    },
  );
}

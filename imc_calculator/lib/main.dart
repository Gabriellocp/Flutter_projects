import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weight_cnt = TextEditingController();
  TextEditingController height_cnt = TextEditingController();
  String _infoText = "Informe seus dados";
  Text _idealWeight = Text("");
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  void _resetData() {
    weight_cnt.text = "";
    height_cnt.text = "";
    setState(() {
      _infoText = "Informe seus dados";
      _idealWeight = Text("");
    });
  }

  void _getimc() {
    setState(() {
      double weight = double.parse(weight_cnt.text);
      double height = double.parse(height_cnt.text) / 100;
      double imc = weight / (height * height);

      if (imc < 18.6) {
        _infoText = "Abaixo do Peso \n IMC: ${imc.toStringAsPrecision(3)}";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal \n IMC: ${imc.toStringAsPrecision(3)}";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText =
            "Levemente Acima do Peso \n IMC: ${imc.toStringAsPrecision(3)}";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I \n IMC: ${imc.toStringAsPrecision(3)}";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau I \n IMC: ${imc.toStringAsPrecision(3)}";
      } else if (imc > 40.0) {
        _infoText = "Obesidade Grau III \n IMC: ${imc.toStringAsPrecision(3)}";
      }

      _idealDiffWeight(imc, weight, height);
    });
  }

  void _idealDiffWeight(double imc, double weight, double height) {
    // Calcular a diferença do IMC atual para
    // chegar no IMC do peso ideal
    double new_weight;
    //1st step - Verify if IMC isn't ideal yet

    if (imc >= 18.6 && imc < 24.9) {
      _idealWeight = Text(
        "Peso já é o ideal",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green, fontSize: 25.0),
      );
    } else {
      //Calculate the diff between ideal and the actual imc value
      // the comparative imc value will be 21.75
      new_weight = 21.75 * height * height;
      _idealWeight = Text(
        "O peso ideal é ${new_weight.toStringAsPrecision(3)}",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent, fontSize: 25.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora IMC"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetData,
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person, size: 120.0, color: Colors.blue),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso em kg",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                controller: weight_cnt,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Insira um valor";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura em cm",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                controller: height_cnt,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Insira um valor";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_form.currentState.validate()) {
                        _getimc();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: _idealWeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

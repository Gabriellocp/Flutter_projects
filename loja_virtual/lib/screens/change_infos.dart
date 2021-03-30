import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ChangeInfoScreen extends StatelessWidget {
  final _adressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Dados"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  TextFormField(
                    controller: _phoneController,
                    validator: (text) {
                      if (text.isEmpty) return "Campo vazio";
                    },
                    decoration: InputDecoration(hintText: "Telefone"),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: _adressController,
                    validator: (text) {
                      if (text.isEmpty) return "Campo vazio";
                    },
                    decoration: InputDecoration(hintText: "Endereço"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "phone": _phoneController.text,
                          "adress": _adressController.text
                        };

                        model.updateUserData(userData);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Atualizar"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

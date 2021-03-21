import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[500])),
      ),
    ),
  ));
}

List<String> _tabTexts = ["Tab1", "Tab2", "Tab3"];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> _bottomTabList = [
    Tab(
      icon: Icon(Icons.fact_check),
      text: "Tab",
    ),
    Tab(icon: Icon(Icons.access_alarm), text: "Tab"),
    Tab(icon: Icon(Icons.add_shopping_cart), text: "Tab"),
  ];
  var _creationTime;

  List _taskList1 = [];
  List _taskList2 = [];
  List _taskList3 = [];
  bool _removeAllowed = false;
  final _controller = TextEditingController();
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPosition;
  List<GlobalKey<FormState>> _form = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  @override
  void initState() {
    super.initState();
    _readFile("1").then((value) {
      setState(() {
        _taskList1 = json.decode(value);
      });
    });
    _readFile("2").then((value) {
      setState(() {
        _taskList2 = json.decode(value);
      });
    });
    _readFile("3").then((value) {
      setState(() {
        _taskList3 = json.decode(value);
      });
    });

    _tabController = TabController(length: _bottomTabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List _getCurrentList() {
    if (_tabController.index == 0) {
      return _taskList1;
    } else if (_tabController.index == 1) {
      return _taskList2;
    } else if (_tabController.index == 2) {
      return _taskList3;
    }
  }

  Future<File> _getFile(String s) async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data$s.json");
  }

  String _getIndex(List list) {
    if (list == _taskList1) {
      return "1";
    } else if (list == _taskList2) {
      return "2";
    } else if (list == _taskList3) {
      return "3";
    }
  }

  Future<File> _saveData(List list) async {
    String data1 = json.encode(_taskList1);
    String data2 = json.encode(_taskList2);
    String data3 = json.encode(_taskList3);
    final file = await _getFile(_getIndex(list));
    if (list == _taskList1) {
      return file.writeAsString(data1);
    } else if (list == _taskList2) {
      return file.writeAsString(data2);
    } else if (list == _taskList3) {
      return file.writeAsString(data3);
    }
  }

  Future<String> _readFile(String s) async {
    try {
      final file = await _getFile(s);
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void _newTask(List list) {
    Map<String, dynamic> _newItem = Map();
    _creationTime = DateTime.now();
    String _formatDate =
        "${_creationTime.day}/${_creationTime.month}/${_creationTime.year}";
    bool _taskControl = false;
    setState(() {
      for (var items in list) {
        if (_controller.text == items["task"]) {
          _taskControl = true;
          break;
        }
      }
      if (_taskControl) {
        Toast.show("Tarefa já existe", context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
            textColor: Colors.black,
            backgroundColor: Colors.white);
      } else {
        _newItem["task"] = _controller.text;
        _newItem["done"] = false;
        _newItem["time"] = _formatDate;
        list.add(_newItem);

        _saveData(list);
      }
      _controller.text = "";
    });
  }

  Future<Null> _refresh() async {
    List list = _getCurrentList();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      list.sort((fst, snd) {
        if (fst["done"] && !snd["done"])
          return 1;
        else if (!fst["done"] && snd["done"])
          return -1;
        else
          return 0;
      });
    });
    _saveData(list);
  }

  Widget _buildListItem(BuildContext context, int index) {
    List list = _getCurrentList();
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete_forever, color: Colors.white),
        ),
      ),
      direction: (_removeAllowed
          ? DismissDirection.startToEnd
          : DismissDirection.none),
      child: CheckboxListTile(
        checkColor: Colors.green,
        activeColor: Colors.white,
        subtitle: Text("Criada em: ${list[index]["time"]}"),
        title: Text(list[index]["task"]),
        value: list[index]["done"],
        secondary: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              list[index]["done"] ? Icons.check : Icons.cancel,
            )),
        onChanged: (changed) {
          setState(() {
            list[index]["done"] = changed;
            _saveData(list);
          });
        },
      ),
      onDismissed: (dir) {
        setState(() {
          _lastRemoved = Map.from(list[index]);
          _lastRemovedPosition = index;
          list.removeAt(index);
          _saveData(list);
        });
        final _removedSnackBar = SnackBar(
          content: Text("Tarefa ${_lastRemoved["task"]} removida"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                list.insert(_lastRemovedPosition, _lastRemoved);
                _saveData(list);
              });
            },
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(_removedSnackBar);
      },
    );
  }

  Widget _buildMainFrame(var index, List list) {
    return Form(
        key: _form[index],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: (Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "NOVA TAREFA",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 15.0),
                        border: OutlineInputBorder(),
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Campo em branco!";
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey[900]),
                        overlayColor: MaterialStateProperty.all(Colors.black),
                        elevation: MaterialStateProperty.all(100.0)),
                    child: Text(
                      "Adicionar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_form[index].currentState.validate()) {
                        print(_tabTexts);
                        _newTask(list);
                      }
                    },
                  )
                ],
              )),
            ),
            Expanded(
              child: RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: list.length,
                    itemBuilder: _buildListItem),
                onRefresh: _refresh,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              padding: EdgeInsets.only(right: 10.0),
              icon: Icon(
                Icons.delete,
                color: (_removeAllowed ? Colors.red : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _removeAllowed = !_removeAllowed;
                });
              })
        ],
        title: Text(
          "Lista de Tarefas",
        ),
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[200],
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMainFrame(0, _taskList1),
          _buildMainFrame(1, _taskList2),
          _buildMainFrame(2, _taskList3)
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.blueGrey[900],
        child: TabBar(
          tabs: _bottomTabList,
          controller: _tabController,
        ),
      ),
    );
  }
}

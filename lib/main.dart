// Importar as bibliotecas necessárias do Flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para comunicação com a API
import 'dart:convert';

// URL da API para obter dados de câmbio
const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=1e567ff5";

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      hintColor: Colors.amber, // Cor da dica
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  // Faz uma requisição HTTP para obter os dados da API e decodifica a resposta JSON
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final yensController = TextEditingController();
  double dolar = 0;
  double euro = 0;
  double yens = 0;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    yensController.text = (real / yens).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    yensController.text = (dolar * this.dolar / yens).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    yensController.text = (euro * this.euro / yens).toStringAsFixed(2);
  }

  void _yensChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double yens = double.parse(text);
    realController.text = (yens * this.yens).toStringAsFixed(2);
    dolarController.text = (yens * this.yens / dolar).toStringAsFixed(2);
    euroController.text = (yens * this.yens / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    yensController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          // Verifica o estado da conexão com a API e exibe diferentes widgets de acordo
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados ...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados ...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                yens = snapshot.data!["results"]["currencies"]["JPY"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextField(
                        controller: realController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        onChanged: _realChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Doláres",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        onChanged: _dolarChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: yensController,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Yens",
                          labelStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "¥",
                        ),
                        onChanged: _yensChanged,
                        keyboardType: TextInputType.number,
                      ),
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConsultaCepPage(),
    );
  }
}

class ConsultaCepPage extends StatefulWidget {
  @override
  _ConsultaCepPageState createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final _controller = TextEditingController();
  String _resultado = "";

  Future<void> _buscarCep() async {
    final cep = _controller.text;
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["erro"] == true) {
        setState(() {
          _resultado = "CEP não encontrado!";
        });
      } else {
        setState(() {
          _resultado = "${data['logradouro']}, ${data['bairro']}, ${data['localidade']} - ${data['uf']}";
        });
      }
    } else {
      setState(() {
        _resultado = "Erro ao buscar o CEP!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consulta de CEP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'CEP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(_resultado),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarCep,
        child: Icon(Icons.search),
      ),
    );
  }
}

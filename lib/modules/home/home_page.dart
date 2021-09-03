import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/anotacao_helper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _controllerTitulo = TextEditingController();
  var _controllerDescricao = TextEditingController();
  var _db = AnotacaoHelper();

  _salvarAnotacao() async {
    var titulo = _controllerTitulo.text;
    var descricao = _controllerDescricao.text;
    var data = DateTime.now().toString();

    var anotacao = Anotacao(titulo, descricao, data);
    var id = await _db.salvarAnotacao(anotacao);

    _controllerTitulo.clear();
    _controllerDescricao.clear();
  }

  _exibirTelaCadastro(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Adicionar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controllerTitulo,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Digite um título..."),
                ),
                TextField(
                  controller: _controllerDescricao,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição..."),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              ElevatedButton(
                  onPressed: () {
                    _salvarAnotacao();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Anotações"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro(context);
        },
      ),
      body: Container(),
    );
  }
}

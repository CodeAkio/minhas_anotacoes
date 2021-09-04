import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  List<Anotacao> _anotacoes = [];

  var _db = AnotacaoHelper();

  _recuperarAnotacoes() async {
    _anotacoes.clear();
    var anotacoes = await _db.recuperarAnotacoes();

    setState(() {
      _anotacoes = anotacoes;
    });
  }

  _salvarAtualizarAnotacao({Anotacao? anotacao}) async {
    var titulo = _controllerTitulo.text;
    var descricao = _controllerDescricao.text;
    var data = DateTime.now().toString();

    if (anotacao == null) {
      var novaAnotacao = Anotacao(titulo, descricao, data);
      await _db.salvarAnotacao(novaAnotacao);
    } else {
      anotacao.titulo = titulo;
      anotacao.descricao = descricao;
      anotacao.data = data;

      await _db.atualizarAnotacao(anotacao);
    }

    _controllerTitulo.clear();
    _controllerDescricao.clear();

    _recuperarAnotacoes();
  }

  _formataData(String data) {
    initializeDateFormatting('pt_BR');

    var formatador = DateFormat.yMd('pt_BR');

    var dataConvertida = DateTime.parse(data);
    var dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _exibirTelaCadastro({Anotacao? anotacao}) {
    var textoSalvarAtualizar = "";

    if (anotacao == null) {
      _controllerTitulo.text = "";
      _controllerDescricao.text = "";
      textoSalvarAtualizar = "Salvar";
    } else {
      _controllerTitulo.text = anotacao.titulo;
      _controllerDescricao.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar Anotação"),
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
                    _salvarAtualizarAnotacao(anotacao: anotacao);
                    Navigator.pop(context);
                  },
                  child: Text(textoSalvarAtualizar)),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
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
          _exibirTelaCadastro();
        },
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index) {
                    final anotacao = _anotacoes[index];
                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle: Text(
                            "${_formataData(anotacao.data)} - ${anotacao.descricao}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _exibirTelaCadastro(anotacao: anotacao);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.highlight_remove,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

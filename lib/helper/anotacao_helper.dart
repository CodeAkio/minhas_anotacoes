import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final String nomeTabela = "anotacoes";
  static final String colunaId = "id";
  static final String colunaTitulo = "titulo";
  static final String colunaDescricao = "descricao";
  static final String colunaData = "data";

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  AnotacaoHelper._internal();

  static Database? _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _inicializarDb();
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $nomeTabela ("
        "$colunaId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colunaTitulo VARCHAR, "
        "$colunaDescricao TEXT, "
        "$colunaData DATETIME)";
    await db.execute(sql);
  }

  _inicializarDb() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados =
        join(caminhoBancoDados, "banco_minhas_anotacoes.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);

    return db;
  }

  Future<List<Anotacao>> recuperarAnotacoes() async {
    var bancoDados = await db;
    var sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List<Map<String, dynamic>> anotacoesMap = await bancoDados.rawQuery(sql);

    List<Anotacao> anotacoes = [];

    for (var anotacaoMap in anotacoesMap) {
      anotacoes.add(Anotacao.fromMap(anotacaoMap));
    }

    return anotacoes;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    var id = await bancoDados.insert(nomeTabela, anotacao.toMap());

    return id;
  }
}

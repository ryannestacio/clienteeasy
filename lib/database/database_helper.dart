import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/aluno.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  // Nome do banco de dados
  final String _dbName = 'academia.db';
  final String _tableName = 'alunos';

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          diaPagamento INTEGER NOT NULL, 
          endereco TEXT NOT NULL,
          valorMensalidade REAL NOT NULL,
          mesesPagos TEXT,
          dataVencimento TEXT
        )''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE $_tableName ADD COLUMN mesesPagos TEXT');
          await db.execute(
              'ALTER TABLE $_tableName ADD COLUMN dataVencimento TEXT');
        }
      },
    );
  }

  // Método para inserir um aluno
  Future<int> inserirAluno(Aluno aluno) async {
    final db = await database;
    return await db.insert(_tableName, {
      'nome': aluno.nome,
      'diaPagamento': aluno.diaPagamento,
      'endereco': aluno.endereco,
      'valorMensalidade': aluno.valorMensalidade,
      'mesesPagos': jsonEncode(aluno.mesesPagos), // Salva como JSON
      'dataVencimento': aluno.dataVencimento.toIso8601String(), // Salva como string
    });
  }

  // Método para obter todos os alunos
  Future<List<Aluno>> getAlunos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Aluno(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        diaPagamento: maps[i]['diaPagamento'],
        endereco: maps[i]['endereco'],
        valorMensalidade: maps[i]['valorMensalidade'],
        mesesPagos: maps[i]['mesesPagos'] != null
            ? List<bool>.from(jsonDecode(maps[i]['mesesPagos']))
            : List.filled(12, false), // Se não houver meses pagos, inicializa com falso
        dataVencimento: DateTime.parse(maps[i]['dataVencimento']),
      );
    });
  }

  // Método para atualizar um aluno
  Future<void> atualizarAluno(Aluno aluno) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'nome': aluno.nome,
        'diaPagamento': aluno.diaPagamento,
        'endereco': aluno.endereco,
        'valorMensalidade': aluno.valorMensalidade,
        'mesesPagos': jsonEncode(aluno.mesesPagos), // Atualiza como JSON
        'dataVencimento': aluno.dataVencimento.toIso8601String(), // Atualiza como string
      },
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  // Método para deletar um aluno
  Future<void> deletarAluno(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Método para atualizar os meses pagos de um aluno
  Future<void> atualizarMesesPagos(Aluno aluno) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'mesesPagos': aluno.mesesPagos != null
            ? jsonEncode(aluno.mesesPagos)
            : jsonEncode(List.filled(12, false)), // Garante que a lista será preenchida com 12 valores falsos
      },
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }
}

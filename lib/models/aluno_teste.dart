import 'package:flutter_test/flutter_test.dart';
import 'package:cliente_facil/models/aluno.dart';
import 'dart:convert';

void main() {
  test('Aluno.fromMap deve criar um Aluno corretamente', () {
    final map = {
      'id': 1,
      'nome': 'João',
      'diaPagamento': 15,
      'endereco': 'Rua X',
      'valorMensalidade': 99.9,
      'mesesPagos': jsonEncode(List.filled(12, false)..[0] = true),
    };

    final aluno = Aluno.fromMap(map);

    expect(aluno.id, 1);
    expect(aluno.nome, 'João');
    expect(aluno.diaPagamento, 15);
    expect(aluno.endereco, 'Rua X');
    expect(aluno.valorMensalidade, 99.9);
    expect(aluno.mesesPagos.length, 12);
    expect(aluno.mesesPagos[0], true);
  });
}

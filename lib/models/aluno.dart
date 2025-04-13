import 'dart:convert';

class Aluno {
  final int? id;
  final String nome;
  final int diaPagamento;
  final String endereco;
  final double valorMensalidade;
  final DateTime dataVencimento;
  List<bool> mesesPagos;

  Aluno({
    this.id,
    required this.nome,
    required this.diaPagamento,
    required this.endereco,
    required this.valorMensalidade,
    DateTime? dataVencimento,
    List<bool>? mesesPagos, // <- Adiciona isso aqui!
  })  : dataVencimento = dataVencimento ?? DateTime.now(),
        mesesPagos = mesesPagos ?? List.filled(12, false); // Inicializa a lista com 12 meses

  // Converte o aluno para Map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'diaPagamento': diaPagamento,
      'endereco': endereco,
      'valorMensalidade': valorMensalidade,
      'mesesPagos': jsonEncode(mesesPagos), // Converte a lista de meses pagos para JSON
      'dataVencimento': dataVencimento.toIso8601String(), // Convertendo para string
    };
  }

  // Converte o Map do banco para Aluno
  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      diaPagamento: map['diaPagamento'],
      endereco: map['endereco'],
      valorMensalidade: map['valorMensalidade'],
      mesesPagos: map['mesesPagos'] != null
          ? List<bool>.from(jsonDecode(map['mesesPagos']))
          : List.filled(12, false), // Caso não tenha mesesPagos, inicializa com 12 meses
      dataVencimento: DateTime.parse(map['dataVencimento']), // Convertendo string de volta para DateTime
    );
  }
}

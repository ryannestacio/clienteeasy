import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aluno_provider.dart';
import 'cadastro_aluno.dart';
import '../models/aluno.dart';

class ListaAlunos extends StatefulWidget {
  const ListaAlunos({super.key});

  @override
  _ListaAlunosState createState() => _ListaAlunosState();
}

class _ListaAlunosState extends State<ListaAlunos> {
  int? _filtroDiaPagamento;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      alunoProvider.carregarAlunos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text(
          'Contas a Receber',
          style: TextStyle(color: Colors.white, 
          fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.teal[700],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                hint: const Text(
                  'Filtrar Dia',
                  style: TextStyle(color: Colors.white),
                ),
                value: _filtroDiaPagamento,
                dropdownColor: Colors.teal[700],
                icon: const Icon(Icons.filter_alt, 
                color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _filtroDiaPagamento = value;
                  });
                },
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(' Todos', 
                    style: TextStyle(
                      color: Colors.white
                      )
                    ),
                  ),
                  ...List.generate(
                    31,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                style: const TextStyle(color: Colors.white, fontSize: 16),
                underline: Container(),
              ),
            ),
          ),
        ],
        elevation: 5,
        shadowColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          //color: const Color.fromARGB(255, 1, 73, 97),
          child: Consumer<AlunoProvider>(
            builder: (context, alunoProvider, child) {
              final alunos = alunoProvider.alunos;
              final alunosFiltrados =
                  _filtroDiaPagamento == null
                      ? alunos
                      : alunos
                          .where(
                            (aluno) => aluno.diaPagamento == _filtroDiaPagamento,
                          )
                          .toList();
        
              if (alunosFiltrados.isEmpty) {
                return const Center(
                  child: Text(
                    'Não há contas a receber.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }
        
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: alunosFiltrados.length,
                      itemBuilder: (context, index) {
                        final aluno = alunosFiltrados[index];
        
                        return Card(
                          color: Colors.grey[400],
                          child: ListTile(
                            title: Text(aluno.nome),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dia de Pagamento: ${aluno.diaPagamento}'),
                                Text('Produto: ${aluno.endereco}'),
                                Text(
                                  'Valor Devedor: R\$ ${aluno.valorMensalidade.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                CadastroAluno(aluno: aluno),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Excluir Cliente'),
                                          content: Text(
                                            'Você tem certeza que deseja excluir a conta do cliente ${aluno.nome}?',
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Excluir'),
                                              onPressed: () {
                                                alunoProvider.removerAluno(
                                                  aluno.id!,
                                                );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.checklist),
                                  onPressed: () {
                                    _showMesesPagos(context, aluno);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                    
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Clientes em dívida: ${alunosFiltrados.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroAluno()),
          );
        },
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void _showMesesPagos(BuildContext context, Aluno aluno) {
    showDialog(
      context: context,
      builder: (context) {
        return MesesPagosDialog(aluno: aluno);
      },
    );
  }
}

class MesesPagosDialog extends StatefulWidget {
  final Aluno aluno;

  const MesesPagosDialog({super.key, required this.aluno});

  @override
  _MesesPagosDialogState createState() => _MesesPagosDialogState();
}

class _MesesPagosDialogState extends State<MesesPagosDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Meses de pagamento do cliente ${widget.aluno.nome}:'),
      content: SingleChildScrollView(
        child: ListBody(
          children: List.generate(12, (index) {
            return CheckboxListTile(
              title: Text('Mês ${index + 1}'),
              value: widget.aluno.mesesPagos[index],
              onChanged: (bool? value) async {
  setState(() {
    widget.aluno.mesesPagos[index] = value ?? false;
  });

  final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
  await alunoProvider.atualizarMesesPagos(widget.aluno);
}
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

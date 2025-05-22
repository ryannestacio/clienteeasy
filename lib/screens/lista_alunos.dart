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

class _ListaAlunosState extends State<ListaAlunos>
    with SingleTickerProviderStateMixin {
  int? _filtroDiaPagamento;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.microtask(() {
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      alunoProvider.carregarAlunos();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade400, Colors.teal.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar customizada
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Lista de Clientes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButton<int>(
                        hint: const Text(
                          'Filtrar Dia',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        value: _filtroDiaPagamento,
                        dropdownColor: Colors.teal.shade700,
                        icon: const Icon(Icons.filter_alt, color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            _filtroDiaPagamento = value;
                          });
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text(
                              ' Todos',
                              style: TextStyle(color: Colors.white),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Consumer<AlunoProvider>(
                  builder: (context, alunoProvider, child) {
                    final alunos = alunoProvider.alunos;
                    final alunosFiltrados =
                        _filtroDiaPagamento == null
                            ? alunos
                            : alunos
                                .where(
                                  (aluno) =>
                                      aluno.diaPagamento == _filtroDiaPagamento,
                                )
                                .toList();

                    if (alunosFiltrados.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Não há contas a receber',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return FadeTransition(
                      opacity: _animation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: alunosFiltrados.length,
                                itemBuilder: (context, index) {
                                  final aluno = alunosFiltrados[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(
                                          16,
                                        ),
                                        title: Text(
                                          aluno.nome,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Dia ${aluno.diaPagamento}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.home,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    aluno.endereco,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.attach_money,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'R\$ ${aluno.valorMensalidade.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.teal,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            CadastroAluno(
                                                              aluno: aluno,
                                                            ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        title: const Text(
                                                          'Excluir Cliente',
                                                        ),
                                                        content: Text(
                                                          'Você tem certeza que deseja excluir a conta do cliente ${aluno.nome}?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: const Text(
                                                              'Cancelar',
                                                            ),
                                                            onPressed:
                                                                () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(),
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                              'Excluir',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              alunoProvider
                                                                  .removerAluno(
                                                                    aluno.id!,
                                                                  );
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.checklist,
                                                color: Colors.teal,
                                              ),
                                              onPressed:
                                                  () => _showMesesPagos(
                                                    context,
                                                    aluno,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Alunos cadastrados: ${alunosFiltrados.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.teal),
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

                final alunoProvider = Provider.of<AlunoProvider>(
                  context,
                  listen: false,
                );
                await alunoProvider.atualizarMesesPagos(widget.aluno);
              },
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/aluno.dart';
import '../providers/aluno_provider.dart';

class CadastroAluno extends StatefulWidget {
  final Aluno? aluno;

  const CadastroAluno({super.key, this.aluno});

  @override
  _CadastroAlunoState createState() => _CadastroAlunoState();
}

class _CadastroAlunoState extends State<CadastroAluno>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _valorMensalidadeController = TextEditingController();
  int? _diaPagamento;
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

    if (widget.aluno != null) {
      _nomeController.text = widget.aluno!.nome;
      _enderecoController.text = widget.aluno!.endereco;
      _valorMensalidadeController.text = widget.aluno!.valorMensalidade
          .toStringAsFixed(2);
      _diaPagamento = widget.aluno!.diaPagamento;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nomeController.dispose();
    _enderecoController.dispose();
    _valorMensalidadeController.dispose();
    super.dispose();
  }

  void _salvarAluno() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final endereco = _enderecoController.text;
      final valorMensalidade =
          double.tryParse(_valorMensalidadeController.text) ?? 0.0;

      final novoAluno = Aluno(
        id: widget.aluno?.id,
        nome: nome,
        diaPagamento: _diaPagamento ?? 0,
        endereco: endereco,
        valorMensalidade: valorMensalidade,
      );

      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);

      if (widget.aluno == null) {
        await alunoProvider.adicionarAluno(novoAluno);
      } else {
        await alunoProvider.atualizarAluno(novoAluno);
      }

      Navigator.pop(context);
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2.0),
      ),
      errorStyle: const TextStyle(color: Colors.white),
    );
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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.aluno == null ? 'Cadastrar Aluno' : 'Editar Aluno',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FadeTransition(
                  opacity: _animation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nomeController,
                                  decoration: _buildInputDecoration(
                                    'Nome do Aluno',
                                    Icons.person,
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o nome';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                DropdownButtonFormField<int>(
                                  value: _diaPagamento,
                                  decoration: _buildInputDecoration(
                                    'Dia de Pagamento',
                                    Icons.calendar_today,
                                  ),
                                  dropdownColor: Colors.teal.shade700,
                                  items: List.generate(
                                    29,
                                    (index) => DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  onChanged: (value) {
                                    setState(() {
                                      _diaPagamento = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Por favor, selecione o dia';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _enderecoController,
                                  decoration: _buildInputDecoration(
                                    'Endereço',
                                    Icons.home,
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o produto';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _valorMensalidadeController,
                                  keyboardType: TextInputType.number,
                                  decoration: _buildInputDecoration(
                                    'Valor',
                                    Icons.attach_money,
                                  ).copyWith(
                                    prefixText: 'R\$ ',
                                    prefixStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o valor';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _salvarAluno,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                widget.aluno == null
                                    ? 'Cadastrar Cliente'
                                    : 'Salvar Alterações',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      // Azul meio claro
      body: SafeArea(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/home_page.png'), // Adicione a sua logo no assets
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //const SizedBox(height: 20),
            
                  // Nome do aplicativo
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      "CLIENTE EASY",
                      style: TextStyle(
                        fontSize: 40,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'TitanOne'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  // Botão estilizado
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            '/lista_alunos'); // Navega para a tela de cadastro
                      },
                      icon: const Icon(Icons.account_balance_wallet_rounded, size: 24),
                      label: const Text(
                        "Cadastro de Contas",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo branca
                        foregroundColor: Colors.blueAccent, // Cor do texto e ícone
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Borda arredondada
                        ),
                        elevation: 5, // Efeito de sombra
                      )),
            
                  const SizedBox(height: 40),
            
                  // Rodapé com informações de contato
                  
                ],
              ),
              
            ),
            Column(
                children: [
                  Text(
                    "Desenvolvido por Ryan Estácio\n\nContatos:\n(82) 9 8219-9052\nryannestacio@icloud.com",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6), // Texto meio fosco
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
      
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _expressao = '';
  String _resultado = '';

  void _atualizarExpressao(String valor) {
    setState(() {
      _expressao += valor;
    });
  }

  void _limpar() {
    setState(() {
      _expressao = '';
      _resultado = '';
    });
  }

  void _calcularResultado() {
    try {
      String exp = _expressao.replaceAll('x', '*').replaceAll('÷', '/');
      final resultado = _avaliarExpressao(exp);
      setState(() {
        _resultado = resultado.toString();
      });
    } catch (e) {
      setState(() {
        _resultado = 'Erro';
      });
    }
  }

  double _avaliarExpressao(String expressao) {
    return double.parse(
      RegExp(r'^[\d\+\-\*\/.]+$').hasMatch(expressao) ? '${_calcular(exp: expressao)}' : '0',
    );
  }

  double _calcular({required String exp}) {
    List<String> tokens = exp.split(RegExp(r'([\+\-\*\/])'));
    List<String> operadores = RegExp(r'[\+\-\*\/]').allMatches(exp).map((m) => m.group(0)!).toList();

    double resultado = double.parse(tokens[0]);
    for (int i = 0; i < operadores.length; i++) {
      double proximo = double.parse(tokens[i + 1]);
      switch (operadores[i]) {
        case '+':
          resultado += proximo;
          break;
        case '-':
          resultado -= proximo;
          break;
        case '*':
          resultado *= proximo;
          break;
        case '/':
          resultado /= proximo;
          break;
      }
    }
    return resultado;
  }

  Widget _botao(String valor, {Color color = Colors.purple}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.pink[100],
        padding: const EdgeInsets.all(16),
        elevation: 1,
      ),
      onPressed: () {
        if (valor == '=') {
          _calcularResultado();
        } else if (valor == 'C') {
          _limpar();
        } else {
          _atualizarExpressao(valor);
        }
      },
      child: Text(
        valor,
        style: TextStyle(
          fontSize: 24,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: BorderRadius.circular(16),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expressao,
                      style: const TextStyle(fontSize: 36, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _resultado,
                      style: const TextStyle(fontSize: 28, color: Colors.purple),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _botao('7'),
                  _botao('8'),
                  _botao('9'),
                  _botao('÷', color: Colors.red),
                  _botao('4'),
                  _botao('5'),
                  _botao('6'),
                  _botao('x', color: Colors.red),
                  _botao('1'),
                  _botao('2'),
                  _botao('3'),
                  _botao('-', color: Colors.red),
                  _botao('0'),
                  _botao('.'),
                  _botao('C', color: Colors.blue),
                  _botao('+', color: Colors.red),
                  _botao('=', color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

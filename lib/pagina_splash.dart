import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'pagina_clima.dart';

class PaginaSplash extends StatefulWidget {
  const PaginaSplash({super.key});

  @override
  State<PaginaSplash> createState() => _PaginaSplashState();
}

class _PaginaSplashState extends State<PaginaSplash> {
  @override
  void initState() {
    super.initState();
    _iniciarTimer();
  }

  void _iniciarTimer() {
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaginaConsulta()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Meteorologia no Bolso',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            Lottie.asset(
              'assets/sunny.json',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}

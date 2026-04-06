import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  //depois mudar para StatefulWidget
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Finanças'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
    );
  }
}

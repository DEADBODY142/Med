import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/homepage.dart';

class UrgentCarePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urgent Care')),
      body: Center(
        child: const Text('Welcome to Urgent Care', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

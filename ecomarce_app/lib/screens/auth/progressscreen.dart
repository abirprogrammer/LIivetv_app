
import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
const ProgressScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Progress',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: const Center(
child: Text(
'Progress Screen',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
),
);
}
}
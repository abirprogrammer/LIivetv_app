
import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
const WorkoutScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Workout',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: const Center(
child: Text(
'Workout Screen',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
),
);
}
}


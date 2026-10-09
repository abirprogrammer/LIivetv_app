import 'package:fitforge/screens/auth/signupscreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/authprovider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;


    if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Email and password are required'),
    backgroundColor: Colors.red,
    ),
    );
    return;
    }

    final authProvider = context.read<AuthProvider>();

    final error = await authProvider.login(
    email: email,
    password: password,
    );

    if (!mounted) return;

// error == null means login successful
    if (error == null) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Login successful'),
    backgroundColor: Colors.green,
    ),
    );

    await Future.delayed(
    const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
    builder: (_) => const MainNavigationScreen(),
    ),
    (route) => false,
    );
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(error),
    backgroundColor: Colors.red,
    ),
    );
    }


  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();


    return Scaffold(
    body: SafeArea(
    child: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 50),

    Center(
    child: Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(25),
    ),
    child: const Icon(
    Icons.fitness_center,
    color: Colors.white,
    size: 50,
    ),
    ),
    ),

    const SizedBox(height: 30),

    const Center(
    child: Text(
    'Welcome Back',
    style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),

    const SizedBox(height: 8),

    const Center(
    child: Text(
    'Login to your FitZone account',
    style: TextStyle(
    color: Colors.grey,
    fontSize: 15,
    ),
    ),
    ),

    const SizedBox(height: 40),

    const Text(
    'Email',
    style: TextStyle(
    fontWeight: FontWeight.w600,
    ),
    ),

    const SizedBox(height: 8),

    TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
    hintText: 'Enter your email',
    prefixIcon: const Icon(
    Icons.email_outlined,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    ),
    ),
    ),

    const SizedBox(height: 20),

    const Text(
    'Password',
    style: TextStyle(
    fontWeight: FontWeight.w600,
    ),
    ),

    const SizedBox(height: 8),

    TextField(
    controller: passwordController,
    obscureText: obscurePassword,
    textInputAction: TextInputAction.done,
    onSubmitted: (_) {
    if (!authProvider.isLoading) {
    login();
    }
    },
    decoration: InputDecoration(
    hintText: 'Enter your password',
    prefixIcon: const Icon(
    Icons.lock_outline,
    ),
    suffixIcon: IconButton(
    icon: Icon(
    obscurePassword
    ? Icons.visibility_off
        : Icons.visibility,
    ),
    onPressed: () {
    setState(() {
    obscurePassword = !obscurePassword;
    });
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    ),
    ),
    ),

    const SizedBox(height: 30),

    SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
    onPressed: authProvider.isLoading
    ? null
        : login,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.red.shade200,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
    ),
    ),
    child: authProvider.isLoading
    ? const SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 2,
    ),
    )
        : const Text(
    'LOGIN',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),

    const SizedBox(height: 20),

    Center(
    child: TextButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => const SignupScreen(),
    ),
    );
    },
    child: const Text(
    "Don't have an account? Sign Up",
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

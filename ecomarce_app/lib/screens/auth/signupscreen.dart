
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/authprovider.dart';
import '../homescreens.dart';
import 'loginscreen.dart';

class SignupScreen extends StatefulWidget {
const SignupScreen({super.key});

@override
State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
final nameController = TextEditingController();
final emailController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

bool obscurePassword = true;
bool obscureConfirmPassword = true;

@override
void dispose() {
nameController.dispose();
emailController.dispose();
phoneController.dispose();
passwordController.dispose();
confirmPasswordController.dispose();
super.dispose();
}

// =========================
// SHOW MESSAGE
// =========================

void _showMessage(
String message, {
bool success = false,
}) {
if (!mounted) return;

ScaffoldMessenger.of(context).hideCurrentSnackBar();

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
backgroundColor:
success ? Colors.green : Colors.red,
duration: const Duration(seconds: 2),
),
);
}

// =========================
// SIGN UP
// =========================

Future<void> signup() async {
final name = nameController.text.trim();
final email = emailController.text.trim();
final phone = phoneController.text.trim();
final password = passwordController.text;
final confirmPassword =
confirmPasswordController.text;

// -------------------------
// VALIDATION
// -------------------------

if (name.isEmpty) {
_showMessage('Please enter your name');
return;
}

if (email.isEmpty) {
_showMessage('Please enter your email');
return;
}

if (phone.isEmpty) {
_showMessage('Please enter your phone number');
return;
}

if (password.isEmpty) {
_showMessage('Please enter a password');
return;
}

if (confirmPassword.isEmpty) {
_showMessage('Please confirm your password');
return;
}

if (!RegExp(
r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
).hasMatch(email)) {
_showMessage('Please enter a valid email');
return;
}

if (password.length < 6) {
_showMessage(
'Password must be at least 6 characters',
);
return;
}

if (password != confirmPassword) {
_showMessage('Passwords do not match');
return;
}

// -------------------------
// CALL API
// -------------------------

final authProvider =
context.read<AuthProvider>();

final error = await authProvider.signup(
name: name,
email: email,
phone: phone,
password: password,
);

if (!mounted) return;

// -------------------------
// SUCCESS
// -------------------------

if (error == null) {
_showMessage(
'Account created successfully!',
success: true,
);

// একটু সময় SnackBar দেখানোর জন্য
await Future.delayed(
const Duration(milliseconds: 800),
);

if (!mounted) return;

// সরাসরি HomeScreen
Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (_) => const MainNavigationScreen(),
),
(route) => false,
);

return;
}

// -------------------------
// ERROR
// -------------------------

_showMessage(error);
}

// =========================
// INPUT DECORATION
// =========================

InputDecoration inputDecoration({
required String hint,
required IconData icon,
}) {
return InputDecoration(
hintText: hint,
prefixIcon: Icon(icon),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
color: Colors.grey.shade300,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Colors.red,
width: 2,
),
),
);
}

// =========================
// BUILD
// =========================

@override
Widget build(BuildContext context) {
final authProvider =
context.watch<AuthProvider>();

return Scaffold(
appBar: AppBar(
title: const Text(
'Create Account',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const SizedBox(height: 15),

// -------------------------
// ICON
// -------------------------

Center(
child: Container(
height: 85,
width: 85,
decoration: BoxDecoration(
color: Colors.red,
borderRadius:
BorderRadius.circular(25),
),
child: const Icon(
Icons.person_add_alt_1,
color: Colors.white,
size: 45,
),
),
),

const SizedBox(height: 25),

// -------------------------
// TITLE
// -------------------------

const Center(
child: Text(
'Join FitZone',
style: TextStyle(
fontSize: 29,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 7),

const Center(
child: Text(
'Create your fitness account',
style: TextStyle(
color: Colors.grey,
fontSize: 15,
),
),
),

const SizedBox(height: 35),

// -------------------------
// NAME
// -------------------------

const Text(
'Full Name',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextField(
controller: nameController,
textInputAction:
TextInputAction.next,
decoration: inputDecoration(
hint: 'Enter your name',
icon: Icons.person_outline,
),
),

const SizedBox(height: 18),

// -------------------------
// EMAIL
// -------------------------

const Text(
'Email',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextField(
controller: emailController,
keyboardType:
TextInputType.emailAddress,
textInputAction:
TextInputAction.next,
decoration: inputDecoration(
hint: 'Enter your email',
icon: Icons.email_outlined,
),
),

const SizedBox(height: 18),

// -------------------------
// PHONE
// -------------------------

const Text(
'Phone',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextField(
controller: phoneController,
keyboardType:
TextInputType.phone,
textInputAction:
TextInputAction.next,
decoration: inputDecoration(
hint: 'Enter phone number',
icon: Icons.phone_outlined,
),
),

const SizedBox(height: 18),

// -------------------------
// PASSWORD
// -------------------------

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
textInputAction:
TextInputAction.next,
decoration: inputDecoration(
hint: 'Create password',
icon: Icons.lock_outline,
).copyWith(
suffixIcon: IconButton(
onPressed: () {
setState(() {
obscurePassword =
!obscurePassword;
});
},
icon: Icon(
obscurePassword
? Icons.visibility_off
    : Icons.visibility,
),
),
),
),

const SizedBox(height: 18),

// -------------------------
// CONFIRM PASSWORD
// -------------------------

const Text(
'Confirm Password',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),

const SizedBox(height: 8),

TextField(
controller:
confirmPasswordController,
obscureText:
obscureConfirmPassword,
textInputAction:
TextInputAction.done,
onSubmitted: (_) {
if (!authProvider.isLoading) {
signup();
}
},
decoration: inputDecoration(
hint: 'Confirm password',
icon: Icons.lock_outline,
).copyWith(
suffixIcon: IconButton(
onPressed: () {
setState(() {
obscureConfirmPassword =
!obscureConfirmPassword;
});
},
icon: Icon(
obscureConfirmPassword
? Icons.visibility_off
    : Icons.visibility,
),
),
),
),

const SizedBox(height: 30),

// -------------------------
// CREATE ACCOUNT BUTTON
// -------------------------

SizedBox(
width: double.infinity,
height: 55,

child: ElevatedButton(
onPressed:
authProvider.isLoading
? null
    : signup,

style:
ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor:
Colors.white,
disabledBackgroundColor:
Colors.red.shade200,
shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
),

child:
authProvider.isLoading
? const SizedBox(
height: 24,
width: 24,
child:
CircularProgressIndicator(
color:
Colors.white,
strokeWidth: 2,
),
)
    : const Text(
'CREATE ACCOUNT',
style: TextStyle(
fontSize: 15,
fontWeight:
FontWeight.bold,
),
),
),
),

const SizedBox(height: 18),

// -------------------------
// LOGIN
// -------------------------

Center(
child: TextButton(
onPressed:
authProvider.isLoading
? null
    : () {
Navigator
    .pushReplacement(
context,
MaterialPageRoute(
builder: (_) =>
const LoginScreen(),
),
);
},
child: const Text(
'Already have an account? Login',
style: TextStyle(
color: Colors.red,
),
),
),
),

const SizedBox(height: 20),
],
),
),
),
);
}
}


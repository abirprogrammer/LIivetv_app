
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';


import 'loginscreen.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});

@override
Widget build(BuildContext context) {
final authProvider =
context.watch<AuthProvider>();

return Scaffold(
appBar: AppBar(
title: const Text(
'Profile',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(24),

child: Column(
children: [
const SizedBox(height: 30),

// =========================
// PROFILE IMAGE
// =========================

CircleAvatar(
radius: 55,

backgroundColor:
Colors.red.withOpacity(0.1),

child: const Icon(
Icons.person,
size: 65,
color: Colors.red,
),
),

const SizedBox(height: 20),

// =========================
// NAME
// =========================

Text(
authProvider.userName ?? 'User',

textAlign: TextAlign.center,

style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

// =========================
// EMAIL
// =========================

Text(
authProvider.userEmail ??
'No email',

textAlign: TextAlign.center,

style: const TextStyle(
color: Colors.grey,
fontSize: 15,
),
),

const SizedBox(height: 8),

// =========================
// PHONE
// =========================

if (authProvider.userPhone != null &&
authProvider.userPhone!.isNotEmpty)
Text(
authProvider.userPhone!,

style: const TextStyle(
color: Colors.grey,
fontSize: 15,
),
),

const SizedBox(height: 40),

// =========================
// ACCOUNT INFO
// =========================

Container(
width: double.infinity,

padding:
const EdgeInsets.all(18),

decoration: BoxDecoration(
color: Theme.of(context)
    .cardColor,

borderRadius:
BorderRadius.circular(18),

border: Border.all(
color: Colors.grey
    .withOpacity(0.15),
),
),

child: Column(
children: [
_profileItem(
icon: Icons.person_outline,
title: 'Name',
value:
authProvider.userName ??
'User',
),

const Divider(height: 25),

_profileItem(
icon:
Icons.email_outlined,
title: 'Email',
value:
authProvider.userEmail ??
'No email',
),

const Divider(height: 25),

_profileItem(
icon: Icons.phone_outlined,
title: 'Phone',
value:
authProvider.userPhone ??
'No phone',
),
],
),
),

const SizedBox(height: 35),

// =========================
// LOGOUT BUTTON
// =========================

SizedBox(
width: double.infinity,
height: 52,

child: ElevatedButton.icon(
onPressed: () async {
await context
    .read<AuthProvider>()
    .logout();

if (!context.mounted) {
return;
}

Navigator.pushAndRemoveUntil(
context,

MaterialPageRoute(
builder: (_) =>
const LoginScreen(),
),

(route) => false,
);
},

icon: const Icon(
Icons.logout,
),

label: const Text(
'Logout',
style: TextStyle(
fontSize: 16,
fontWeight:
FontWeight.bold,
),
),

style:
ElevatedButton.styleFrom(
backgroundColor:
Colors.red,

foregroundColor:
Colors.white,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
),
),
),
],
),
),
);
}

// =========================
// PROFILE ITEM
// =========================

Widget _profileItem({
required IconData icon,
required String title,
required String value,
}) {
return Row(
children: [
Container(
height: 45,
width: 45,

decoration: BoxDecoration(
color:
Colors.red.withOpacity(0.1),

borderRadius:
BorderRadius.circular(12),
),

child: Icon(
icon,
color: Colors.red,
),
),

const SizedBox(width: 14),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Text(
title,

style: const TextStyle(
color: Colors.grey,
fontSize: 12,
),
),

const SizedBox(height: 3),

Text(
value,

style: const TextStyle(
fontSize: 15,
fontWeight:
FontWeight.w600,
),
),
],
),
),
],
);
}
}


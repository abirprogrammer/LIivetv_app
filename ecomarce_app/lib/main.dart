import 'package:fitforge/provider/authprovider.dart';
import 'package:fitforge/provider/themeprovider.dart';
import 'package:fitforge/screens/auth/loginscreen.dart';
import 'package:fitforge/screens/auth/profilescreen.dart';
import 'package:fitforge/screens/auth/progressscreen.dart';
import 'package:fitforge/screens/auth/workoutscreen.dart';
import 'package:fitforge/screens/homescreens.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(
          providers: [
          ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
  ),


  ChangeNotifierProvider(
  create: (_) => AuthProvider()..loadUser(),
  ),
  ],
  child: const GymApp(),
  ),


  );
  }

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
    context.watch<ThemeProvider>();


    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'FitZone',

    themeMode: themeProvider.themeMode,

    theme: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor:
    const Color(0xffF7F7F7),
    useMaterial3: true,
    ),

    darkTheme: ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.red,
    useMaterial3: true,
    ),

    home: const LoginScreen(),
    );


  }
}

// ======================================================
// MAIN NAVIGATION SCREEN
// ======================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    WorkoutScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    // ================================================
    // CURRENT SCREEN
    // ================================================

    body: IndexedStack(
    index: _currentIndex,
    children: _screens,
    ),

    // ================================================
    // BOTTOM NAVIGATION
    // ================================================

    bottomNavigationBar:
    NavigationBar(
    selectedIndex: _currentIndex,

    backgroundColor:
    Theme.of(context).scaffoldBackgroundColor,

    indicatorColor:
    Colors.red.withOpacity(0.15),

    onDestinationSelected: (index) {
    setState(() {
    _currentIndex = index;
    });
    },

    destinations: const [

    NavigationDestination(
    icon: Icon(
    Icons.home_outlined,
    ),
    selectedIcon: Icon(
    Icons.home,
    color: Colors.red,
    ),
    label: 'Home',
    ),

    NavigationDestination(
    icon: Icon(
    Icons.fitness_center_outlined,
    ),
    selectedIcon: Icon(
    Icons.fitness_center,
    color: Colors.red,
    ),
    label: 'Workout',
    ),

    NavigationDestination(
    icon: Icon(
    Icons.bar_chart_outlined,
    ),
    selectedIcon: Icon(
    Icons.bar_chart,
    color: Colors.red,
    ),
    label: 'Progress',
    ),

    NavigationDestination(
    icon: Icon(
    Icons.person_outline,
    ),
    selectedIcon: Icon(
    Icons.person,
    color: Colors.red,
    ),
    label: 'Profile',
    ),
    ],
    ),
    );


  }
}




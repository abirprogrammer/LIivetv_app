import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/channel_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const LiveTvApp());
}

class LiveTvApp extends StatelessWidget {
  const LiveTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ChannelProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LiveTv',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
              primaryColor: const Color(0xFFFF2A54),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFF2A54),
                secondary: Color(0xFF00E5FF),
                surface: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black87),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              fontFamily: 'Roboto',
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0F1117),
              primaryColor: const Color(0xFFFF2A54),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF2A54),
                secondary: Color(0xFF00E5FF),
                surface: Color(0xFF141722),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF141722),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF1E2230),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              fontFamily: 'Roboto',
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

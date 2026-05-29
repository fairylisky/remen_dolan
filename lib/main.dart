import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_state.dart';
import 'theme/app_colors.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.init();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const RemenDolanApp(),
    ),
  );
}

class RemenDolanApp extends StatelessWidget {
  const RemenDolanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remen Dolan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200], // Background on desktop
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: child,
            ),
          ),
        );
      },
      home: const LoginScreen(),
    );
  }
}

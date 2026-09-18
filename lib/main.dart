import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_theme.dart';
import 'providers/onboarding_provider.dart';
import 'views/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase Initialization with your real Anon Key
  await Supabase.initialize(
    url: 'https://djtogdcucxekzwxpyrjr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqdG9nZGN1Y3hla3p3eHB5cmpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc2NzIxNTMsImV4cCI6MjEwMzI0ODE1M30.Gi8TOcjrLDQo2ntYEEoSIAt81jJgNTfV02z0Zvou9b8', 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..init()),
      ],
      child: MaterialApp(
        title: 'Skill Pathway',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AuthScreen(),
      ),
    );
  }
}
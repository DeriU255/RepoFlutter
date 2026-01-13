import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardiapp/providers/teacher_provider.dart';
import 'package:guardiapp/providers/absence_provider.dart';
import 'package:guardiapp/providers/schedule_provider.dart';
import 'package:guardiapp/providers/calendar_provider.dart';
import 'package:guardiapp/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfesoresProvider()),
        ChangeNotifierProvider(create: (_) => AusenciasProvider()),
        ChangeNotifierProvider(create: (_) => HorarioProvider()),
        ChangeNotifierProvider(create: (_) => CalendarioProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GuardiApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}

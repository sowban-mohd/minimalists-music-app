import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/presentation/pages/home_screen.dart';

void main() {
  runApp(ProviderScope(child: const MinimalistsMusicApp()));
}

class MinimalistsMusicApp extends StatelessWidget {
  const MinimalistsMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true
      ),
      home: HomeScreen(),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:minimalists_music_app/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MusicFileAdapter());

  await Hive.openBox<MusicFile>('music_files');
  
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



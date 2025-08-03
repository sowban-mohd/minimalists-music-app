import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/core/constants/constants.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:minimalists_music_app/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Hive setup
  await Hive.initFlutter();
  Hive.registerAdapter(MusicFileAdapter());

  await Hive.openBox<MusicFile>(Constants.musicBoxName);

  runApp(ProviderScope(child: const MinimalistsMusicApp()));
}

class MinimalistsMusicApp extends StatelessWidget {
  const MinimalistsMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ColorPalette.onSurfaceContainer,
          selectionHandleColor: ColorPalette.onSurfaceContainer,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

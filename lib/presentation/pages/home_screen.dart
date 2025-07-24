import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/selected_tab_index.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/presentation/components/bottom_navigation_bar_widget.dart';
import 'package:minimalists_music_app/presentation/components/music_library_body.dart';
import 'package:minimalists_music_app/presentation/components/player_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 24.0),
          child: Consumer(
            builder: (context, ref, _) {
              final selectedTabIndex = ref.watch(selectedTabIndexProvider);
              return selectedTabIndex == 0
                  ? PlayerScreenBody()
                  : MusicLibraryBody();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/selected_tab.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final selectedIndex = ref.watch(selectedTabIndexProvider);
                  final selectedIndexNotifier = ref.read(
                    selectedTabIndexProvider.notifier,
                  );
                  return IconButton(
                    icon: Icon(
                      selectedIndex == 0
                          ? Icons.music_note
                          : Icons.music_note_outlined,
                      size: 28,
                      color: Color(0xFF7cbbd7),
                    ),
                    onPressed: () => selectedIndexNotifier.state = 0,
                  );
                },
              ),

              IconButton(
                    icon: Icon(
                      Icons.file_upload_outlined,
                      size: 28,
                      color: Color(0xFF7cbbd7),
                    ),
                    onPressed: () {}
                  ),

              Consumer(
                builder: (context, ref, _) {
                  final selectedIndex = ref.watch(selectedTabIndexProvider);
                  final selectedIndexNotifier = ref.read(
                    selectedTabIndexProvider.notifier,
                  );
                  return IconButton(
                    icon: Icon(
                      selectedIndex == 1
                          ? Icons.library_music
                          : Icons.library_music_outlined,
                      size: 28,
                      color: Color(0xFF7cbbd7),
                    ),
                    onPressed: () => selectedIndexNotifier.state = 1,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

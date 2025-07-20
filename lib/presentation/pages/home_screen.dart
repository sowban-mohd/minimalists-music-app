import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/tonearm_state_notifier.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/presentation/components/bottom_navigation_bar.dart';
import 'package:minimalists_music_app/presentation/components/cd.dart';
import 'package:minimalists_music_app/presentation/components/search_bar.dart';
import 'package:minimalists_music_app/presentation/components/tonearm.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isSearchActive = false;

  late final double screenWidth;
  late final double screenHeight;

  @override
  void initState() {
    super.initState();
    final size = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    ).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  @override
  Widget build(BuildContext context) {
    final tonearmStateNotifier = ref.read(tonearmStateProvider.notifier);

    final cdFromTop = screenHeight * 0.25;
    final cdFromLeft = (screenWidth - 340) / 2;
    final tonearmFromLeft = cdFromLeft + 150;

    return Scaffold(
      backgroundColor: ColorPalette.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 24.0),
          child: Stack(
            children: [
              //CD
              Positioned(
                top: cdFromTop,
                left: cdFromLeft,
                child: CustomPaint(size: const Size(250, 250), painter: CD()),
              ),

              //Tonearm
              Consumer(
                builder: (context, ref, _) {
                  final rotationAngle = ref.watch(
                    tonearmStateProvider.select((state) => state.rotationAngle),
                  );
                  return Positioned(
                    top: cdFromTop,
                    left: tonearmFromLeft,
                    child: CustomPaint(
                      size: Size(120, 150),
                      painter: Tonearm(rotationAngle: rotationAngle),
                    ),
                  );
                },
              ),

              //Invisible gesture detetctor for tonearm handle
              Consumer(
                builder: (context, ref, _) {
                  final isSnappedToCd = ref.watch(
                    tonearmStateProvider.select((state) => state.isSnappedToCd),
                  );
                  final fromTop = cdFromTop + 125;
                  final fromLeft = tonearmFromLeft + 90;
                  final fromLeftWhenCD = tonearmFromLeft + 30;

                  return Positioned(
                    top: fromTop,
                    left: isSnappedToCd ? fromLeftWhenCD : fromLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior
                          .translucent, //enables gesture detection on empty space
                      onPanUpdate: (details) {
                        tonearmStateNotifier.rotateTonearm(details.delta.dx);
                      },
                      onPanEnd: (_) {
                        tonearmStateNotifier.resetToResting();
                      },
                      child: SizedBox(width: 40, height: 40),
                    ),
                  );
                },
              ),

              //Search Bar
              SearchBarWidget(
                isActive: isSearchActive,
                onTap: () => setState(() => isSearchActive = true),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}

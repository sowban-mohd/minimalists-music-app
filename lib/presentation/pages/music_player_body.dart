import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/music_play_controller.dart';
import 'package:minimalists_music_app/controller/tonearm_state_notifier.dart';
import 'package:minimalists_music_app/presentation/components/cd.dart';
import 'package:minimalists_music_app/presentation/components/search_bar_widget.dart';
import 'package:minimalists_music_app/presentation/components/tonearm.dart';

class PlayerScreenBody extends ConsumerWidget {
  const PlayerScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(musicPlayControllerProvider, (_, next) async {
      if (next.shouldPlay == true) {
       await ref.read(musicPlayControllerProvider.notifier).playRandomSong();
      } else {
       await ref.read(musicPlayControllerProvider.notifier).stop();
      }
    });

    final tonearmStateNotifier = ref.read(tonearmStateProvider.notifier);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final cdFromTop = screenHeight * 0.25;
    final cdFromLeft = (screenWidth - 340) / 2;
    final tonearmFromLeft = cdFromLeft + 150;

    return Stack(
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
        SearchBarWidget(),
      ],
    );
  }
}

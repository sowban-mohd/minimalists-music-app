import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/tonearm_state_notifier.dart';
import 'package:minimalists_music_app/repository/music_play_repository.dart';

final musicPlayControllerProvider =
    NotifierProvider<MusicPlayController, MusicPlayState>(
      MusicPlayController.new,
    );

class MusicPlayState {
  final bool shouldPlay;
  final String? successMessage;
  final String? errorMessage;

  const MusicPlayState({
    required this.shouldPlay,
    this.successMessage,
    this.errorMessage,
  });

  MusicPlayState copyWith({
    bool? shouldPlay,
    String? successMessage,
    String? errorMessage,
  }) {
    return MusicPlayState(
      shouldPlay: shouldPlay ?? this.shouldPlay,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class MusicPlayController extends Notifier<MusicPlayState> {
  late final MusicPlayRepository _repository;

  @override
  MusicPlayState build() {
    _repository = ref.read(musicPlayRepositoryProvider);

    final isSnapped = ref.read(
      tonearmStateProvider.select((s) => s.isSnappedToCd),
    );

    // Listen to snapping state changes
    ref.listen<bool>(tonearmStateProvider.select((s) => s.isSnappedToCd), (
      prev,
      next,
    ) {
      state = state.copyWith(shouldPlay: next);
    });

    _repository.setUpOnComplete(() {
      ref.read(tonearmStateProvider.notifier).unsnapFromCd();
    });

    return MusicPlayState(shouldPlay: isSnapped);
  }

  Future<void> playRandomSong() async {
    try {
      await _repository.playRandomSong();
      state = state.copyWith(
        successMessage: "Playing random song",
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), successMessage: null);
    }
  }

  Future<void> stop() async {
    await _repository.stop();
  }
}

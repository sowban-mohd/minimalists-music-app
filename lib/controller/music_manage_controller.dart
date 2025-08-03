import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:minimalists_music_app/repository/music_manage_repository.dart';

final musicManageControllerProvider =
    NotifierProvider<MusicManageController, MusicManageState>(
      MusicManageController.new,
    );

class MusicManageController extends Notifier<MusicManageState> {
  late final MusicManageRepository _repository;
  @override
  MusicManageState build() {
    _repository = ref.read(musicManageRepoProvider);
    return Initial();
  }

  Future<void> updateMetaData({
    required MusicFile song,
    required String songName,
    required String artistName,
  }) async {
    state = Loading();
    try {
      await _repository.updateMetaData(
        song: song,
        songName: songName,
        artistName: artistName,
      );
      state = Success("Song details updated successfully");
    } catch (e) {
      state = Failure("Failed to update the song details: $e");
    }
  }

  Future<void> deleteSong(MusicFile song) async {
    state = Loading();
    try {
      await _repository.deleteSong(song);
      state = Success("Song deleted successfully");
    } catch (e) {
      state = Failure("Failed to delete song: $e");
    }
  }
}

sealed class MusicManageState {
  const MusicManageState();
}

class Initial extends MusicManageState {
  const Initial();
}

class Loading extends MusicManageState {
  const Loading();
}

class Success extends MusicManageState {
  final String message;
  const Success(this.message);
}

class Failure extends MusicManageState {
  final String message;
  const Failure(this.message);
}

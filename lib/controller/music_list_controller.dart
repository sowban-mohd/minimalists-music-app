import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:minimalists_music_app/repository/music_list_repository.dart';

final musicListControllerProvider =
    NotifierProvider<MusicListController, MusicListState>(
      MusicListController.new,
    );

class MusicListState {
  final List<MusicFile>? musicList;
  final String? errorMessage;

  MusicListState({this.musicList, this.errorMessage});
}

class MusicListController extends Notifier<MusicListState> {
  late final MusicListRepository _repository;
  @override
  MusicListState build() {
    _repository = ref.read(musicListRepositoryProvider);

    try {
      _repository.watchBox().listen((event) {
        try {
          state = MusicListState(musicList: _repository.getAllSongs());
        } catch (e) {
          state = MusicListState(errorMessage: 'Error in loading music: $e');
        }
      });

      return MusicListState(musicList: _repository.getAllSongs());
    } catch (e) {
      return MusicListState(errorMessage: 'Error in loading music: $e');
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minimalists_music_app/controller/selected_tab_index.dart';
import 'package:minimalists_music_app/repository/music_upload_repository.dart';

final musicUploadControllerProvider =
    NotifierProvider<MusicUploadController, MusicUploadState>(
      MusicUploadController.new,
    );

class MusicUploadController extends Notifier<MusicUploadState> {
  late final MusicUploadRepository _repository;

  @override
  MusicUploadState build() {
    _repository = ref.read(musicUploadRepositoryProvider);
    return MusicUploadState.initial; //Initial state
  }

  Future<void> uploadSongs() async {
    try {
      final result = await _repository.pickMusicFiles(); //Picking audio file(s)
      ref.read(selectedTabIndexProvider.notifier).state = 1;

      if (result != null) {
        for (var file in result.files) {
          final newPath = await _repository.copyToAppStorage(
            file.path!,
          ); //Copying picked file(s) to app specific storage
          final metaData = await _repository.retrieveMetaData(
            newPath,
          ); //Retrieving metadata from the audio file

          final String trackName = metaData.trackName ?? file.name;
          final List<String>? trackArtistNames = metaData.trackArtistNames;

          //Store the metadata for audio file in local database
          await _repository.storeInDatabase(
            trackName: trackName,
            newPath: newPath,
            trackArtistNames: trackArtistNames,
          );
        }
        String fileOrFiles = result.files.length == 1 ? 'File' : 'Files';
        state = MusicUploadState(successMessage: '$fileOrFiles uploaded succesfully');
      } else {
        //Changes the tab to 0 (music player tab) when user cancels file upload
        ref.read(selectedTabIndexProvider.notifier).state = 0;
      }
    } catch (e) {
      state = MusicUploadState(errorMessage:'Error occured : ${e.toString()}');
    }
  }
}

class MusicUploadState {
  final String? successMessage;
  final bool? loading;
  final String? errorMessage;

 const MusicUploadState({
    this.successMessage,
    this.loading,
    this.errorMessage,
  });

  MusicUploadState copyWith({
    String? successMessage,
    bool? loading,
    String? errorMessage,
  }) {
    return MusicUploadState(
      successMessage: successMessage ?? this.successMessage,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static const MusicUploadState initial = MusicUploadState();
}

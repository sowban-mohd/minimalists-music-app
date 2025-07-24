import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minimalists_music_app/controller/selected_tab_index.dart';
import 'package:minimalists_music_app/models/music_upload_state.dart';
import 'package:minimalists_music_app/repository/music_repository.dart';

final musicUploadControllerProvider =
    NotifierProvider<MusicUploadController, MusicUploadState>(
      MusicUploadController.new,
    );

// class MusicControllerState {
//   final bool? isLoading;
//   final String? errorMessage;
//   final List<String>? uploadingFiles;
//   MusicControllerState({
//     this.isLoading,
//     this.errorMessage,
//     this.uploadingFiles,
//   });
// }

class MusicUploadController extends Notifier<MusicUploadState> {
  late final MusicRepository _repository;

  @override
  MusicUploadState build() {
    _repository = ref.read(musicRepositoryProvider);
    return Initial(); //Initial state
  }

  Future<void> uploadSongs() async {
    try {
      final result = await _repository.pickMusicFiles(); //Picking audio file(s)
      state = Uploading();
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
        state = Success('$fileOrFiles uploaded succesfully');
      } else {
        //Changes the tab to 0 (music player tab) when user cancels file upload
        ref.read(selectedTabIndexProvider.notifier).state = 0;
      }
    } catch (e) {
      state = Error('Error occured : ${e.toString()}');
    }
  }
}

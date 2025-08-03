import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/core/constants/constants.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as p;

final musicUploadRepositoryProvider = Provider((ref) => MusicUploadRepository());

class MusicUploadRepository {
  ///Picking audio file(s)
  Future<FilePickerResult?> pickMusicFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );
    return result;
  }

  ///Copying picked file(s) to app specific storage
  Future<String> copyToAppStorage(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(sourcePath);
    final destinationPath = p.join(appDir.path, fileName);

    final sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);

    return destinationPath;
  }
   
  ///Retrieving metadata from the audio file
  Future<Metadata> retrieveMetaData(String path) async {
    return await MetadataRetriever.fromFile(File(path));
  }
 
  ///Store the metadata for audio file in local database
  Future<void> storeInDatabase({
    required String trackName,
    List<String>? trackArtistNames,
    required String newPath,
  }) async {
    final box = Hive.box<MusicFile>(Constants.musicBoxName);
    final musicFile = MusicFile(
      name: trackName,
      path: newPath,
      artist: trackArtistNames?.join(", ") ?? '',
    );

    await box.add(musicFile);
  }
}

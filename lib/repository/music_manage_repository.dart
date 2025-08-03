import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/models/music_file.dart';

final musicManageRepoProvider = Provider((_) => MusicManageRepository());

class MusicManageRepository {
  Future<void> updateMetaData({
    required MusicFile song,
    required String songName,
    required String artistName,
  }) async {
    bool updated = false;
    if (song.artist != artistName) {
      song.artist = artistName;
      updated = true;
    }
    if (song.name != songName) {
      song.name = songName;
      updated = true;
    }
    if (updated) await song.save();
  }

  Future<void> deleteSong(MusicFile song) async {
    await song.delete();
  }
}

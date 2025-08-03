import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/core/constants/constants.dart';
import 'package:minimalists_music_app/models/music_file.dart';

final musicListRepositoryProvider = Provider((_) => MusicListRepository());

class MusicListRepository {
  final Box<MusicFile> _musicBox = Hive.box<MusicFile>(Constants.musicBoxName);

  List<MusicFile> getAllSongs() {
    return _musicBox.values.toList();
  }

  Stream<BoxEvent> watchBox() {
    return _musicBox.watch();
  }
}

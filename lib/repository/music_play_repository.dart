import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/core/constants/constants.dart';
import 'package:minimalists_music_app/models/music_file.dart';

final audioPlayerProvider = Provider((_) => AudioPlayer());
final musicPlayRepositoryProvider = Provider(
  (ref) => MusicPlayRepository(ref.read(audioPlayerProvider)),
);

class MusicPlayRepository {
  final AudioPlayer _player;

  MusicPlayRepository(AudioPlayer player) : _player = player;

  void setUpOnComplete(VoidCallback callback) {
    _player.onPlayerComplete.listen((_) {
      callback();
    });
  }

  Future<String> playRandomSong() async {
    final box = Hive.box<MusicFile>(Constants.musicBoxName);

    if (box.isEmpty) {
      throw Exception('Music library is empty');
    }

    final random = Random();
    final index = random.nextInt(box.length);
    final musicFile = box.getAt(index);

    if (musicFile != null) {
      await _player.play(DeviceFileSource(musicFile.path));
      return 'Song playing is : ${musicFile.name}';
    } else {
      throw Exception('Error occured in playing song');
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }
}

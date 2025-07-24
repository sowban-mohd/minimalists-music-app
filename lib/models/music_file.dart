import 'package:hive_flutter/hive_flutter.dart';

part 'music_file.g.dart';

@HiveType(typeId: 0)
class MusicFile extends HiveObject{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String path;

  @HiveField(2)
  final String? artist;

  MusicFile({
    required this.name,
    required this.path,
    this.artist,
  });
}

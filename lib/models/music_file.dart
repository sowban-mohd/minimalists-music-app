import 'package:hive_flutter/hive_flutter.dart';

part 'music_file.g.dart';

@HiveType(typeId: 0)
class MusicFile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  final String path;

  @HiveField(2)
  String? artist;

  MusicFile({
    required this.name,
    required this.path,
    this.artist,
  });

  // MusicFile copyWith({
  //   String? name,
  //   String? path,
  //   String? artist,
  // }) {
  //   return MusicFile(
  //     name: name ?? this.name,
  //     path: path ?? this.path,
  //     artist: artist ?? this.artist,
  //   );
  // }
}

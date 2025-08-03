import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/music_manage_controller.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/core/utils/show_snackbar.dart';
import 'package:minimalists_music_app/models/music_file.dart';

void showSongEditingDialog(BuildContext context, {required MusicFile song}) {
  showDialog(
    context: context,
    builder: (_) {
      return SongEditingDialog(song: song);
    },
  );
}

class SongEditingDialog extends ConsumerStatefulWidget {
  final MusicFile song;
  const SongEditingDialog({super.key, required this.song});

  @override
  ConsumerState<SongEditingDialog> createState() => _SongEditingDialogState();
}

class _SongEditingDialogState extends ConsumerState<SongEditingDialog> {
  late final TextEditingController songNameController;
  late final TextEditingController artistNameController;

  @override
  void initState() {
    super.initState();
    songNameController = TextEditingController(text: widget.song.name);
    artistNameController = TextEditingController(
      text: widget.song.artist ?? '',
    );
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        width: 350,
        height: 350,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorPalette.musicCardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              height: 60,
              width: 60,
              child: Image.asset('assets/icons/music.png', fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Song name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: _buildTextField(
                    context,
                    controller: songNameController,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Artist',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: _buildTextField(
                    context,
                    controller: artistNameController,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(105, 42),
                    shape: RoundedSuperellipseBorder(
                      side: BorderSide(color: Color(0xFFdee0e1), width: 0.2),
                      borderRadius: BorderRadiusGeometry.circular(14.0),
                    ),
                    foregroundColor: Color(0xFF1d91e2),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Consumer(
                  builder: (context, ref, _) {
                    final controllerProvider = musicManageControllerProvider;
                    final controllerState = ref.watch(controllerProvider);

                    ref.listen(controllerProvider, (previous, next) {
                      if (next is Failure) {
                        showSnackbar(context, next.message);
                      } else if (next is Success) {
                        Navigator.of(context).pop();
                      }
                    });

                    return ElevatedButton(
                      onPressed: () async {
                        final updatedSongName = songNameController.text.trim();
                        final updatedArtistName = artistNameController.text
                            .trim();

                        await ref
                            .read(controllerProvider.notifier)
                            .updateMetaData(
                              song: widget.song,
                              songName: updatedSongName,
                              artistName: updatedArtistName,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(105, 42),
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadiusGeometry.circular(14.0),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: controllerState is Loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextField _buildTextField(
  BuildContext context, {
  required TextEditingController controller,
}) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,

    style: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'NunitoSans',
      fontWeight: FontWeight.w300,
    ),
    onTapOutside: (_) => FocusScope.of(
      context,
    ).unfocus(), //Removed focus from textfield on tapped outside
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFdee0e1), width: 0.2),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0.2),
        borderRadius: BorderRadius.circular(14.0),
      ),
    ),
  );
}

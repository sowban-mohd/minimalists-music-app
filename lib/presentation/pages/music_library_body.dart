import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalists_music_app/controller/music_list_controller.dart';
import 'package:minimalists_music_app/controller/music_manage_controller.dart';
import 'package:minimalists_music_app/controller/music_upload_controller.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/core/utils/show_snackbar.dart';
import 'package:minimalists_music_app/presentation/components/deletion_confirmation_dialog.dart';
import 'package:minimalists_music_app/presentation/components/song_details_editing_dialog.dart';
import 'package:minimalists_music_app/presentation/reusable_layouts/empty_list_body.dart';

class MusicLibraryBody extends ConsumerWidget {
  const MusicLibraryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicManageController = ref.read(
      musicManageControllerProvider.notifier,
    );

    ref.listen(musicUploadControllerProvider, (_, next) {
      if (next.successMessage != null) {
        showSnackbar(context, next.successMessage!);
      } else if (next.errorMessage != null) {
        showSnackbar(context, next.errorMessage!);
      }
    });

    ref.listen(musicManageControllerProvider, (_, next) {
      if (next is Success) {
        showSnackbar(context, next.message);
      } else if (next is Failure) {
        showSnackbar(context, next.message);
      }
    });

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text(
            'Music Library',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 45),
          Consumer(
            builder: (context, ref, _) {
              final isLoading = ref.watch(
                musicUploadControllerProvider.select((state) => state.loading),
              );
              if (isLoading != null) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              final musicListState = ref.watch(musicListControllerProvider);
              final songs = musicListState.musicList;
              if (songs != null) {
                if (songs.isEmpty) {
                  return EmptyListScreen(message: 'No Songs Avaliable');
                }

                return SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ColorPalette.musicCardColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                'assets/icons/music.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'NunitoSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                  if (song.artist != null)
                                    Text(
                                      song.artist!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              icon: Icon(Icons.more_vert),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  showSongEditingDialog(context, song: song);
                                } else if (value == 'delete') {
                                  bool? confirmed =
                                      await showConfirmationDialog(context);
                                  if (confirmed != null && confirmed == true) {
                                    await musicManageController.deleteSong(
                                      song,
                                    );
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: SizedBox(
                                    width: 85,
                                    height: 45,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                            'assets/icons/edit_icon.png',
                                          ),
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: SizedBox(
                                    width: 85,
                                    height: 45,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                            'assets/icons/delete_icon.png',
                                          ),
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, _) => SizedBox(height: 16),
                    ),
                  ),
                );
              } else if (musicListState.errorMessage != null) {
                return EmptyListScreen(message: musicListState.errorMessage!);
              } else {
                return EmptyListScreen(message: 'Unexpected error occured');
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalists_music_app/controller/music_upload_controller.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';
import 'package:minimalists_music_app/core/utils/show_snackbar.dart';
import 'package:minimalists_music_app/models/music_file.dart';
import 'package:minimalists_music_app/models/music_upload_state.dart';

class MusicLibraryBody extends ConsumerWidget {
  const MusicLibraryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(musicUploadControllerProvider, (_, next) {
      if (next is Success) {
        showSnackbar(context, next.message);
      } else if (next is Error) {
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
              final musicUploadingState = ref.watch(
                musicUploadControllerProvider,
              );
              if (musicUploadingState is Uploading) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return ValueListenableBuilder(
                valueListenable: Hive.box<MusicFile>('music_files').listenable(),
                builder: (context, box, _) {
                  final items = box.values.toList();
      
                  if (items.isEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: double.infinity,
                      height: 350,
                      child: Center(
                        child: Text(
                          'No Songs Avaliable',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
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
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
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
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (item.artist != null)
                                      Text(
                                        item.artist!,
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
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

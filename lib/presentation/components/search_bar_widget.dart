import 'package:flutter/material.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 300,
        height: 50,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: TextField(
            controller: searchController,
            cursorColor: ColorPalette.onSurfaceContainer,
            onTapOutside: (_) => FocusScope.of(
              context,
            ).unfocus(), //Removed focus from textfield on tapped outside
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 15,
                color: ColorPalette.onSurfaceContainer,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(Icons.search, color: ColorPalette.onSurfaceContainer),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

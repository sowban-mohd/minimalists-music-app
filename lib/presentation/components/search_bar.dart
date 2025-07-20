import 'package:flutter/material.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';

class SearchBarWidget extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const SearchBarWidget({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Align(
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
              cursorColor: ColorPalette.onSurface,
              onTap: onTap,
              autofocus: isActive,
              onTapOutside: (_) => FocusScope.of(context).unfocus(), //Removed focus from textfield on tapped outside
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: ColorPalette.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.search, color: ColorPalette.onSurface),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

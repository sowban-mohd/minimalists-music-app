import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  final String message;
  const EmptyListScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      height: 350,
      child: Center(
        child: Text(
          message,
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
}

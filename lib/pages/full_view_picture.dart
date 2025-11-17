import 'package:flutter/material.dart';

class FullViewPicture extends StatelessWidget {
  const FullViewPicture({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(image, fit: BoxFit.contain)),
          Align(
            alignment: Alignment(-.9, -.9),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

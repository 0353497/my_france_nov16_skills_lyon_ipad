import 'package:flutter/material.dart';

class Travelpage extends StatelessWidget {
  const Travelpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            fit: BoxFit.cover,
            "assets/location_image/map_paris_city.jpg",
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Text(
            "Populair Locations",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),

        Positioned(
          right: 20,
          bottom: 130,
          width: 100,
          height: 100,
          child: IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {},
            icon: Image.asset(width: 64, "assets/icons/icon_draw.png"),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          width: 100,
          height: 100,
          child: IconButton.filled(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {},
            icon: Icon(Icons.download, color: Colors.black, size: 64),
          ),
        ),
      ],
    );
  }
}

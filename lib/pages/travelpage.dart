import 'package:flutter/material.dart';

class Travelpage extends StatelessWidget {
  const Travelpage({super.key});
  static List<Alignment> markerLocations = [
    Alignment(-0.8, -0.6),
    Alignment(0.3, -0.2),
    Alignment(-0.5, 0.4),
    Alignment(0.7, 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true,
      minScale: 0.5,
      maxScale: 4.0,
      constrained: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 2,
        height: MediaQuery.of(context).size.height * 2,
        child: Stack(
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
                "Popular Locations",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            ...markerLocations.map((alignment) {
              return Align(
                alignment: alignment,
                child: GestureDetector(
                  onTap: () {
                    print("Marker tapped at ${alignment}");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.amber,
                      size: 120,
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              right: 20,
              bottom: 130,
              width: 100,
              height: 100,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  elevation: WidgetStatePropertyAll(4),
                ),
                onPressed: () {
                  print("Draw button pressed");
                },
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
                  elevation: WidgetStatePropertyAll(4),
                ),
                onPressed: () {
                  print("Download button pressed");
                },
                icon: Icon(Icons.download, color: Colors.black, size: 64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

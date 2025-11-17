import 'package:flutter/material.dart';
import 'package:my_france/pages/full_view_picture.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/api.dart';

class Travelpage extends StatefulWidget {
  const Travelpage({super.key});

  @override
  State<Travelpage> createState() => _TravelpageState();
}

class _TravelpageState extends State<Travelpage> {
  List locationData = [];
  bool isLoading = true;
  bool isInDrawMode = false;
  List<Offset> drawnPoints = [];
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    loadLocationData();
    _transformationController.addListener(() => setState(() {}));
  }

  Future<void> loadLocationData() async {
    try {
      final data = await ApiHelper.readAssetJson(
        'assets/data/location_map_data.json',
      );
      setState(() {
        locationData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, double> _getPositionFromCoordinates(List<dynamic> coordinates) {
    double left = coordinates[0].toDouble();
    double top = coordinates[1].toDouble();
    return {'left': left, 'top': top};
  }

  void _showLocationDialog(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          location['location_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Text(location['location_introduction']),
                          ),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              Flexible(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullViewPicture(
                                        image:
                                            "assets/location_image/${location['location_scene_image']}",
                                      ),
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/location_image/${location['location_scene_image']}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullViewPicture(
                                        image:
                                            "assets/location_image/${location['location_map_image']}",
                                      ),
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/location_image/${location['location_map_image']}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      launchUrlString("maps://");
                    },
                    child: Text("Go now!"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _transformationController,
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
                ...locationData.map((location) {
                  final position = _getPositionFromCoordinates(
                    location['location_mark_x_y_of_map_image'],
                  );
                  return Positioned(
                    left: position['left']! - 60,
                    top: position['top']! - 60,
                    child: GestureDetector(
                      onTap: () => _showLocationDialog(location),
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
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Transform(
            transform: _transformationController.value,
            child: CanvasDrawer(
              isDrawingEnabled: isInDrawMode,
              points: drawnPoints,
              onPointsChanged: (points) {
                setState(() {
                  drawnPoints = points;
                });
              },
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 130,
          width: 100,
          height: 100,
          child: IconButton.filled(
            style: ButtonStyle(
              backgroundColor: isInDrawMode
                  ? WidgetStatePropertyAll(Colors.green)
                  : WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(4),
            ),
            onPressed: () {
              setState(() {
                isInDrawMode = !isInDrawMode;
              });
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
              debugPrint("Download button pressed");
            },
            icon: Icon(Icons.download, color: Colors.black, size: 64),
          ),
        ),
      ],
    );
  }
}

class CanvasDrawer extends StatefulWidget {
  final bool isDrawingEnabled;
  final List<Offset> points;
  final ValueChanged<List<Offset>> onPointsChanged;

  const CanvasDrawer({
    super.key,
    required this.isDrawingEnabled,
    required this.points,
    required this.onPointsChanged,
  });

  @override
  State<CanvasDrawer> createState() => _CanvasDrawerState();
}

class _CanvasDrawerState extends State<CanvasDrawer> {
  List<Offset> localPoints = [];

  @override
  void initState() {
    super.initState();
    localPoints = List.from(widget.points);
  }

  @override
  void didUpdateWidget(CanvasDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.points != oldWidget.points) {
      localPoints = List.from(widget.points);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDrawingEnabled
        ? Listener(
            onPointerDown: (event) {
              setState(() {
                localPoints.add(event.localPosition);
                widget.onPointsChanged(localPoints);
              });
            },
            onPointerMove: (event) {
              setState(() {
                localPoints.add(event.localPosition);
                widget.onPointsChanged(localPoints);
              });
            },
            onPointerUp: (event) {
              setState(() {
                localPoints.add(Offset.zero);
                widget.onPointsChanged(localPoints);
              });
            },
            child: CustomPaint(
              painter: Drawing(points: localPoints),
              child: Container(),
            ),
          )
        : IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              painter: Drawing(points: localPoints),
              child: Container(),
            ),
          );
  }
}

class Drawing extends CustomPainter {
  final List<Offset> points;

  Drawing({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Drawing oldDelegate) {
    return oldDelegate.points != points;
  }
}

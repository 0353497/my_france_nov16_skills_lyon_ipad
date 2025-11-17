import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../utils/api.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController controller = ScrollController();
  int selectedIndex = -1;
  bool isFavorite = false;
  List<Map<String, dynamic>> diaryEntries = [];
  bool isLoading = true;
  String? errorMessage;
  bool isLeftSideDiaryList = true; // Track which view is on which side

  final List<String> assetImages = [
    'assets/location_image/scene_1.jpg',
    'assets/location_image/scene_2.jpg',
    'assets/location_image/scene_3.jpg',
    'assets/location_image/scene_4.jpg',
    'assets/location_image/scene_5.jpg',
    'assets/location_image/scene_6.jpg',
    'assets/location_image/scene_7.jpg',
    'assets/location_image/scene_8.jpg',
    'assets/location_image/scene_9.jpg',
    'assets/location_image/scene_10.jpg',
    'assets/location_image/scene_11.jpg',
  ];

  String getRandomAssetImage() {
    final random = Random();
    return assetImages[random.nextInt(assetImages.length)];
  }

  @override
  void initState() {
    super.initState();
    fetchDiaryEntries();
  }

  Future<void> fetchDiaryEntries() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await ApiHelper.getDiaries();

      if (response['msg'] == 'Success' && response['data'] is List) {
        setState(() {
          diaryEntries = List<Map<String, dynamic>>.from(response['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load diary entries';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DragTarget<String>(
            onWillAcceptWithDetails: (data) =>
                data.data == 'detail_view' || data.data == 'diary_list',
            onAcceptWithDetails: (data) {
              setState(() {
                if (data.data == 'detail_view') {
                  isLeftSideDiaryList = false;
                } else if (data.data == 'diary_list') {
                  isLeftSideDiaryList = true;
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  border: candidateData.isNotEmpty
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Draggable<String>(
                  data: isLeftSideDiaryList ? 'diary_list' : 'detail_view',
                  feedback: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isLeftSideDiaryList ? 'Diary List' : 'Detail View',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey.withAlpha(50),
                    child: Center(
                      child: Text(
                        'Drop zone',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ),
                  child: isLeftSideDiaryList
                      ? _buildDiaryListView()
                      : _buildDetailView(),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: DragTarget<String>(
            onWillAcceptWithDetails: (data) =>
                data.data == 'detail_view' || data.data == 'diary_list',
            onAcceptWithDetails: (data) {
              setState(() {
                if (data.data == 'detail_view') {
                  isLeftSideDiaryList = true;
                } else if (data.data == 'diary_list') {
                  isLeftSideDiaryList = false;
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  border: candidateData.isNotEmpty
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Draggable<String>(
                  data: isLeftSideDiaryList ? 'detail_view' : 'diary_list',
                  feedback: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isLeftSideDiaryList ? 'Detail View' : 'Diary List',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    color: Colors.grey.withAlpha(100),
                    child: Center(
                      child: Text(
                        'Drop zone',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ),
                  child: isLeftSideDiaryList
                      ? _buildDetailView()
                      : _buildDiaryListView(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiaryListView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Diaries",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Spacer(),
              Icon(Icons.drag_handle, color: Colors.grey),
            ],
          ),
          if (isLoading)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage!),
                    ElevatedButton(
                      onPressed: fetchDiaryEntries,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        spacing: 12,
                        children: List.generate(diaryEntries.length, (index) {
                          if (index % 2 != 0) return SizedBox.shrink();
                          final entry = diaryEntries[index];
                          return ListViewHomePageCard(
                            image: getRandomAssetImage(),
                            title: entry['diary_title'],
                            description: 'By ${entry['diary_upload_username']}',
                            height: index == 0 ? 200.0 : 500.0,
                            isSelected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          );
                        }).where((widget) => widget is! SizedBox).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        spacing: 12,
                        children: List.generate(diaryEntries.length, (index) {
                          if (index % 2 == 0) return SizedBox.shrink();
                          final entry = diaryEntries[index];
                          return ListViewHomePageCard(
                            image: getRandomAssetImage(),
                            title: entry['diary_title'],
                            description: 'By ${entry['diary_upload_username']}',
                            height: 500.0,
                            isSelected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          );
                        }).where((widget) => widget is! SizedBox).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                selectedIndex == -1 ? "Welcome" : "Detail View",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Spacer(),
              Icon(Icons.drag_handle, color: Colors.grey),
            ],
          ),
          Expanded(
            child: selectedIndex == -1 || diaryEntries.isEmpty
                ? welcomeToFranceView()
                : highlightCard(),
          ),
        ],
      ),
    );
  }

  Column welcomeToFranceView() {
    return Column(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 500,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment(.5, -.5),
                    child: Image.asset(
                      opacity: AlwaysStoppedAnimation(.7),
                      width: constraints.maxWidth - 100,
                      "assets/icons/art_icon_la_tour_eiffel.png",
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0),
                    child: Image.asset(
                      "assets/icons/art_icon_arc_de_triomphe.png",
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Center(
          child: Text(
            "Welcome to France",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  highlightCard() {
    if (selectedIndex == -1 || selectedIndex >= diaryEntries.length) {
      return welcomeToFranceView();
    }

    final selectedEntry = diaryEntries[selectedIndex];
    var data =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
        "nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in "
        "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia "
        "deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur "
        "adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip "
        "ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit "
        "esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non "
        "proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(getRandomAssetImage()),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = -1;
                        });
                      },
                      icon: Icon(Icons.close, weight: 12, size: 40),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_outline,
                          weight: 12,
                          size: 40,
                          color: isFavorite ? Colors.amberAccent : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedEntry['diary_title'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final data = ClipboardData(
                      text: selectedEntry['diary_title'],
                    );
                    Clipboard.setData(data);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Succes fully copied")),
                    );
                  },
                  icon: Icon(Icons.copy),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'By ${selectedEntry['diary_upload_username']} • ${selectedEntry['diary_upload_datetime']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 16),
            Text(
              data,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewHomePageCard extends StatelessWidget {
  const ListViewHomePageCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.height,
    this.isSelected = false,
    this.onTap,
  });
  final String image;
  final String title;
  final String description;
  final double height;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Card(
          elevation: isSelected ? 8.0 : 1.0,
          color: isSelected ? Colors.blueAccent.withAlpha(10) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(color: Colors.blueAccent, width: 2.0)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image.startsWith('http')
                            ? NetworkImage(image) as ImageProvider
                            : AssetImage(image),
                      ),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blueAccent : null,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blueAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

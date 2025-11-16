import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController controller = ScrollController();
  int selectedIndex = -1;

  final List<Map<String, dynamic>> diaryEntries = [
    {
      'image': 'assets/location_image/scene_3.jpg',
      'title': 'Nice trip in Lyon',
      'description': 'Exploring the beautiful city of Lyon',
      'height': 200.0,
    },
    {
      'image': 'assets/location_image/scene_1.jpg',
      'title': 'Paris Adventure',
      'description': 'A wonderful day at the Eiffel Tower',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_5.jpg',
      'title': 'Marseille Coast',
      'description': 'Beautiful Mediterranean views',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_7.jpg',
      'title': 'Bordeaux Wine Tour',
      'description': 'Tasting the finest French wines',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_2.jpg',
      'title': 'Nice Promenade',
      'description': 'Walking along the French Riviera',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_4.jpg',
      'title': 'Strasbourg Cathedral',
      'description': 'Gothic architecture at its finest',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_6.jpg',
      'title': 'Loire Valley Castles',
      'description': 'Discovering medieval French castles',
      'height': 500.0,
    },
    {
      'image': 'assets/location_image/scene_8.jpg',
      'title': 'Provence Lavender Fields',
      'description': 'Purple fields as far as the eye can see',
      'height': 500.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Diaries",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            spacing: 12,
                            children: List.generate(
                              (diaryEntries.length / 2).ceil(),
                              (index) {
                                final entryIndex = index * 2;
                                if (entryIndex >= diaryEntries.length)
                                  return SizedBox.shrink();
                                final entry = diaryEntries[entryIndex];
                                return ListViewHomePageCard(
                                  image: entry['image'],
                                  title: entry['title'],
                                  description: entry['description'],
                                  height: entry['height'],
                                  isSelected: selectedIndex == entryIndex,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = entryIndex;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            spacing: 12,
                            children: List.generate(
                              (diaryEntries.length / 2).floor(),
                              (index) {
                                final entryIndex = index * 2 + 1;
                                if (entryIndex >= diaryEntries.length)
                                  return SizedBox.shrink();
                                final entry = diaryEntries[entryIndex];
                                return ListViewHomePageCard(
                                  image: entry['image'],
                                  title: entry['title'],
                                  description: entry['description'],
                                  height: entry['height'],
                                  isSelected: selectedIndex == entryIndex,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = entryIndex;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: selectedIndex == -1
                ? welcomeToFranceView()
                : highlightCard(),
          ),
        ),
      ],
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
                          image: AssetImage(
                            diaryEntries[selectedIndex]["image"],
                          ),
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
                          selectedIndex = -1;
                        });
                      },
                      icon: Icon(Icons.star_outline, weight: 12, size: 40),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  diaryEntries[selectedIndex]["title"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () async {
                    final data = ClipboardData(
                      text: diaryEntries[selectedIndex]["title"],
                    );
                    Clipboard.setData(data);
                  },
                  icon: Icon(Icons.copy),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              diaryEntries[selectedIndex]["description"],
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
          color: isSelected ? Colors.blueAccent.withOpacity(0.1) : null,
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
                        image: AssetImage(image),
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

import 'package:flutter/material.dart';
import 'package:my_france/pages/account_page.dart';
import 'package:my_france/pages/homepage.dart';
import 'package:my_france/pages/travelpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentView = 0;

  void switchView(int index) {
    setState(() {
      currentView = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: SideBar(
                currentView: currentView,
                onViewChanged: switchView,
              ),
            ),
            Flexible(flex: 5, child: getCurrentView()),
          ],
        ),
      ),
    );
  }

  getCurrentView() {
    if (currentView == 0) return Homepage();
    if (currentView == 1) return Travelpage();
    if (currentView == 2) return AccountPage();
  }
}

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });
  final int currentView;
  final Function(int) onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 46,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 35,
                foregroundImage: AssetImage(
                  "assets/icons/art_icon_arc_de_triomphe.png",
                ),
              ),
              Flexible(
                child: Text("My France", style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
          SideBarTile(
            icon: Icons.home_outlined,
            text: "Home",
            isSelected: currentView == 0,
            onTap: () => onViewChanged(0),
          ),
          SideBarTile(
            icon: Icons.map_outlined,
            text: "Travel",
            isSelected: currentView == 1,
            onTap: () => onViewChanged(1),
          ),
          SideBarTile(
            icon: Icons.account_circle_outlined,
            text: "Account",
            isSelected: currentView == 2,
            onTap: () => onViewChanged(2),
          ),
        ],
      ),
    );
  }
}

class SideBarTile extends StatelessWidget {
  const SideBarTile({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 12,
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.blue : null),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                color: isSelected ? Colors.blue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

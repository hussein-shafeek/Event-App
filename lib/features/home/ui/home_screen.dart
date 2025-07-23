import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/ui/love_tab.dart';
import 'package:evently/features/events/ui/map_tap.dart';
import 'package:evently/features/events/ui/profile_tab.dart';
import 'package:evently/features/home/data/nav_bar_icon.dart';
import 'package:evently/features/home/ui/home_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> tabs = [HomeTab(), MapTap(), LoveTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        color: AppColors.primary,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            if (currentIndex == index) return;
            currentIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'Home'),
              activeIcon: NavBarIcon(imageName: 'sHome'),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'map'),
              activeIcon: NavBarIcon(imageName: 'smap'),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'IconLove'),
              activeIcon: NavBarIcon(imageName: 'sHeart'),
              label: "Love",
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'Profile'),
              activeIcon: NavBarIcon(imageName: 'sprofile'),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

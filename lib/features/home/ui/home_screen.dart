import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/ui/love/love_tab.dart';
import 'package:evently/features/events/ui/map_tap.dart';
import 'package:evently/features/events/ui/profile/profile_tab.dart';
import 'package:evently/features/home/data/nav_bar_icon.dart';
import 'package:evently/features/home/ui/home_tab/home_tab.dart';
import 'package:evently/l10n/app_localizations.dart';
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
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      body: tabs[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createEvent),
        child: Icon(Icons.add, size: 36),
        //backgroundColor: AppColors.primary,
        shape: CircleBorder(),
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
              label: appLocalizations.home,
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'map'),
              activeIcon: NavBarIcon(imageName: 'smap'),
              label: appLocalizations.map,
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'IconLove'),
              activeIcon: NavBarIcon(imageName: 'sHeart'),
              label: appLocalizations.love,
            ),
            BottomNavigationBarItem(
              icon: NavBarIcon(imageName: 'Profile'),
              activeIcon: NavBarIcon(imageName: 'sprofile'),
              label: appLocalizations.profile,
            ),
          ],
        ),
      ),
    );
  }
}

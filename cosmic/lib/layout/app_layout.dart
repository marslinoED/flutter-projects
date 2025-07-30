import 'package:cosmic/screens/homeScreen/home_screen.dart';
import 'package:cosmic/screens/planetsScreen/planets_screen.dart';
import 'package:cosmic/screens/settingsScreen/setting_screen.dart';
import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppLayout extends StatefulWidget {
  AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  List<Map<String, dynamic>> screens = [
    {'screenTitle': 'Home', 'Screen': HomeScreen()},
    {'screenTitle': 'Planets', 'Screen': PlanetsScreen()},
    {'screenTitle': 'Settings', 'Screen': SettingsScreen()},
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Planets'),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Settings',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: AppTheme().darkAccent,
        backgroundColor: AppTheme().backgroundTransparent,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.all(Radius.circular(50)),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.4),
                  width: 3,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circularButton(Icon(Icons.menu), Colors.grey[600]!, () {}),
                  const SizedBox(width: 30),
                  Text(
                    screens[currentIndex]['screenTitle'],
                    style: AppTheme().bodyExtraLarge,
                  ),
                  const SizedBox(width: 30),
                  circularButton(Icon(Icons.person), Colors.grey[600]!, () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          screens[currentIndex]['Screen'],
        ],
      ),
    );
  }
}

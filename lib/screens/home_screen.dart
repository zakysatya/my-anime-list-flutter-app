import 'package:flutter/material.dart';
import 'package:myanimelist/screens/dashboard_screen.dart';
import 'package:myanimelist/screens/explore_screen.dart';
import 'package:myanimelist/screens/profile_screen.dart';
import 'package:myanimelist/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          //borderRadius: BorderRadius.circular(24.0),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.backgroundColor,
            unselectedItemColor: AppColors.backgroundColor,
            selectedIconTheme: const IconThemeData(size: 36),
            selectedLabelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold),
            onTap: _onItemTapped,
            iconSize: 32,

            showUnselectedLabels: false,
            backgroundColor: AppColors.primaryColor,
            elevation: 0,  // Remove elevation for better visual
          ),
        ),
      ),
    );
  }
}

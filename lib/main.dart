import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myanimelist/screens/auth/login_screen.dart';
import 'package:myanimelist/screens/auth/register_screen.dart';
import 'package:myanimelist/screens/dashboard_screen.dart';
import 'package:myanimelist/screens/explore_screen.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:myanimelist/screens/splash_screen.dart';
import 'package:myanimelist/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Anime List',
      theme: ThemeData(
          textTheme: GoogleFonts.tsukimiRoundedTextTheme(),
        appBarTheme: AppBarTheme( iconTheme: IconThemeData(color: AppColors.textSecondaryColor),backgroundColor: AppColors.backgroundColor, titleTextStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: AppColors.textSecondaryColor)),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/explore': (context) => ExploreScreen(),
        // '/detail': (context) => DetailScreen(),
        '/home': (context) => HomeScreen(),
        // '/user_info': (context) => UserInfoScreen()

      },
    );
  }
}

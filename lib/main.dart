import 'package:co_2/splash.dart';
import 'package:flutter/material.dart';



void main() {
  runApp( MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        
      primaryColor: Color(0xFF40E0D0), // Turquoise
      scaffoldBackgroundColor: Color.fromARGB(255, 248, 247, 247), // Soft Grey
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE0E0E0)), // Light Grey text
        bodyMedium: TextStyle(color: Color(0xFF2C2C2C)), // Dark Grey text
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF40E0D0), // Turquoise button
      foregroundColor: Colors.white, // White text on buttons
     ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF40E0D0), // Dark Grey AppBar
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
),

      
    );
  }
}
import 'package:co_2/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:co_2/test.dart';
import 'package:co_2/education.dart';
import 'package:co_2/practice.dart';
import 'package:co_2/history_page.dart';
import 'camera_view.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color(0xFF40E0D0),Color(0xFF2C2C2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Color Blindness Aid & Test!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildFeatureCard(
                        context,
                        title: 'Color Blindness Test',
                        icon: Icons.check_circle,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorBlindnessTestPage(),
                          ),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Aid Tools',
                        icon: Icons.camera,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ColorScanner()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Educational Content',
                        icon: Icons.school,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EducationalContentPage(),
                          ),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'History & Progress',
                        icon: Icons.history,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPage()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Color Naming Practice',
                        icon: Icons.palette,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorNamingPracticePage(),
                          ),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Real-Time Simulation',
                        icon: Icons.visibility,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorBlindnessSimulator(),
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
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: Colors.white.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF40E0D0)),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

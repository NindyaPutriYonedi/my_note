import 'package:flutter/material.dart';
import 'package:my_note/screen/home_screen.dart';
import 'package:my_note/screen/home_screen.dart';

void main() {
  runApp(SplashApp());
}

class SplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/ss.jpg',
            fit: BoxFit.cover,
          ),

          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // ...
// Content
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center, // <-- ubah dari start ke center
    children: [
      Text(
        'Welcome to My Noted!',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 12),
      Text(
        'Your journey begins here. Let’s get started!',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white70,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 30),

      // Tombol Get Started di tengah dan lebar penuh
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Get Started',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      )
    ],
  ),
),

        ],
      ),
    );
  }
}

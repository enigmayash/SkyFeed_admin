import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('lib\Images\retro-world-theatre-day-scenes-with-curtains-stage.jpg'), // Replace with your provided image link
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // App Name in the center
          Center(
            child: Text(
              'SkyFeed',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
            ),
          ),

          // Sign In and Sign Up buttons at top right corner
          Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to Sign In page
                    Navigator.pushNamed(context, '/SignInPage'); // Replace with your sign-in page route
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign Up page
                    Navigator.pushNamed(context, '/SignUpPage'); // Replace with your sign-up page route
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

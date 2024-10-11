import 'package:flutter/material.dart';
// import 'SignInPage.dart';
// import 'SignUpPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // App Name in the center
          const Center(
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
                    Navigator.pushNamed(context,
                        '/SignInPage'); // Replace with your sign-in page route
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign Up page
                    Navigator.pushNamed(context,
                        '/SignUpPage'); // Replace with your sign-up page route
                  },
                  child: const Text(
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

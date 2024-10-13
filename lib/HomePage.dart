import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// import 'SignInPage.dart';
// import 'SignUpPage.dart';
// import 'MediaUploadPage.dart';
// import 'listmedia.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      setState(() {
        _isSignedIn = result.isSignedIn;
      });
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      setState(() {
        _isSignedIn = false;
      });
    } catch (e) {
      print('Error signing out: $e');
    }
  }

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

          // Navigation buttons
          Positioned(
            top: 50,
            right: 20,
            child: _isSignedIn ? _buildSignedInButtons() : _buildSignedOutButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildSignedInButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => context.go('/upload-media'),
          child: const Text('Upload Media'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => context.go('/list-media'),
          child: const Text('View Media'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
        ),
      ],
    );
  }

  Widget _buildSignedOutButtons() {
    return Row(
      children: [
        TextButton(
          onPressed: () => context.go('/signin'),
          child: const Text(
            'Sign In',
            style: TextStyle(color: Color.fromARGB(255, 10, 0, 0), fontSize: 18),
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => context.go('/signup'),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Color.fromARGB(255, 10, 0, 0), fontSize: 18),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// import 'SignInPage.dart';
import 'package:go_router/go_router.dart';

class ConfirmSignUpPage extends StatefulWidget {
  final String username;

  const ConfirmSignUpPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _ConfirmSignUpPageState createState() => _ConfirmSignUpPageState();
}

class _ConfirmSignUpPageState extends State<ConfirmSignUpPage> {
  final _confirmationCodeController = TextEditingController();

  Future<void> _confirmSignUp() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.username,
        confirmationCode: _confirmationCodeController.text.trim(),
      );

      if (result.isSignUpComplete) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up confirmed! Please sign in.')),
          );
          context.go('/signin');
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming sign up: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _confirmationCodeController,
              decoration: const InputDecoration(labelText: 'Confirmation Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmSignUp,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

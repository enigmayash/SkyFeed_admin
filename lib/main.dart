import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:go_router/go_router.dart';
import 'HomePage.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'ConfirmSignUpPage.dart';
import 'MediaUploadPage.dart';
import 'listmedia.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/confirm-signup',
      builder: (context, state) {
        final username = state.uri.queryParameters['username'] ?? '';
        return ConfirmSignUpPage(username: username);
      },
    ),
    GoRoute(
      path: '/upload-media',
      builder: (context, state) => const MediaUploadPage(),
    ),
    GoRoute(
      path: '/list-media',
      builder: (context, state) => const ListmediaUploadPage(),
    ),
  ],
);

Future<void> _configureAmplify() async {
  final auth = AmplifyAuthCognito();
  final storage = AmplifyStorageS3();
  await Amplify.addPlugin(auth);
  await Amplify.addPlugin(storage);

  try {
    await Amplify.configure(amplifyconfig);
  } on Exception catch (e) {
    print('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SkyFeed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

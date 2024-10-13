import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'HomePage.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'ConfirmSignUpPage.dart';
import 'MediaUploadPage.dart';
import 'listmedia.dart';

const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "eu-north-1:353d3f07-5e30-4d0f-b545-9b8e8bf4a30a",
                            "Region": "eu-north-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-north-1_lDQJe5APa",
                        "AppClientId": "6tagqi5ji479q39m0ga4f027lo",
                        "Region": "eu-north-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''';

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
  await Amplify.addPlugin(auth);

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

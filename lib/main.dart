import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'SignUpPage.dart';


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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // initialize amplify
  await _configureAmplify()
  runApp(MyApp());
}

Future<void> _configureAmplify() async{
  try{
    // Adding cognito plugins to authentiicate
    Amplify.addPlugin(AmplifyAuthCognito());

    // confugure Amplify
    await Amplify.configure(amplifyconfig);
  }
  catch(e){
    print('Errorrrrrrrrrr: $e');
  }
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "Sky Feed",
      home: SignUpPage(),
    );
  }
}

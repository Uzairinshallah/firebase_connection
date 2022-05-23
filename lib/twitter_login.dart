import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Twitter_login extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Twitter_login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twitter Login App'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Login With Twitter'),
            onPressed: () async {
              final twitterLogin = TwitterLogin(
                apiKey: "cnphDWFUMdZQo5PAAvhparcWf",
                apiSecretKey:
                    "1241677921674280960-FQp1DCCV4E8BQkjafem2ltdg0SdyT0",
                redirectURI:
                    'https://fir-test-f0323.firebaseapp.com/__/auth/handler',
              );
              // final authResult = twitterLogin.login();
              final authResult = await twitterLogin.login();
              final AuthCredential = TwitterAuthProvider.credential(
                  accessToken: authResult.authToken!,
                  secret: authResult.authTokenSecret!);
              await FirebaseAuth.instance.signInWithCredential(AuthCredential);
              switch (authResult.status) {
                case TwitterLoginStatus.loggedIn:
                  // success
                  break;
                case TwitterLoginStatus.cancelledByUser:
                  // cancel
                  break;
                case TwitterLoginStatus.error:
                  // error
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}

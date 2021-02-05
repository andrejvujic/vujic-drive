import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:vujic_drive/services/auth.dart';
import 'package:vujic_drive/widgets/info_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> signInWithGoogle() async {
    final result = await AuthService.signInWithGoogle();
    if (result.length > 0) {
      InfoAlert.show(context,
          title: 'Greška',
          text: 'Došlo je do greške prilikom prijavljivanja. ($result)',);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GoogleSignInButton(
              onPressed: signInWithGoogle,
              darkMode: true,
            ),
          ],
        ),
      ),
    );
  }
}

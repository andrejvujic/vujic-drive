import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vujic_drive/screens/login.dart';
import 'package:vujic_drive/uploads/screens/folder.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (context) => FirebaseAuth.instance.authStateChanges(),
      builder: (context, _) {
        final user = context.watch<User>();

        return (user == null) ? Login() : Folder();
      },
    );
  }
}

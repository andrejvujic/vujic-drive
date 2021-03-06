import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/screens/folder.dart';
import 'package:vujic_drive/widgets/home_drawer/home_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vujić Drive',
        ),
      ),
      drawer: HomeDrawer(),
      body: StreamBuilder(
        stream: db.currentUserData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final Map<String, dynamic> userData = snapshot.data.data();

          if (userData == null) {
            db.addUserData(FirebaseAuth.instance.currentUser);
          }
          return Folder();
        },
      ),
    );
  }
}

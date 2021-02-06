import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/widgets/folder_icon.dart';

class Folders extends StatefulWidget {
  @override
  _FoldersState createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);
  final int crossAxisCount = 2;

  List<FolderIcon> getFolderIcons(List<QueryDocumentSnapshot> folders) {
    final folderIcons = <FolderIcon>[];

    for (QueryDocumentSnapshot folder in folders) {
      final Map<String, dynamic> data = folder.data();
      folderIcons.add(
        FolderIcon(),
      );
    }

    print(folderIcons.length);
    return folderIcons;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.currentUserRootFolders,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        }

        final List<QueryDocumentSnapshot> rootFolders = snapshot.data.docs;

        return Expanded(
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            children: getFolderIcons(rootFolders),
          ),
        );
      },
    );
  }
}

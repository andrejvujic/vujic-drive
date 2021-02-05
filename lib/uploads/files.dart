import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/widgets/file_icon.dart';

class Files extends StatefulWidget {
  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);
  final int crossAxisCount = 2;

  List<FileIcon> getFolderIcons(List<QueryDocumentSnapshot> folders) {
    final folderIcons = <FileIcon>[];

    for (QueryDocumentSnapshot folder in folders) {
      final Map<String, dynamic> data = folder.data();
      folderIcons.add(
        FileIcon(),
      );
    }

    return folderIcons;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.currentUserRootFiles,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
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

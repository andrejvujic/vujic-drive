import 'package:flutter/material.dart';
import 'package:vujic_drive/uploads/files.dart';
import 'package:vujic_drive/uploads/folders.dart';

class Uploads extends StatefulWidget {
  @override
  _UploadsState createState() => _UploadsState();

  final String uid;
  final String folderId;
  Uploads({@required this.uid, this.folderId = ''});
}

class _UploadsState extends State<Uploads> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Folders(
          parent: widget.folderId,
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          height: 0.0,
          thickness: 1.0,
        ),
        Files(
          parent: widget.folderId,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FolderIcon extends StatelessWidget {
  final Map<String, dynamic> folderData;
  FolderIcon({@required this.folderData});

  void onTap() {}

  void onLongPress(LongPressStartDetails longPressStartDetails) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPress,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
          borderSide: BorderSide.none,
          onPressed: () => null,
          onLongPress: () => null,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.folder,
                  size: 94.0,
                ),
                Text(
                  '${this.folderData['name']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

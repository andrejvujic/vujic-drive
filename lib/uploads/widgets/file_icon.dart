import 'package:flutter/material.dart';

class FileIcon extends StatelessWidget {
  final Map<String, dynamic> fileData;
  final String parentGlobalPath;
  FileIcon({
    @required this.fileData,
    this.parentGlobalPath,
  });

  final settings = <Map<String, dynamic>>[
    {
      'title': 'Preuzmi',
      'icon': Icons.file_download,
      'value': 'download',
    },
    {
      'title': 'Obriši',
      'icon': Icons.delete,
      'value': 'delete',
    },
    {
      'title': 'Preimenuj',
      'icon': Icons.edit,
      'value': 'rename',
    },
  ];

  Future<dynamic> perfomSelectedAction(BuildContext context, dynamic value) {
    switch (value) {
      case 'download':
        downloadFile();
        break;
      case 'delete':
        deleteFile();
        break;
      case 'rename':
        renameFile();
        break;
      default:
        break;
    }

    return null;
  }

  void downloadFile() {}
  void renameFile() {}
  void deleteFile() {}

  List<PopupMenuEntry<dynamic>> getMenuTiles() {
    final List<PopupMenuEntry<dynamic>> menuTiles = [];
    for (final setting in settings) {
      menuTiles.add(
        PopupMenuItem(
          value: setting['value'],
          child: Row(
            children: <Widget>[
              Icon(
                setting['icon'],
                color: Colors.tealAccent,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                '${setting['title']}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return menuTiles;
  }

  void onTap(BuildContext context) => null;

  void onLongPress(
    BuildContext context,
    LongPressStartDetails longPressStartDetails,
  ) {
    final double pressX = longPressStartDetails.globalPosition.dx,
        pressY = longPressStartDetails.globalPosition.dy;

    showMenu(
      color: Theme.of(context).primaryColor,
      context: context,
      position: RelativeRect.fromLTRB(pressX, pressY, pressX, pressY),
      items: getMenuTiles(),
    ).then(
      (value) => perfomSelectedAction(context, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      onLongPressStart: (LongPressStartDetails longPressStartDetails) =>
          onLongPress(context, longPressStartDetails),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.note,
              size: 94.0,
            ),
            Text(
              '${this.fileData['name']}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vujic_drive/uploads/screens/folder.dart';
import 'package:vujic_drive/utils/route_builders.dart';

class FolderIcon extends StatelessWidget {
  final Map<String, dynamic> folderData;
  final String parentGlobalPath;
  FolderIcon({
    @required this.folderData,
    this.parentGlobalPath,
  });

  final settings = <Map<String, dynamic>>[
    {
      'title': 'Otvori',
      'icon': Icons.folder,
      'value': 'open',
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
    {
      'title': 'Podešavanja',
      'icon': Icons.settings,
      'value': 'settings',
    },
  ];

  Future<dynamic> perfomSelectedAction(BuildContext context, dynamic value) {
    switch (value) {
      case 'open':
        openFolder(context);
        break;
      case 'delete':
        deleteFolder();
        break;
      case 'rename':
        renameFolder();
        break;
      case 'settings':
        openFolderSettings();
        break;
      default:
        break;
    }

    return null;
  }

  void openFolder(BuildContext context) {
    Navigator.push(
      context,
      RouteBuilders.buildSlideRoute(
        Folder(
          folderId: this.folderData['id'],
          folderName: this.folderData['name'],
          folderGlobalPath: '${this.parentGlobalPath}/${this.folderData['id']}',
        ),
      ),
    );
  }

  void deleteFolder() {}
  void renameFolder() {}
  void openFolderSettings() {}

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

  void onTap(BuildContext context) => openFolder(context);

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
              Icons.folder,
              size: 94.0,
            ),
            Text(
              '${this.folderData['name']}',
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

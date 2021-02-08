import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/screens/folder.dart';
import 'package:vujic_drive/utils/route_builders.dart';
import 'package:vujic_drive/widgets/custom_alert.dart';
import 'package:vujic_drive/widgets/info_alert.dart';
import 'package:vujic_drive/widgets/text_input.dart';

class FolderIcon extends StatefulWidget {
  final Map<String, dynamic> folderData;
  final String parentGlobalPath;
  FolderIcon({
    @required this.folderData,
    this.parentGlobalPath,
  });

  @override
  _FolderIconState createState() => _FolderIconState();
}

class _FolderIconState extends State<FolderIcon> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);

  final settings = <Map<String, dynamic>>[
    {
      'title': 'Otvori',
      'icon': Icons.folder,
      'value': 'open',
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

  TextEditingController folderCtrlr;

  @override
  void initState() {
    super.initState();
    folderCtrlr = TextEditingController();
  }

  @override
  void dispose() {
    folderCtrlr.dispose();
    super.dispose();
  }

  Future<dynamic> perfomSelectedAction(BuildContext context, dynamic value) {
    switch (value) {
      case 'open':
        openFolder(context);
        break;
      case 'rename':
        renameFolder(context);
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
          folderId: widget.folderData['id'],
          folderName: widget.folderData['name'],
          folderGlobalPath:
              '${widget.parentGlobalPath}/${widget.folderData['id']}',
        ),
      ),
    );
  }

  Future<void> renameFolder(BuildContext context) async {
    folderCtrlr.text = widget.folderData['name'];

    CustomAlert.show(
      context,
      title: 'Preimenuj folder',
      children: <Widget>[
        TextInput(
          controller: folderCtrlr,
          labelText: 'Ime foldera',
          hintText: 'Ime foldera',
        ),
      ],
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'OTKAŽI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            if (folderCtrlr.text.isNotEmpty) {
              try {
                await db.renameFolder(folderCtrlr.text, widget.folderData);
              } catch (e) {
                InfoAlert.show(
                  context,
                  title: 'Ups...',
                  text:
                      'Došlo je do greške prilikom mijenjanja imena ovog foldera. Pokušajte ponovo.',
                );
              }
            } else {
              InfoAlert.show(
                context,
                title: 'Greška',
                text:
                    'Novo ime foldera ne smije biti prazno. Popunite ga, pa pokušajte ponovo.',
              );
            }
          },
          child: Text(
            'POTVRDI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
        ),
      ],
    );
  }

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
              '${widget.folderData['name']}',
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

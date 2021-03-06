import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/services/storage.dart';
import 'package:vujic_drive/widgets/custom_alert.dart';
import 'package:vujic_drive/widgets/info_alert.dart';
import 'package:vujic_drive/widgets/text_input.dart';
import 'package:vujic_drive/widgets/yes_no_alert.dart';

class FileIcon extends StatefulWidget {
  final Map<String, dynamic> fileData;
  final String parentGlobalPath;
  FileIcon({
    @required this.fileData,
    this.parentGlobalPath,
  });

  @override
  _FileIconState createState() => _FileIconState();
}

class _FileIconState extends State<FileIcon> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);

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

  TextEditingController fileCtrlr;

  @override
  void initState() {
    super.initState();
    fileCtrlr = TextEditingController();
  }

  @override
  void dispose() {
    fileCtrlr.dispose();
    super.dispose();
  }

  Future<dynamic> perfomSelectedAction(BuildContext context, dynamic value) {
    switch (value) {
      case 'download':
        downloadFile(context);
        break;
      case 'delete':
        deleteFile(context);
        break;
      case 'rename':
        renameFile(context);
        break;
      default:
        break;
    }

    return null;
  }

  void downloadFile(BuildContext context) async {
    final url = '${widget.fileData['downloadUrl']}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      InfoAlert.show(
        context,
        title: 'Ups...',
        text:
            'Naišli smo na grešku dok smo pokušavali da preuzmemo vaš fajl. Pokušajte ponovo.',
      );
    }
  }

  void deleteFile(BuildContext context) async {
    YesNoAlert.show(
      context,
      title: 'Upozorenje',
      text: 'Da li ste sigurni da želite da obrišete ovaj fajl zauvijek?',
      onYesPressed: () async {
        try {
          await StorageService.deleteByDownloadUrl(
            widget.fileData['downloadUrl'],
          );
          await db.removeFile(widget.fileData['id']);
        } catch (e) {
          InfoAlert.show(
            context,
            title: 'Ups...',
            text:
                'Došlo je do neočekivane greške prilikom brisanja ovog fajla. Pokušajte ponovo.',
          );
        }
      },
    );
  }

  Future<void> renameFile(BuildContext context) async {
    fileCtrlr.text = widget.fileData['name'];

    CustomAlert.show(
      context,
      title: 'Preimenuj fajl',
      children: <Widget>[
        TextInput(
          controller: fileCtrlr,
          labelText: 'Ime fajl',
          hintText: 'Ime fajl',
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
            if (fileCtrlr.text.isNotEmpty) {
              try {
                await db.renameFile(fileCtrlr.text, widget.fileData);
              } catch (e) {
                InfoAlert.show(
                  context,
                  title: 'Ups...',
                  text:
                      'Došlo je do greške prilikom mijenjanja imena ovog fajla. Pokušajte ponovo.',
                );
              }
            } else {
              InfoAlert.show(
                context,
                title: 'Greška',
                text:
                    'Novo ime fajla ne smije biti prazno. Popunite ga, pa pokušajte ponovo.',
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

  void onTap(BuildContext context) => downloadFile(context);

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
              '${widget.fileData['name']}',
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

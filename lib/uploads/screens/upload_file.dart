import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vujic_drive/services/app.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/services/storage.dart';
import 'package:vujic_drive/widgets/info_alert.dart';
import 'package:vujic_drive/widgets/loading_overlay.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();

  final String folderGlobalPath;
  UploadFile({this.folderGlobalPath});
}

class _UploadFileState extends State<UploadFile> {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);
  TextEditingController fileCtrlr;
  List<PlatformFile> selectedFiles = <PlatformFile>[];

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

  Future<void> uploadFiles(AppService app) async {
    final parent = widget.folderGlobalPath.split('/').last;

    app.startLoading();
    try {
      for (int i = selectedFiles.length - 1; i > -1; i--) {
        final file = selectedFiles[i];
        final fileName = file.name;
        final fileId = db.files.doc().id;

        final fileDownloadUrl = await StorageService.uploadFile(
          '${widget.folderGlobalPath}/$fileId',
          File(file.path),
        ).then(
          (value) => value.ref.getDownloadURL(),
        );

        await db.addFile(
          fileId,
          fileName,
          fileDownloadUrl,
          parent,
        );

        setState(
          () => selectedFiles..removeAt(i),
        );
      }
    } catch (e) {
      await InfoAlert.show(
        context,
        title: 'Ups...',
        text: 'Došlo je do neočekivane greške prilikom objavljivanja fajlova.',
      );
      app.stopLoading();
      return;
    }

    app.stopLoading();
    Navigator.pop(context);
  }

  Future<void> selectFiles(AppService app) async {
    app.startLoading();

    try {
      final FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if ((result?.files ?? []).length > 0) {
        final List<PlatformFile> tempSelectedFiles = selectedFiles;
        for (final file in result.files) {
          if (bytesToMegaBytes(file.size) > 50) {
            await InfoAlert.show(
              context,
              title: 'Prevelik fajl',
              text:
                  'Fajl koji ste odabrali (${file.name}) prevazilazi makismalanu veličinu od 50 MB. Odaberite manji fajl, pa pokušajte ponovo.',
            );
            continue;
          }
          tempSelectedFiles.add(file);
        }
        setState(() => selectedFiles = tempSelectedFiles);
      }
    } catch (e) {}

    app.stopLoading();
  }

  void removeFile(int index) => setState(
        () => selectedFiles..removeAt(index),
      );

  double bytesToMegaBytes(int bytes) => bytes / 1000000;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(
      builder: (BuildContext context, AppService app, Widget _) {
        return LoadingOverlay(
          isLoading: app.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Objavi nove fajlove',
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => selectFiles(app),
              child: Icon(
                Icons.add,
              ),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ((selectedFiles?.length ?? 0) > 0)
                        ? ListView.builder(
                            itemCount: selectedFiles.length,
                            itemBuilder: (BuildContext context, int index) {
                              final file = selectedFiles[index];
                              return ListTile(
                                title: Text(
                                  '${file.name}',
                                ),
                                subtitle: Text(
                                  '${bytesToMegaBytes(file.size).toStringAsFixed(2)} MB',
                                ),
                                trailing: IconButton(
                                  onPressed: () => removeFile(index),
                                  icon: Icon(
                                    Icons.close,
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Niste odabrali nijedan fajl',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Još uvijek niste odabrali nijedan fajl. To možete uraditi klikom na tipku za dodavanje fajlova u donjem desnom uglu.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: ElevatedButton(
                      onPressed: ((selectedFiles?.length ?? 0) > 0)
                          ? () => uploadFiles(app)
                          : null,
                      child: Text(
                        'Objavi fajlove',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

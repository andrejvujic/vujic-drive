import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vujic_drive/services/app.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/uploads.dart';
import 'package:vujic_drive/widgets/custom_alert.dart';
import 'package:vujic_drive/widgets/home_drawer/home_drawer.dart';
import 'package:vujic_drive/widgets/info_alert.dart';
import 'package:vujic_drive/widgets/loading_overlay.dart';
import 'package:vujic_drive/widgets/text_input.dart';

class Folder extends StatefulWidget {
  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> with TickerProviderStateMixin {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController folderCtrlr;

  double fabIconRotation = 0.0, fabIconChildSize = 24.0;
  AnimationController rotationCtrlr, colorCtrlr1, colorCtrlr2, sizeCtrlr;
  Animation<double> rotationAnimation, sizeAnimation;
  Animation<Color> colorAnimation1, colorAnimation2;

  Color fabColor = Colors.tealAccent, fabIconChildColor = Colors.black;

  @override
  void initState() {
    super.initState();
    folderCtrlr = TextEditingController();

    colorCtrlr1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    colorAnimation1 = ColorTween(begin: Colors.tealAccent, end: Colors.red)
        .animate(colorCtrlr1)
          ..addListener(() {
            setState(
              () => fabColor = colorAnimation1.value,
            );
          });

    colorCtrlr2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    colorAnimation2 =
        ColorTween(begin: Colors.black, end: Colors.white).animate(colorCtrlr2)
          ..addListener(() {
            setState(
              () => fabIconChildColor = colorAnimation2.value,
            );
          });

    rotationCtrlr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    sizeCtrlr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    sizeAnimation = Tween<double>(begin: 24.0, end: 27.0).animate(sizeCtrlr)
      ..addListener(
        () {
          setState(() => fabIconChildSize = sizeAnimation.value);
        },
      );

    rotationAnimation = Tween<double>(begin: 0.0, end: 45.0 * 3.14 / 180.0)
        .animate(rotationCtrlr)
          ..addListener(
            () {
              setState(() => fabIconRotation = rotationAnimation.value);
            },
          );
  }

  @override
  void dispose() {
    folderCtrlr.dispose();
    rotationCtrlr.dispose();
    colorCtrlr1.dispose();
    colorCtrlr2.dispose();
    sizeCtrlr.dispose();
    super.dispose();
  }

  Future<void> addFolder(String name, AppService app,
      {String parent = ''}) async {
    Navigator.pop(context);

    if (name.isNotEmpty) {
      app.startLoading();
      try {
        await db.addFolder(name, parent);
      } catch (e) {}
      app.stopLoading();
    } else {
      InfoAlert.show(
        context,
        title: 'Greška',
        text:
            'Nije bilo moguće dodati folder jer niste unijeli ništa za ime foldera. Unesite ime pa pokušajte ponovo',
      );
    }
  }

  Future<void> createNewFolder(BuildContext context, AppService app) async {
    folderCtrlr.clear();

    final actions = <Widget>[
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
        onPressed: () => addFolder(folderCtrlr.text, app),
        child: Text(
          'DODAJ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    ];

    CustomAlert.show(
      context,
      title: 'Novi folder',
      children: <Widget>[
        TextInput(
          controller: folderCtrlr,
          labelText: 'Naziv foldera',
          hintText: 'Naziv foldera',
        ),
      ],
      actions: actions,
    );
  }

  Future<void> createNewFile() async {}

  void showCreateNew(BuildContext context, AppService app) {
    rotationCtrlr.forward();
    colorCtrlr1.forward();
    colorCtrlr2.forward();
    sizeCtrlr.forward();

    scaffoldKey.currentState.showBottomSheet(
      (context) {
        return WillPopScope(
          onWillPop: () async => Future.value(false),
          child: GestureDetector(
            onVerticalDragStart: (_) => null,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.folder),
                  title: Text('Folder'),
                  onTap: () => createNewFolder(context, app),
                ),
                ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Fajl'),
                  onTap: () => createNewFile(),
                ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void hideCreateNew(BuildContext context) {
    rotationCtrlr.reverse();
    colorCtrlr1.reverse();
    colorCtrlr2.reverse();
    sizeCtrlr.reverse();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(
      builder: (BuildContext context, AppService app, Widget _) {
        return LoadingOverlay(
          isLoading: app.isLoading,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                'Vujić Drive',
              ),
            ),
            drawer: HomeDrawer(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: fabColor,
              child: Transform.rotate(
                angle: fabIconRotation,
                child: Icon(
                  Icons.add,
                  color: fabIconChildColor,
                  size: fabIconChildSize,
                ),
              ),
              onPressed: () => (fabIconRotation > 0.0)
                  ? hideCreateNew(context)
                  : showCreateNew(context, app),
            ),
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

                return Uploads(
                  uid: FirebaseAuth.instance.currentUser.uid,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

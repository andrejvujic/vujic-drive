import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vujic_drive/services/app.dart';
import 'package:vujic_drive/services/db.dart';
import 'package:vujic_drive/uploads/uploads.dart';
import 'package:vujic_drive/widgets/custom_alert.dart';
import 'package:vujic_drive/widgets/home_drawer/home_drawer.dart';
import 'package:vujic_drive/widgets/text_input.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final db = Database(uid: FirebaseAuth.instance.currentUser.uid);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController folderCtrlr;
  double fabIconRotation = 0.0;
  AnimationController rotationCtrlr;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    folderCtrlr = TextEditingController();
    rotationCtrlr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = Tween<double>(begin: 0.0, end: 45.0 * 3.14 / 180.0)
        .animate(rotationCtrlr)
          ..addListener(
            () {
              setState(() => fabIconRotation = animation.value);
              print(animation.value);
            },
          );
  }

  @override
  void dispose() {
    folderCtrlr.dispose();
    rotationCtrlr.dispose();
    super.dispose();
  }

  Future<void> addFolder(String name) async {}

  Future<void> createNewFolder(BuildContext context) async {
    folderCtrlr.clear();

    final actions = <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'OTKAŽI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () => addFolder(folderCtrlr.text),
        child: Text(
          'DODAJ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
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

  void showCreateNew(BuildContext context) {
    rotationCtrlr.forward();
    scaffoldKey.currentState.showBottomSheet(
      (context) {
        return WillPopScope(
          onWillPop: () async => Future.value(false),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Folder'),
                onTap: () => createNewFolder(context),
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Fajl'),
                onTap: () => createNewFile(),
              ),
            ],
          ),
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void hideCreateNew(BuildContext context) {
    rotationCtrlr.reverse();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(
      builder: (BuildContext context, AppService app, Widget _) {
        return Scaffold(
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
            child: Transform.rotate(
              angle: fabIconRotation,
              child: Icon(Icons.add),
            ),
            onPressed: () => (fabIconRotation > 0.0)
                ? hideCreateNew(context)
                : showCreateNew(context),
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
        );
      },
    );
  }
}

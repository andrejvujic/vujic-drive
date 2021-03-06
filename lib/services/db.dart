import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final String uid;
  Database({this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference folders =
      FirebaseFirestore.instance.collection('folders');
  CollectionReference files = FirebaseFirestore.instance.collection('files');

  static String getRandomId(CollectionReference collection) =>
      collection.doc().id;

  Future<void> addUserData(User user) async {
    Map<String, dynamic> data = {
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'joinedOn': Timestamp.now(),
    };

    await this.users.doc(this.uid).set(data);
  }

  Future<void> addFile(
      String id, String name, String downloadUrl, String parent) async {
    Map<String, dynamic> data = {
      'name': name,
      'id': id,
      'createdBy': this.uid,
      'createdOn': Timestamp.now(),
      'parent': parent,
      'allowAccessTo': <String>[
        this.uid,
      ],
      'downloadUrl': downloadUrl,
    };

    await this.files.doc(id).set(data);
  }

  Future<void> removeFile(String id) async => await files.doc(id).delete();

  Future<void> renameFile(String name, Map<String, dynamic> data) async {
    data['name'] = name;
    await files.doc(data['id']).set(data);
  }

  Future<void> addFolder(String name, String parent) async {
    final id = getRandomId(this.folders);

    Map<String, dynamic> data = {
      'name': name,
      'id': id,
      'createdBy': this.uid,
      'createdOn': Timestamp.now(),
      'parent': parent,
      'allowAccessTo': <String>[
        this.uid,
      ],
    };

    await this.folders.doc(id).set(data);
  }

  Future<void> removeFolder(String id) async => await files.doc(id).delete();

  Future<void> renameFolder(String name, Map<String, dynamic> data) async {
    data['name'] = name;
    await folders.doc(data['id']).set(data);
  }

  /*
  Stream<QuerySnapshot> get currentUserRootFolders => this
      .folders
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: '')
      .snapshots();
  */

  /*
  Stream<QuerySnapshot> get currentUserRootFiles => this
      .files
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: '')
      .snapshots();
  */

  Stream<QuerySnapshot> getFoldersByParent(String id) => this
      .folders
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: id)
      .snapshots();

  Stream<QuerySnapshot> getFilesByParent(String id) => this
      .files
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: id)
      .snapshots();

  Stream<DocumentSnapshot> get currentUserData =>
      this.users.doc(this.uid).snapshots();
}

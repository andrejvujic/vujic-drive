import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final String uid;
  Database({this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference folders =
      FirebaseFirestore.instance.collection('folders');
  CollectionReference files = FirebaseFirestore.instance.collection('files');

  Future<void> addUserData(User user) async {
    Map<String, dynamic> data = {
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'joinedOn': Timestamp.now(),
    };

    await users.doc(this.uid).set(data);
  }

  Stream<QuerySnapshot> get currentUserRootFolders => folders
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: '')
      .snapshots();

  Stream<QuerySnapshot> get currentUserRootFiles => files
      .orderBy('createdOn', descending: true)
      .where('allowAccessTo', arrayContains: this.uid)
      .where('parent', isEqualTo: '')
      .snapshots();

  Stream<DocumentSnapshot> get currentUserData =>
      users.doc(this.uid).snapshots();
}

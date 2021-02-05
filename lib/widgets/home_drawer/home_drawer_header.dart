import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeDrawerHeader extends StatelessWidget {
  final name = FirebaseAuth.instance.currentUser.displayName;
  final email = FirebaseAuth.instance.currentUser.email;
  final photoUrl = FirebaseAuth.instance.currentUser.photoURL;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            '$photoUrl',
          ),
        ),
        title: Text(
          '$name',
        ),
        subtitle: Text(
          '$email',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  HomeDrawerTile({@required this.title, this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: this.onTap,
        leading: Icon(this.icon),
        title: Text(this.title),
      ),
    );
  }
}

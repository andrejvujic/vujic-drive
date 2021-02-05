import 'package:flutter/material.dart';
import 'package:vujic_drive/services/auth.dart';
import 'package:vujic_drive/widgets/home_drawer/home_drawer_header.dart';
import 'package:vujic_drive/widgets/home_drawer/home_drawer_tile.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final settings = <Map<String, dynamic>>[
    {
      'title': 'Odjavi se',
      'icon': Icons.logout,
      'onTap': AuthService.signOut,
    },
  ];

  List<HomeDrawerTile> get homeDrawerTiles {
    final tiles = <HomeDrawerTile>[];

    for (Map<String, dynamic> setting in settings) {
      tiles.add(
        HomeDrawerTile(
          title: setting['title'],
          icon: setting['icon'],
          onTap: setting['onTap'],
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          HomeDrawerHeader(),
          Column(
            children: homeDrawerTiles,
          ),
        ],
      ),
    );
  }
}

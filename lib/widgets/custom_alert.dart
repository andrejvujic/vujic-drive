import 'package:flutter/material.dart';

class CustomAlert {
  static Future<void> show(
    BuildContext context, {
    String title,
    List<Widget> children = const [],
    List<Widget> actions = const [],
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: children,
              ),
            ),
            actions: actions,
          ),
        );
      },
    );
  }
}

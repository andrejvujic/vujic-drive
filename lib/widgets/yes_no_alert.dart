import 'package:flutter/material.dart';

class YesNoAlert {
  static Future<void> show(
    BuildContext context, {
    String title = '',
    String text = '',
    Function onYesPressed,
    Function onNoPressed,
  }) async =>
      showDialog(
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
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'NE',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    onNoPressed?.call();
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'DA',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    onYesPressed?.call();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
}

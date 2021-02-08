import 'package:flutter/material.dart';

class RouteBuilders {
  static Route buildSlideRoute(
    Widget child, {
    double horizontalOffset = 1.0,
    double verticalOffset = 0.0,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(horizontalOffset, verticalOffset);
        final end = Offset.zero;
        final curve = Curves.ease;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();

  final Widget child, progressIndicator, progressIndicatorChild;
  final bool isLoading;
  final Color overlayColor;
  final double overlayColorOpacity;

  LoadingOverlay({
    @required this.child,
    this.progressIndicator,
    this.progressIndicatorChild,
    this.isLoading = false,
    this.overlayColor = Colors.black,
    this.overlayColorOpacity = 0.5,
  });
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        (widget.isLoading ?? false)
            ? Center(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    ModalBarrier(
                      color: widget.overlayColor
                          .withOpacity(widget.overlayColorOpacity),
                    ),
                    widget.progressIndicator ?? CircularProgressIndicator(),
                  ],
                ),
              )
            : Container(
                width: 0.0,
                height: 0.0,
              ),
      ],
    );
  }
}

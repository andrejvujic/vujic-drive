import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  @override
  _TextInputState createState() => _TextInputState();

  final String initialValue, hintText, labelText, helperText;
  final int maxLength, maxLines;
  final double width;
  final EdgeInsets margin, padding;
  final TextEditingController controller;
  final Function onChanged;
  final TextInputType keyboardType;
  final Widget suffix;
  final bool secureText;

  TextInput({
    this.initialValue,
    this.hintText,
    this.labelText,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
    this.width,
    this.controller,
    this.onChanged,
    this.suffix,
    this.secureText = false,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.keyboardType = TextInputType.text,
  });
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width * 0.90,
      margin: widget.margin,
      padding: widget.padding,
      child: TextFormField(
        onChanged: (
          String _value,
        ) =>
            widget.onChanged?.call(
          _value,
        ),
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        initialValue: widget.initialValue,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforced: false,
        obscureText: widget.secureText,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          suffix: widget.suffix,
          filled: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          labelText: widget.labelText,
          fillColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

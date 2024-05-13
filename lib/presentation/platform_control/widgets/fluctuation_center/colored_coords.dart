import 'package:flutter/material.dart';

class ColoredCoords extends StatelessWidget {
  final InlineSpan _xText;
  final InlineSpan _yText;
  const ColoredCoords({
    super.key,
    required InlineSpan xText,
    required InlineSpan yText,
  }) : _yText = yText, _xText = xText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: '(',
          ),
          _xText,
          const TextSpan(
            text: ', ',
          ),
          _yText,
          const TextSpan(
            text: ')',
          ),
        ],
      ),
    );
  }
}
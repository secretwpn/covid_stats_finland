import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextStyle textStyle;

  const IconLabel({Key key, this.text, this.icon, this.textStyle})
      : super(key: key);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 6),
          Text(text, style: textStyle),
        ],
      );
}

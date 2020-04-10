import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends TextSpan {
  final String text;
  final String url;

  Hyperlink(this.text, this.url)
      : super(
          text: text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.blue,
            fontStyle: FontStyle.italic,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => launchUrl(url),
        );

  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

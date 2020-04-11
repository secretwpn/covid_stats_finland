import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

charts.Color fromDartColor(Color sourceColor) => charts.Color(
      r: sourceColor.red,
      g: sourceColor.green,
      b: sourceColor.blue,
      a: sourceColor.alpha,
    );

charts.Color gridColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? fromDartColor(Colors.black12)
        : fromDartColor(Colors.white12);

charts.Color labelColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? fromDartColor(Colors.black38)
        : fromDartColor(Colors.white38);

charts.Color lineColor(BuildContext context) =>
    fromDartColor(Theme.of(context).accentColor);

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

charts.Color fromDartColor(Color sourceColor) => charts.Color(
      r: sourceColor.red,
      g: sourceColor.green,
      b: sourceColor.blue,
      a: sourceColor.alpha,
    );
import 'package:charts_flutter/flutter.dart' as charts;

var chartLayout = charts.LayoutConfig(
  leftMarginSpec: marginHorizontal,
  topMarginSpec: marginVertical,
  rightMarginSpec: marginHorizontal,
  bottomMarginSpec: marginVertical,
);
var marginHorizontal = charts.MarginSpec.fixedPixel(24);
var marginVertical = charts.MarginSpec.fixedPixel(12);

import 'package:covid_stats_finland/main.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
  backgroundColor: Colors.black,
  primaryColorDark: Colors.white,
  accentColor: Colors.blue,
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
));
final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
  backgroundColor: Colors.white,
  primaryColorDark: Colors.black,
  accentColor: Colors.redAccent,
  primarySwatch: Colors.red,
  brightness: Brightness.light,
));

abstract class AppModel extends ChangeNotifier {
  ThemeData get theme;
  TrendMode get trendMode;
  Hcd get selectedHcd;
  int get selectedHcdIndex;
  int get selectedValue;
  set theme(ThemeData value);
  set trendMode(TrendMode value);
  set selectedHcd(Hcd value);
  set selectedHcdIndex(int value);
  set selectedValue(int value);
}

class AppModelImplementation extends AppModel {
  ThemeData _theme = lightTheme;
  Hcd _selectedHcd;
  int _selectedHcdIndex = 0;
  int _selectedValue = 0;
  TrendMode _trendMode = TrendMode.cumulative;

  AppModelImplementation() {
    getIt.signalReady(this);
  }

  @override
  get theme => _theme;

  @override
  set theme(ThemeData value) {
    _theme = value;
    notifyListeners();
  }

  @override
  get selectedHcd => _selectedHcd;

  @override
  set selectedHcd(Hcd value) {
    _selectedHcd = value;
    notifyListeners();
  }

  @override
  get selectedHcdIndex => _selectedHcdIndex;

  @override
  set selectedHcdIndex(int value) {
    _selectedHcdIndex = value;
    notifyListeners();
  }

  @override
  get selectedValue => _selectedValue;

  @override
  set selectedValue(int value) {
    _selectedValue = value;
    notifyListeners();
  }

  @override
  get trendMode => _trendMode;

  @override
  set trendMode(TrendMode value) {
    _trendMode = value;
    notifyListeners();
  }
}

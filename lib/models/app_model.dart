import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelectionModel with ChangeNotifier {
  int _selectedValue = 0;

  int get selectedValue => _selectedValue;

  set selectedValue(int value) {
    if (_selectedValue == value) return;
    _selectedValue = value;
    notifyListeners();
  }
}

class UiModel with ChangeNotifier {
  TrendMode _trendMode = TrendMode.cumulative;
  int _selectedHcdIndex = 0;

  TrendMode get trendMode => _trendMode;

  set trendMode(TrendMode value) {
    if (_trendMode == value) return;
    _trendMode = value;
    notifyListeners();
  }

  int get selectedHcdIndex => _selectedHcdIndex;

  set selectedHcdIndex(int value) {
    if (_selectedHcdIndex == value) return;
    _selectedHcdIndex = value;
    notifyListeners();
  }
}

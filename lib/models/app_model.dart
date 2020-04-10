import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionModel with ChangeNotifier {
  int _selectedValue = 0;
  DateTime _selectedDateTime = DateTime.now();

  int get selectedValue => _selectedValue;

  set selectedValue(int value) {
    if (_selectedValue == value) return;
    _selectedValue = value;
    notifyListeners();
  }

  DateTime get selectedDateTime => _selectedDateTime;
  String get selectedDateFormatted => DateFormat.MMMEd().format(_selectedDateTime);

  set selectedDateTime(DateTime value) {
    if (_selectedDateTime == value) return;
    _selectedDateTime = value;
    notifyListeners();
  }
}

class UiModel with ChangeNotifier {
  TrendMode _trendMode = TrendMode.cumulative;
  int _selectedConfirmedHcdIndex = 0;
  int _selectedHospitalizedHcdIndex = 0;

  TrendMode get trendMode => _trendMode;

  set trendMode(TrendMode value) {
    if (_trendMode == value) return;
    _trendMode = value;
    notifyListeners();
  }

  int get selectedConfirmedHcdIndex => _selectedConfirmedHcdIndex;

  set selectedConfirmedHcdIndex(int value) {
    if (_selectedConfirmedHcdIndex == value) return;
    _selectedConfirmedHcdIndex = value;
    notifyListeners();
  }

  int get selectedHospitalizedHcdIndex => _selectedHospitalizedHcdIndex;

  set selectedHospitalizedHcdIndex(int value) {
    if (_selectedHospitalizedHcdIndex == value) return;
    _selectedHospitalizedHcdIndex = value;
    notifyListeners();
  }
}

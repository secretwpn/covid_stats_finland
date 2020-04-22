import 'package:covid_stats_finland/models/hospitalized_sample.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionModel with ChangeNotifier {
  int _selectedValue = 0;
  DateTime _selectedConfirmedDate = DateTime.now();
  HospitalizedSample _selectedHospitalizedSample;

  DateTime get selectedConfirmedDate => _selectedConfirmedDate;

  set selectedConfirmedDate(DateTime value) {
    if (_selectedConfirmedDate == value) return;
    _selectedConfirmedDate = value;
    notifyListeners();
  }

  String get selectedConfirmedDateFormatted =>
      DateFormat.MMMEd().format(_selectedConfirmedDate);
  DateTime get selectedHospitalizedDate => _selectedHospitalizedSample.date;

  String get selectedHospitalizedDateFormatted =>
      DateFormat.MMMEd().format(_selectedHospitalizedSample.date);

  int get selectedHospitalizedDead => _selectedHospitalizedSample.dead;

  int get selectedHospitalizedIcu => _selectedHospitalizedSample.icu;

  HospitalizedSample get selectedHospitalizedSample =>
      _selectedHospitalizedSample;

  set selectedHospitalizedSample(HospitalizedSample value) {
    if (_selectedHospitalizedSample == value) return;
    _selectedHospitalizedSample = value;
    notifyListeners();
  }

  int get selectedHospitalizedWard => _selectedHospitalizedSample.ward;

  int get selectedValue => _selectedValue;

  set selectedValue(int value) {
    if (_selectedValue == value) return;
    _selectedValue = value;
    notifyListeners();
  }
}

class UiModel with ChangeNotifier {
  ConfirmedTrendMode _confirmedTrendMode = ConfirmedTrendMode.cumulative;
  HospitalizedTrendMode _hospitalizedTrendMode = HospitalizedTrendMode.hospitalized;

  int _selectedConfirmedHcdIndex = 0;
  int _selectedHospitalizedHcdIndex = 0;

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

  ConfirmedTrendMode get confirmedTrendMode => _confirmedTrendMode;
  HospitalizedTrendMode get hospitalizedTrendMode => _hospitalizedTrendMode;

  set confirmedTrendMode(ConfirmedTrendMode value) {
    if (_confirmedTrendMode == value) return;
    _confirmedTrendMode = value;
    notifyListeners();
  }

  set hospitalizedTrendMode(HospitalizedTrendMode value) {
    if (_hospitalizedTrendMode == value) return;
    _hospitalizedTrendMode = value;
    notifyListeners();
  }
}

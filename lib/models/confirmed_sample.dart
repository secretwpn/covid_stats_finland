import 'dart:convert';

class ConfirmedSample {
  final int value;
  final DateTime date;
  final String healthCareDistrict;

  ConfirmedSample({this.value, this.date, this.healthCareDistrict});

  factory ConfirmedSample.fromRawJson(String str) => ConfirmedSample.fromJson(json.decode(str));

  factory ConfirmedSample.fromJson(Map<String, dynamic> json) => ConfirmedSample(
        value: json["value"] as int,
        date: DateTime.parse(json["date"] as String),
        healthCareDistrict: json["healthCareDistrict"] as String,
      );

  static int getConfirmedToDate(DateTime dateTime, List<ConfirmedSample> samples) =>
      samples
          .where((s) => s.date.compareTo(dateTime) < 0)
          .fold(0, (t, e) => t + e.value);
}

import 'dart:convert';

class Sample {
  final int value;
  final DateTime date;
  final String healthCareDistrict;

  Sample({this.value, this.date, this.healthCareDistrict});

  factory Sample.fromRawJson(String str) => Sample.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        value: json["value"] as int,
        date: DateTime.parse(json["date"] as String),
        healthCareDistrict: json["healthCareDistrict"] as String,
      );

  Map<String, dynamic> toJson() =>
      {"value": value, "date": date, "healthCareDistrict": healthCareDistrict};
}

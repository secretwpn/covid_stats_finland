import 'dart:convert';

class HospitalizedSample {
  final int total;
  final int ward;
  final int icu;
  final int dead;
  final DateTime date;
  final String hcdId;

  HospitalizedSample({
    this.date,
    this.hcdId,
    this.total,
    this.ward,
    this.icu,
    this.dead,
  });

  factory HospitalizedSample.fromJson(Map<String, dynamic> json) =>
      HospitalizedSample(
        total: json["totalHospitalised"] as int,
        ward: json["inWard"] as int,
        icu: json["inIcu"] as int,
        dead: json["dead"] as int,
        date: DateTime.parse(json["date"] as String),
        hcdId: json["area"] as String,
      );

  factory HospitalizedSample.fromRawJson(String str) =>
      HospitalizedSample.fromJson(json.decode(str));

  static int getConfirmedToDate(
          DateTime dateTime, List<HospitalizedSample> samples) =>
      samples
          .where((s) => s.date.compareTo(dateTime) < 0)
          .fold(0, (t, e) => t + e.total);
}

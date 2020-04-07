import 'package:covid_stats_finland/models/sample.dart';

/// Health care district

class Hcd {
  final String name;
  final List<Sample> samples;

  Hcd({this.name, this.samples});

  factory Hcd.fromJson(String name, Map<String, dynamic> json) => Hcd(
        name: name,
        samples: List<Sample>.from(
          json[name].map(
            (x) => Sample.fromJson(x),
          ),
        ),
      );

  int getConfirmedTotal() => samples.fold(0, (t, e) => t + e.value);

  static int getConfirmedToDate(DateTime dateTime, List<Sample> samples) =>
      samples.where((s) => s.date.compareTo(dateTime) < 0).fold(
            0,
            (t, e) => t + e.value,
          );

  int getConfirmed(DateTime dateTime) => getConfirmedToDate(dateTime, samples);
}

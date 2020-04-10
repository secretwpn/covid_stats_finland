import 'package:collection/collection.dart';
import 'package:covid_stats_finland/models/confirmed_sample.dart';

/// Health care district

class Hcd {
  final String name;
  final List<ConfirmedSample> samples;

  Hcd({this.name, this.samples});

  factory Hcd.fromJson(String name, Map<String, dynamic> json) => Hcd(
        name: name,
        samples: List<ConfirmedSample>.from(
          json[name].map(
            (x) => ConfirmedSample.fromJson(x),
          ),
        ).where((sample) => sample.value > 5).toList(),
      );

  int getConfirmedTotal() => samples.fold(0, (t, e) => t + e.value);

  int getConfirmed(DateTime dateTime) =>
      ConfirmedSample.getConfirmedToDate(dateTime, samples);

  getMaxDate() =>
      maxBy<ConfirmedSample, DateTime>(samples, (s) => s.date)?.date;
}

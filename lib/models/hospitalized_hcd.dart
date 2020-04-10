import 'package:collection/collection.dart';
import 'package:covid_stats_finland/models/hospitalized_sample.dart';

/// Health care district

class HospitalizedHcd {
  final String name;
  final List<HospitalizedSample> samples;

  HospitalizedHcd({this.name, this.samples});

  int getConfirmed(DateTime dateTime) =>
      HospitalizedSample.getConfirmedToDate(dateTime, samples);

  getMaxDate() =>
      maxBy<HospitalizedSample, DateTime>(samples, (s) => s.date)?.date;

  getLatestTotal() => getLatestSample().total;
  HospitalizedSample getLatestSample() =>
      samples.firstWhere((sample) => sample.date == getMaxDate());
}

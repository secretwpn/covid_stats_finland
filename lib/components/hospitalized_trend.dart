import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_sample.dart';
import 'package:covid_stats_finland/util.dart' as util;
import 'package:flutter/material.dart';

class HospitalizedByTimeTrend extends StatelessWidget {
  final HospitalizedHcd hcd;
  final void Function(DateTime, int) onSelectValue;

  const HospitalizedByTimeTrend({
    Key key,
    @required this.hcd,
    @required this.onSelectValue,
  }) : super(key: key);

  _wardColor(BuildContext context) => util.fromDartColor(Theme.of(context).accentColor.withAlpha(170));
  _icuColor(BuildContext context) => util.fromDartColor(Theme.of(context).accentColor);
  _deadColor(BuildContext context) => Theme.of(context).brightness == Brightness.light ? charts.MaterialPalette.black : util.fromDartColor(Theme.of(context).accentColor.withAlpha(80));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: charts.TimeSeriesChart(
          [
            charts.Series<HospitalizedSample, DateTime>(
              id: 'In ward',
              domainFn: (HospitalizedSample sample, _) => sample.date,
              measureFn: (HospitalizedSample sample, _) => sample.ward,
              data: hcd.samples,
              colorFn: (_, __) => _wardColor(context),
            ),
            charts.Series<HospitalizedSample, DateTime>(
              id: 'On ICU',
              domainFn: (HospitalizedSample sample, _) => sample.date,
              measureFn: (HospitalizedSample sample, _) => sample.icu,
              data: hcd.samples,
              colorFn: (_, __) => _icuColor(context),
            ),
            charts.Series<HospitalizedSample, DateTime>(
              id: 'Dead',
              domainFn: (HospitalizedSample sample, _) => sample.date,
              measureFn: (HospitalizedSample sample, _) => sample.dead,
              data: hcd.samples,
              colorFn: (_, __) => _deadColor(context),
            ),
          ],
          animate: true,
          defaultRenderer: charts.BarRendererConfig<DateTime>(
            groupingType: charts.BarGroupingType.stacked,
          ),
          behaviors: [
            charts.SeriesLegend(
              position: charts.BehaviorPosition.bottom,
              outsideJustification: charts.OutsideJustification.start,
            ),
          ],
          primaryMeasureAxis: charts.NumericAxisSpec()),

    );
  }
}

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/constants.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_sample.dart';
import 'package:covid_stats_finland/util.dart' as util;
import 'package:flutter/material.dart';

class HospitalizedByTimeTrend extends StatelessWidget {
  final HospitalizedHcd hcd;
  final void Function(HospitalizedSample) onSelectValue;

  const HospitalizedByTimeTrend({
    Key key,
    @required this.hcd,
    @required this.onSelectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gridColor = util.gridColor(context);
    var labelColor = util.labelColor(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: _buildChart(context, gridColor, labelColor),
    );
  }

  charts.TimeSeriesChart _buildChart(
    BuildContext context,
    charts.Color gridColor,
    charts.Color labelColor,
  ) => charts.TimeSeriesChart(
      [
         charts.Series<HospitalizedSample, DateTime>(
          id: 'Ward',
          domainFn: (HospitalizedSample sample, _) => sample.date,
          measureFn: (HospitalizedSample sample, _) => sample.ward,
          data: hcd.samples,
          colorFn: (_, __) => _wardColor(context),
        ),
        charts.Series<HospitalizedSample, DateTime>(
          id: 'Intensive care',
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
      animate: false,
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.start,
          showMeasures: true,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tap),
      ],
      layoutConfig: chartLayout,
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            HospitalizedSample selectedSample = model.selectedDatum[0].datum;
            onSelectValue(selectedSample);
          }
        })
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          hour: charts.TimeFormatterSpec(
            format: "d MMM",
            transitionFormat: "d MMM",
          ),
        ),
        tickProviderSpec: charts.DateTimeEndPointsTickProviderSpec(),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
    );

  static _deadColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? charts.MaterialPalette.black
          : util.fromDartColor(Theme.of(context).accentColor.withAlpha(80));

  static _icuColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
          ? util.fromDartColor(Colors.redAccent)
          : util.fromDartColor(Colors.redAccent);


  static _wardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? util.fromDartColor(Colors.blueAccent)
          : util.fromDartColor(Colors.blueAccent);
}

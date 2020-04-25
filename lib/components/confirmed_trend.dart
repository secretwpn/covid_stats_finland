import 'dart:collection';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/constants.dart';
import 'package:covid_stats_finland/models/confirmed_sample.dart';
import 'package:covid_stats_finland/util.dart' as util;
import 'package:flutter/material.dart';

class ConfirmedTrend extends StatelessWidget {
  final List<ConfirmedSample> samples;
  final void Function(DateTime, int) onSelectValue;

  const ConfirmedTrend({
    Key key,
    @required this.samples,
    @required this.onSelectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gridColor = util.gridColor(context);
    var labelColor = util.labelColor(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: charts.TimeSeriesChart(
        [
          charts.Series<ConfirmedSample, DateTime>(
            id: 'Total',
            // colorFn: (_, __) => _cumulColor(context),
            domainFn: (ConfirmedSample sample, _) => sample.date,
            measureFn: (ConfirmedSample sample, _) =>
                ConfirmedSample.getConfirmedToDate(sample.date, samples),
            data: samples,
            seriesColor: _cumulColor(context),
          )..setAttribute(charts.measureAxisIdKey, 'total'),
          charts.Series<ConfirmedSample, DateTime>(
            id: 'Daily',
            // colorFn: (_, __) => _dailyColor(context),
            domainFn: (ConfirmedSample sample, _) => sample.date,
            measureFn: (ConfirmedSample sample, _) => sample.value,
            data: samples,
            seriesColor:  _dailyColor(context),
          )..setAttribute(charts.measureAxisIdKey, 'daily')
        ],
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        animate: false,
        defaultInteractions: true,
        disjointMeasureAxes: LinkedHashMap<String, charts.NumericAxisSpec>.from({
          'total': charts.NumericAxisSpec(),
          'daily': charts.NumericAxisSpec(),
        }),
        // primaryMeasureAxis: charts.NumericAxisSpec(
          // renderSpec: charts.GridlineRendererSpec(
          //   lineStyle: charts.LineStyleSpec(color: gridColor),
          //   labelStyle: charts.TextStyleSpec(color: labelColor),
          // ),
        // ),
        domainAxis: charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DateTimeEndPointsTickProviderSpec(),
          renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(color: gridColor),
            labelStyle: charts.TextStyleSpec(color: labelColor),
          ),
        ),
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
                var dateTime = _getDateTime(model);
                var value = _getValue(model);
                onSelectValue(dateTime, value);
              }
            },
          )
        ],
      ),
    );
  }

  DateTime _getDateTime(charts.SelectionModel model) =>
      model.selectedSeries[0].domainFn(model.selectedDatum[0].index);

  int _getValue(charts.SelectionModel model) =>
      model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
}

_cumulColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? util.fromDartColor(Colors.redAccent)
        : util.fromDartColor(Colors.redAccent);

_dailyColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? util.fromDartColor(Colors.blueAccent)
        : util.fromDartColor(Colors.blueAccent);

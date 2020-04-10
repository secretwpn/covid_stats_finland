import 'package:covid_stats_finland/util.dart' as util;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/models/confirmed_sample.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';

class ConfirmedTrend extends StatelessWidget {
  final List<ConfirmedSample> samples;
  final TrendMode mode;
  final void Function(DateTime, int) onSelectValue;

  const ConfirmedTrend({
    Key key,
    @required this.samples,
    @required this.mode,
    @required this.onSelectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: _buildChart(context, mode),
    );
  }

  Widget _buildChart(BuildContext context, TrendMode mode) {
    Widget widget;
    switch (mode) {
      case TrendMode.cumulative:
        widget = _buildCumulativeChart(context);
        break;
      case TrendMode.daily:
        widget = _buildDailyChart(context);
        break;
      default:
        widget = Text("unknown trend mode $mode");
        break;
    }
    return widget;
  }

  charts.TimeSeriesChart _buildCumulativeChart(BuildContext context) {
    charts.Color gridColor = _gridColor(context);
    charts.Color labelColor = _labelColor(context);
    charts.Color lineColor = _lineColor(context);
    return charts.TimeSeriesChart(
      [
        charts.Series<ConfirmedSample, DateTime>(
          id: 'confirmed-cumulative',
          colorFn: (_, __) => lineColor,
          domainFn: (ConfirmedSample sample, _) => sample.date,
          measureFn: (ConfirmedSample sample, _) =>
              ConfirmedSample.getConfirmedToDate(sample.date, samples),
          data: samples,
        )
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      animate: true,
      defaultInteractions: true,
      defaultRenderer: charts.LineRendererConfig<DateTime>(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 8),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DateTimeEndPointsTickProviderSpec(),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
      behaviors: [
        charts.SelectNearest(
          selectionModelType: charts.SelectionModelType.info,
          eventTrigger: charts.SelectionTrigger.tapAndDrag,
          expandToDomain: true,
        ),
        charts.DomainHighlighter(charts.SelectionModelType.info),
        charts.LinePointHighlighter(
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          symbolRenderer: charts.CircleSymbolRenderer(isSolid: false),
        ),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection)
              onSelectValue(_getDateTime(model), _getValue(model));
          },
        )
      ],
    );
  }

  charts.TimeSeriesChart _buildDailyChart(BuildContext context) {
    var gridColor = _gridColor(context);
    var labelColor = _labelColor(context);
    var lineColor = _lineColor(context);
    return charts.TimeSeriesChart(
      [
        charts.Series<ConfirmedSample, DateTime>(
          id: 'confirmed-daily',
          colorFn: (_, __) => lineColor,
          domainFn: (ConfirmedSample sample, _) => sample.date,
          measureFn: (ConfirmedSample sample, _) => sample.value,
          data: samples,
        )
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      animate: true,
      defaultInteractions: true,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 8),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DateTimeEndPointsTickProviderSpec(),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(color: gridColor),
          labelStyle: charts.TextStyleSpec(color: labelColor),
        ),
      ),
      behaviors: [
        charts.SelectNearest(
          selectionModelType: charts.SelectionModelType.info,
          eventTrigger: charts.SelectionTrigger.tapAndDrag,
          expandToDomain: true,
        ),
        charts.DomainHighlighter(charts.SelectionModelType.info),
        charts.LinePointHighlighter(
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          symbolRenderer: charts.CircleSymbolRenderer(isSolid: false),
        ),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection)
              onSelectValue(_getDateTime(model), _getValue(model));
          },
        )
      ],
    );
  }

  int _getValue(charts.SelectionModel model) =>
      model.selectedSeries[0].measureFn(model.selectedDatum[0].index);

  DateTime _getDateTime(charts.SelectionModel model) =>
      model.selectedSeries[0].domainFn(model.selectedDatum[0].index);

  charts.Color _gridColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? util.fromDartColor(Colors.black12)
          : util.fromDartColor(Colors.white12);

  charts.Color _labelColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? util.fromDartColor(Colors.black38)
          : util.fromDartColor(Colors.white38);

  charts.Color _lineColor(BuildContext context) =>
      util.fromDartColor(Theme.of(context).accentColor);
}

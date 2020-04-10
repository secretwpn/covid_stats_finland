import 'package:covid_stats_finland/models/confirmed_sample.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';

class Trend extends StatelessWidget {
  final Color lineColor;
  final List<ConfirmedSample> samples;
  final TrendMode mode;
  final void Function(int) onSelectValue;

  const Trend(
      {Key key,
      @required this.samples,
      @required this.mode,
      @required this.onSelectValue,
      this.lineColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = _fromDartColor(lineColor);
    return Container(
      padding: EdgeInsets.all(12),
      child: _buildChart(context, mode, color),
    );
  }

  charts.Color _gridColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
  ? _fromDartColor(Colors.black12)
  : _fromDartColor(Colors.white12);

  charts.Color _labelColor(BuildContext context) => Theme.of(context).brightness == Brightness.light
  ? _fromDartColor(Colors.black38)
  : _fromDartColor(Colors.white38);

  charts.Color _lineColor(BuildContext context) => _fromDartColor(Theme.of(context).accentColor);

  Widget _buildChart(BuildContext context, TrendMode mode, charts.Color lineColor) {
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
              if (model.hasDatumSelection) onSelectValue(_getValue(model));
            },
          )
        ],
      );
  }

  _getValue(charts.SelectionModel model) =>
      model.selectedSeries[0].measureFn(model.selectedDatum[0].index);

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
              if (model.hasDatumSelection) onSelectValue(_getValue(model));
            },
          )
        ],
      );
  }
}

  charts.Color _fromDartColor(Color sourceColor) => charts.Color(
        r: sourceColor.red,
        g: sourceColor.green,
        b: sourceColor.blue,
        a: sourceColor.alpha,
      );
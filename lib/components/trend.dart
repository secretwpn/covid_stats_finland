import 'package:covid_stats_finland/models/sample.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';

class Trend extends StatelessWidget {
  final List<Sample> samples;
  final TrendMode mode;
  final void Function(int) onSelectValue;

  const Trend({Key key, @required this.samples, @required this.mode, @required this.onSelectValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lineColor = _buildColor(Theme.of(context).accentColor);
    var tickColor = _buildColor(Theme.of(context).accentColor);
    charts.RenderSpec<num> tickRendererValue = charts.SmallTickRendererSpec(
      labelStyle: charts.TextStyleSpec(color: tickColor),
      // lineStyle: charts.LineStyleSpec(color: lineColor),
    );
    charts.RenderSpec<DateTime> tickRendererDate = charts.SmallTickRendererSpec(
      labelStyle: charts.TextStyleSpec(color: tickColor),
      // lineStyle: charts.LineStyleSpec(color: lineColor),
    );
    return Container(
      padding: EdgeInsets.all(12),
      child: _buildChart(mode, lineColor, tickRendererValue, tickRendererDate),
    );
  }

  Widget _buildChart(
      TrendMode mode,
      charts.Color lineColor,
      charts.RenderSpec<num> tickRendererValue,
      charts.RenderSpec<DateTime> tickRendererDate) {
    Widget widget;
    switch (mode) {
      case TrendMode.cumulative:
        widget = _buildCumulativeChart(
            lineColor, tickRendererValue, tickRendererDate);
        break;
      case TrendMode.daily:
        widget =
            _buildDailyChart(lineColor, tickRendererValue, tickRendererDate);
        break;
      default:
        widget = Text("unknown trend mode $mode");
        break;
    }
    return widget;
  }

  charts.TimeSeriesChart _buildDailyChart(
          charts.Color lineColor,
          charts.RenderSpec<num> tickRendererValue,
          charts.RenderSpec<DateTime> tickRendererDate) =>
      charts.TimeSeriesChart(
        [
          charts.Series<Sample, DateTime>(
            id: 'confirmed-daily',
            colorFn: (_, __) => lineColor,
            domainFn: (Sample sample, _) => sample.date,
            measureFn: (Sample sample, _) => sample.value,
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
          renderSpec: tickRendererValue,
        ),
        domainAxis: charts.DateTimeAxisSpec(
          renderSpec: tickRendererDate,
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

  _getValue(charts.SelectionModel model) =>
      model.selectedSeries[0].measureFn(model.selectedDatum[0].index);

  charts.TimeSeriesChart _buildCumulativeChart(
          charts.Color lineColor,
          charts.RenderSpec<num> tickRendererValue,
          charts.RenderSpec<DateTime> tickRendererDate) =>
      charts.TimeSeriesChart(
        [
          charts.Series<Sample, DateTime>(
            id: 'confirmed-cumulative',
            colorFn: (_, __) => lineColor,
            domainFn: (Sample sample, _) => sample.date,
            measureFn: (Sample sample, _) =>
                Sample.getConfirmedToDate(sample.date, samples),
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
          renderSpec: tickRendererValue,
        ),
        domainAxis: charts.DateTimeAxisSpec(
          renderSpec: tickRendererDate,
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

  charts.Color _buildColor(Color sourceColor) => charts.Color(
        r: sourceColor.red,
        g: sourceColor.green,
        b: sourceColor.blue,
        a: sourceColor.alpha,
      );
}

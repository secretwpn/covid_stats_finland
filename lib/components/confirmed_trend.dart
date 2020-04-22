import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats_finland/constants.dart';
import 'package:covid_stats_finland/models/confirmed_sample.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:covid_stats_finland/util.dart' as util;
import 'package:flutter/material.dart';

class ConfirmedTrend extends StatelessWidget {
  final List<ConfirmedSample> samples;
  final ConfirmedTrendMode mode;
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

  Widget _buildChart(BuildContext context, ConfirmedTrendMode mode) {
    Widget widget;
    switch (mode) {
      case ConfirmedTrendMode.cumulative:
        widget = _buildCumulativeChart(context);
        break;
      case ConfirmedTrendMode.daily:
        widget = _buildDailyChart(context);
        break;
      default:
        widget = Text("unknown trend mode $mode");
        break;
    }
    return widget;
  }

  charts.TimeSeriesChart _buildCumulativeChart(BuildContext context) {
    var gridColor = util.gridColor(context);
    var labelColor = util.labelColor(context);
    var lineColor = util.lineColor(context);
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
      animate: false,
      defaultInteractions: true,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      primaryMeasureAxis: charts.NumericAxisSpec(
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
        ),
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
    );
  }

  charts.TimeSeriesChart _buildDailyChart(BuildContext context) {
    var gridColor = util.gridColor(context);
    var labelColor = util.labelColor(context);
    var lineColor = util.lineColor(context);
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
      layoutConfig: chartLayout,
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

  DateTime _getDateTime(charts.SelectionModel model) =>
      model.selectedSeries[0].domainFn(model.selectedDatum[0].index);

  int _getValue(charts.SelectionModel model) =>
      model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
}

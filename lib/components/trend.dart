import 'package:covid_stats_finland/models/sample.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class Trend extends StatelessWidget {
  final List<Sample> samples;

  const Trend({Key key, this.samples}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).accentColor;
    return Container(
      padding: EdgeInsets.all(12),
      child: TimeSeriesChart(
        [
          Series<Sample, DateTime>(
            id: 'Confirmed cases',
            colorFn: (_, __) => Color(r: color.red, g: color.green, b: color.blue, a: color.alpha),
            domainFn: (Sample sample, _) => sample.date,
            measureFn: (Sample sample, _) =>
                Sample.getConfirmedToDate(sample.date, samples),
            data: samples,
          )
        ],
        dateTimeFactory: const LocalDateTimeFactory(),
        animate: true,
        defaultInteractions: true,
        primaryMeasureAxis: NumericAxisSpec(tickProviderSpec: BasicNumericTickProviderSpec(desiredTickCount: 8)),
        behaviors: [
          SelectNearest(
            selectionModelType: SelectionModelType.info,
            eventTrigger: SelectionTrigger.tapAndDrag,
            expandToDomain: true,
          ),
          DomainHighlighter(SelectionModelType.info),
          LinePointHighlighter(
            showVerticalFollowLine: LinePointHighlighterFollowLineType.nearest,
            showHorizontalFollowLine:
                LinePointHighlighterFollowLineType.nearest,
            symbolRenderer: CircleSymbolRenderer(isSolid: false),
          ),
        ],
        selectionModels: [
          SelectionModelConfig(changedListener: (SelectionModel model) {
            if (model.hasDatumSelection)
              print(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index));
          })
        ],
      ),
    );
  }
}

import 'package:covid_stats_finland/components/icon_label.dart';
import 'package:covid_stats_finland/components/confirmed_trend.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmedCasesDisplay extends StatelessWidget {
  final List<Hcd> hcdList;
  const ConfirmedCasesDisplay({Key key, this.hcdList}) : super(key: key);

  _buildTrendModeButton(TrendMode mode) {
    String labelText;
    switch (mode) {
      case TrendMode.cumulative:
        labelText = "Cumulative";
        break;
      case TrendMode.daily:
        labelText = "Daily";
        break;
      default:
        labelText = "unknown";
        break;
    }
    return Consumer<UiModel>(
      builder: (BuildContext context, UiModel model, Widget _) => FlatButton(
        color: mode == model.trendMode
            ? Theme.of(context).accentColor
            : Colors.transparent,
        textColor: mode == model.trendMode
            ? Theme.of(context).backgroundColor
            : Theme.of(context).accentColor,
        onPressed: () => model.trendMode = mode,
        child: Text(labelText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DateTime maxDate =
    //     maxBy<Hcd, DateTime>(hcdList, (hcd) => hcd.getMaxDate()).getMaxDate();
    // var timeText = DateFormat.MMMEd().format(maxDate);
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Consumer<SelectionModel>(
            builder: (BuildContext _, SelectionModel model, Widget __) => Text(
              "${model.selectedValue} confirmed cases on ${model.selectedDateFormatted}",
            ),
          ),
          Expanded(
            child: Consumer<UiModel>(
              builder: (BuildContext _, UiModel uiModel, Widget __) =>
                  ConfirmedTrend(
                samples: hcdList[uiModel.selectedConfirmedHcdIndex].samples,
                mode: uiModel.trendMode,
                onSelectValue: (DateTime dateTime, int value) {
                  Provider.of<SelectionModel>(context, listen: false)
                      .selectedValue = value;
                  Provider.of<SelectionModel>(context, listen: false)
                      .selectedDateTime = dateTime;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: ButtonBar(
              children: <Widget>[
                _buildTrendModeButton(TrendMode.daily),
                _buildTrendModeButton(TrendMode.cumulative),
              ],
            ),
          ),
          Expanded(
            child: Consumer<UiModel>(
              builder: _buildListView,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, UiModel uiModel, Widget _) =>
      ListView.builder(
        itemCount: hcdList.length,
        itemBuilder: (context, i) => ListTile(
          selected: i == uiModel.selectedConfirmedHcdIndex,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(hcdList[i].name),
              Text(hcdList[i].getConfirmedTotal().toString()),
            ],
          ),
          onTap: () => uiModel.selectedConfirmedHcdIndex = i,
        ),
      );
}

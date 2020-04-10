import 'package:collection/collection.dart';
import 'package:covid_stats_finland/components/hospitalized_trend.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HospitalizedCasesDisplay extends StatelessWidget {
  final List<HospitalizedHcd> hcdList;
  const HospitalizedCasesDisplay({Key key, this.hcdList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime maxDate =
        maxBy<HospitalizedHcd, DateTime>(hcdList, (hcd) => hcd.getMaxDate())
            .getMaxDate();
    var timeText = DateFormat.MMMEd().format(maxDate);
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("Hospitalized cases total on $timeText"),
          Expanded(
            child: Consumer<UiModel>(
              builder: (BuildContext _, UiModel uiModel, Widget __) =>
                  HospitalizedByTimeTrend(
                hcd: hcdList[uiModel.selectedHospitalizedHcdIndex],
                onSelectValue: (DateTime dateTime, int value) {
                  Provider.of<SelectionModel>(context, listen: false).selectedValue = value;
                },
              ),
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
        itemBuilder: (context, i) {
          var hcd = hcdList[i];
          return ListTile(
          selected: i == uiModel.selectedHospitalizedHcdIndex,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(hcd.name),
              Text(hcd.getLatestTotal().toString()),
            ],
          ),
          onTap: () => uiModel.selectedHospitalizedHcdIndex = i,
        );
        },
      );
}

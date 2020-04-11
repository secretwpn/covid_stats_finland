import 'package:covid_stats_finland/components/hospitalized_trend.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_sample.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HospitalizedCasesDisplay extends StatelessWidget {
  final List<HospitalizedHcd> hcdList;
  const HospitalizedCasesDisplay({Key key, this.hcdList}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Consumer<SelectionModel>(
              builder: (BuildContext _, SelectionModel model, Widget __) =>
                  model.selectedHospitalizedSample == null
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                              "${model.selectedHospitalizedDateFormatted}"),
                        ),
            ),
            Expanded(
              child: Consumer<UiModel>(
                builder: (BuildContext _, UiModel uiModel, Widget __) =>
                    HospitalizedByTimeTrend(
                  hcd: hcdList[uiModel.selectedHospitalizedHcdIndex],
                  onSelectValue: (HospitalizedSample value) {
                    Provider.of<SelectionModel>(context, listen: false)
                        .selectedHospitalizedSample = value;
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

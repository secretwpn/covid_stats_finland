import 'package:collection/collection.dart';
import 'package:covid_stats_finland/api.dart';
import 'package:covid_stats_finland/components/advanced_future_builder.dart';
import 'package:covid_stats_finland/components/info_page.dart';
import 'package:covid_stats_finland/components/trend.dart';
import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final _darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: Colors.black,
    primaryColorDark: Colors.white54,
    accentColor: Colors.blue,
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  ),
);
final _lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: Colors.white,
    primaryColorDark: Colors.black,
    accentColor: Colors.redAccent,
    primarySwatch: Colors.red,
    brightness: Brightness.light,
  ),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  @override
  Widget build(BuildContext context) => AdvancedFutureBuilder<ApiResponse>(
      future: fetchDataSet(),
      successWidgetBuilder: (response) {
        var hcdList = response.districts.toList();
        hcdList.sort(
            (a, b) => a.getConfirmedTotal().compareTo(b.getConfirmedTotal()));
        hcdList = hcdList.reversed.toList();

        return MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider(
              create: (_) => UiModel(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => SelectionModel(),
              lazy: true,
            ),
          ],
          child: MaterialApp(
            themeMode: _themeMode,
            theme: _darkTheme,
            darkTheme: _lightTheme,
            home: Scaffold(
              appBar: AppBar(
                title: Text('COVID-19 Finland'),
                actions: <Widget>[
                  _buildThemeSwitchButton(),
                  _buildInfoButton(),
                ],
              ),
              body: DataSetDisplay(hcdList: hcdList),
            ),
          ),
        );
      });

  toggleThemeMode() => setState(
        () {
          _themeMode =
              _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        },
      );

  Widget _buildThemeSwitchButton() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel model, Widget child) =>
            IconButton(
          icon: Icon(Icons.brightness_4),
          onPressed: () {
            toggleThemeMode();
          },
        ),
      );
  Widget _buildInfoButton() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel model, Widget child) =>
            IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoPage()),
            );
          },
        ),
      );
}

class DataSetDisplay extends StatelessWidget {
  final List<Hcd> hcdList;
  const DataSetDisplay({Key key, this.hcdList}) : super(key: key);

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
    DateTime maxDate = maxBy<Hcd, DateTime>(hcdList, (hcd) => hcd.getMaxDate()).getMaxDate();
    var timeText = DateFormat.MMMEd().format(maxDate);
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("Confirmed cases by $timeText"),
          Expanded(
            child: Consumer<UiModel>(
              builder: (BuildContext _, UiModel uiModel, Widget __) => Trend(
                lineColor: Theme.of(context).primaryColor,
                samples: hcdList[uiModel.selectedHcdIndex].samples,
                mode: uiModel.trendMode,
                onSelectValue: (int value) {
                  Provider.of<SelectionModel>(context, listen: false)
                      .selectedValue = value;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Consumer<SelectionModel>(
                    builder: (BuildContext _, SelectionModel model,
                            Widget __) =>
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.people),
                            Text(" ${model.selectedValue}",
                                style: Theme.of(context).textTheme.headline),
                          ],
                        )),
                ButtonBar(
                  children: <Widget>[
                    _buildTrendModeButton(TrendMode.daily),
                    _buildTrendModeButton(TrendMode.cumulative),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel uiModel, Widget _) =>
            ListView.builder(
          itemCount: hcdList.length,
          itemBuilder: (context, i) => ListTile(
            selected: i == uiModel.selectedHcdIndex,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(hcdList[i].name),
                Text(hcdList[i].getConfirmedTotal().toString()),
              ],
            ),
            onTap: () {
              uiModel.selectedHcdIndex = i;
            },
          ),
        ),
      );
}

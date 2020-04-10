import 'package:covid_stats_finland/api.dart';
import 'package:covid_stats_finland/components/advanced_future_builder.dart';
import 'package:covid_stats_finland/components/trend.dart';
import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/trend_mode.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<AppModel>(
    AppModelImplementation(),
    signalsReady: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
  backgroundColor: Colors.black,
  primaryColorDark: Colors.white,
  accentColor: Colors.blue,
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
));
final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
  backgroundColor: Colors.white,
  primaryColorDark: Colors.black,
  accentColor: Colors.redAccent,
  primarySwatch: Colors.red,
  brightness: Brightness.light,
));

class _MyAppState extends State<MyApp> {
  var _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('COVID-19 Stats Finland'),
          actions: <Widget>[_buildThemeSwitchButton()],
        ),
        body: AdvancedFutureBuilder<ApiResponse>(
          future: fetchDataSet(),
          successWidgetBuilder: (response) {
            var dataSet = response.districts.toList();
            dataSet.sort((a, b) =>
                a.getConfirmedTotal().compareTo(b.getConfirmedTotal()));
            return DataSetDisplay(dataSet: dataSet.reversed.toList());
          },
        ),
      ),
    );
  }

  IconButton _buildThemeSwitchButton() => IconButton(
        icon: Icon(Icons.brightness_4),
        onPressed: () {
          this.setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          });
        },
      );
}

class DataSetDisplay extends StatefulWidget {
  final List<Hcd> dataSet;

  const DataSetDisplay({Key key, this.dataSet}) : super(key: key);

  @override
  _DataSetDisplayState createState() => _DataSetDisplayState();
}

class _DataSetDisplayState extends State<DataSetDisplay> {
  Hcd _selectedHcd;
  int _selectedHcdIndex = 0;
  int _selectedValue = 0;
  TrendMode _trendMode = TrendMode.cumulative;

  @override
  void initState() {
    _selectedHcd = widget.dataSet.first;
    super.initState();
  }

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
    return FlatButton(
        color: mode == _trendMode
            ? Theme.of(context).accentColor
            : Colors.transparent,
        onPressed: () {
          this.setState(() {
            _trendMode = mode;
          });
        },
        child: Text(labelText));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Trend(
              samples: _selectedHcd.samples,
              mode: _trendMode,
              onSelectValue: (int value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("$_selectedValue"),
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

  ListView _buildListView() => ListView.builder(
        itemCount: widget.dataSet.length,
        itemBuilder: (context, i) => ListTile(
          selected: i == _selectedHcdIndex,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.dataSet[i].name),
              Text(widget.dataSet[i].getConfirmedTotal().toString()),
            ],
          ),
          onTap: () {
            setState(() {
              _selectedHcd = widget.dataSet[i];
              _selectedHcdIndex = i;
            });
          },
        ),
      );
}

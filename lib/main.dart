import 'package:covid_stats_finland/api.dart';
import 'package:covid_stats_finland/components/advanced_future_builder.dart';
import 'package:covid_stats_finland/components/trend.dart';
import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData.from(colorScheme: ColorScheme.fromSwatch(
        backgroundColor: Colors.white,
        primaryColorDark: Colors.black,
        accentColor: Colors.redAccent,
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      )),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.fromSwatch(
        backgroundColor: Colors.black,
        primaryColorDark: Colors.white,
        accentColor: Colors.blue,
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      )),
      home: Scaffold(
        appBar: AppBar(
          title: Text('COVID-19 Stats Finland'),
        ),
        body: AdvancedFutureBuilder<ApiResponse>(
          future: fetchDataSet(),
          onResponse: (response) {
            var dataSet = response.districts.toList();
            dataSet.sort((a, b) =>
                a.getConfirmedTotal().compareTo(b.getConfirmedTotal()));
            return DataSetDisplay(dataSet: dataSet.reversed.toList());
          },
        ),
      ),
    );
  }
}

class DataSetDisplay extends StatefulWidget {
  final List<Hcd> dataSet;

  const DataSetDisplay({Key key, this.dataSet}) : super(key: key);

  @override
  _DataSetDisplayState createState() => _DataSetDisplayState();
}

class _DataSetDisplayState extends State<DataSetDisplay> {
  Hcd _selectedHcd;
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedHcd = widget.dataSet.first;
    super.initState();
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
            ),
          ),
          Expanded(
            child: buildListView(),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: widget.dataSet.length,
      itemBuilder: (context, i) => ListTile(
        selected: i == _selectedIndex,
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
            _selectedIndex = i;
          });
        },
      ),
    );
  }
}

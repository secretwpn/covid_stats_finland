import 'package:covid_stats_finland/api.dart';
import 'package:covid_stats_finland/components/advanced_future_builder.dart';
import 'package:covid_stats_finland/components/confirmed_cases_display.dart';
import 'package:covid_stats_finland/components/hospitalized_cases_display.dart';
import 'package:covid_stats_finland/components/icon_label.dart';
import 'package:covid_stats_finland/components/info_page.dart';
import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/app_model.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(MyApp());
}

final _darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: Colors.black,
    // primaryColorDark: Colors.white54,
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  var _refreshKey = GlobalKey();
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: _lightTheme,
        darkTheme: _darkTheme,
        home: AdvancedFutureBuilder<ApiResponse>(
          key: _refreshKey,
          future: fetchData(),
          successWidgetBuilder: (response) {
            var confirmedHcdList = response.confirmedHcdList.toList();
            var hospitalizedHcdList = response.hospitalizedHcdList.toList();
            confirmedHcdList.sort(
              (a, b) => b.getConfirmedTotal().compareTo(a.getConfirmedTotal()),
            );
            hospitalizedHcdList.sort(
              (a, b) => b.getLatestTotal().compareTo(a.getLatestTotal()),
            );
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
              child: _buildDefaultTabController(
                confirmedHcdList,
                hospitalizedHcdList,
              ),
            );
          },
        ),
      );

  DefaultTabController _buildDefaultTabController(List<Hcd> confirmedHcdList,
          List<HospitalizedHcd> hospitalizedHcdList) =>
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('COVID-19 Finland'),
            actions: <Widget>[
              _buildThemeSwitchButton(),
              _buildInfoButton(),
              _buildRefreshButton(),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: IconLabel(
                    icon: Icons.people,
                    text: "Confirmed",
                  ),
                ),
                Tab(
                  child: IconLabel(
                    icon: Icons.local_hospital,
                    text: "Hospitalized",
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              ConfirmedCasesDisplay(hcdList: confirmedHcdList),
              HospitalizedCasesDisplay(hcdList: hospitalizedHcdList),
            ],
          ),
        ),
      );

  Widget _buildInfoButton() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel model, Widget child) =>
            IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoPage()),
          ),
        ),
      );

  Widget _buildRefreshButton() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel model, Widget child) =>
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => setState(() {
                      _refreshKey = GlobalKey();
                    })),
      );

  Widget _buildThemeSwitchButton() => Consumer<UiModel>(
        builder: (BuildContext context, UiModel model, Widget child) =>
            IconButton(
          icon: Icon(Icons.brightness_4),
          onPressed: () => _toggleThemeMode(),
        ),
      );
  _toggleThemeMode() => setState(
        () => _themeMode =
            _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );
}

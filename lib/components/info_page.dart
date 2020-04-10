import 'package:covid_stats_finland/components/hyperlink.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Info"),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  "COVID-19 Finland",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        text: 'Open data source: ',
                        style: Theme.of(context).textTheme.body1,
                        children: <TextSpan>[
                          Hyperlink(
                            'HS-Datadesk',
                            'https://github.com/HS-Datadesk/koronavirus-avoindata',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "The data is updated once every few days",
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        text: 'World Health Organization Summary: ',
                        style: Theme.of(context).textTheme.body1,
                        children: <TextSpan>[
                          Hyperlink(
                            'WHO',
                            'https://www.who.int/emergencies/diseases/novel-coronavirus-2019',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Author: ',
                        style: Theme.of(context).textTheme.body1,
                        children: <TextSpan>[
                          Hyperlink(
                            'secretwpn',
                            'https://github.com/secretwpn',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Stay home, stay safe.',
                style: Theme.of(context).textTheme.body1,
              ),
            ],
          ),
        ));
  }
}

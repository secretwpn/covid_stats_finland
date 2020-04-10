import 'dart:convert';

import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

const statsApiUrl =
    'https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/processedThlData';

Future<String> fetchDataSetRaw() async {
  final response = await http.get(statsApiUrl);
  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to load dataSet');
  }
}

Future<String> fakeFetchDataSetRaw() async {
  return await rootBundle.loadString('assets/data-new.json');
}

Future<ApiResponse> fetchDataSet() async {
  String rawJson = await fetchDataSetRaw();
  var apiResponse = json.decode(rawJson);
  var confirmedSamplesByHcd = apiResponse["confirmed"] as Map<String, dynamic>;

  var hcds = Set<Hcd>();
  confirmedSamplesByHcd.forEach((key, i) {
    hcds.add(Hcd.fromJson(key, confirmedSamplesByHcd));
  });

  return ApiResponse(hcds);
}

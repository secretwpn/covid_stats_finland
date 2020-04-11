import 'dart:convert';

import 'package:covid_stats_finland/models/api_response.dart';
import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_sample.dart';
import 'package:http/http.dart' as http;

// Uncomment lines below if you want to use local files for development
// and use fakeFetchXXXRaw() instead of fetchRawJson(xxxUrl)
// import 'package:flutter/services.dart' show rootBundle;
// Future<String> fakeFetchConfirmedRaw() async {
//   return await rootBundle.loadString('assets/data-confirmed.json');
// }

// Future<String> fakeFetchHospitalizedRaw() async {
//   return await rootBundle.loadString('assets/data-hospitalized.json');
// }

const confirmedUrl =
    'https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/processedThlData';
const hospitalizedUrl =
    'https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/finnishCoronaHospitalData';


Future<Set<Hcd>> fetchConfirmed() async {
  String rawJson = await fetchRawJson(confirmedUrl);
  var apiResponse = json.decode(rawJson);
  var confirmedSamplesByHcd = apiResponse["confirmed"] as Map<String, dynamic>;

  var hcds = Set<Hcd>();
  confirmedSamplesByHcd.forEach((key, i) {
    var hcd = Hcd.fromJson(key, confirmedSamplesByHcd);
    if (hcd.getConfirmedTotal() > 0) hcds.add(hcd);
  });

  return hcds;
}

Future<ApiResponse> fetchData() async {
  var confirmedHcds = await fetchConfirmed();
  var hospitalizedHcds = await fetchHospitalized();

  return ApiResponse(confirmedHcds, hospitalizedHcds);
}

Future<Set<HospitalizedHcd>> fetchHospitalized() async {
  String rawJson = await fetchRawJson(hospitalizedUrl);
  var apiResponse = json.decode(rawJson);
  var samplesJson = apiResponse["hospitalised"] as List<dynamic>;

  var samples = samplesJson
      .map((sampleJson) => HospitalizedSample.fromJson(sampleJson))
      .toList();

  var hcds = samples
      .map((sample) => sample.hcdId)
      .toSet()
      .map(
        (hcdId) => HospitalizedHcd(
          name: hcdId,
          samples: samples
              .where((sample) => sample.hcdId == hcdId)
              .where((sample) => sample.total > 5)
              .toList(),
        ),
      )
      .toSet();

  return hcds;
}

Future<String> fetchRawJson(String url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to load dataSet');
  }
}

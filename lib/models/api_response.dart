import 'package:covid_stats_finland/models/hcd.dart';
import 'package:covid_stats_finland/models/hospitalized_hcd.dart';

class ApiResponse {
  final Set<Hcd> confirmedHcdList;
  final Set<HospitalizedHcd> hospitalizedHcdList;

  ApiResponse(this.confirmedHcdList, this.hospitalizedHcdList);
}

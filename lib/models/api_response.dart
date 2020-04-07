import 'package:covid_stats_finland/models/hcd.dart';

class ApiResponse {
  final Set<Hcd> districts;

  ApiResponse(this.districts);
}
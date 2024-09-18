import 'package:weather_app/models/temperature.dart';

class WeatherModel {
  final String? areaName;
  final int? weatherConditionCode;
  final Temperature temperature;
  final String? weatherMain;
  final DateTime? date;
  final DateTime? sunrise;
  final DateTime? sunset;
  final Temperature tempMax;
  final Temperature tempMin;

  WeatherModel({
    this.areaName,
    this.weatherConditionCode,
    required this.temperature,
    this.weatherMain,
    this.date,
    this.sunrise,
    this.sunset,
    required this.tempMax,
    required this.tempMin,
  });
}

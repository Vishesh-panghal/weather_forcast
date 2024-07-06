class Weather {
  final String cityName;
  final String mainCondition;
  final int humidity;
  final int pressure;
  final int visibility;
  final double temprature;
  final double max_temprature;
  final double min_temprature;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.temprature,
    required this.min_temprature,
    required this.max_temprature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['weather'][0]['main'],
      temprature: json['main']['temp'].toDouble(),
      min_temprature: json['main']['temp_min'].toDouble(),
      max_temprature: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
    );
  }
}

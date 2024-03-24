class WeatherData {
  final String description;
  final double temperature;
  final int humidity;

  WeatherData(
      {required this.description,
      required this.temperature,
      required this.humidity});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}

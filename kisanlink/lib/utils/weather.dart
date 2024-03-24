import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kisanlink/model/weatherdata.dart';
import 'package:http/http.dart' as http;

class WeatherContainer extends StatefulWidget {
  final String city;

  WeatherContainer({required this.city});

  @override
  _WeatherContainerState createState() => _WeatherContainerState();
}

class _WeatherContainerState extends State<WeatherContainer> {
  String apiKey = '8b1ca8d5554419009e889d1f3f018f75';

  Future<WeatherData> fetchWeather() async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=${widget.city}&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherData(
        description: jsonData['weather'][0]['description'],
        temperature: jsonData['main']['temp'].toDouble(),
        humidity: jsonData['main']['humidity'],
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: fetchWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final weatherData = snapshot.data!;
          return Container(
            width: 330,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Weather in ${widget.city}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Description: ${weatherData.description}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Temperature: ${weatherData.temperature}°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Humidity: ${weatherData.humidity}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}

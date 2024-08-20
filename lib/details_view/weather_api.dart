import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  Map<String, dynamic>? weatherData;

  Future<void> fetchWeather(double lat, double lon) async {
    const apiKey =
        '89c9c4dbdcd67e8348617153bb28a72e'; // Replace with your OpenWeatherMap API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    Logger().f(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Logger().f(data);
      setState(() {
        weatherData = data;
      });
      // data.forEach((key, value) {value.add("")})
      // setState(() {
      //   _weatherData = (jsonData['daily'] as List<dynamic>).map((item) => WeatherData.fromJson(item)).toList();
      // });
    } else {
      //   throw Exception('Failed to fetch data');
      Logger().e(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              TextField(
                controller: latController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Enter a lat"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: lonController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Enter a lon"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final lat = double.tryParse(latController.text);
                  final lon = double.tryParse(lonController.text);
                  if (lat != null && lon != null) {
                    fetchWeather(lat, lon);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 4,
                ),
                child: const Text(
                  'submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (weatherData != null)
                Expanded(
                  child: ListView(
                    children: weatherData!.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value.toString()),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

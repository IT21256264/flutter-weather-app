import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "London";
    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=688240e5a274ac127b2c416511a3a3c7"));

      final data = json.decode(res.body);

      if (data["cod"] != "200") {
        throw ("An unexpected error occurred");
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              debugPrint("refresh");
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final currentData = data["list"][0];
          final currentTemp = currentData["main"]["temp"];
          final currentSky = currentData["weather"][0]["main"];
          final currentPresure = currentData["main"]["pressure"];
          final currentHumidity = currentData["main"]["humidity"];
          final currentWindSpeed = currentData["wind"]["speed"];

          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.purple[50],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "$currentTemp K",
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          currentSky == "Clouds" || currentSky == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                          size: 64,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentSky,
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final forecastData = data["list"][index + 1];
                    final forecastTemp = forecastData["main"]["temp"];
                    final forecastSky = forecastData["weather"][0]["main"];
                    final forecastTime = forecastData["dt_txt"];
                    final time = DateTime.parse(forecastTime);

                    return ForecastItem(
                      time: DateFormat.Hm().format(time),
                      icon: forecastSky == "Clouds" || forecastSky == "Rain"
                          ? Icons.cloud
                          : Icons.sunny,
                      temperature: "$forecastTemp K",
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfo(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: currentHumidity.toString()),
                  AdditionalInfo(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWindSpeed.toString()),
                  AdditionalInfo(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    value: currentPresure.toString(),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

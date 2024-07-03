import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const ForecastItem(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        color: Colors.purple[50],
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(height: 5),
              Text(
                temperature,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

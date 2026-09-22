import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SensorPage(),
    );
  }
}

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o dispositivo está dentro dos valores esperados
    bool dispositivoParado =
        x >= 7.8 &&
        x <= 8.10 &&
        y >= -0.35 &&
        y <= -0.20 &&
        z >= 5.67 &&
        z <= 5.95;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor do celular'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Acelerômetro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'X: ${x.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),

            Text(
              'Y: ${y.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),

            Text(
              'Z: ${z.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 30),

            if (dispositivoParado)
              const Text(
                'Dispositivo parado',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              )
            else
              const Text(
                'Dispositivo se movimentou',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 46, 144, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distância entre locais',
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {
  double latitude = 0;
  double longitude = 0;
  double distancia = 0;

  // Segunda localização - Academia RIAD
  double latitudeDestino = -21.4659;
  double longitudeDestino = -47.0042;

  Future<void> buscarLocalizacao() async {
    // Verifica se o GPS está ativado
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Verifica a permissão
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    // Obtém a localização atual
    Position posicao = await Geolocator.getCurrentPosition();

    // Calcula a distância
    double distanciaCalculada = Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latitudeDestino,
      longitudeDestino,
    );

    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
      distancia = distanciaCalculada;
    });

    print('Latitude atual: $latitude');
    print('Longitude atual: $longitude');
    print('Distância: $distancia metros');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distância entre locais'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Distância entre onde estou até a academia RIAD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                distancia < 1000
                    ? '${distancia.toStringAsFixed(2)} metros'
                    : '${(distancia / 1000).toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: buscarLocalizacao,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Atualizar localização',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Denah Venue Utama (Gunakan pinch-to-zoom untuk memperbesar)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Container(
                width: 350,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  border: Border.all(color: Colors.blueGrey, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        'DENAH AUDITORIUM UTAMA\nUniversitas Nusa Putra',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.red.shade100,
                        child: const Text('Pintu Utama (Gate A)'),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.green.shade100,
                        child: const Text('Panggung Utama'),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 120,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.amber.shade100,
                        child: const Text('Booth Registrasi & Kit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
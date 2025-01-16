import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:animate_do/animate_do.dart';

class WavyHeaderWithClippers extends StatelessWidget {
  final String text; // Zmienna do przyjęcia tekstu
  final double height; // Zmienna do przyjęcia wysokości nagłówka

  // Konstruktor przyjmujący argumenty text i height
  WavyHeaderWithClippers({required this.text, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height:
            height, // Wysokość ustawiana na podstawie przekazanego argumentu
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(174, 108, 170, 1), // Jasny różowy
              Color.fromRGBO(143, 148, 251, 1), // Niebieski
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeInUp(
            duration: const Duration(milliseconds: 1900), // Czas animacji
            child: Text(
              text, // Wyświetlanie przekazanego tekstu
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

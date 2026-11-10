import 'dart:math' as math;
import 'geo.dart';
import 'personaje.dart';

/// Un personaje escondido en un punto del mapa.
class Aparicion {
  final Personaje personaje;
  final Coordenada coordenada;
  const Aparicion(this.personaje, this.coordenada);
}

/// Punto al azar entre [min] y [max] metros del [centro].
/// Se usa raíz cuadrada para repartir parejo por el área.
Coordenada puntoAleatorio(Coordenada centro, double min, double max, math.Random random) {
  final distancia = math.sqrt(min * min + random.nextDouble() * (max * max - min * min));
  return destino(centro, random.nextDouble() * 360, distancia);
}

/// El [random] se inyecta: con semilla fija el "azar" es repetible en las pruebas.
List<Aparicion> generarApariciones({
  required Coordenada centro,
  required List<Personaje> personajes,
  required math.Random random,
  double radioMin = 60,
  double radioMax = 500,
}) =>
    [for (final p in personajes) Aparicion(p, puntoAleatorio(centro, radioMin, radioMax, random))];

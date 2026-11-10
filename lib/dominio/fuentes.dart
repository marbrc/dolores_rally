import 'geo.dart';

/// Contratos: el resto de la app NO sabe si la posición viene del GPS real o de un simulador.
abstract class FuentePosicion {
  Stream<Coordenada> get posiciones;
}

abstract class FuenteBrujula {
  /// Rumbo en grados (0 = norte).
  Stream<double> get rumbos;
}

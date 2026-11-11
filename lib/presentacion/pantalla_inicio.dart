import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../datos/almacen_prefs.dart';
import '../datos/fuentes_reales.dart';
import '../datos/fuentes_simuladas.dart';
import '../dominio/almacen.dart';
import '../dominio/catalogo.dart';
import 'pantalla_coleccion.dart';
import 'pantalla_rally.dart';
import 'rally_viewmodel.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  void _jugarReal(BuildContext context) {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (_) => PantallaRally(
        crearVm: () => RallyViewModel(
          posicion: PosicionGps(),
          brujula: BrujulaReal(),
          almacen: AlmacenPrefs(),
          personajes: personajes,
          centro: plazaPrincipal,
          random: math.Random(), // sin semilla: cada partida es distinta
        ),
      ),
    ));
  }

  void _jugarDemo(BuildContext context) {
    final posicion = PosicionSimulada(plazaPrincipal);
    final brujula = BrujulaSimulada();
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (_) => PantallaRally(
        crearVm: () => RallyViewModel(
          posicion: posicion,
          brujula: brujula,
          almacen: AlmacenMemoria(), // el demo no toca tu progreso real
          personajes: personajes,
          centro: plazaPrincipal,
          random: math.Random(),
        ),
        controlesDemo: _ControlesDemo(posicion: posicion, brujula: brujula),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD6E8), Color(0xFFFFF0F6), Color(0xFFFFE4F1)],
          ),
        ),
        child: SafeArea(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E8C).withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Text('🔔', style: TextStyle(fontSize: 64)),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Rally de la Independencia AR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8A1459),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              ' Atrapa a los personajes escondidos en Dolores Hidalgo ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFFC2185B)),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: const BorderSide(color: Color(0xFFF8BBD0), width: 2),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Usa el radar y el "frío o caliente" para encontrarlos. '
                  'Acércate a menos de 15 m y responde su pregunta para atraparlos.',
                  style: TextStyle(color: Color(0xFF6A1B4D), height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: const Color(0xFFFFF3C4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Mira a tu alrededor, cuida tu paso y no cruces la calle viendo el teléfono.',
                  style: TextStyle(color: Color(0xFF7A5B00)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => _jugarReal(context),
              icon: const Icon(Icons.explore),
              label: const Text('Jugar en Dolores Hidalgo (GPS real)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _jugarDemo(context),
              icon: const Icon(Icons.school),
              label: const Text('Modo demo (salón de clases)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute<void>(
                builder: (_) => PantallaColeccion(almacen: AlmacenPrefs(), personajes: personajes),
              )),
              icon: const Icon(Icons.collections_bookmark),
              label: const Text('Mi álbum'),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Deslizador para girar y botones para "caminar" en el salón.
class _ControlesDemo extends StatefulWidget {
  final PosicionSimulada posicion;
  final BrujulaSimulada brujula;
  const _ControlesDemo({required this.posicion, required this.brujula});

  @override
  State<_ControlesDemo> createState() => _ControlesDemoState();
}

class _ControlesDemoState extends State<_ControlesDemo> {
  double _grados = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF48FB1), width: 2),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          const Text('Gira', style: TextStyle(color: Color(0xFF8A1459), fontWeight: FontWeight.bold)),
          Expanded(
            child: Slider(
              min: 0,
              max: 359,
              value: _grados,
              activeColor: const Color(0xFFE91E8C),
              inactiveColor: const Color(0xFFF8BBD0),
              onChanged: (g) {
                setState(() => _grados = g);
                widget.brujula.girar(g);
              },
            ),
          ),
          Text('${_grados.round()}°', style: const TextStyle(color: Color(0xFF8A1459))),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          OutlinedButton(
            onPressed: () => widget.posicion.avanzar(_grados, -10),
            child: const Text('⬇️ 10 m'),
          ),
          FilledButton(
            onPressed: () => widget.posicion.avanzar(_grados, 10),
            child: const Text('⬆️ Avanzar 10 m'),
          ),
          OutlinedButton(
            onPressed: () => widget.posicion.avanzar(_grados, 2),
            child: const Text('+2 m'),
          ),
        ]),
      ]),
    );
  }
}

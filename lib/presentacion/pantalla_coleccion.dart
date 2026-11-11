import 'package:flutter/material.dart';
import '../dominio/almacen.dart';
import '../dominio/personaje.dart';

/// Álbum: muestra los personajes atrapados y deja en "?" los pendientes.
class PantallaColeccion extends StatelessWidget {
  final AlmacenColeccion almacen;
  final List<Personaje> personajes;
  const PantallaColeccion({super.key, required this.almacen, required this.personajes});

  Future<(Set<String>, int)> _cargar() async =>
      (await almacen.cargarCapturados(), await almacen.cargarMejorPuntaje());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💖 Mi álbum')),
      body: FutureBuilder<(Set<String>, int)>(
        future: _cargar(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE91E8C)));
          }
          final (ids, mejor) = snap.data!;
          return Column(children: [
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF8BBD0), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('🏆 ${ids.length}/${personajes.length}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Color(0xFF8A1459), fontSize: 16)),
                  Text('⭐ Mejor puntaje: $mejor',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Color(0xFF8A1459), fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(14),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                children: [
                  for (final p in personajes)
                    _Carta(personaje: p, desbloqueado: ids.contains(p.id)),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _Carta extends StatelessWidget {
  final Personaje personaje;
  final bool desbloqueado;
  const _Carta({required this.personaje, required this.desbloqueado});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: desbloqueado
            ? () => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFFFFF0F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    title: Text('${personaje.emoji} ${personaje.nombre}',
                        style: const TextStyle(color: Color(0xFF8A1459))),
                    content: Text(personaje.bio),
                  ),
                )
            : null,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: desbloqueado
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFFFC1DC)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF3E5EC), Color(0xFFE8D5DF)],
                  ),
            border: Border.all(
              color: desbloqueado ? const Color(0xFFE91E8C) : const Color(0xFFD7BCC9),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(desbloqueado ? personaje.emoji : '❓', style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 6),
              Text(
                desbloqueado ? personaje.nombre : 'Por descubrir',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: desbloqueado ? const Color(0xFF8A1459) : Colors.grey.shade600,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Mood {
  final String emoji;
  final String label;
  final Color color;
  final String description;

  const Mood({
    required this.emoji,
    required this.label,
    required this.color,
    required this.description,
  });
}

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  final List<Mood> moods = const [
    Mood(
      emoji: '😊',
      label: 'Feliz',
      color: Color(0xFFFFD700), // Dorado
      description: 'Me siento alegre y positivo',
    ),
    Mood(
      emoji: '😌',
      label: 'Tranquilo',
      color: Color(0xFF00A3FF), // Azul eléctrico
      description: 'Me siento en paz y relajado',
    ),
    Mood(
      emoji: '😔',
      label: 'Triste',
      color: Color(0xFF6C8EBF), // Azul claro
      description: 'Me siento bajo de ánimo',
    ),
    Mood(
      emoji: '😡',
      label: 'Enojado',
      color: Color(0xFFFF5252), // Rojo claro
      description: 'Me siento frustrado o irritado',
    ),
    Mood(
      emoji: '😰',
      label: 'Ansioso',
      color: Color(0xFF9C27B0), // Púrpura
      description: 'Me siento estresado o preocupado',
    ),
    Mood(
      emoji: '😴',
      label: 'Cansado',
      color: Color(0xFF607D8B), // Azul grisáceo
      description: 'Me siento agotado o sin energía',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1, // Hacemos las tarjetas más cuadradas
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 160, // Altura fija para cada elemento
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        return _MoodCard(mood: mood);
      },
    );
  }
}

class _MoodCard extends StatelessWidget {
  final Mood mood;

  const _MoodCard({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de meditación con el estado de ánimo seleccionado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Has seleccionado: ${mood.label}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                mood.color.withOpacity(0.15),
                const Color(0xFF1A2E4F).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: mood.color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: mood.color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mood.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mood.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                mood.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                mood.description,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

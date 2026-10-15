import 'package:flutter/material.dart';

import '../../game_scope.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GameScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final stats = controller.statistics;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: 'Rodadas concluídas',
                value: '${stats.totalRounds}',
              ),
              _StatCard(
                title: 'Vitórias',
                value:
                    '${stats.wins} (${stats.winPercentage.toStringAsFixed(1)}%)',
              ),
              _StatCard(
                title: 'Derrotas',
                value:
                    '${stats.losses} (${stats.lossPercentage.toStringAsFixed(1)}%)',
              ),
              _StatCard(title: 'Erros totais', value: '${stats.totalMistakes}'),
              _StatCard(title: 'Dicas usadas', value: '${stats.hintsUsed}'),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

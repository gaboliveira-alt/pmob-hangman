import 'package:flutter/material.dart';

import '../../domain/game/game_rules.dart';
import '../../game_scope.dart';
import '../labels/labels.dart';
import '../state/game_controller.dart';
import 'game_screen.dart';
import 'statistics_screen.dart';
import 'team_screen.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GameScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        actions: [
          IconButton(
            tooltip: 'Estatísticas',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const StatisticsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Equipe',
            icon: const Icon(Icons.groups),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const TeamScreen())),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          switch (controller.catalogStatus) {
            case CatalogStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CatalogStatus.error:
              return _ErrorView(
                message:
                    controller.errorMessage ?? 'Erro ao carregar os dados.',
                onRetry: controller.loadCatalog,
              );
            case CatalogStatus.ready:
              return _SelectionView(controller: controller);
          }
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            const Text('Não foi possível carregar os dados.'),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionView extends StatelessWidget {
  const _SelectionView({required this.controller});

  final GameController controller;

  Future<void> _start(BuildContext context) async {
    final category = controller.selectedCategory;
    final difficulty = controller.selectedDifficulty;
    if (category == null || difficulty == null) return;

    final result = controller.startRound(
      category: category,
      difficulty: difficulty,
    );
    if (!context.mounted) return;

    if (result == StartRoundResult.exhausted) {
      final started = await showExhaustedDialog(context, controller);
      if (!context.mounted || !started) return;
    }

    await Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCategory = controller.selectedCategory;
    final selectedDifficulty = controller.selectedDifficulty;
    final difficulties = selectedCategory == null
        ? const []
        : controller.difficultiesFor(selectedCategory);
    final canStart = selectedCategory != null && selectedDifficulty != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categoria', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in controller.categories)
                ChoiceChip(
                  label: Text(category.label),
                  selected: category == selectedCategory,
                  onSelected: (_) => controller.selectCategory(category),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Dificuldade', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final difficulty in difficulties)
                ChoiceChip(
                  label: Text(difficulty.label),
                  selected: difficulty == selectedDifficulty,
                  onSelected: (_) => controller.selectDifficulty(difficulty),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seleção atual', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Categoria: ${selectedCategory?.label ?? '—'}'),
                  Text('Dificuldade: ${selectedDifficulty?.label ?? '—'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canStart ? () => _start(context) : null,
              child: const Text('Iniciar'),
            ),
          ),
        ],
      ),
    );
  }
}

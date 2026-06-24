import 'package:flutter/material.dart';

import '../../../common/widgets/responsive_layout.dart';
import '../../people/data/people_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _InsightsDashboard(padding: 16),
      tablet: _InsightsDashboard(padding: 24),
      desktop: _InsightsDashboard(padding: 32),
    );
  }
}

class _InsightsDashboard extends StatelessWidget {
  final double padding;

  const _InsightsDashboard({required this.padding});

  @override
  Widget build(BuildContext context) {
    final showAppBar = !ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('Insights')) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - (padding * 2);
          final columns = availableWidth >= 1100
              ? 3
              : availableWidth >= 680
              ? 2
              : 1;
          final spacing = columns == 1 ? 0.0 : 16.0;
          final cardWidth =
              (availableWidth - (spacing * (columns - 1))) / columns;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food insights',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Patterns and likely next choices based on each person\'s '
                  'preferences, likes, and dislikes.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: spacing,
                  runSpacing: 16,
                  children: peopleProfiles
                      .map(
                        (person) => SizedBox(
                          width: cardWidth,
                          child: _PersonInsightCard(person: person),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PersonInsightCard extends StatelessWidget {
  final PersonProfile person;

  const _PersonInsightCard({required this.person});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(person.icon)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(person.summary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _InsightSection(
              icon: Icons.insights,
              label: 'Pattern',
              text: person.pattern,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _InsightSection(
                icon: Icons.auto_awesome,
                label: 'Prediction',
                text: person.prediction,
                iconColor: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 18),
            Text('Preferences', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: person.preferences
                  .map((item) => Chip(label: Text(item)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _PreferenceLine(
              icon: Icons.thumb_up_outlined,
              label: 'Likes',
              values: person.likes,
              color: colors.primary,
            ),
            const SizedBox(height: 10),
            _PreferenceLine(
              icon: Icons.block,
              label: 'Avoids',
              values: person.dislikes,
              color: colors.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final Color? iconColor;

  const _InsightSection({
    required this.icon,
    required this.label,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 3),
              Text(text),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> values;
  final Color color;

  const _PreferenceLine({
    required this.icon,
    required this.label,
    required this.values,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: ${values.join(', ')}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

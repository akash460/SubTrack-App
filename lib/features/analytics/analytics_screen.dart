import 'package:material_ui/material_ui.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Projected yearly spend card
          Card(
            color: colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Annual Forecast',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$587.64',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on your current subscriptions',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Spending Breakdown Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending by Category',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CategoryRow(
                    label: 'Entertainment',
                    amount: '\$27.48',
                    percentage: '56%',
                    color: Colors.purple,
                  ),
                  const Divider(height: 24),
                  _CategoryRow(
                    label: 'Productivity & Cloud',
                    amount: '\$9.99',
                    percentage: '20%',
                    color: Colors.blue,
                  ),
                  const Divider(height: 24),
                  _CategoryRow(
                    label: 'Fitness & Health',
                    amount: '\$11.50',
                    percentage: '24%',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Insights placeholder
          Card(
            child: ListTile(
              leading: Icon(Icons.tips_and_updates_outlined, color: colorScheme.primary),
              title: const Text('Smart Savings Tip'),
              subtitle: const Text(
                'Switching Netflix to an annual plan could save you up to 15% annually.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String amount;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          percentage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amount,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

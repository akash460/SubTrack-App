import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class SubscriptionDetailScreen extends StatelessWidget {
  const SubscriptionDetailScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Subscription',
            onPressed: () => context.push('/subscriptions/$id/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Main Subscription Header Card
          Card(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.subscriptions_outlined,
                      size: 32,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    id.toUpperCase().replaceAll('-', ' '),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      'ID: $id',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    backgroundColor: colorScheme.surface,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$15.49 / month',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detail specs
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text('Next Renewal Date'),
                  subtitle: Text('November 24, 2026'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text('Category'),
                  subtitle: Text('Entertainment & Streaming'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text('Payment Method'),
                  subtitle: Text('Mastercard ending in 4242'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Reminder'),
                  subtitle: Text('2 days prior'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Edit & Back buttons
          FilledButton.icon(
            onPressed: () => context.push('/subscriptions/$id/edit'),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Subscription'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Back to Subscriptions'),
          ),
        ],
      ),
    );
  }
}

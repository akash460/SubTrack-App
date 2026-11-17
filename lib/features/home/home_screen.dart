import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SubTrack'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Total Monthly Spend Summary Card
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Monthly Spend',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$48.97',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '4 active subscriptions',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Subscriptions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/subscriptions/add'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Sample Subscription Cards with navigation to details
          _SubscriptionListTile(
            id: 'sub-netflix',
            name: 'Netflix Standard',
            amount: '\$15.49 / mo',
            renewalDate: 'Renews Nov 24, 2026',
            icon: Icons.movie_outlined,
            iconBackgroundColor: Colors.red.shade100,
            iconColor: Colors.red.shade800,
          ),
          _SubscriptionListTile(
            id: 'sub-spotify',
            name: 'Spotify Premium',
            amount: '\$11.99 / mo',
            renewalDate: 'Renews Dec 02, 2026',
            icon: Icons.music_note_outlined,
            iconBackgroundColor: Colors.green.shade100,
            iconColor: Colors.green.shade800,
          ),
          _SubscriptionListTile(
            id: 'sub-cloud',
            name: 'Google One 2TB',
            amount: '\$9.99 / mo',
            renewalDate: 'Renews Dec 15, 2026',
            icon: Icons.cloud_outlined,
            iconBackgroundColor: Colors.blue.shade100,
            iconColor: Colors.blue.shade800,
          ),
          _SubscriptionListTile(
            id: 'sub-gym',
            name: 'Gym Membership',
            amount: '\$11.50 / mo',
            renewalDate: 'Renews Dec 20, 2026',
            icon: Icons.fitness_center_outlined,
            iconBackgroundColor: Colors.orange.shade100,
            iconColor: Colors.orange.shade800,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/subscriptions/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Subscription'),
      ),
    );
  }
}

class _SubscriptionListTile extends StatelessWidget {
  const _SubscriptionListTile({
    required this.id,
    required this.name,
    required this.amount,
    required this.renewalDate,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  final String id;
  final String name;
  final String amount;
  final String renewalDate;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: iconBackgroundColor,
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          renewalDate,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
        onTap: () => context.push('/subscriptions/$id'),
      ),
    );
  }
}

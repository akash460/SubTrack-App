import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Subscription Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Subscription Name',
                      hintText: 'e.g. Netflix, Spotify, iCloud',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Cost',
                      hintText: 'e.g. 14.99',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Billing Cycle',
                      hintText: 'Monthly / Yearly / Weekly',
                      prefixIcon: Icon(Icons.repeat),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'First Payment / Renewal Date',
                      hintText: 'Select date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Subscription added (Placeholder)'),
                        ),
                      );
                      context.pop();
                    },
                    child: const Text('Save Subscription'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class EditSubscriptionScreen extends StatelessWidget {
  const EditSubscriptionScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Subscription'),
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
                  Row(
                    children: [
                      const Icon(Icons.edit_note, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Editing: $id',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: id.replaceAll('-', ' ').toUpperCase(),
                    decoration: const InputDecoration(
                      labelText: 'Subscription Name',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '15.49',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Cost',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: 'Monthly',
                    decoration: const InputDecoration(
                      labelText: 'Billing Cycle',
                      prefixIcon: Icon(Icons.repeat),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Subscription $id updated (Placeholder)'),
                        ),
                      );
                      context.pop();
                    },
                    child: const Text('Save Changes'),
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

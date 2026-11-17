import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subtrack/data/local/app_database.dart';

/// Riverpod provider exposing the singleton [AppDatabase] instance.
///
/// Disposes the underlying database connection when the provider scope is destroyed.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Alias for [databaseProvider] for semantic flexibility.
final appDatabaseProvider = databaseProvider;

/// Provider exposing [SubscriptionsDao].
final subscriptionsDaoProvider = Provider<SubscriptionsDao>((ref) {
  return ref.watch(databaseProvider).subscriptionsDao;
});

/// Provider exposing [CategoriesDao].
final categoriesDaoProvider = Provider<CategoriesDao>((ref) {
  return ref.watch(databaseProvider).categoriesDao;
});

/// Reactive stream provider for active (non-deleted) subscriptions.
final activeSubscriptionsProvider = StreamProvider<List<Subscription>>((ref) {
  return ref.watch(subscriptionsDaoProvider).watchActiveSubscriptions();
});

/// Reactive stream provider for all seeded and user categories.
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoriesDaoProvider).watchCategories();
});

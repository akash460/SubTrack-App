import 'package:drift/drift.dart';
import 'package:subtrack/data/local/app_database.dart';

part 'subscriptions_dao.g.dart';

@DriftAccessor(tables: [Subscriptions, Categories])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  /// Watches active (non-soft-deleted) subscriptions, ordered by upcoming billing date.
  Stream<List<Subscription>> watchActiveSubscriptions() {
    return (select(subscriptions)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.nextBillingDate,
                  mode: OrderingMode.asc,
                ),
          ]))
        .watch();
  }

  /// Watches all subscriptions including soft-deleted ones.
  Stream<List<Subscription>> watchAllSubscriptions() {
    return (select(subscriptions)
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.nextBillingDate,
                  mode: OrderingMode.asc,
                ),
          ]))
        .watch();
  }

  /// Fetches a single subscription by its UUID [id].
  Future<Subscription?> getById(String id) {
    return (select(subscriptions)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts a new subscription.
  Future<int> insert(Insertable<Subscription> subscription) {
    return into(subscriptions).insert(subscription);
  }

  /// Descriptive alias for [insert].
  Future<int> insertSubscription(Insertable<Subscription> subscription) =>
      insert(subscription);

  /// Updates an existing subscription.
  ///
  /// Named [updateSubscription] because [update] is reserved by Drift's
  /// internal [DatabaseConnectionUser.update] query builder DSL.
  Future<bool> updateSubscription(Insertable<Subscription> subscription) {
    return update(subscriptions).replace(subscription);
  }

  /// Soft-deletes a subscription by updating [deletedAt] and [updatedAt].
  Future<int> softDelete(String id) {
    final now = DateTime.now();
    return (update(subscriptions)..where((tbl) => tbl.id.equals(id))).write(
      SubscriptionsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Restores a soft-deleted subscription.
  Future<int> restore(String id) {
    return (update(subscriptions)..where((tbl) => tbl.id.equals(id))).write(
      SubscriptionsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Permanently removes a subscription record from SQLite.
  Future<int> hardDelete(String id) {
    return (delete(subscriptions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Watches all categories.
  Stream<List<Category>> watchCategories() {
    return (select(categories)..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }
}

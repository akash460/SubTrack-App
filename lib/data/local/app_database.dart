import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:subtrack/data/local/daos/categories_dao.dart';
import 'package:subtrack/data/local/daos/subscriptions_dao.dart';
import 'package:subtrack/data/local/tables/categories_table.dart';
import 'package:subtrack/data/local/tables/subscriptions_table.dart';

export 'package:drift/drift.dart' show Value;
export 'tables/categories_table.dart';
export 'tables/subscriptions_table.dart';
export 'daos/categories_dao.dart';
export 'daos/subscriptions_dao.dart';

part 'app_database.g.dart';

/// The central Drift database managing [Subscriptions] and [Categories].
@DriftDatabase(
  tables: [Subscriptions, Categories],
  daos: [SubscriptionsDao, CategoriesDao],
)
class AppDatabase extends _$AppDatabase {
  /// Instantiates [AppDatabase].
  ///
  /// Uses [driftDatabase] to provide an optimized SQLite connection on each platform
  /// (or accepts an explicit [executor], such as an in-memory database for tests).
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'subtrack_database'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Seed default categories on initial database creation
        await batch((b) {
          b.insertAll(categories, initialCategories);
        });
      },
      beforeOpen: (details) async {
        // Enforce SQLite foreign key constraints
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Default categories to seed when the database is created.
  static final List<CategoriesCompanion> initialCategories = [
    const CategoriesCompanion(
      id: Value('entertainment'),
      name: Value('Entertainment'),
      iconCode: Value(0xe40d), // Icons.movie.codePoint
      colorHex: Value('#8B5CF6'),
    ),
    const CategoriesCompanion(
      id: Value('music'),
      name: Value('Music'),
      iconCode: Value(0xe415), // Icons.music_note.codePoint
      colorHex: Value('#EC4899'),
    ),
    const CategoriesCompanion(
      id: Value('utilities'),
      name: Value('Utilities'),
      iconCode: Value(0xe37c), // Icons.lightbulb_outline.codePoint
      colorHex: Value('#F59E0B'),
    ),
    const CategoriesCompanion(
      id: Value('education'),
      name: Value('Education'),
      iconCode: Value(0xe559), // Icons.school.codePoint
      colorHex: Value('#3B82F6'),
    ),
    const CategoriesCompanion(
      id: Value('fitness'),
      name: Value('Fitness'),
      iconCode: Value(0xe28d), // Icons.fitness_center.codePoint
      colorHex: Value('#10B981'),
    ),
    const CategoriesCompanion(
      id: Value('finance_emi'),
      name: Value('Finance/EMI'),
      iconCode: Value(0xe041), // Icons.account_balance_wallet.codePoint
      colorHex: Value('#0F766E'),
    ),
    const CategoriesCompanion(
      id: Value('shopping'),
      name: Value('Shopping'),
      iconCode: Value(0xe59a), // Icons.shopping_bag.codePoint
      colorHex: Value('#F97316'),
    ),
    const CategoriesCompanion(
      id: Value('other'),
      name: Value('Other'),
      iconCode: Value(0xe148), // Icons.category.codePoint
      colorHex: Value('#64748B'),
    ),
  ];

  // Convenience delegates on database matching DAO requirements
  Stream<List<Subscription>> watchActiveSubscriptions() =>
      subscriptionsDao.watchActiveSubscriptions();

  Future<Subscription?> getSubscriptionById(String id) =>
      subscriptionsDao.getById(id);

  Future<int> insertSubscription(Insertable<Subscription> subscription) =>
      subscriptionsDao.insert(subscription);

  Future<bool> updateSubscription(Insertable<Subscription> subscription) =>
      subscriptionsDao.updateSubscription(subscription);

  Future<int> softDeleteSubscription(String id) =>
      subscriptionsDao.softDelete(id);

  Stream<List<Category>> watchCategories() =>
      categoriesDao.watchCategories();
}

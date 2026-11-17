import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/data/local/app_database.dart';
import 'package:subtrack/data/local/database_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase & Seeds', () {
    test('seeds the 8 required categories on database creation', () async {
      final categories = await db.categoriesDao.getAllCategories();
      expect(categories.length, 8);

      final categoryNames = categories.map((c) => c.name).toSet();
      expect(
        categoryNames,
        containsAll([
          'Entertainment',
          'Music',
          'Utilities',
          'Education',
          'Fitness',
          'Finance/EMI',
          'Shopping',
          'Other',
        ]),
      );
    });

    test('watchCategories emits the seeded categories', () async {
      final categoriesStream = db.watchCategories();
      final categories = await categoriesStream.first;
      expect(categories.length, 8);
    });
  });

  group('SubscriptionsDao CRUD', () {
    test('insert, getById, watchActiveSubscriptions, update, and softDelete', () async {
      final now = DateTime.now();
      final nextBilling = now.add(const Duration(days: 30));

      const subId = 'sub-uuid-1';
      final companion = SubscriptionsCompanion.insert(
        id: subId,
        name: 'Netflix',
        amountPaise: 64900,
        billingCycle: 'monthly',
        nextBillingDate: nextBilling,
        categoryId: 'entertainment',
        colorHex: '#E50914',
        notes: const Value('4K Premium Ultra HD'),
      );

      // 1. Insert
      await db.subscriptionsDao.insert(companion);

      // 2. getById
      final fetched = await db.subscriptionsDao.getById(subId);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Netflix');
      expect(fetched.amountPaise, 64900);
      expect(fetched.currency, 'INR'); // default value
      expect(fetched.reminderDaysBefore, 2); // default value
      expect(fetched.isPaused, isFalse); // default value
      expect(fetched.notes, '4K Premium Ultra HD');
      expect(fetched.deletedAt, isNull);

      // 3. watchActiveSubscriptions
      var activeSubs = await db.subscriptionsDao.watchActiveSubscriptions().first;
      expect(activeSubs.length, 1);
      expect(activeSubs.first.id, subId);

      // 4. Update
      final updatedCompanion = companion.copyWith(
        amountPaise: const Value(79900),
        notes: const Value('Price updated to 799'),
      );
      final updated = await db.subscriptionsDao.updateSubscription(updatedCompanion);
      expect(updated, isTrue);

      final afterUpdate = await db.subscriptionsDao.getById(subId);
      expect(afterUpdate!.amountPaise, 79900);
      expect(afterUpdate.notes, 'Price updated to 799');

      // 5. Soft Delete
      await db.subscriptionsDao.softDelete(subId);

      final afterDelete = await db.subscriptionsDao.getById(subId);
      expect(afterDelete!.deletedAt, isNotNull);

      // Active subscriptions stream should now be empty (excludes soft-deleted)
      activeSubs = await db.subscriptionsDao.watchActiveSubscriptions().first;
      expect(activeSubs, isEmpty);
    });
  });

  group('Riverpod Database Providers', () {
    test('databaseProvider exposes database and DAOs', () {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(container.dispose);

      final injectedDb = container.read(databaseProvider);
      expect(injectedDb, same(db));

      final subDao = container.read(subscriptionsDaoProvider);
      expect(subDao, same(db.subscriptionsDao));

      final catDao = container.read(categoriesDaoProvider);
      expect(catDao, same(db.categoriesDao));
    });
  });
}

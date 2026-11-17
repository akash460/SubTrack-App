// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_dao.dart';

// ignore_for_file: type=lint
mixin _$SubscriptionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $SubscriptionsTable get subscriptions => attachedDatabase.subscriptions;
  SubscriptionsDaoManager get managers => SubscriptionsDaoManager(this);
}

class SubscriptionsDaoManager {
  final _$SubscriptionsDaoMixin _db;
  SubscriptionsDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db.attachedDatabase, _db.subscriptions);
}

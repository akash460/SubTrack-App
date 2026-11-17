import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/data/local/app_database.dart' as db;
import 'package:subtrack/models/billing_cycle.dart';
import 'package:subtrack/models/subscription.dart';

void main() {
  group('BillingCycle enum', () {
    test('fromString parses valid cycle strings regardless of case and whitespace', () {
      expect(BillingCycle.fromString('weekly'), BillingCycle.weekly);
      expect(BillingCycle.fromString('MONTHLY'), BillingCycle.monthly);
      expect(BillingCycle.fromString(' Quarterly '), BillingCycle.quarterly);
      expect(BillingCycle.fromString('yearly'), BillingCycle.yearly);
    });

    test('fromString throws ArgumentError for unknown string', () {
      expect(() => BillingCycle.fromString('bi-weekly'), throwsArgumentError);
      expect(() => BillingCycle.fromString('daily'), throwsArgumentError);
      expect(() => BillingCycle.fromString(''), throwsArgumentError);
    });

    test('tryParse safely parses or returns null', () {
      expect(BillingCycle.tryParse('monthly'), BillingCycle.monthly);
      expect(BillingCycle.tryParse('invalid'), isNull);
      expect(BillingCycle.tryParse(null), isNull);
    });

    test('displayName returns user-friendly label', () {
      expect(BillingCycle.weekly.displayName, 'Weekly');
      expect(BillingCycle.monthly.displayName, 'Monthly');
      expect(BillingCycle.quarterly.displayName, 'Quarterly');
      expect(BillingCycle.yearly.displayName, 'Yearly');
    });

    test('toJson returns string representation matching JSON enum mapping', () {
      expect(BillingCycle.weekly.toJson(), 'weekly');
      expect(BillingCycle.monthly.toJson(), 'monthly');
      expect(BillingCycle.quarterly.toJson(), 'quarterly');
      expect(BillingCycle.yearly.toJson(), 'yearly');
    });
  });

  group('Subscription Freezed model', () {
    final now = DateTime(2026, 1, 1, 10, 0);
    final nextBilling = DateTime(2026, 2, 1, 10, 0);

    final sub = Subscription(
      id: 'sub-101',
      name: 'Netflix Premium',
      amountPaise: 64900,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: nextBilling,
      categoryId: 'entertainment',
      colorHex: '#E50914',
      notes: '4K family account',
      createdAt: now,
      updatedAt: now,
    );

    test('default fields applied correctly', () {
      expect(sub.currency, 'INR');
      expect(sub.reminderDaysBefore, 2);
      expect(sub.isPaused, isFalse);
      expect(sub.deletedAt, isNull);
      expect(sub.isActive, isTrue);
      expect(sub.isDeleted, isFalse);
    });

    test('copyWith works as expected', () {
      final updated = sub.copyWith(
        amountPaise: 79900,
        notes: 'Price revised',
        isPaused: true,
      );
      expect(updated.id, sub.id);
      expect(updated.amountPaise, 79900);
      expect(updated.notes, 'Price revised');
      expect(updated.isPaused, isTrue);
      expect(updated.isActive, isFalse); // because paused
    });

    test('equality and hashCode work via Freezed', () {
      final sub2 = Subscription(
        id: 'sub-101',
        name: 'Netflix Premium',
        amountPaise: 64900,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: nextBilling,
        categoryId: 'entertainment',
        colorHex: '#E50914',
        notes: '4K family account',
        createdAt: now,
        updatedAt: now,
      );
      expect(sub, equals(sub2));
      expect(sub.hashCode, equals(sub2.hashCode));
    });

    test('JSON serialization round-trip', () {
      final json = sub.toJson();
      expect(json['id'], 'sub-101');
      expect(json['name'], 'Netflix Premium');
      expect(json['amountPaise'], 64900);
      expect(json['billingCycle'], 'monthly');
      expect(json['currency'], 'INR');

      final deserialized = Subscription.fromJson(json);
      expect(deserialized, equals(sub));
    });
  });

  group('Drift Mappers', () {
    final now = DateTime(2026, 1, 1);
    final nextBilling = DateTime(2026, 2, 1);

    final driftRow = db.Subscription(
      id: 'drift-row-1',
      name: 'Spotify Family',
      amountPaise: 17900,
      currency: 'INR',
      billingCycle: 'monthly',
      nextBillingDate: nextBilling,
      categoryId: 'music',
      reminderDaysBefore: 3,
      colorHex: '#1DB954',
      notes: '6 accounts',
      isPaused: false,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
    );

    test('Subscription.fromDrift maps all row fields to domain model', () {
      final domain = Subscription.fromDrift(driftRow);
      expect(domain.id, driftRow.id);
      expect(domain.name, driftRow.name);
      expect(domain.amountPaise, 17900);
      expect(domain.currency, 'INR');
      expect(domain.billingCycle, BillingCycle.monthly);
      expect(domain.nextBillingDate, nextBilling);
      expect(domain.categoryId, 'music');
      expect(domain.reminderDaysBefore, 3);
      expect(domain.colorHex, '#1DB954');
      expect(domain.notes, '6 accounts');
      expect(domain.isPaused, isFalse);
      expect(domain.createdAt, now);
      expect(domain.updatedAt, now);
      expect(domain.deletedAt, isNull);
    });

    test('db.Subscription.toDomain extension works identically', () {
      final domain = driftRow.toDomain();
      expect(domain.id, driftRow.id);
      expect(domain.billingCycle, BillingCycle.monthly);
    });

    test('toCompanion maps domain model to Drift SubscriptionsCompanion', () {
      final domain = Subscription.fromDrift(driftRow);
      final companion = domain.toCompanion();

      expect(companion.id.value, domain.id);
      expect(companion.name.value, domain.name);
      expect(companion.amountPaise.value, 17900);
      expect(companion.currency.value, 'INR');
      expect(companion.billingCycle.value, 'monthly');
      expect(companion.nextBillingDate.value, nextBilling);
      expect(companion.categoryId.value, 'music');
      expect(companion.reminderDaysBefore.value, 3);
      expect(companion.colorHex.value, '#1DB954');
      expect(companion.notes.value, '6 accounts');
      expect(companion.isPaused.value, false);
      expect(companion.createdAt.value, now);
      expect(companion.updatedAt.value, now);
      expect(companion.deletedAt.value, isNull);
    });

    test('toDriftRow and toDrift map back to Drift data class', () {
      final domain = Subscription.fromDrift(driftRow);
      final mappedDrift = domain.toDriftRow();

      expect(mappedDrift.id, domain.id);
      expect(mappedDrift.name, domain.name);
      expect(mappedDrift.amountPaise, domain.amountPaise);
      expect(mappedDrift.billingCycle, 'monthly');
      expect(domain.toDrift().id, domain.id);
    });

    test('Round-trip fidelity between Drift row and Domain model', () {
      final domain = driftRow.toDomain();
      final backToDrift = domain.toDriftRow();

      expect(backToDrift.id, driftRow.id);
      expect(backToDrift.name, driftRow.name);
      expect(backToDrift.amountPaise, driftRow.amountPaise);
      expect(backToDrift.currency, driftRow.currency);
      expect(backToDrift.billingCycle, driftRow.billingCycle);
      expect(backToDrift.nextBillingDate, driftRow.nextBillingDate);
      expect(backToDrift.categoryId, driftRow.categoryId);
      expect(backToDrift.reminderDaysBefore, driftRow.reminderDaysBefore);
      expect(backToDrift.colorHex, driftRow.colorHex);
      expect(backToDrift.notes, driftRow.notes);
      expect(backToDrift.isPaused, driftRow.isPaused);
      expect(backToDrift.createdAt, driftRow.createdAt);
      expect(backToDrift.updatedAt, driftRow.updatedAt);
      expect(backToDrift.deletedAt, driftRow.deletedAt);
    });
  });
}

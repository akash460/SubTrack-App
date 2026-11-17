import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:subtrack/data/local/app_database.dart' as db;
import 'package:subtrack/models/billing_cycle.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

/// Immutable domain model representing a Subscription.
@freezed
abstract class Subscription with _$Subscription {
  const Subscription._();

  const factory Subscription({
    required String id,
    required String name,
    required int amountPaise,
    @Default('INR') String currency,
    required BillingCycle billingCycle,
    required DateTime nextBillingDate,
    required String categoryId,
    @Default(2) int reminderDaysBefore,
    required String colorHex,
    String? notes,
    @Default(false) bool isPaused,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Subscription;

  /// Creates a [Subscription] from a JSON map.
  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  /// Factory constructor to map a Drift database [row] to the domain [Subscription] model.
  factory Subscription.fromDrift(db.Subscription row) {
    return Subscription(
      id: row.id,
      name: row.name,
      amountPaise: row.amountPaise,
      currency: row.currency,
      billingCycle: BillingCycle.fromString(row.billingCycle),
      nextBillingDate: row.nextBillingDate,
      categoryId: row.categoryId,
      reminderDaysBefore: row.reminderDaysBefore,
      colorHex: row.colorHex,
      notes: row.notes,
      isPaused: row.isPaused,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  /// Converts this domain model into a Drift companion for inserts and updates.
  db.SubscriptionsCompanion toCompanion() {
    return db.SubscriptionsCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      amountPaise: drift.Value(amountPaise),
      currency: drift.Value(currency),
      billingCycle: drift.Value(billingCycle.name),
      nextBillingDate: drift.Value(nextBillingDate),
      categoryId: drift.Value(categoryId),
      reminderDaysBefore: drift.Value(reminderDaysBefore),
      colorHex: drift.Value(colorHex),
      notes: drift.Value(notes),
      isPaused: drift.Value(isPaused),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
      deletedAt: drift.Value(deletedAt),
    );
  }

  /// Converts this domain model into a Drift [db.Subscription] data row.
  db.Subscription toDriftRow() {
    return db.Subscription(
      id: id,
      name: name,
      amountPaise: amountPaise,
      currency: currency,
      billingCycle: billingCycle.name,
      nextBillingDate: nextBillingDate,
      categoryId: categoryId,
      reminderDaysBefore: reminderDaysBefore,
      colorHex: colorHex,
      notes: notes,
      isPaused: isPaused,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Whether this subscription has been soft-deleted.
  bool get isDeleted => deletedAt != null;

  /// Whether this subscription is currently active (not paused and not deleted).
  bool get isActive => !isPaused && deletedAt == null;
}

/// Extension mapping a Drift [db.Subscription] row to domain [Subscription].
extension SubscriptionDriftRowX on db.Subscription {
  Subscription toDomain() => Subscription.fromDrift(this);
}

/// Extension mapping domain [Subscription] to Drift types.
extension SubscriptionDomainX on Subscription {
  db.Subscription toDrift() => toDriftRow();
}

import 'package:drift/drift.dart';
import 'package:subtrack/data/local/tables/categories_table.dart';

/// Drift table definition for Subscriptions.
class Subscriptions extends Table {
  /// UUID primary key for the subscription
  TextColumn get id => text()();

  /// Name of the subscription service (e.g. 'Netflix', 'Spotify')
  TextColumn get name => text()();

  /// Subscription cost stored in paise (1 INR = 100 paise) to avoid floating point issues
  IntColumn get amountPaise => integer()();

  /// Currency code, defaults to 'INR'
  TextColumn get currency => text().withDefault(const Constant('INR'))();

  /// Billing cycle frequency: weekly, monthly, quarterly, yearly
  TextColumn get billingCycle => text()();

  /// Next renewal / billing date
  DateTimeColumn get nextBillingDate => dateTime()();

  /// Foreign key referencing [Categories.id]
  TextColumn get categoryId => text().references(Categories, #id)();

  /// Number of days before the billing date to send a reminder, defaults to 2
  IntColumn get reminderDaysBefore => integer().withDefault(const Constant(2))();

  /// Hex color code for branding/customization (e.g. '#E50914')
  TextColumn get colorHex => text()();

  /// Optional notes or comments on the subscription
  TextColumn get notes => text().nullable()();

  /// Whether the subscription is temporarily paused, defaults to false
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();

  /// Timestamp when the subscription was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the subscription was last modified
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Soft deletion timestamp; null if active
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

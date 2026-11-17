import 'package:drift/drift.dart';

/// Drift table definition for subscription categories.
class Categories extends Table {
  /// Unique category identifier (e.g. 'entertainment', 'utilities')
  TextColumn get id => text()();

  /// Human-readable category name
  TextColumn get name => text()();

  /// Material icon code point (e.g. 0xe40d for Icons.movie)
  IntColumn get iconCode => integer()();

  /// Hex color code representing the category (e.g. '#8B5CF6')
  TextColumn get colorHex => text()();

  @override
  Set<Column> get primaryKey => {id};
}

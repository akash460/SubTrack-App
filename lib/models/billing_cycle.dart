import 'package:json_annotation/json_annotation.dart';

part 'billing_cycle.g.dart';

/// Supported recurring billing cycle frequencies.
@JsonEnum(alwaysCreate: true)
enum BillingCycle {
  @JsonValue('weekly')
  weekly,

  @JsonValue('monthly')
  monthly,

  @JsonValue('quarterly')
  quarterly,

  @JsonValue('yearly')
  yearly;

  /// User-friendly label for display.
  String get displayName {
    switch (this) {
      case BillingCycle.weekly:
        return 'Weekly';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.quarterly:
        return 'Quarterly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }

  /// Converts this [BillingCycle] to its JSON string representation.
  String toJson() => _$BillingCycleEnumMap[this]!;

  /// Parses a string representation (e.g. 'weekly', 'monthly') into [BillingCycle].
  ///
  /// Throws [ArgumentError] if the string does not match any valid cycle.
  static BillingCycle fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'weekly':
        return BillingCycle.weekly;
      case 'monthly':
        return BillingCycle.monthly;
      case 'quarterly':
        return BillingCycle.quarterly;
      case 'yearly':
        return BillingCycle.yearly;
      default:
        throw ArgumentError('Invalid billing cycle: $value');
    }
  }

  /// Tries to parse a string into [BillingCycle], returning `null` if invalid.
  static BillingCycle? tryParse(String? value) {
    if (value == null) return null;
    try {
      return fromString(value);
    } catch (_) {
      return null;
    }
  }
}

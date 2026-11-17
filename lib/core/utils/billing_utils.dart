import 'package:subtrack/models/billing_cycle.dart';
import 'package:subtrack/models/subscription.dart';

/// Calculates the normalized monthly cost in paise for a given [subscription].
///
/// Conversion rules:
/// - weekly: `amountPaise * 52 / 12`
/// - monthly: `amountPaise * 1`
/// - quarterly: `amountPaise / 3`
/// - yearly: `amountPaise / 12`
int monthlyCostPaise(Subscription subscription) {
  return calculateMonthlyCostPaise(
    amountPaise: subscription.amountPaise,
    cycle: subscription.billingCycle,
  );
}

/// Pure calculation of monthly cost in paise given [amountPaise] and [cycle].
int calculateMonthlyCostPaise({
  required int amountPaise,
  required BillingCycle cycle,
}) {
  switch (cycle) {
    case BillingCycle.weekly:
      return ((amountPaise * 52) / 12).round();
    case BillingCycle.monthly:
      return amountPaise;
    case BillingCycle.quarterly:
      return (amountPaise / 3).round();
    case BillingCycle.yearly:
      return (amountPaise / 12).round();
  }
}

/// Calculates the normalized yearly cost in paise for a given [subscription].
///
/// Conversion rules:
/// - weekly: `amountPaise * 52`
/// - monthly: `amountPaise * 12`
/// - quarterly: `amountPaise * 4`
/// - yearly: `amountPaise * 1`
int yearlyCostPaise(Subscription subscription) {
  return calculateYearlyCostPaise(
    amountPaise: subscription.amountPaise,
    cycle: subscription.billingCycle,
  );
}

/// Pure calculation of yearly cost in paise given [amountPaise] and [cycle].
int calculateYearlyCostPaise({
  required int amountPaise,
  required BillingCycle cycle,
}) {
  switch (cycle) {
    case BillingCycle.weekly:
      return amountPaise * 52;
    case BillingCycle.monthly:
      return amountPaise * 12;
    case BillingCycle.quarterly:
      return amountPaise * 4;
    case BillingCycle.yearly:
      return amountPaise;
  }
}

/// Determines whether a given [year] is a leap year in the Gregorian calendar.
bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

/// Returns the number of days in the specified [month] of [year].
int daysInMonth(int year, int month) {
  switch (month) {
    case 1: // January
    case 3: // March
    case 5: // May
    case 7: // July
    case 8: // August
    case 10: // October
    case 12: // December
      return 31;
    case 4: // April
    case 6: // June
    case 9: // September
    case 11: // November
      return 30;
    case 2: // February
      return isLeapYear(year) ? 29 : 28;
    default:
      throw ArgumentError.value(month, 'month', 'Month must be between 1 and 12');
  }
}

/// Adds [months] to [date], clamping the day to the last valid day of the target month.
///
/// For example:
/// - 31 Jan 2026 + 1 month = 28 Feb 2026
/// - 31 Jan 2024 + 1 month = 29 Feb 2024 (leap year)
/// - 31 Mar 2026 + 1 month = 30 Apr 2026
///
/// If [anchorDay] is provided, it is used as the preferred day before clamping.
/// This prevents day drift across multiple month additions (e.g. Jan 31 -> Feb 28 -> Mar 31).
DateTime addMonthsClamped(DateTime date, int months, {int? anchorDay}) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final targetYear = totalMonths ~/ 12;
  final targetMonth = (totalMonths % 12) + 1;
  final preferredDay = anchorDay ?? date.day;
  final maxDay = daysInMonth(targetYear, targetMonth);
  final clampedDay = preferredDay > maxDay ? maxDay : preferredDay;

  if (date.isUtc) {
    return DateTime.utc(
      targetYear,
      targetMonth,
      clampedDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  } else {
    return DateTime(
      targetYear,
      targetMonth,
      clampedDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}

/// Helper that advances [baseDate] by [count] intervals of [cycle].
DateTime addCycleInterval(
  DateTime baseDate,
  BillingCycle cycle,
  int count, {
  int? anchorDay,
}) {
  switch (cycle) {
    case BillingCycle.weekly:
      return baseDate.add(Duration(days: 7 * count));
    case BillingCycle.monthly:
      return addMonthsClamped(baseDate, count, anchorDay: anchorDay);
    case BillingCycle.quarterly:
      return addMonthsClamped(baseDate, 3 * count, anchorDay: anchorDay);
    case BillingCycle.yearly:
      return addMonthsClamped(baseDate, 12 * count, anchorDay: anchorDay);
  }
}

/// Computes the next billing date occurring strictly after [from],
/// following the recurring interval [cycle] starting from anchor [date].
///
/// If [from] is omitted or equal to [date], advances at least 1 cycle from [date].
/// When adding months, the day is clamped to the last valid day of the month
/// (e.g., 31 Jan + 1 month = 28 Feb or 29 Feb in leap years).
DateTime nextBillingDateAfter(
  DateTime date,
  BillingCycle cycle, [
  DateTime? from,
  int? anchorDay,
]) {
  final reference = from ?? date;
  final effectiveAnchorDay = anchorDay ?? date.day;

  // If date is already strictly after the reference, it is already the upcoming date.
  if (date.isAfter(reference)) {
    return date;
  }

  // Step forward until we find a date strictly after reference.
  int step = 1;
  while (true) {
    final candidate = addCycleInterval(
      date,
      cycle,
      step,
      anchorDay: effectiveAnchorDay,
    );
    if (candidate.isAfter(reference)) {
      return candidate;
    }
    step++;
  }
}

/// Rolls forward [nextBillingDate] across any missed cycles until it is in the future
/// relative to [now].
///
/// - If [nextBillingDate] is already strictly after [now], returns it unchanged.
/// - If [nextBillingDate] is on or before [now], steps forward by [cycle] intervals
///   until the resulting date is strictly after [now].
///
/// Month-end clamping is applied on each step while preserving the original day anchor
/// to prevent permanent day drift (e.g., Jan 31 -> Feb 28 -> Mar 31).
DateTime rollForward(
  DateTime nextBillingDate,
  BillingCycle cycle,
  DateTime now, {
  int? anchorDay,
}) {
  if (nextBillingDate.isAfter(now)) {
    return nextBillingDate;
  }
  return nextBillingDateAfter(
    nextBillingDate,
    cycle,
    now,
    anchorDay ?? nextBillingDate.day,
  );
}

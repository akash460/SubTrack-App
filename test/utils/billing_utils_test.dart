import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/core/utils/billing_utils.dart';
import 'package:subtrack/models/billing_cycle.dart';
import 'package:subtrack/models/subscription.dart';

void main() {
  group('monthlyCostPaise & yearlyCostPaise', () {
    Subscription createSub({
      required int amountPaise,
      required BillingCycle billingCycle,
    }) {
      return Subscription(
        id: 'test-sub-1',
        name: 'Test Sub',
        amountPaise: amountPaise,
        billingCycle: billingCycle,
        nextBillingDate: DateTime(2026, 1, 1),
        categoryId: 'entertainment',
        colorHex: '#FFFFFF',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
    }

    test('weekly cycle: weekly x 52 / 12', () {
      // 12,000 paise weekly: (12000 * 52) / 12 = 52,000 paise
      final sub = createSub(amountPaise: 12000, billingCycle: BillingCycle.weekly);
      expect(monthlyCostPaise(sub), 52000);
      expect(yearlyCostPaise(sub), 12000 * 52); // 624,000 paise
    });

    test('weekly cycle rounding with fractional paise: 10,000 paise', () {
      // 10,000 * 52 / 12 = 43,333.333... -> 43,333 paise
      final sub = createSub(amountPaise: 10000, billingCycle: BillingCycle.weekly);
      expect(monthlyCostPaise(sub), 43333);
      expect(yearlyCostPaise(sub), 520000);
    });

    test('monthly cycle: monthly x 1', () {
      // 64,900 paise monthly: monthly x 1 = 64,900 paise
      final sub = createSub(amountPaise: 64900, billingCycle: BillingCycle.monthly);
      expect(monthlyCostPaise(sub), 64900);
      expect(yearlyCostPaise(sub), 64900 * 12); // 778,800 paise
    });

    test('quarterly cycle: quarterly / 3', () {
      // 99,900 paise quarterly: 99,900 / 3 = 33,300 paise
      final sub = createSub(amountPaise: 99900, billingCycle: BillingCycle.quarterly);
      expect(monthlyCostPaise(sub), 33300);
      expect(yearlyCostPaise(sub), 99900 * 4); // 399,600 paise
    });

    test('quarterly cycle rounding: 10,000 paise', () {
      // 10,000 / 3 = 3,333.333... -> 3,333 paise
      final sub = createSub(amountPaise: 10000, billingCycle: BillingCycle.quarterly);
      expect(monthlyCostPaise(sub), 3333);
      expect(yearlyCostPaise(sub), 40000);
    });

    test('yearly cycle: yearly / 12', () {
      // 120,000 paise yearly: 120,000 / 12 = 10,000 paise
      final sub = createSub(amountPaise: 120000, billingCycle: BillingCycle.yearly);
      expect(monthlyCostPaise(sub), 10000);
      expect(yearlyCostPaise(sub), 120000);
    });

    test('yearly cycle rounding: 119,900 paise', () {
      // 119,900 / 12 = 9,991.666... -> 9,992 paise
      final sub = createSub(amountPaise: 119900, billingCycle: BillingCycle.yearly);
      expect(monthlyCostPaise(sub), 9992);
      expect(yearlyCostPaise(sub), 119900);
    });
  });

  group('Leap year detection & days in month', () {
    test('standard leap years (divisible by 4 and not 100)', () {
      expect(isLeapYear(2024), isTrue);
      expect(isLeapYear(2028), isTrue);
      expect(isLeapYear(2020), isTrue);
      expect(isLeapYear(2016), isTrue);
    });

    test('non-leap years', () {
      expect(isLeapYear(2023), isFalse);
      expect(isLeapYear(2025), isFalse);
      expect(isLeapYear(2026), isFalse);
    });

    test('century years: 400-year rule', () {
      // Divisible by 400 -> leap year
      expect(isLeapYear(2000), isTrue);
      expect(isLeapYear(1600), isTrue);
      expect(isLeapYear(2400), isTrue);

      // Divisible by 100 but not 400 -> not leap year
      expect(isLeapYear(1900), isFalse);
      expect(isLeapYear(2100), isFalse);
      expect(isLeapYear(1800), isFalse);
    });

    test('daysInMonth returns correct days for all months including February', () {
      expect(daysInMonth(2026, 1), 31);
      expect(daysInMonth(2026, 2), 28); // non-leap
      expect(daysInMonth(2024, 2), 29); // leap year
      expect(daysInMonth(2000, 2), 29); // leap century
      expect(daysInMonth(1900, 2), 28); // non-leap century
      expect(daysInMonth(2026, 3), 31);
      expect(daysInMonth(2026, 4), 30);
      expect(daysInMonth(2026, 5), 31);
      expect(daysInMonth(2026, 6), 30);
      expect(daysInMonth(2026, 7), 31);
      expect(daysInMonth(2026, 8), 31);
      expect(daysInMonth(2026, 9), 30);
      expect(daysInMonth(2026, 10), 31);
      expect(daysInMonth(2026, 11), 30);
      expect(daysInMonth(2026, 12), 31);
    });
  });

  group('Month-end clamping (addMonthsClamped)', () {
    test('31 Jan + 1 month = 28 Feb in non-leap year (2026)', () {
      final date = DateTime(2026, 1, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2026, 2, 28));
    });

    test('31 Jan + 1 month = 29 Feb in leap year (2024)', () {
      final date = DateTime(2024, 1, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2024, 2, 29));
    });

    test('31 Mar + 1 month = 30 Apr', () {
      final date = DateTime(2026, 3, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2026, 4, 30));
    });

    test('31 May + 1 month = 30 Jun', () {
      final date = DateTime(2026, 5, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2026, 6, 30));
    });

    test('31 Aug + 1 month = 30 Sep', () {
      final date = DateTime(2026, 8, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2026, 9, 30));
    });

    test('31 Oct + 1 month = 30 Nov', () {
      final date = DateTime(2026, 10, 31);
      final result = addMonthsClamped(date, 1);
      expect(result, DateTime(2026, 11, 30));
    });

    test('29 Feb 2024 + 1 year (12 months) = 28 Feb 2025', () {
      final date = DateTime(2024, 2, 29);
      final result = addMonthsClamped(date, 12);
      expect(result, DateTime(2025, 2, 28));
    });

    test('29 Feb 2024 + 4 years (48 months) with anchorDay=29 = 29 Feb 2028', () {
      final date = DateTime(2024, 2, 29);
      final result = addMonthsClamped(date, 48, anchorDay: 29);
      expect(result, DateTime(2028, 2, 29));
    });

    test('anchorDay preserves original 31st across multiple months (Jan 31 -> Mar 31)', () {
      final jan31 = DateTime(2026, 1, 31);
      // Adding 2 months to Jan 31 with anchorDay=31 gives Mar 31, NOT Mar 28
      final mar31 = addMonthsClamped(jan31, 2, anchorDay: 31);
      expect(mar31, DateTime(2026, 3, 31));

      // Adding 3 months gives Apr 30 (clamped)
      final apr30 = addMonthsClamped(jan31, 3, anchorDay: 31);
      expect(apr30, DateTime(2026, 4, 30));

      // Adding 4 months gives May 31
      final may31 = addMonthsClamped(jan31, 4, anchorDay: 31);
      expect(may31, DateTime(2026, 5, 31));
    });
  });

  group('nextBillingDateAfter', () {
    test('normal weekly cycle', () {
      final start = DateTime(2026, 1, 1);
      final next = nextBillingDateAfter(start, BillingCycle.weekly, start);
      expect(next, DateTime(2026, 1, 8));
    });

    test('normal monthly cycle', () {
      final start = DateTime(2026, 1, 15);
      final next = nextBillingDateAfter(start, BillingCycle.monthly, start);
      expect(next, DateTime(2026, 2, 15));
    });

    test('normal quarterly cycle', () {
      final start = DateTime(2026, 1, 15);
      final next = nextBillingDateAfter(start, BillingCycle.quarterly, start);
      expect(next, DateTime(2026, 4, 15));
    });

    test('normal yearly cycle', () {
      final start = DateTime(2025, 6, 1);
      final next = nextBillingDateAfter(start, BillingCycle.yearly, start);
      expect(next, DateTime(2026, 6, 1));
    });

    test('month-end clamping: 31 Jan non-leap year -> 28 Feb', () {
      final start = DateTime(2026, 1, 31);
      final next = nextBillingDateAfter(start, BillingCycle.monthly, start);
      expect(next, DateTime(2026, 2, 28));
    });

    test('month-end clamping: 31 Jan leap year -> 29 Feb', () {
      final start = DateTime(2024, 1, 31);
      final next = nextBillingDateAfter(start, BillingCycle.monthly, start);
      expect(next, DateTime(2024, 2, 29));
    });

    test('quarterly month-end clamping: 31 Jan -> 30 Apr', () {
      final start = DateTime(2026, 1, 31);
      final next = nextBillingDateAfter(start, BillingCycle.quarterly, start);
      expect(next, DateTime(2026, 4, 30));
    });

    test('yearly leap day clamping: 29 Feb 2024 -> 28 Feb 2025', () {
      final start = DateTime(2024, 2, 29);
      final next = nextBillingDateAfter(start, BillingCycle.yearly, start);
      expect(next, DateTime(2025, 2, 28));
    });

    test('finds next billing date after specified future date [from]', () {
      final anchor = DateTime(2026, 1, 15);
      // Reference date is 20 Feb 2026: next cycle strictly after reference is 15 Mar 2026
      final next = nextBillingDateAfter(anchor, BillingCycle.monthly, DateTime(2026, 2, 20));
      expect(next, DateTime(2026, 3, 15));
    });

    test('when date is already strictly after from, returns date', () {
      final date = DateTime(2026, 4, 1);
      final from = DateTime(2026, 3, 15);
      final next = nextBillingDateAfter(date, BillingCycle.monthly, from);
      expect(next, DateTime(2026, 4, 1));
    });
  });

  group('rollForward across multiple missed cycles', () {
    test('future nextBillingDate returns unchanged (0 missed cycles)', () {
      final nextBilling = DateTime(2026, 5, 1);
      final now = DateTime(2026, 4, 15);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 5, 1));
    });

    test('exact match (now == nextBillingDate) rolls forward by 1 cycle', () {
      final nextBilling = DateTime(2026, 4, 15);
      final now = DateTime(2026, 4, 15);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 5, 15));
    });

    test('single missed monthly cycle rolls forward 1 cycle', () {
      final nextBilling = DateTime(2026, 1, 10);
      final now = DateTime(2026, 1, 25);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 2, 10));
    });

    test('multiple missed monthly cycles (missed 4 cycles)', () {
      // Due date was Jan 10, user opens app on May 5.
      // Missed: Jan 10, Feb 10, Mar 10, Apr 10, May 10 -> wait!
      // On May 5: Jan 10 (missed), Feb 10 (missed), Mar 10 (missed), Apr 10 (missed).
      // Next upcoming date after May 5 is May 10!
      final nextBilling = DateTime(2026, 1, 10);
      final now = DateTime(2026, 5, 5);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 5, 10));
    });

    test('multiple missed monthly cycles spanning across years', () {
      // Due date was Nov 15, 2024, user opens app on Feb 20, 2026 (15 months missed!)
      final nextBilling = DateTime(2024, 11, 15);
      final now = DateTime(2026, 2, 20);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 3, 15));
    });

    test('multiple missed weekly cycles (missed 5 weeks)', () {
      final nextBilling = DateTime(2026, 1, 1);
      // 5 weeks later = 35 days (Feb 5). Let now be Feb 2.
      // Week 0: Jan 1
      // Week 1: Jan 8
      // Week 2: Jan 15
      // Week 3: Jan 22
      // Week 4: Jan 29
      // Week 5: Feb 5
      final now = DateTime(2026, 2, 2);
      final result = rollForward(nextBilling, BillingCycle.weekly, now);
      expect(result, DateTime(2026, 2, 5));
    });

    test('multiple missed quarterly cycles (missed 3 quarters)', () {
      final nextBilling = DateTime(2025, 1, 1);
      // Quarters: Jan 1, Apr 1, Jul 1, Oct 1, Jan 1 (2026).
      // If now is Oct 15, 2025, the next quarter is Jan 1, 2026.
      final now = DateTime(2025, 10, 15);
      final result = rollForward(nextBilling, BillingCycle.quarterly, now);
      expect(result, DateTime(2026, 1, 1));
    });

    test('multiple missed yearly cycles (missed 3 years)', () {
      final nextBilling = DateTime(2021, 6, 15);
      final now = DateTime(2024, 8, 1);
      // Missed: Jun 15 2021, Jun 15 2022, Jun 15 2023, Jun 15 2024
      // Next upcoming after Aug 1, 2024: Jun 15, 2025.
      final result = rollForward(nextBilling, BillingCycle.yearly, now);
      expect(result, DateTime(2025, 6, 15));
    });

    test('month-end clamping preserved across multiple missed monthly cycles (31st anchor)', () {
      // Created Jan 31, 2026.
      // Cycles:
      // Jan 31 -> Feb 28 -> Mar 31 -> Apr 30 -> May 31.
      // If now is April 15, 2026:
      // Jan 31 (missed), Feb 28 (missed), Mar 31 (missed).
      // Next date after April 15 is April 30!
      final nextBilling = DateTime(2026, 1, 31);
      final now = DateTime(2026, 4, 15);
      final result = rollForward(nextBilling, BillingCycle.monthly, now);
      expect(result, DateTime(2026, 4, 30));

      // And rolling forward when now is May 15 should restore the 31st anchor!
      final mayNow = DateTime(2026, 5, 15);
      final mayResult = rollForward(nextBilling, BillingCycle.monthly, mayNow);
      expect(mayResult, DateTime(2026, 5, 31));
    });

    test('leap year clamping preserved across multiple missed yearly cycles (29 Feb anchor)', () {
      // Leap day subscription: 29 Feb 2020.
      // 2021: 28 Feb (clamped)
      // 2022: 28 Feb (clamped)
      // 2023: 28 Feb (clamped)
      // 2024: 29 Feb (leap year restored!)
      final leapDay = DateTime(2020, 2, 29);
      final now = DateTime(2023, 5, 1);
      final result = rollForward(leapDay, BillingCycle.yearly, now);
      expect(result, DateTime(2024, 2, 29));
    });
  });
}

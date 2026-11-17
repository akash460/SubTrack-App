import 'package:flutter_test/flutter_test.dart';
import 'package:subtrack/core/utils/money.dart';

void main() {
  group('formatInr', () {
    test('formats ₹1,23,456.50 correctly with Indian numbering grouping', () {
      // 12345650 paise = ₹1,23,456.50
      expect(formatInr(12345650), '₹1,23,456.50');
    });

    test('formats zero paise as ₹0.00', () {
      expect(formatInr(0), '₹0.00');
    });

    test('formats whole rupees correctly', () {
      expect(formatInr(100), '₹1.00');
      expect(formatInr(64900), '₹649.00');
      expect(formatInr(79900), '₹799.00');
    });

    test('formats fractional paise correctly', () {
      expect(formatInr(50), '₹0.50');
      expect(formatInr(5), '₹0.05');
      expect(formatInr(99), '₹0.99');
    });

    test('formats large numbers adhering to Indian numbering tiers (Lakhs and Crores)', () {
      // 1 Thousand: 1,000 rupees = 1,00,000 paise
      expect(formatInr(100000), '₹1,000.00');

      // 10 Thousand: 10,000 rupees = 10,00,000 paise
      expect(formatInr(1000000), '₹10,000.00');

      // 1 Lakh: 1,00,000 rupees = 1,00,00,000 paise
      expect(formatInr(10000000), '₹1,00,000.00');

      // 10 Lakhs: 10,00,000 rupees = 10,00,00,000 paise
      expect(formatInr(100000000), '₹10,00,000.00');

      // 1 Crore: 1,00,00,000 rupees = 1,00,00,00,000 paise
      expect(formatInr(1000000000), '₹1,00,00,000.00');

      // 10 Crores: 10,00,00,000 rupees = 10,00,00,00,000 paise
      expect(formatInr(10000000000), '₹10,00,00,000.00');
    });

    test('handles negative paise amounts', () {
      expect(formatInr(-12345650), '-₹1,23,456.50');
      expect(formatInr(-5000), '-₹50.00');
    });

    test('supports hiding currency symbol', () {
      expect(formatInr(12345650, showSymbol: false), '1,23,456.50');
    });

    test('supports custom decimal digits', () {
      expect(formatInr(12345650, decimalDigits: 0), '₹1,23,457');
      expect(formatInr(64900, decimalDigits: 0), '₹649');
    });
  });

  group('Conversion helpers', () {
    test('paiseToRupees converts accurately', () {
      expect(paiseToRupees(12345650), 123456.50);
      expect(paiseToRupees(100), 1.0);
      expect(paiseToRupees(0), 0.0);
      expect(paiseToRupees(50), 0.50);
    });

    test('rupeesToPaise converts accurately with rounding', () {
      expect(rupeesToPaise(123456.50), 12345650);
      expect(rupeesToPaise(1), 100);
      expect(rupeesToPaise(0), 0);
      expect(rupeesToPaise(0.5), 50);
      expect(rupeesToPaise(649), 64900);
    });
  });
}

import 'package:intl/intl.dart';

/// Formats an amount in paise to Indian Rupee (INR) currency format with Indian numbering grouping.
///
/// In the Indian numbering system, the rightmost three digits are grouped together,
/// and subsequent digits are grouped in pairs (e.g. ₹1,23,456.50).
///
/// Example:
/// ```dart
/// formatInr(12345650); // "₹1,23,456.50"
/// formatInr(100);      // "₹1.00"
/// formatInr(0);        // "₹0.00"
/// ```
String formatInr(
  int paise, {
  int decimalDigits = 2,
  bool showSymbol = true,
}) {
  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: showSymbol ? '₹' : '',
    decimalDigits: decimalDigits,
  );
  return formatter.format(paise / 100);
}

/// Converts paise to rupees as a [double].
double paiseToRupees(int paise) => paise / 100.0;

/// Converts rupees to integer paise, rounding to the nearest paise.
int rupeesToPaise(num rupees) => (rupees * 100).round();

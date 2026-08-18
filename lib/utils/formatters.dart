/// Formats an amount as "$2,000,098,293.09" style text — comma-grouped
/// thousands, two decimal places, configurable currency symbol.
String formatMoney(double amount, {String symbol = '\$'}) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final posFromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
  }
  return '$symbol${buffer.toString()}.${parts[1]}';
}

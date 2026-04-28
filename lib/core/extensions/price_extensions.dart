extension PriceFormatting on num {
  String formatCurrency() {
    final value = toDouble();
    final hasDecimal = value % 1 != 0;
    final formatted = value.toStringAsFixed(hasDecimal ? 2 : 0);
    return '\$${formatted}';
  }
}

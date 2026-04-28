extension PriceFormatting on num {
  String formatCurrency() {
    final v = toDouble();
    return '\$${v.toStringAsFixed(v % 1 == 0 ? 0 : 2)}';
  }
}
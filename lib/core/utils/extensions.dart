extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension DoubleExtensions on double {
  String toPriceString() {
    return '\$${toStringAsFixed(2)}';
  }
}



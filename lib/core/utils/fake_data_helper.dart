import 'dart:math';

class FakeDataHelper {
  static double resolvePrice({required double? price, required int seed}) {
    if (price != null && price.isFinite && price > 0) {
      return price;
    }
    final random = Random(seed);
    return 50 + random.nextInt(451).toDouble();
  }

  static String resolveDescription({
    required String? description,
    required String title,
    required int seed,
  }) {
    if (description != null && description.trim().isNotEmpty) {
      return description.trim();
    }

    final random = Random(seed);
    final adjective = _adjectives[random.nextInt(_adjectives.length)];
    final material = _materials[random.nextInt(_materials.length)];
    final benefit = _benefits[random.nextInt(_benefits.length)];

    return '$adjective $title crafted with $material. '
        '$benefit Designed for everyday use with a premium feel.';
  }

  static const List<String> _adjectives = [
    'Sleek',
    'Modern',
    'Premium',
    'Minimalist',
    'Elegant',
    'Durable',
    'Refined',
  ];

  static const List<String> _materials = [
    'high-grade materials',
    'soft-touch finish',
    'reinforced stitching',
    'lightweight alloy',
    'eco-friendly fabrics',
  ];

  static const List<String> _benefits = [
    'Comfort meets style in a balanced silhouette.',
    'Built to keep up with your daily routine.',
    'Pairs perfectly with casual and smart looks.',
    'Optimized for long-lasting performance.',
  ];
}

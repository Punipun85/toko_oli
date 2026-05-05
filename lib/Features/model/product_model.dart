class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.priceValue,
    required this.sae,
    required this.volume,
    required this.type,
    required this.series,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String brand;
  final num priceValue;
  final String sae;
  final String volume;
  final String type;
  final String series;
  final String category;
  final String description;
  final String? imageUrl;

  String get price =>
      hasPrice ? 'Rp ${_formatPrice(priceValue)}' : 'Harga belum tersedia';

  bool get hasPrice => priceValue > 0;

  String? get resolvedImageUrl {
    final rawImage = imageUrl?.trim();
    if (rawImage == null || rawImage.isEmpty) {
      return null;
    }

    if (rawImage.startsWith('//')) {
      return 'https:$rawImage';
    }

    if (rawImage.startsWith('http://') || rawImage.startsWith('https://')) {
      return Uri.encodeFull(rawImage);
    }

    return null;
  }

  factory Product.fromSupabase(Map<String, dynamic> json) {
    final merkData = json['merk'];
    final kategoriData = json['kategori'];
    final harga = _parsePrice(json['harga']);

    return Product(
      id: json['id_produk'].toString(),
      name: (json['nama_produk'] ?? '').toString(),
      brand: _extractRelationValue(
        merkData,
        'nama_merk',
        fallback: 'Pertamina',
      ),
      priceValue: harga,
      sae: (json['sae'] ?? '-').toString(),
      volume: (json['volume'] ?? '-').toString(),
      type: (json['tipe'] ?? '-').toString(),
      series: (json['seri'] ?? '-').toString(),
      category: _extractRelationValue(
        kategoriData,
        'nama_kategori',
        fallback: 'Oli',
      ),
      description: (json['deskripsi'] ?? 'Detail produk belum tersedia.')
          .toString(),
      imageUrl: json['gambar']?.toString(),
    );
  }

  static String _extractRelationValue(
    dynamic relation,
    String key, {
    required String fallback,
  }) {
    if (relation is Map<String, dynamic>) {
      return (relation[key] ?? fallback).toString();
    }

    if (relation is List &&
        relation.isNotEmpty &&
        relation.first is Map<String, dynamic>) {
      return (relation.first[key] ?? fallback).toString();
    }

    return fallback;
  }

  static num _parsePrice(dynamic rawPrice) {
    if (rawPrice is num) {
      return rawPrice;
    }

    final normalizedPrice = (rawPrice?.toString() ?? '')
        .replaceAll(RegExp(r'[^0-9,.-]'), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    return num.tryParse(normalizedPrice) ?? 0;
  }

  static String _formatPrice(num value) {
    final digits = value.round().toString();
    final parts = <String>[];

    for (var end = digits.length; end > 0; end -= 3) {
      final start = end - 3 < 0 ? 0 : end - 3;
      parts.insert(0, digits.substring(start, end));
    }

    return parts.join('.');
  }
}

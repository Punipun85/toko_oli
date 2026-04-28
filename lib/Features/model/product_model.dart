class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
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
  final String price;
  final String sae;
  final String volume;
  final String type;
  final String series;
  final String category;
  final String description;
  final String? imageUrl;

  factory Product.fromSupabase(Map<String, dynamic> json) {
    final merkData = json['merk'];
    final kategoriData = json['kategori'];
    final harga = _parsePrice(json['harga']);

    return Product(
      id: json['id_produk'].toString(),
      name: (json['nama_produk'] ?? '').toString(),
      brand: _extractRelationValue(merkData, 'nama_merk', fallback: 'Pertamina'),
      price: harga <= 0 ? 'Hubungi kami' : 'Rp ${harga.toInt()}',
      sae: (json['sae'] ?? '-').toString(),
      volume: (json['volume'] ?? '-').toString(),
      type: (json['tipe'] ?? '-').toString(),
      series: (json['seri'] ?? '-').toString(),
      category: _extractRelationValue(kategoriData, 'nama_kategori', fallback: 'Oli'),
      description: (json['deskripsi'] ?? 'Detail produk belum tersedia.').toString(),
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

    if (relation is List && relation.isNotEmpty && relation.first is Map<String, dynamic>) {
      return (relation.first[key] ?? fallback).toString();
    }

    return fallback;
  }

  static num _parsePrice(dynamic rawPrice) {
    if (rawPrice is num) {
      return rawPrice;
    }

    return num.tryParse(rawPrice?.toString() ?? '') ?? 0;
  }
}

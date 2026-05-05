import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    @JsonKey(name: 'id_produk', fromJson: _parseString) required String id,
    @JsonKey(name: 'nama_produk', fromJson: _parseStringEmpty) required String name,
    @JsonKey(name: 'harga', fromJson: _parsePrice) required num priceValue,
    @JsonKey(name: 'sae', fromJson: _parseStringDash) required String sae,
    @JsonKey(name: 'volume', fromJson: _parseStringDash) required String volume,
    @JsonKey(name: 'tipe', fromJson: _parseStringDash) required String type,
    @JsonKey(name: 'seri', fromJson: _parseStringDash) required String series,
    @JsonKey(name: 'deskripsi', fromJson: _parseStringDesc) required String description,
    @JsonKey(name: 'gambar') String? imageUrl,
    @JsonKey(name: 'merk', fromJson: _extractMerk) @Default('Pertamina') String brand,
    @JsonKey(name: 'kategori', fromJson: _extractCategory) @Default('Oli') String category,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  const Product._();

  String get price => hasPrice ? 'Rp ${_formatPrice(priceValue)}' : 'Harga belum tersedia';

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
}

// Helpers for manual parsing overrides
String _parseString(dynamic value) => value.toString();
String _parseStringEmpty(dynamic value) => value?.toString() ?? '';
String _parseStringDash(dynamic value) => value?.toString() ?? '-';
String _parseStringDesc(dynamic value) => value?.toString() ?? 'Detail produk belum tersedia.';

num _parsePrice(dynamic rawPrice) {
  if (rawPrice is num) return rawPrice;
  final normalizedPrice = (rawPrice?.toString() ?? '')
      .replaceAll(RegExp(r'[^0-9,.-]'), '')
      .replaceAll('.', '')
      .replaceAll(',', '.');
  return num.tryParse(normalizedPrice) ?? 0;
}

String _extractMerk(dynamic relation) {
  if (relation is Map<String, dynamic>) {
    return (relation['nama_merk'] ?? 'Pertamina').toString();
  }
  if (relation is List && relation.isNotEmpty && relation.first is Map<String, dynamic>) {
    return (relation.first['nama_merk'] ?? 'Pertamina').toString();
  }
  return 'Pertamina';
}

String _extractCategory(dynamic relation) {
  if (relation is Map<String, dynamic>) {
    return (relation['nama_kategori'] ?? 'Oli').toString();
  }
  if (relation is List && relation.isNotEmpty && relation.first is Map<String, dynamic>) {
    return (relation.first['nama_kategori'] ?? 'Oli').toString();
  }
  return 'Oli';
}

String _formatPrice(num value) {
  final digits = value.round().toString();
  final parts = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    parts.insert(0, digits.substring(start, end));
  }
  return parts.join('.');
}

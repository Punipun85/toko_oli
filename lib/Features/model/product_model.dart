class Product {
  final String id;
  final String name;
  final String brand;
  final String price;
  final String sae;
  final String volume;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.sae,
    required this.volume,
  });

  // Fungsi untuk mengubah JSON dari PHP menjadi objek Flutter
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_produk'].toString(),
      name: json['nama_produk'],
      brand: json['nama_merk'],
      price: 'Rp ${double.parse(json['harga']).toInt()}',
      sae: json['sae'],
      volume: json['volume'],
    );
  }

  static List<Product> get sampleData => [
        Product(
          id: '1',
          name: 'Castrol Power1 Ultimate',
          brand: 'Castrol',
          price: 'Rp 128000',
          sae: '10W-40',
          volume: '1L',
        ),
        Product(
          id: '2',
          name: 'Shell Helix Ultra',
          brand: 'Shell',
          price: 'Rp 150000',
          sae: '5W-30',
          volume: '1L',
        ),
        Product(
          id: '3',
          name: 'Motul Scooter Expert',
          brand: 'Motul',
          price: 'Rp 99000',
          sae: '10W-40',
          volume: '800ml',
        ),
        Product(
          id: '4',
          name: 'Yamalube Super Matic',
          brand: 'Yamalube',
          price: 'Rp 76000',
          sae: '10W-40',
          volume: '1L',
        ),
      ];
}

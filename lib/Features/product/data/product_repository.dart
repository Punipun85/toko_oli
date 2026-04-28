import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/Features/model/product_model.dart';

class ProductRepository {
  ProductRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Product>> fetchProducts() async {
    final response = await _client
        .from('produk')
        .select(
          '''
id_produk,
nama_produk,
harga,
sae,
volume,
tipe,
deskripsi,
gambar,
seri,
kategori:kategori!produk_id_kategori_fkey(nama_kategori),
merk:merk!produk_id_merk_fkey(nama_merk)
''',
        )
        .order('id_produk');

    return (response as List<dynamic>)
        .map((item) => Product.fromSupabase(item as Map<String, dynamic>))
        .toList();
  }
}

import 'package:flutter/material.dart';
// TODO: Jangan lupa import file ProductDetailPage Anda di sini jika beda folder
// import 'product_detail_page.dart'; 

// 1. Model Data (Bisa dipindah ke file terpisah nanti)
class Product {
  final String name;
  final String price;
  final String sae;
  final String volume;
  final String type;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.sae,
    required this.volume,
    required this.type,
    required this.description,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2. Data Dummy Produk
    final List<Product> dummyProducts = [
      Product(
        name: 'Enduro 4T Racing',
        price: 'Rp 55.000',
        sae: '10W-40',
        volume: '1 Liter',
        type: 'Semi-Sintetis',
        description: 'Oli pelumas mesin motor 4 tak berkualitas tinggi.',
      ),
      Product(
        name: 'Shell Advance AX7',
        price: 'Rp 65.000',
        sae: '10W-40',
        volume: '800 ml',
        type: 'Sintetis',
        description: 'Meningkatkan performa standar sepeda motor.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.red),
            SizedBox(width: 8),
            Text('Surakarta, Jawa Tengah', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      // BAGIAN INI TETAP SAMA
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari merk oli, jenis kendaraan...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PROMO SPESIAL HARI INI\nDiskon 20% Oli Motor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem(Icons.motorcycle, 'Oli Mtr'),
                  _buildCategoryItem(Icons.directions_car, 'Oli Mbl'),
                  _buildCategoryItem(Icons.settings, 'Transmisi'),
                  _buildCategoryItem(Icons.more_horiz, 'Lainnya'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rekomendasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
                ],
              ),
              
              // 3. ListView Dinamis
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, dummyProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // PERHATIKAN: bottomNavigationBar sudah dihapus dari sini!
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(radius: 25, child: Icon(icon)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // 4. Widget Card yang menerima objek Product dan bisa diklik
  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail saat diklik
        /* Pastikan file ProductDetailPage sudah ada dan di-import
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
        */
        // Hapus tanda komentar (/* ... */) di atas jika ProductDetailPage sudah siap
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Menuju detail: ${product.name}')),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(product.price, style: const TextStyle(color: Colors.red)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
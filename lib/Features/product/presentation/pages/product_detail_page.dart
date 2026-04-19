import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Produk
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.image, size: 100, color: Colors.grey)),
            ),
            
            // 2. Info Utama Produk
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pertamina Enduro 4T Racing',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rp 55.000',
                    style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('4.8 (120 Ulasan)', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const Divider(height: 30),

                  // 3. Spesifikasi & Deskripsi
                  const Text('Spesifikasi:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('- SAE: 10W-40\n- Volume: 1 Liter\n- Tipe: Semi-Sintetis'),
                  const SizedBox(height: 20),
                  
                  const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Oli pelumas mesin motor 4 tak berkualitas tinggi yang dirancang khusus untuk memberikan perlindungan maksimal pada mesin kendaraan Anda dalam kondisi ekstrem.',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 4. Sticky Bottom Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(0, -2))
            ],
          ),
          child: Row(
            children: [
              // Pengatur Kuantitas
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
                    const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Tombol Tambah ke Keranjang
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text('Tambah ke Keranjang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
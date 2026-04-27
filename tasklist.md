# Task List

## Objective
Menerjemahkan PRD Toko Oli menjadi langkah implementasi yang rapi, terukur, dan cocok dengan basis proyek Flutter yang sudah ada.

## Phase 0 - Foundation Audit
- [ ] Rapikan deskripsi proyek pada `README.md` dan `pubspec.yaml`.
- [ ] Ganti `widget_test.dart` template default dengan test yang sesuai aplikasi saat ini.
- [ ] Jalankan `flutter analyze` dan catat baseline issue.
- [ ] Tentukan strategi state management utama, disarankan Riverpod.
- [ ] Tentukan sumber data produk final: Supabase, PHP API, atau hybrid.

## Phase 1 - Data and Architecture
- [ ] Buat struktur `data`, `domain`, dan `presentation` yang konsisten per fitur.
- [ ] Buat model produk yang aman terhadap parsing harga dan null data.
- [ ] Pisahkan logic fetch produk dari widget ke repository atau service layer.
- [ ] Buat environment config untuk base URL API dan key yang sensitif.
- [ ] Hilangkan ketergantungan langsung ke `127.0.0.1` di kode aplikasi.

## Phase 2 - Product Browsing
- [ ] Hubungkan beranda ke provider atau controller produk.
- [ ] Aktifkan pencarian produk di beranda dan katalog.
- [ ] Aktifkan filter kategori dan spesifikasi SAE.
- [ ] Tambahkan loading, empty, dan error state yang jelas pada daftar produk.
- [ ] Samakan source of truth produk antara beranda, katalog, dan detail.

## Phase 3 - Cart Flow
- [ ] Buat state keranjang global.
- [ ] Hubungkan tombol `Tambah ke keranjang` dari detail produk.
- [ ] Hubungkan tombol cart dari kartu produk di beranda dan katalog.
- [ ] Tambahkan update quantity, hapus item, dan hitung subtotal otomatis.
- [ ] Tampilkan badge jumlah item pada navigasi atau ikon keranjang.

## Phase 4 - Profile and User Data
- [ ] Tentukan model user profile dan vehicle garage.
- [ ] Integrasikan autentikasi dasar dengan Supabase bila jadi backend utama.
- [ ] Ubah halaman profil dari statis menjadi data-driven.
- [ ] Tambahkan pengelolaan alamat pengiriman dan kendaraan.

## Phase 5 - Checkout Preparation
- [ ] Definisikan alur checkout minimum viable.
- [ ] Tambahkan validasi data sebelum lanjut checkout.
- [ ] Simpan snapshot ringkasan order.
- [ ] Tentukan apakah pembayaran dilakukan in-app atau via handoff.

## Phase 6 - Quality
- [ ] Tambahkan widget test untuk dashboard navigation.
- [ ] Tambahkan widget test untuk product list dan product detail.
- [ ] Tambahkan test state keranjang.
- [ ] Pastikan `flutter analyze` bersih.
- [ ] Pastikan `flutter test` lulus sebelum merge.

## Immediate Recommended Next Steps
- [ ] Perbaiki test default yang saat ini tidak relevan dengan struktur aplikasi.
- [ ] Refactor fetch produk di `HomePage` ke service atau repository.
- [ ] Implementasikan state keranjang terpusat sebagai fondasi fitur transaksi.

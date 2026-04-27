# Product Requirements Document

## Product Name
Toko Oli

## Document Status
Draft v0.1

## Background
Toko Oli adalah aplikasi Flutter untuk membantu pengguna mencari, membandingkan, dan membeli oli kendaraan dengan pengalaman yang terasa premium namun tetap mudah digunakan. Basis produk saat ini sudah memiliki layar utama seperti beranda, katalog, detail produk, keranjang, dan profil, tetapi sebagian besar masih memakai data statis atau fallback lokal. PRD ini menyusun arah produk agar pengembangan berikutnya fokus, terukur, dan selaras dengan struktur kode yang sudah ada.

## Problem Statement
Pemilik kendaraan sering kesulitan memilih oli yang sesuai dengan tipe kendaraan, spesifikasi SAE, dan kebutuhan penggunaan harian. Di sisi lain, toko atau bengkel membutuhkan kanal digital yang memudahkan discovery produk, edukasi spesifikasi, dan konversi ke checkout tanpa pengalaman yang terasa membingungkan.

## Product Vision
Menjadi aplikasi belanja oli kendaraan yang membantu pengguna memilih produk dengan percaya diri melalui katalog yang jelas, rekomendasi yang relevan, dan alur checkout yang cepat.

## Goals
1. Memudahkan pengguna menemukan oli yang cocok berdasarkan kategori, merek, dan spesifikasi.
2. Meningkatkan konversi dari halaman katalog ke detail produk dan checkout.
3. Menyediakan fondasi data yang siap berkembang dari sample data ke backend nyata.
4. Menjaga pengalaman aplikasi tetap cepat, konsisten, dan mudah dipahami di Android terlebih dahulu.

## Non-Goals
1. Marketplace multi-tenant untuk banyak penjual pada fase awal.
2. Sistem servis bengkel lengkap dengan booking montir lapangan.
3. Loyalty program kompleks, poin, atau gamification pada milestone pertama.
4. Dukungan offline-first penuh pada versi awal.

## Target Users
1. Pemilik motor harian yang ingin membeli oli sesuai rekomendasi umum.
2. Pemilik mobil keluarga yang ingin membandingkan spesifikasi dan harga.
3. Pelanggan bengkel langganan yang ingin repeat order dengan cepat.

## User Needs
1. Bisa mencari produk dengan cepat.
2. Bisa memahami kecocokan oli tanpa harus ahli teknis.
3. Bisa melihat harga, merek, SAE, dan volume dengan jelas.
4. Bisa menambahkan produk ke keranjang dan checkout tanpa friksi.
5. Bisa menyimpan profil, kendaraan, dan preferensi pembelian.

## Current Product Snapshot
1. `lib/main.dart` sudah menginisialisasi Supabase dan membuka `DashboardPage`.
2. `DashboardPage` menyediakan navigasi bawah untuk Beranda, Katalog, Keranjang, dan Akun.
3. Beranda dan katalog sudah menampilkan produk, tetapi masih bergantung pada `Product.sampleData` ketika request API gagal.
4. Detail produk sudah tersedia, namun aksi seperti bookmark, share, tambah ke keranjang, dan beli sekarang belum terhubung ke state atau backend.
5. Keranjang dan profil masih statis.
6. Test masih template default Flutter dan belum sesuai perilaku aplikasi saat ini.

## Core Features
### 1. Home Discovery
Pengguna melihat hero promo, kategori utama, pencarian, dan rekomendasi produk.

### 2. Product Catalog
Pengguna menelusuri daftar produk, memfilter berdasarkan kategori atau SAE, lalu masuk ke detail produk.

### 3. Product Detail
Pengguna melihat spesifikasi teknis, keunggulan produk, harga, dan melakukan aksi pembelian.

### 4. Cart and Checkout Preparation
Pengguna meninjau item, subtotal, biaya tambahan, dan melanjutkan ke checkout.

### 5. User Profile and Garage
Pengguna mengelola data diri, kendaraan, alamat, serta preferensi akun.

## Functional Requirements
### Must Have
1. Menampilkan daftar produk dari sumber data nyata dengan fallback yang aman bila backend gagal.
2. Mendukung pencarian produk berdasarkan nama, merek, SAE, atau kategori.
3. Menampilkan detail produk dengan informasi harga, SAE, volume, dan deskripsi.
4. Menambahkan produk ke keranjang dan memperbarui jumlah item secara konsisten.
5. Menyimpan state navigasi dan data keranjang selama sesi aplikasi berjalan.
6. Menyediakan halaman profil dasar dengan identitas pengguna dan data kendaraan utama.

### Should Have
1. Filter kategori dan spesifikasi yang benar-benar bekerja di katalog.
2. Integrasi autentikasi Supabase untuk akun pengguna.
3. Penyimpanan data keranjang dan profil ke backend.
4. Banner promo dan rekomendasi berbasis kendaraan.

### Could Have
1. Wishlist atau bookmark produk.
2. Riwayat transaksi.
3. Notifikasi promo atau reminder ganti oli.

## UX Requirements
1. Tema premium gelap-oranye tetap dipertahankan sebagai identitas visual.
2. Informasi inti produk harus terbaca dalam 3 detik pertama tanpa membuka detail.
3. CTA utama seperti tambah ke keranjang dan beli sekarang harus konsisten di seluruh alur.
4. Empty state, loading state, dan error state harus jelas dan tidak terasa rusak.

## Technical Requirements
1. Arsitektur perlu bergerak dari UI-heavy ke pemisahan data, domain, dan presentation yang lebih rapi.
2. State management perlu dipindahkan dari `setState` lokal ke pendekatan yang lebih scalable, idealnya Riverpod sesuai arah skill Flutter yang dipakai.
3. Konfigurasi API tidak boleh hardcoded ke `127.0.0.1` untuk build produksi.
4. Integrasi Supabase perlu didefinisikan per use case, bukan hanya inisialisasi global.
5. Semua fitur inti harus tercakup oleh `flutter analyze` dan widget test yang relevan.

## Success Metrics
1. Pengguna bisa membuka katalog dalam kurang dari 2 detik pada jaringan normal.
2. Pengguna bisa menambahkan produk ke keranjang dari katalog atau detail produk tanpa error.
3. Crash-free session rate target minimal 99%.
4. Minimal 70% skenario UI inti memiliki test coverage widget atau integration test.

## Risks and Gaps
1. Endpoint produk saat ini mengarah ke localhost, sehingga tidak usable di device nyata tanpa konfigurasi ulang.
2. Data dan aksi penting masih statis sehingga demo terlihat hidup, tetapi alur bisnis belum benar-benar berjalan.
3. Inisialisasi Supabase sudah ada, namun belum ada kontrak data yang jelas antara Supabase dan fitur aplikasi.
4. Struktur folder fitur sudah mulai terbentuk, tetapi belum diikuti state layer dan repository layer yang konsisten.

## Release Recommendation
### Milestone 1
Validasi fondasi produk: data produk nyata, keranjang aktif, dan test dasar.

### Milestone 2
Autentikasi, profil pengguna, data kendaraan, dan sinkronisasi backend.

### Milestone 3
Checkout penuh, riwayat transaksi, promo personal, dan optimasi performa.

## Open Questions
1. Backend utama akan memakai Supabase, PHP API yang sudah ada, atau kombinasi keduanya?
2. Checkout akan diselesaikan di dalam aplikasi atau hanya sampai konfirmasi pesanan?
3. Apakah kategori produk nantinya mengikuti jenis kendaraan, merek, atau spesifikasi teknis?
4. Apakah target fase pertama hanya Android atau sekaligus iOS dan web?

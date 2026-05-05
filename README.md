# OliMart Flutter App

OliMart adalah aplikasi Flutter untuk katalog oli, cart, checkout, dashboard admin, dan alur delivery courier dengan integrasi Supabase dan fallback dummy data.

## Status implementasi

Saat ini aplikasi sudah:

- membaca `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dari `.env`
- inisialisasi Supabase tanpa hardcode service role
- fallback ke data dummy saat Supabase belum siap atau query gagal
- routing berbasis role:
  - `customer` ke customer dashboard
  - `admin` ke admin dashboard
  - `courier` ke courier dashboard

## Setup environment

Buat `.env`:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=sb_publishable_your_public_client_key
```

Contoh placeholder tersedia di:

- [.env.example](C:/Users/Asus/vsc/vscode/android/toko_oli/.env.example)

## Key yang aman untuk Flutter

Aman dipakai di Flutter client:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Jangan pernah taruh di Flutter:

- `service_role` key
- database password
- admin secret lain

Alasannya: `service_role` bisa melewati RLS dan kalau bocor dari APK/IPA maka seluruh data bisa disalahgunakan.

## Menjalankan Flutter app

```powershell
flutter pub get
flutter run
```

## Menjalankan migration Supabase

Schema ecommerce additive ada di folder:

- [supabase/migrations](C:/Users/Asus/vsc/vscode/android/toko_oli/supabase/migrations)

Push migration ke project yang sudah ter-link:

```powershell
supabase db push
```

Dokumentasi schema lebih detail ada di:

- [README_olimart_schema.md](C:/Users/Asus/vsc/vscode/android/toko_oli/supabase/README_olimart_schema.md)

## Repository yang sudah disambungkan

- `AuthRepository`
- `ProductRepository`
- `CartRepository`
- `OrderRepository`
- `AddressRepository`
- `WishlistRepository`
- `ReviewRepository`
- `VehicleRepository`
- `OilRecommendationRepository`
- `OilChangeReminderRepository`
- `PromoRepository`
- `StockRepository`
- `ArticleRepository`
- `AdminDashboardRepository`
- `CourierRepository`
- `StorageRepository`

Semua repository memakai pola:

1. coba Supabase schema baru
2. fallback ke schema lama bila relevan
3. fallback ke data dummy lokal bila Supabase tidak tersedia

## Testing yang disarankan

Jalankan:

```powershell
flutter analyze
flutter test
```

Lalu verifikasi manual:

1. login sebagai customer
2. login sebagai admin
3. login sebagai courier
4. cek product list
5. tambah produk ke cart
6. buat checkout
7. buka admin dashboard
8. update status order dari admin
9. update stok
10. update delivery status dari courier

Status verifikasi terakhir pada 4 Mei 2026:

- `flutter test --no-pub` lulus
- `flutter analyze` sudah tanpa error build, tetapi masih ada sekitar 107 warning/info lint yang belum dirapikan semuanya

## Remaining TODOs

Beberapa area masih perlu diperdalam agar production-ready:

- form CRUD admin yang lebih lengkap untuk product, promo, article, dan recommendation
- UI khusus checkout multi-step dan address management penuh
- upload image picker native ke Storage dari UI
- sinkronisasi lebih dalam antara schema legacy `produk` dan schema ecommerce baru `products`
- widget dan integration test untuk admin/courier flow
- cleanup warning analyzer seperti `unnecessary_non_null_assertion`, `withOpacity`, dan beberapa deprecation API Flutter terbaru
- hardening error handling dan retry state per screen

## Catatan penting

Client role check di Flutter hanya dipakai untuk routing dan tampilan UI. Hak akses sebenarnya harus tetap dikunci oleh RLS di database Supabase.

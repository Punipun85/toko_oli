# OliMart Supabase Schema

Dokumen ini menjelaskan schema ecommerce additive untuk OliMart. Migration ini dirancang agar **tidak mengganggu data yang sudah ada** pada tabel lama seperti `public.produk`, `public.kategori`, dan `public.merk`.

## File migration

- `supabase/migrations/20260504223000_create_olimart_ecommerce_schema.sql`
- `supabase/migrations/20260504224000_create_olimart_storage_and_storage_policies.sql`
- `supabase/migrations/20260504225000_seed_olimart_ecommerce.sql`

## Cara menjalankan migration

Jalankan dari root project:

```powershell
supabase db push
```

Jika ingin reset database lokal lalu menerapkan semua migration dari awal:

```powershell
supabase db reset
```

Catatan:

- Migration baru ini bersifat additive dan tidak melakukan `drop` atau `truncate` pada data ecommerce lama.
- Jika database remote sudah berisi data produksi, gunakan `supabase db push`, bukan `db reset`.

## Cara seed database

Seed sample untuk brands, categories, products, variants, oil recommendations, articles, store settings, dan role permissions sudah dimasukkan ke migration:

- `20260504225000_seed_olimart_ecommerce.sql`

Untuk database yang belum pernah menerima migration ini:

```powershell
supabase db push
```

Untuk environment lokal yang ingin dibangun ulang dari nol:

```powershell
supabase db reset
```

## Cara set role admin

Role disimpan di tabel `public.profiles`.

```sql
update public.profiles
set
  role = 'admin',
  account_type = 'regular'
where email = 'admin@olimart.com';
```

Atau berdasarkan `auth.users.id`:

```sql
update public.profiles
set role = 'admin'
where id = 'USER_UUID_HERE';
```

## Cara set role courier

```sql
update public.profiles
set
  role = 'courier',
  account_type = 'regular'
where email = 'courier@olimart.com';
```

## Cara connect Flutter ke Supabase

Gunakan `.env` di Flutter client:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=sb_publishable_your_public_anon_key
```

Inisialisasi di `main.dart`:

```dart
await Supabase.initialize(
  url: SupabaseConfig.url,
  anonKey: SupabaseConfig.anonKey,
);
```

## Key yang aman untuk Flutter client

Yang aman dipakai di Flutter:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY` atau publishable client key

Yang **tidak aman** dipakai di Flutter:

- `service_role` key
- database password
- access token admin backend

## Kenapa service role key tidak boleh dipakai di Flutter

`service_role` key melewati Row Level Security. Kalau key itu ditanam di aplikasi Flutter:

- siapa pun yang membongkar APK/IPA bisa mengambil key tersebut
- attacker bisa membaca, mengubah, atau menghapus data database
- storage bucket privat juga bisa ikut terekspos

Karena itu:

- Flutter hanya boleh memakai `anon` atau publishable key
- operasi admin harus dijalankan dari backend aman, Edge Function, atau server internal

## Ringkasan RLS

Schema ini sudah menambahkan RLS untuk kebutuhan utama:

- customer membaca produk, brand, category aktif
- customer mengelola cart, address, vehicle profile, reminder miliknya
- customer membaca order miliknya dan membuat order untuk dirinya sendiri
- customer membuat review hanya bila pernah memiliki order selesai
- admin mengelola catalog, orders, promos, stock, articles, reviews, dan data operasional
- courier membaca assignment miliknya dan mengubah status pengiriman untuk assignment tersebut

## Storage buckets

Buckets yang dibuat:

- `product-images`
- `article-images`
- `review-images`
- `delivery-proofs`
- `store-assets`

Kebijakan storage:

- publik dapat membaca `product-images` dan `article-images`
- admin dapat upload ke `product-images`, `article-images`, dan `store-assets`
- user terautentikasi dapat upload `review-images` untuk review miliknya
- courier dapat upload `delivery-proofs` untuk assignment pengiriman miliknya

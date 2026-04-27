# Supabase Linking Guide

Project ini sudah disiapkan untuk dihubungkan ke Supabase project dengan ref `cyuepjhmvrtyhsidfvhm`.

## Yang Masih Dibutuhkan
- Supabase CLI
- Supabase Personal Access Token
- Database password untuk project Supabase

## Langkah Setelah CLI Tersedia
Jalankan dari root project:

```powershell
npx supabase login
npx supabase link --project-ref cyuepjhmvrtyhsidfvhm
```

Jika diminta password database, masukkan password database project Supabase, bukan publishable key.

## Verifikasi
Setelah berhasil link, jalankan:

```powershell
npx supabase db push
```

Atau untuk menarik schema remote:

```powershell
npx supabase db pull
```

## Struktur Lokal yang Sudah Disiapkan
- `supabase/config.toml`
- `supabase/migrations/20260427153000_initial_schema.sql`
- `supabase/seed.sql`

## Catatan
- `supabase/seed.sql` hanya berisi data seed, mengikuti praktik yang direkomendasikan Supabase.
- Schema tabel ada di file migration agar lebih cocok untuk workflow CLI.

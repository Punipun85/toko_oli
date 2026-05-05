alter table public.kategori enable row level security;
alter table public.merk enable row level security;
alter table public.produk enable row level security;

drop policy if exists "Public read kategori" on public.kategori;
create policy "Public read kategori"
on public.kategori
for select
to anon, authenticated
using (true);

drop policy if exists "Public read merk" on public.merk;
create policy "Public read merk"
on public.merk
for select
to anon, authenticated
using (true);

drop policy if exists "Public read produk" on public.produk;
create policy "Public read produk"
on public.produk
for select
to anon, authenticated
using (true);

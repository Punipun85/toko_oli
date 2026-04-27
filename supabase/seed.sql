insert into public.kategori (id_kategori, nama_kategori) values
  (1, 'Oli Motor 4T'),
  (2, 'Oli Motor 2T'),
  (3, 'Oli Mobil'),
  (4, 'Transmisi')
on conflict (id_kategori) do update
set nama_kategori = excluded.nama_kategori;

insert into public.merk (id_merk, nama_merk) values
  (1, 'Pertamina'),
  (2, 'Shell'),
  (3, 'Motul'),
  (4, 'Castrol')
on conflict (id_merk) do update
set nama_merk = excluded.nama_merk;

insert into public.produk (
  id_produk,
  id_kategori,
  id_merk,
  nama_produk,
  harga,
  sae,
  volume,
  tipe,
  deskripsi,
  gambar
) values
  (1, 1, 1, 'Enduro 4T Racing', 55000.00, '10W-40', '1 Liter', 'Semi-Sintetis', 'Oli pelumas mesin motor 4 tak berkualitas tinggi.', 'enduro_4t.jpg'),
  (2, 1, 2, 'Shell Advance AX7', 65000.00, '10W-40', '800 ml', 'Sintetis', 'Meningkatkan performa standar sepeda motor.', 'shell_ax7.jpg'),
  (3, 3, 3, 'Motul 3100 Gold', 80000.00, '15W-50', '1 Liter', 'Technosynthese', 'Diformulasikan untuk keawetan mesin.', 'motul_3100.jpg')
on conflict (id_produk) do update
set
  id_kategori = excluded.id_kategori,
  id_merk = excluded.id_merk,
  nama_produk = excluded.nama_produk,
  harga = excluded.harga,
  sae = excluded.sae,
  volume = excluded.volume,
  tipe = excluded.tipe,
  deskripsi = excluded.deskripsi,
  gambar = excluded.gambar;

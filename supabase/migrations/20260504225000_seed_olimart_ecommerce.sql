insert into public.brands (id, name, slug, description, is_active)
values
  ('10000000-0000-0000-0000-000000000001', 'Pertamina', 'pertamina', 'Official Pertamina lubricants line.', true),
  ('10000000-0000-0000-0000-000000000002', 'Shell', 'shell', 'Shell automotive lubricants.', true),
  ('10000000-0000-0000-0000-000000000003', 'Castrol', 'castrol', 'Castrol lubricants and fluids.', true),
  ('10000000-0000-0000-0000-000000000004', 'Federal Oil', 'federal-oil', 'Federal Oil motorcycle lubricants.', true),
  ('10000000-0000-0000-0000-000000000005', 'Motul', 'motul', 'Motul performance lubricants.', true),
  ('10000000-0000-0000-0000-000000000006', 'AHM', 'ahm', 'Astra Honda Motor genuine oil products.', true)
on conflict (id) do update
set
  name = excluded.name,
  slug = excluded.slug,
  description = excluded.description,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

insert into public.categories (id, name, slug, description, sort_order, is_active)
values
  ('20000000-0000-0000-0000-000000000001', 'Oli Motor', 'oli-motor', 'Pelumas untuk motor matic, sport, dan bebek.', 1, true),
  ('20000000-0000-0000-0000-000000000002', 'Oli Mobil', 'oli-mobil', 'Pelumas untuk mesin bensin mobil.', 2, true),
  ('20000000-0000-0000-0000-000000000003', 'Oli Diesel', 'oli-diesel', 'Pelumas untuk kendaraan diesel dan niaga.', 3, true),
  ('20000000-0000-0000-0000-000000000004', 'Transmisi', 'transmisi', 'ATF dan gear oil.', 4, true),
  ('20000000-0000-0000-0000-000000000005', 'Coolant', 'coolant', 'Cairan pendingin radiator.', 5, true),
  ('20000000-0000-0000-0000-000000000006', 'Grease', 'grease', 'Gemuk dan grease untuk kendaraan.', 6, true)
on conflict (id) do update
set
  name = excluded.name,
  slug = excluded.slug,
  description = excluded.description,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

insert into public.products (
  id,
  brand_id,
  category_id,
  name,
  slug,
  description,
  short_description,
  viscosity,
  vehicle_type,
  engine_type,
  product_type,
  series,
  status,
  is_active,
  is_featured
) values
  ('30000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Pertamina Enduro Matic-G SAE 20W-40', 'pertamina-enduro-matic-g-sae-20w-40', 'Pelumas motor matic mineral untuk penggunaan harian dengan proteksi suhu kerja stabil.', 'Oli motor matic mineral harian.', '20W-40', array['motor', 'matic'], array['4-stroke'], 'Motorcycle Oil', 'Enduro', 'active', true, true),
  ('30000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'Pertamina Enduro 4T Racing SAE 10W-40', 'pertamina-enduro-4t-racing-sae-10w-40', 'Pelumas semi synthetic untuk motor sport dan harian dengan akselerasi responsif.', 'Oli motor sport semi synthetic.', '10W-40', array['motor', 'sport'], array['4-stroke'], 'Motorcycle Oil', 'Enduro', 'active', true, true),
  ('30000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'Pertamina Fastron Techno SAE 10W-40', 'pertamina-fastron-techno-sae-10w-40', 'Pelumas mobil semi synthetic untuk mesin bensin modern dan pemakaian harian.', 'Oli mobil semi synthetic.', '10W-40', array['mobil'], array['gasoline'], 'Engine Oil', 'Fastron', 'active', true, true),
  ('30000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'Pertamina Fastron Gold SAE 5W-30', 'pertamina-fastron-gold-sae-5w-30', 'Pelumas full synthetic premium untuk mesin bensin modern dengan fokus efisiensi bahan bakar.', 'Oli mobil full synthetic premium.', '5W-30', array['mobil'], array['gasoline'], 'Engine Oil', 'Fastron', 'active', true, true),
  ('30000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'Shell Helix HX7 SAE 10W-40', 'shell-helix-hx7-sae-10w-40', 'Pelumas sintetik untuk mobil bensin dengan perlindungan sludge yang baik.', 'Oli mobil Shell HX7.', '10W-40', array['mobil'], array['gasoline'], 'Engine Oil', 'Helix', 'active', true, false),
  ('30000000-0000-0000-0000-000000000006', '10000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000001', 'Castrol Power1 SAE 10W-40', 'castrol-power1-sae-10w-40', 'Pelumas motor untuk tarikan ringan dan akselerasi agresif.', 'Oli motor Castrol Power1.', '10W-40', array['motor'], array['4-stroke'], 'Motorcycle Oil', 'Power1', 'active', true, false),
  ('30000000-0000-0000-0000-000000000007', '10000000-0000-0000-0000-000000000004', '20000000-0000-0000-0000-000000000001', 'Federal Matic 30', 'federal-matic-30', 'Pelumas untuk motor matic harian dengan formula hemat dan stabil.', 'Oli motor Federal Matic.', '10W-30', array['motor', 'matic'], array['4-stroke'], 'Motorcycle Oil', 'Federal Matic', 'active', true, false),
  ('30000000-0000-0000-0000-000000000008', '10000000-0000-0000-0000-000000000005', '20000000-0000-0000-0000-000000000001', 'Motul Scooter LE SAE 10W-30', 'motul-scooter-le-sae-10w-30', 'Pelumas motor skuter untuk efisiensi dan perlindungan temperatur tinggi.', 'Oli skuter Motul.', '10W-30', array['motor', 'scooter'], array['4-stroke'], 'Motorcycle Oil', 'Scooter LE', 'active', true, false),
  ('30000000-0000-0000-0000-000000000009', '10000000-0000-0000-0000-000000000006', '20000000-0000-0000-0000-000000000001', 'AHM MPX2', 'ahm-mpx2', 'Pelumas resmi Honda untuk motor bebek dan sport harian.', 'Oli resmi Honda MPX2.', '10W-30', array['motor'], array['4-stroke'], 'Motorcycle Oil', 'MPX', 'active', true, false),
  ('30000000-0000-0000-0000-000000000010', '10000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000003', 'Pertamina Meditran SX Bio SAE 15W-40', 'pertamina-meditran-sx-bio-sae-15w-40', 'Pelumas diesel untuk kendaraan niaga dan operasional workshop.', 'Oli diesel heavy duty.', '15W-40', array['diesel', 'truck'], array['diesel'], 'Diesel Engine Oil', 'Meditran', 'active', true, true)
on conflict (id) do update
set
  brand_id = excluded.brand_id,
  category_id = excluded.category_id,
  name = excluded.name,
  slug = excluded.slug,
  description = excluded.description,
  short_description = excluded.short_description,
  viscosity = excluded.viscosity,
  vehicle_type = excluded.vehicle_type,
  engine_type = excluded.engine_type,
  product_type = excluded.product_type,
  series = excluded.series,
  status = excluded.status,
  is_active = excluded.is_active,
  is_featured = excluded.is_featured,
  updated_at = timezone('utc', now());

insert into public.product_variants (
  id,
  product_id,
  name,
  slug,
  sku,
  barcode,
  volume_label,
  pack_type,
  unit_count,
  volume_liters,
  price,
  cost_price,
  stock_quantity,
  reserved_stock,
  minimum_stock,
  reorder_stock_level,
  is_stock_tracked,
  allow_backorder,
  stock_validation_status,
  is_active
) values
  ('40000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '0.8L', '0-8l', 'OLI-ENDURO-MG-08', '899990000001', '0.8L', 'Bottle', 1, 0.8, 44900, 38000, 32, 4, 8, 12, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '6 x 1L', '6x1l', 'OLI-ENDURO-MG-6X1', '899990000002', '6 x 1L', 'Case', 6, 6.0, 324600, 280000, 12, 2, 4, 8, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000002', '1L', '1l', 'OLI-ENDURO-RACE-1L', '899990000003', '1L', 'Bottle', 1, 1.0, 67450, 54000, 26, 3, 6, 10, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000002', '6 x 1L', '6x1l', 'OLI-ENDURO-RACE-6X1', '899990000004', '6 x 1L', 'Case', 6, 6.0, 404700, 336000, 10, 1, 4, 8, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000005', '30000000-0000-0000-0000-000000000003', '1L', '1l', 'OLI-FASTRON-TECH-1L', '899990000005', '1L', 'Bottle', 1, 1.0, 79800, 65000, 20, 2, 6, 10, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000006', '30000000-0000-0000-0000-000000000003', '4L', '4l', 'OLI-FASTRON-TECH-4L', '899990000006', '4L', 'Bottle', 1, 4.0, 311000, 260000, 8, 1, 4, 6, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000007', '30000000-0000-0000-0000-000000000004', '1L', '1l', 'OLI-FASTRON-GOLD-1L', '899990000007', '1L', 'Bottle', 1, 1.0, 142850, 118000, 16, 2, 5, 8, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000008', '30000000-0000-0000-0000-000000000004', '4 x 5L', '4x5l', 'OLI-FASTRON-GOLD-4X5', '899990000008', '4 x 5L', 'Case', 4, 20.0, 3294000, 2860000, 3, 0, 2, 3, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000009', '30000000-0000-0000-0000-000000000005', '1L', '1l', 'OLI-SHELL-HX7-1L', '899990000009', '1L', 'Bottle', 1, 1.0, 128000, 105000, 14, 1, 4, 6, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000010', '30000000-0000-0000-0000-000000000006', '1L', '1l', 'OLI-CASTROL-P1-1L', '899990000010', '1L', 'Bottle', 1, 1.0, 82500, 68000, 18, 2, 5, 8, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000011', '30000000-0000-0000-0000-000000000007', '0.8L', '0-8l', 'OLI-FED-MATIC30-08', '899990000011', '0.8L', 'Bottle', 1, 0.8, 56000, 45000, 22, 3, 6, 10, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000012', '30000000-0000-0000-0000-000000000008', '1L', '1l', 'OLI-MOTUL-SCOOTER-1L', '899990000012', '1L', 'Bottle', 1, 1.0, 102500, 84000, 12, 2, 5, 8, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000013', '30000000-0000-0000-0000-000000000009', '0.8L', '0-8l', 'OLI-AHM-MPX2-08', '899990000013', '0.8L', 'Bottle', 1, 0.8, 62000, 51000, 24, 2, 6, 10, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000014', '30000000-0000-0000-0000-000000000010', '20L', '20l', 'OLI-MEDITRAN-SX-20L', '899990000014', '20L', 'Pail', 1, 20.0, 628200, 540000, 5, 1, 3, 5, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000015', '30000000-0000-0000-0000-000000000010', 'Drum', 'drum', 'OLI-MEDITRAN-SX-DRUM', '899990000015', 'Drum', 'Drum', 1, 200.0, 5250000, 4600000, 1, 0, 1, 2, true, false, 'validated', true),
  ('40000000-0000-0000-0000-000000000016', '30000000-0000-0000-0000-000000000004', '10L', '10l', 'OLI-FASTRON-GOLD-10L', '899990000016', '10L', 'Pail', 1, 10.0, 1647000, 1440000, 4, 1, 2, 3, true, false, 'validated', true)
on conflict (id) do update
set
  product_id = excluded.product_id,
  name = excluded.name,
  slug = excluded.slug,
  sku = excluded.sku,
  barcode = excluded.barcode,
  volume_label = excluded.volume_label,
  pack_type = excluded.pack_type,
  unit_count = excluded.unit_count,
  volume_liters = excluded.volume_liters,
  price = excluded.price,
  cost_price = excluded.cost_price,
  stock_quantity = excluded.stock_quantity,
  reserved_stock = excluded.reserved_stock,
  minimum_stock = excluded.minimum_stock,
  reorder_stock_level = excluded.reorder_stock_level,
  is_stock_tracked = excluded.is_stock_tracked,
  allow_backorder = excluded.allow_backorder,
  stock_validation_status = excluded.stock_validation_status,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

insert into public.product_images (
  id,
  product_id,
  variant_id,
  image_url,
  storage_path,
  alt_text,
  is_primary,
  sort_order
) values
  ('50000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', null, 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/product-images/enduro-4t-matic-g.svg', 'product-images/enduro-4t-matic-g.svg', 'Pertamina Enduro Matic-G', true, 1),
  ('50000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', null, 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/product-images/enduro-racing-platinum.svg', 'product-images/enduro-racing-platinum.svg', 'Pertamina Enduro 4T Racing', true, 1),
  ('50000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000003', null, 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/product-images/fastron-techno-sn-10w-40.svg', 'product-images/fastron-techno-sn-10w-40.svg', 'Pertamina Fastron Techno', true, 1),
  ('50000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000004', null, 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/product-images/fastron-gold-sm-0w-20.svg', 'product-images/fastron-gold-sm-0w-20.svg', 'Pertamina Fastron Gold', true, 1),
  ('50000000-0000-0000-0000-000000000005', '30000000-0000-0000-0000-000000000010', null, 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/product-images/meditran-sx.png', 'product-images/meditran-sx.png', 'Pertamina Meditran SX Bio', true, 1)
on conflict (id) do update
set
  product_id = excluded.product_id,
  variant_id = excluded.variant_id,
  image_url = excluded.image_url,
  storage_path = excluded.storage_path,
  alt_text = excluded.alt_text,
  is_primary = excluded.is_primary,
  sort_order = excluded.sort_order,
  updated_at = timezone('utc', now());

insert into public.oil_recommendations (
  id,
  vehicle_type,
  engine_type,
  vehicle_brand,
  vehicle_model,
  product_id,
  variant_id,
  notes,
  priority,
  is_active
) values
  ('60000000-0000-0000-0000-000000000001', 'motor', '4-stroke', 'Honda', 'Vario 150', '30000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000001', 'Direkomendasikan untuk skuter harian dengan kebutuhan pelumasan stabil.', 10, true),
  ('60000000-0000-0000-0000-000000000002', 'motor', '4-stroke', 'Yamaha', 'NMAX', '30000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000003', 'Pilihan untuk riding harian dan akselerasi responsif.', 9, true),
  ('60000000-0000-0000-0000-000000000003', 'mobil', 'gasoline', 'Toyota', 'Avanza', '30000000-0000-0000-0000-000000000003', '40000000-0000-0000-0000-000000000006', 'Cocok untuk MPV harian dengan interval servis reguler.', 8, true),
  ('60000000-0000-0000-0000-000000000004', 'mobil', 'gasoline', 'Honda', 'Brio', '30000000-0000-0000-0000-000000000004', '40000000-0000-0000-0000-000000000007', 'Direkomendasikan untuk efisiensi bahan bakar dan perlindungan mesin.', 10, true),
  ('60000000-0000-0000-0000-000000000005', 'diesel', 'diesel', 'Mitsubishi', 'L300', '30000000-0000-0000-0000-000000000010', '40000000-0000-0000-0000-000000000014', 'Direkomendasikan untuk kendaraan niaga dan operasional workshop.', 10, true)
on conflict (id) do update
set
  vehicle_type = excluded.vehicle_type,
  engine_type = excluded.engine_type,
  vehicle_brand = excluded.vehicle_brand,
  vehicle_model = excluded.vehicle_model,
  product_id = excluded.product_id,
  variant_id = excluded.variant_id,
  notes = excluded.notes,
  priority = excluded.priority,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

insert into public.articles (
  id,
  title,
  slug,
  excerpt,
  content,
  cover_image_url,
  tags,
  status,
  published_at
) values
  ('70000000-0000-0000-0000-000000000001', 'Cara Memilih Oli yang Sesuai dengan Jenis Kendaraan', 'cara-memilih-oli-yang-sesuai-dengan-jenis-kendaraan', 'Panduan singkat memilih viskositas dan tipe oli berdasarkan kendaraan.', 'Memilih oli yang tepat dimulai dari memahami viskositas, jenis mesin, dan pola pemakaian kendaraan. Untuk motor matic harian, fokuslah pada oli yang menjaga suhu dan respons CVT. Untuk mobil bensin modern, pertimbangkan oli full synthetic dengan viskositas rendah agar efisien dan tetap aman di suhu tinggi.', 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/article-images/choosing-oil-guide.jpg', array['panduan', 'oli', 'edukasi'], 'published', timezone('utc', now())),
  ('70000000-0000-0000-0000-000000000002', 'Tanda Oli Harus Segera Diganti', 'tanda-oli-harus-segera-diganti', 'Gejala umum yang menandakan oli dan filter butuh servis.', 'Beberapa tanda oli perlu diganti antara lain suara mesin lebih kasar, akselerasi terasa berat, dan warna oli terlalu pekat. Kendaraan operasional seperti motor kurir dan armada workshop juga perlu interval yang lebih ketat karena jam kerja yang tinggi.', 'https://cyuepjhmvrtyhsidfvhm.supabase.co/storage/v1/object/public/article-images/oil-change-signs.jpg', array['servis', 'perawatan'], 'published', timezone('utc', now()))
on conflict (id) do update
set
  title = excluded.title,
  slug = excluded.slug,
  excerpt = excluded.excerpt,
  content = excluded.content,
  cover_image_url = excluded.cover_image_url,
  tags = excluded.tags,
  status = excluded.status,
  published_at = excluded.published_at,
  updated_at = timezone('utc', now());

insert into public.store_settings (id, key, value, description)
values
  ('80000000-0000-0000-0000-000000000001', 'store_profile', '{"name":"OliMart","support_whatsapp":"+6281234567890","support_email":"support@olimart.local","currency":"IDR"}'::jsonb, 'Profil dasar toko.'),
  ('80000000-0000-0000-0000-000000000002', 'shipping', '{"default_courier":"Internal Courier","free_shipping_threshold":500000,"service_fee":12000}'::jsonb, 'Pengaturan pengiriman dan biaya layanan.'),
  ('80000000-0000-0000-0000-000000000003', 'inventory', '{"low_stock_threshold":5,"enable_backorder":false,"stock_validation_required":true}'::jsonb, 'Pengaturan inventaris dasar.'),
  ('80000000-0000-0000-0000-000000000004', 'content', '{"homepage_headline":"Premium engine care for daily drivers","show_articles":true}'::jsonb, 'Pengaturan konten storefront.')
on conflict (id) do update
set
  key = excluded.key,
  value = excluded.value,
  description = excluded.description,
  updated_at = timezone('utc', now());

insert into public.role_permissions (id, role, permission_key, is_allowed)
values
  ('90000000-0000-0000-0000-000000000001', 'admin', 'catalog.manage', true),
  ('90000000-0000-0000-0000-000000000002', 'admin', 'orders.manage', true),
  ('90000000-0000-0000-0000-000000000003', 'admin', 'reports.read', true),
  ('90000000-0000-0000-0000-000000000004', 'courier', 'delivery.update_status', true),
  ('90000000-0000-0000-0000-000000000005', 'customer', 'cart.manage', true)
on conflict (id) do update
set
  role = excluded.role,
  permission_key = excluded.permission_key,
  is_allowed = excluded.is_allowed,
  updated_at = timezone('utc', now());

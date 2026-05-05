update public.produk
set gambar = replace(
  gambar,
  '/storage/v1/object/public/product-images/',
  '/storage/v1/object/public/product-images/product-images/'
)
where gambar like '%/storage/v1/object/public/product-images/%'
  and gambar not like '%/storage/v1/object/public/product-images/product-images/%';

insert into storage.buckets (id, name, public)
values
  ('product-images', 'product-images', true),
  ('article-images', 'article-images', true),
  ('review-images', 'review-images', false),
  ('delivery-proofs', 'delivery-proofs', false),
  ('store-assets', 'store-assets', false)
on conflict (id) do update
set public = excluded.public;

drop policy if exists "storage_public_read_product_images" on storage.objects;
create policy "storage_public_read_product_images"
on storage.objects
for select
to public
using (bucket_id = 'product-images');

drop policy if exists "storage_public_read_article_images" on storage.objects;
create policy "storage_public_read_article_images"
on storage.objects
for select
to public
using (bucket_id = 'article-images');

drop policy if exists "storage_admin_upload_product_images" on storage.objects;
create policy "storage_admin_upload_product_images"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'product-images' and public.is_admin());

drop policy if exists "storage_admin_update_product_images" on storage.objects;
create policy "storage_admin_update_product_images"
on storage.objects
for update
to authenticated
using (bucket_id = 'product-images' and public.is_admin())
with check (bucket_id = 'product-images' and public.is_admin());

drop policy if exists "storage_admin_upload_article_images" on storage.objects;
create policy "storage_admin_upload_article_images"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'article-images' and public.is_admin());

drop policy if exists "storage_admin_update_article_images" on storage.objects;
create policy "storage_admin_update_article_images"
on storage.objects
for update
to authenticated
using (bucket_id = 'article-images' and public.is_admin())
with check (bucket_id = 'article-images' and public.is_admin());

drop policy if exists "storage_admin_manage_store_assets" on storage.objects;
create policy "storage_admin_manage_store_assets"
on storage.objects
for all
to authenticated
using (bucket_id = 'store-assets' and public.is_admin())
with check (bucket_id = 'store-assets' and public.is_admin());

drop policy if exists "storage_review_images_insert_own_review" on storage.objects;
create policy "storage_review_images_insert_own_review"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'review-images'
  and (storage.foldername(name))[1] = auth.uid()::text
  and exists (
    select 1
    from public.reviews r
    where r.id = public.try_uuid((storage.foldername(name))[2])
      and r.user_id = auth.uid()
  )
);

drop policy if exists "storage_review_images_read_own_or_admin" on storage.objects;
create policy "storage_review_images_read_own_or_admin"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'review-images'
  and (
    public.is_admin()
    or (storage.foldername(name))[1] = auth.uid()::text
  )
);

drop policy if exists "storage_delivery_proofs_insert_assigned" on storage.objects;
create policy "storage_delivery_proofs_insert_assigned"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'delivery-proofs'
  and public.is_courier()
  and exists (
    select 1
    from public.delivery_assignments da
    where da.id = public.try_uuid((storage.foldername(name))[1])
      and da.courier_id = auth.uid()
  )
);

drop policy if exists "storage_delivery_proofs_read_assigned" on storage.objects;
create policy "storage_delivery_proofs_read_assigned"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'delivery-proofs'
  and (
    public.is_admin()
    or exists (
      select 1
      from public.delivery_assignments da
      where da.id = public.try_uuid((storage.foldername(name))[1])
        and da.courier_id = auth.uid()
    )
  )
);

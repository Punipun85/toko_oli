create table if not exists public.wishlist_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint wishlist_items_unique unique (user_id, product_id)
);

create index if not exists idx_wishlist_items_user_id on public.wishlist_items(user_id);
create index if not exists idx_wishlist_items_product_id on public.wishlist_items(product_id);

drop trigger if exists trg_wishlist_items_updated_at on public.wishlist_items;
create trigger trg_wishlist_items_updated_at
before update on public.wishlist_items
for each row execute procedure public.set_updated_at();

alter table public.wishlist_items enable row level security;

drop policy if exists "wishlist_items_own_manage" on public.wishlist_items;
create policy "wishlist_items_own_manage"
on public.wishlist_items
for all
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

alter table public.reviews
  add column if not exists admin_reply text,
  add column if not exists admin_replied_at timestamptz,
  add column if not exists admin_replied_by uuid references public.profiles(id) on delete set null;

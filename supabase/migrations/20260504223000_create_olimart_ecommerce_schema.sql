create extension if not exists pgcrypto;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'profile_role') then
    create type public.profile_role as enum ('customer', 'admin', 'courier');
  end if;

  if not exists (select 1 from pg_type where typname = 'account_type') then
    create type public.account_type as enum ('regular', 'workshop', 'spare_part_shop', 'wholesale');
  end if;

  if not exists (select 1 from pg_type where typname = 'product_status') then
    create type public.product_status as enum ('draft', 'active', 'archived');
  end if;

  if not exists (select 1 from pg_type where typname = 'cart_status') then
    create type public.cart_status as enum ('active', 'ordered', 'abandoned');
  end if;

  if not exists (select 1 from pg_type where typname = 'address_type') then
    create type public.address_type as enum ('home', 'office', 'workshop', 'warehouse', 'other');
  end if;

  if not exists (select 1 from pg_type where typname = 'order_status') then
    create type public.order_status as enum ('draft', 'pending', 'confirmed', 'processing', 'shipped', 'completed', 'cancelled', 'refunded');
  end if;

  if not exists (select 1 from pg_type where typname = 'payment_status') then
    create type public.payment_status as enum ('unpaid', 'pending', 'paid', 'failed', 'expired', 'refunded', 'partially_refunded');
  end if;

  if not exists (select 1 from pg_type where typname = 'delivery_status') then
    create type public.delivery_status as enum ('pending', 'ready_to_ship', 'assigned', 'picked_up', 'in_transit', 'delivered', 'failed', 'returned');
  end if;

  if not exists (select 1 from pg_type where typname = 'return_refund_status') then
    create type public.return_refund_status as enum ('requested', 'approved', 'rejected', 'picked_up', 'received', 'refunded', 'closed');
  end if;

  if not exists (select 1 from pg_type where typname = 'promo_type') then
    create type public.promo_type as enum ('percentage', 'fixed_amount', 'free_shipping');
  end if;

  if not exists (select 1 from pg_type where typname = 'stock_movement_type') then
    create type public.stock_movement_type as enum ('initial', 'purchase', 'sale', 'adjustment', 'return_in', 'return_out', 'damaged', 'reserved', 'released');
  end if;

  if not exists (select 1 from pg_type where typname = 'notification_type') then
    create type public.notification_type as enum ('order', 'promo', 'system', 'reminder', 'chat');
  end if;

  if not exists (select 1 from pg_type where typname = 'notification_status') then
    create type public.notification_status as enum ('unread', 'read', 'archived');
  end if;

  if not exists (select 1 from pg_type where typname = 'chat_sender_type') then
    create type public.chat_sender_type as enum ('customer', 'admin', 'courier', 'system');
  end if;

  if not exists (select 1 from pg_type where typname = 'chat_status') then
    create type public.chat_status as enum ('open', 'closed', 'resolved');
  end if;

  if not exists (select 1 from pg_type where typname = 'article_status') then
    create type public.article_status as enum ('draft', 'published', 'archived');
  end if;
end
$$;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create or replace function public.try_uuid(input text)
returns uuid
language plpgsql
immutable
as $$
begin
  return input::uuid;
exception
  when others then
    return null;
end;
$$;

create or replace function public.current_profile_role()
returns public.profile_role
language sql
stable
as $$
  select p.role
  from public.profiles p
  where p.id = auth.uid()
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select coalesce(public.current_profile_role() = 'admin', false)
$$;

create or replace function public.is_courier()
returns boolean
language sql
stable
as $$
  select coalesce(public.current_profile_role() = 'courier', false)
$$;

create or replace function public.is_completed_order_product(_user_id uuid, _product_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.orders o
    join public.order_items oi on oi.order_id = o.id
    where o.user_id = _user_id
      and oi.product_id = _product_id
      and o.order_status = 'completed'
  )
$$;

alter table if exists public.profiles
  add column if not exists role public.profile_role not null default 'customer',
  add column if not exists account_type public.account_type not null default 'regular',
  add column if not exists phone text,
  add column if not exists avatar_url text,
  add column if not exists is_active boolean not null default true,
  add column if not exists metadata jsonb not null default '{}'::jsonb;

create index if not exists idx_profiles_role on public.profiles(role);
create index if not exists idx_profiles_account_type on public.profiles(account_type);

create table if not exists public.brands (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  logo_url text,
  website_url text,
  country_origin text,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  image_url text,
  parent_id uuid references public.categories(id) on delete set null,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  brand_id uuid not null references public.brands(id) on delete restrict,
  category_id uuid not null references public.categories(id) on delete restrict,
  name text not null,
  slug text not null unique,
  description text,
  short_description text,
  viscosity text,
  vehicle_type text[] not null default '{}',
  engine_type text[] not null default '{}',
  product_type text,
  series text,
  search_brand text not null default '',
  search_name text not null default '',
  search_viscosity text not null default '',
  search_vehicle_type text not null default '',
  search_engine_type text not null default '',
  search_document tsvector generated always as (
    setweight(to_tsvector('simple', coalesce(search_name, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(search_brand, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(search_viscosity, '')), 'B') ||
    setweight(to_tsvector('simple', coalesce(search_vehicle_type, '')), 'B') ||
    setweight(to_tsvector('simple', coalesce(search_engine_type, '')), 'B')
  ) stored,
  status public.product_status not null default 'draft',
  is_active boolean not null default true,
  is_featured boolean not null default false,
  meta_title text,
  meta_description text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  name text not null,
  slug text not null,
  sku text not null unique,
  barcode text unique,
  volume_label text not null,
  pack_type text,
  unit_count integer not null default 1,
  volume_liters numeric(12, 3),
  price numeric(14, 2) not null default 0,
  cost_price numeric(14, 2),
  compare_at_price numeric(14, 2),
  currency_code text not null default 'IDR',
  stock_quantity integer not null default 0,
  reserved_stock integer not null default 0,
  minimum_stock integer not null default 0,
  reorder_stock_level integer not null default 0,
  is_stock_tracked boolean not null default true,
  allow_backorder boolean not null default false,
  stock_validation_status text not null default 'unchecked',
  stock_validation_notes text,
  stock_validated_at timestamptz,
  stock_validated_by uuid references public.profiles(id) on delete set null,
  weight_grams numeric(12, 2),
  dimensions jsonb not null default '{}'::jsonb,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint product_variants_non_negative_stock check (stock_quantity >= 0 and reserved_stock >= 0 and minimum_stock >= 0 and reorder_stock_level >= 0),
  constraint product_variants_reserved_lte_stock check (reserved_stock <= stock_quantity),
  constraint product_variants_unique_slug_per_product unique (product_id, slug)
);

create table if not exists public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  variant_id uuid references public.product_variants(id) on delete cascade,
  image_url text not null,
  storage_path text,
  alt_text text,
  is_primary boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.carts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  status public.cart_status not null default 'active',
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid not null references public.carts(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete restrict,
  variant_id uuid not null references public.product_variants(id) on delete restrict,
  quantity integer not null default 1,
  unit_price numeric(14, 2) not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint cart_items_positive_quantity check (quantity > 0),
  constraint cart_items_unique_variant_per_cart unique (cart_id, variant_id)
);

create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  label text not null,
  recipient_name text not null,
  phone text not null,
  address_line1 text not null,
  address_line2 text,
  district text,
  city text not null,
  province text not null,
  postal_code text not null,
  country text not null default 'Indonesia',
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  address_type public.address_type not null default 'home',
  is_default boolean not null default false,
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.promos (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text,
  promo_type public.promo_type not null,
  discount_value numeric(14, 2) not null default 0,
  minimum_order_amount numeric(14, 2) not null default 0,
  max_discount_amount numeric(14, 2),
  usage_limit integer,
  usage_count integer not null default 0,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete restrict,
  address_id uuid references public.addresses(id) on delete set null,
  promo_id uuid references public.promos(id) on delete set null,
  order_number text not null unique,
  order_status public.order_status not null default 'pending',
  payment_status public.payment_status not null default 'unpaid',
  delivery_status public.delivery_status not null default 'pending',
  subtotal numeric(14, 2) not null default 0,
  discount_total numeric(14, 2) not null default 0,
  shipping_total numeric(14, 2) not null default 0,
  service_fee numeric(14, 2) not null default 0,
  tax_total numeric(14, 2) not null default 0,
  grand_total numeric(14, 2) not null default 0,
  payment_method text,
  payment_reference text,
  courier_name text,
  courier_service text,
  tracking_number text,
  notes text,
  paid_at timestamptz,
  shipped_at timestamptz,
  delivered_at timestamptz,
  cancelled_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete restrict,
  variant_id uuid not null references public.product_variants(id) on delete restrict,
  product_name text not null,
  variant_name text not null,
  sku text,
  quantity integer not null default 1,
  unit_price numeric(14, 2) not null default 0,
  discount_amount numeric(14, 2) not null default 0,
  total_price numeric(14, 2) not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint order_items_positive_quantity check (quantity > 0)
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  order_id uuid not null references public.orders(id) on delete cascade,
  rating integer not null,
  title text,
  body text,
  image_urls text[] not null default '{}',
  is_published boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint reviews_rating_range check (rating between 1 and 5),
  constraint reviews_one_per_order_product unique (user_id, product_id, order_id)
);

create table if not exists public.vehicle_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  vehicle_type text not null,
  brand text,
  model text,
  year integer,
  engine_type text,
  engine_capacity_cc integer,
  current_odometer_km integer,
  plate_number text,
  notes text,
  is_default boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.oil_recommendations (
  id uuid primary key default gen_random_uuid(),
  vehicle_type text not null,
  engine_type text,
  vehicle_brand text,
  vehicle_model text,
  min_year integer,
  max_year integer,
  product_id uuid not null references public.products(id) on delete cascade,
  variant_id uuid references public.product_variants(id) on delete set null,
  notes text,
  priority integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.oil_change_reminders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  vehicle_profile_id uuid not null references public.vehicle_profiles(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  last_changed_at timestamptz,
  last_odometer_km integer,
  next_change_date date,
  next_change_odometer_km integer,
  reminder_days_before integer not null default 7,
  reminder_km_before integer not null default 500,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.stock_movements (
  id uuid primary key default gen_random_uuid(),
  variant_id uuid not null references public.product_variants(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  movement_type public.stock_movement_type not null,
  quantity integer not null,
  reference_type text,
  reference_id uuid,
  notes text,
  performed_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  type public.notification_type not null,
  title text not null,
  body text not null,
  data jsonb not null default '{}'::jsonb,
  status public.notification_status not null default 'unread',
  read_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.articles (
  id uuid primary key default gen_random_uuid(),
  author_id uuid references public.profiles(id) on delete set null,
  title text not null,
  slug text not null unique,
  excerpt text,
  content text not null,
  cover_image_url text,
  tags text[] not null default '{}',
  status public.article_status not null default 'draft',
  published_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.admin_chats (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id) on delete cascade,
  assigned_admin_id uuid references public.profiles(id) on delete set null,
  subject text not null,
  status public.chat_status not null default 'open',
  order_id uuid references public.orders(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid not null references public.admin_chats(id) on delete cascade,
  sender_user_id uuid references public.profiles(id) on delete set null,
  sender_type public.chat_sender_type not null,
  message text not null,
  attachment_urls text[] not null default '{}',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.store_settings (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  value jsonb not null default '{}'::jsonb,
  description text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.role_permissions (
  id uuid primary key default gen_random_uuid(),
  role public.profile_role not null,
  permission_key text not null,
  is_allowed boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint role_permissions_unique unique (role, permission_key)
);

create table if not exists public.delivery_assignments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  courier_id uuid not null references public.profiles(id) on delete cascade,
  assigned_by uuid references public.profiles(id) on delete set null,
  status public.delivery_status not null default 'assigned',
  assigned_at timestamptz not null default timezone('utc', now()),
  picked_up_at timestamptz,
  delivered_at timestamptz,
  proof_image_urls text[] not null default '{}',
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint delivery_assignments_one_active unique (order_id, courier_id)
);

create table if not exists public.return_refund_requests (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  order_item_id uuid references public.order_items(id) on delete set null,
  user_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null,
  details text,
  evidence_urls text[] not null default '{}',
  requested_amount numeric(14, 2),
  approved_amount numeric(14, 2),
  status public.return_refund_status not null default 'requested',
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists idx_brands_active on public.brands(is_active);
create index if not exists idx_categories_active on public.categories(is_active);
create index if not exists idx_categories_parent_id on public.categories(parent_id);
create index if not exists idx_products_brand_id on public.products(brand_id);
create index if not exists idx_products_category_id on public.products(category_id);
create index if not exists idx_products_status on public.products(status, is_active);
create index if not exists idx_products_name on public.products(name);
create index if not exists idx_products_viscosity on public.products(viscosity);
create index if not exists idx_products_search_brand on public.products(search_brand);
create index if not exists idx_products_search_vehicle_type on public.products using gin(vehicle_type);
create index if not exists idx_products_search_engine_type on public.products using gin(engine_type);
create index if not exists idx_products_search_document on public.products using gin(search_document);
create index if not exists idx_product_variants_product_id on public.product_variants(product_id);
create index if not exists idx_product_variants_minimum_stock on public.product_variants(minimum_stock);
create index if not exists idx_product_variants_stock on public.product_variants(stock_quantity, reserved_stock);
create index if not exists idx_product_images_product_id on public.product_images(product_id);
create index if not exists idx_product_images_variant_id on public.product_images(variant_id);
create index if not exists idx_carts_user_id on public.carts(user_id);
create unique index if not exists idx_carts_active_user on public.carts(user_id) where status = 'active';
create index if not exists idx_cart_items_cart_id on public.cart_items(cart_id);
create index if not exists idx_addresses_user_id on public.addresses(user_id);
create index if not exists idx_orders_user_id on public.orders(user_id);
create index if not exists idx_orders_status on public.orders(order_status, payment_status, delivery_status);
create index if not exists idx_orders_created_at on public.orders(created_at desc);
create index if not exists idx_orders_order_number on public.orders(order_number);
create index if not exists idx_order_items_order_id on public.order_items(order_id);
create index if not exists idx_order_items_product_id on public.order_items(product_id);
create index if not exists idx_reviews_product_id on public.reviews(product_id);
create index if not exists idx_reviews_user_id on public.reviews(user_id);
create index if not exists idx_vehicle_profiles_user_id on public.vehicle_profiles(user_id);
create index if not exists idx_oil_recommendations_lookup on public.oil_recommendations(vehicle_type, engine_type, is_active);
create index if not exists idx_oil_change_reminders_user_id on public.oil_change_reminders(user_id);
create index if not exists idx_oil_change_reminders_next_date on public.oil_change_reminders(next_change_date);
create index if not exists idx_promos_code on public.promos(code);
create index if not exists idx_stock_movements_variant_id on public.stock_movements(variant_id);
create index if not exists idx_stock_movements_created_at on public.stock_movements(created_at desc);
create index if not exists idx_notifications_user_id on public.notifications(user_id, status);
create index if not exists idx_articles_status on public.articles(status, published_at desc);
create index if not exists idx_admin_chats_customer_id on public.admin_chats(customer_id);
create index if not exists idx_chat_messages_chat_id on public.chat_messages(chat_id, created_at);
create index if not exists idx_role_permissions_role on public.role_permissions(role);
create index if not exists idx_delivery_assignments_order_id on public.delivery_assignments(order_id);
create index if not exists idx_delivery_assignments_courier_id on public.delivery_assignments(courier_id);
create index if not exists idx_return_refund_requests_order_id on public.return_refund_requests(order_id);
create index if not exists idx_return_refund_requests_user_id on public.return_refund_requests(user_id);

create or replace function public.populate_product_search_fields()
returns trigger
language plpgsql
as $$
declare
  _brand_name text;
begin
  select b.name into _brand_name
  from public.brands b
  where b.id = new.brand_id;

  new.search_brand = coalesce(_brand_name, new.search_brand, '');
  new.search_name = coalesce(new.name, '');
  new.search_viscosity = coalesce(new.viscosity, '');
  new.search_vehicle_type = coalesce(array_to_string(new.vehicle_type, ' '), '');
  new.search_engine_type = coalesce(array_to_string(new.engine_type, ' '), '');

  return new;
end;
$$;

drop trigger if exists trg_products_search_fields on public.products;
create trigger trg_products_search_fields
before insert or update on public.products
for each row execute procedure public.populate_product_search_fields();

drop trigger if exists trg_brands_updated_at on public.brands;
create trigger trg_brands_updated_at before update on public.brands for each row execute procedure public.set_updated_at();
drop trigger if exists trg_categories_updated_at on public.categories;
create trigger trg_categories_updated_at before update on public.categories for each row execute procedure public.set_updated_at();
drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at before update on public.products for each row execute procedure public.set_updated_at();
drop trigger if exists trg_product_variants_updated_at on public.product_variants;
create trigger trg_product_variants_updated_at before update on public.product_variants for each row execute procedure public.set_updated_at();
drop trigger if exists trg_product_images_updated_at on public.product_images;
create trigger trg_product_images_updated_at before update on public.product_images for each row execute procedure public.set_updated_at();
drop trigger if exists trg_carts_updated_at on public.carts;
create trigger trg_carts_updated_at before update on public.carts for each row execute procedure public.set_updated_at();
drop trigger if exists trg_cart_items_updated_at on public.cart_items;
create trigger trg_cart_items_updated_at before update on public.cart_items for each row execute procedure public.set_updated_at();
drop trigger if exists trg_addresses_updated_at on public.addresses;
create trigger trg_addresses_updated_at before update on public.addresses for each row execute procedure public.set_updated_at();
drop trigger if exists trg_promos_updated_at on public.promos;
create trigger trg_promos_updated_at before update on public.promos for each row execute procedure public.set_updated_at();
drop trigger if exists trg_orders_updated_at on public.orders;
create trigger trg_orders_updated_at before update on public.orders for each row execute procedure public.set_updated_at();
drop trigger if exists trg_order_items_updated_at on public.order_items;
create trigger trg_order_items_updated_at before update on public.order_items for each row execute procedure public.set_updated_at();
drop trigger if exists trg_reviews_updated_at on public.reviews;
create trigger trg_reviews_updated_at before update on public.reviews for each row execute procedure public.set_updated_at();
drop trigger if exists trg_vehicle_profiles_updated_at on public.vehicle_profiles;
create trigger trg_vehicle_profiles_updated_at before update on public.vehicle_profiles for each row execute procedure public.set_updated_at();
drop trigger if exists trg_oil_recommendations_updated_at on public.oil_recommendations;
create trigger trg_oil_recommendations_updated_at before update on public.oil_recommendations for each row execute procedure public.set_updated_at();
drop trigger if exists trg_oil_change_reminders_updated_at on public.oil_change_reminders;
create trigger trg_oil_change_reminders_updated_at before update on public.oil_change_reminders for each row execute procedure public.set_updated_at();
drop trigger if exists trg_stock_movements_updated_at on public.stock_movements;
create trigger trg_stock_movements_updated_at before update on public.stock_movements for each row execute procedure public.set_updated_at();
drop trigger if exists trg_notifications_updated_at on public.notifications;
create trigger trg_notifications_updated_at before update on public.notifications for each row execute procedure public.set_updated_at();
drop trigger if exists trg_articles_updated_at on public.articles;
create trigger trg_articles_updated_at before update on public.articles for each row execute procedure public.set_updated_at();
drop trigger if exists trg_admin_chats_updated_at on public.admin_chats;
create trigger trg_admin_chats_updated_at before update on public.admin_chats for each row execute procedure public.set_updated_at();
drop trigger if exists trg_chat_messages_updated_at on public.chat_messages;
create trigger trg_chat_messages_updated_at before update on public.chat_messages for each row execute procedure public.set_updated_at();
drop trigger if exists trg_store_settings_updated_at on public.store_settings;
create trigger trg_store_settings_updated_at before update on public.store_settings for each row execute procedure public.set_updated_at();
drop trigger if exists trg_role_permissions_updated_at on public.role_permissions;
create trigger trg_role_permissions_updated_at before update on public.role_permissions for each row execute procedure public.set_updated_at();
drop trigger if exists trg_delivery_assignments_updated_at on public.delivery_assignments;
create trigger trg_delivery_assignments_updated_at before update on public.delivery_assignments for each row execute procedure public.set_updated_at();
drop trigger if exists trg_return_refund_requests_updated_at on public.return_refund_requests;
create trigger trg_return_refund_requests_updated_at before update on public.return_refund_requests for each row execute procedure public.set_updated_at();

create or replace view public.low_stock_products as
select
  p.id as product_id,
  pv.id as variant_id,
  p.name as product_name,
  pv.name as variant_name,
  greatest(pv.stock_quantity - pv.reserved_stock, 0) as current_stock,
  pv.minimum_stock
from public.product_variants pv
join public.products p on p.id = pv.product_id
where pv.is_active = true
  and pv.is_stock_tracked = true
  and greatest(pv.stock_quantity - pv.reserved_stock, 0) <= pv.minimum_stock;

create or replace view public.best_selling_products as
select
  p.id as product_id,
  p.name as product_name,
  pv.name as variant,
  sum(oi.quantity) as units_sold,
  sum(oi.total_price) as revenue
from public.order_items oi
join public.orders o on o.id = oi.order_id
join public.products p on p.id = oi.product_id
join public.product_variants pv on pv.id = oi.variant_id
where o.payment_status in ('paid', 'partially_refunded', 'refunded')
group by p.id, p.name, pv.name;

create or replace view public.customer_order_summary as
select
  o.user_id as customer_id,
  count(*) as total_orders,
  coalesce(sum(o.grand_total), 0) as total_spending,
  max(o.created_at) as last_order_date
from public.orders o
group by o.user_id;

create or replace view public.admin_dashboard_summary as
select
  coalesce(sum(case when o.payment_status = 'paid' and o.created_at::date = current_date then o.grand_total end), 0) as today_sales,
  count(*) filter (where o.created_at::date = current_date) as new_orders,
  count(*) filter (where o.order_status in ('pending', 'confirmed', 'processing')) as orders_to_process,
  count(*) filter (where o.order_status = 'shipped' or o.delivery_status in ('in_transit', 'delivered')) as shipped_orders,
  (select count(*) from public.low_stock_products) as low_stock_products,
  (
    select count(*)
    from public.product_variants pv
    where pv.is_active = true
      and greatest(pv.stock_quantity - pv.reserved_stock, 0) <= 0
  ) as out_of_stock_products,
  coalesce(sum(case when o.payment_status = 'paid' and date_trunc('month', o.created_at) = date_trunc('month', now()) then o.grand_total end), 0) as monthly_revenue,
  (
    select count(*)
    from public.profiles p
    where p.role = 'customer'
      and date_trunc('month', p.created_at) = date_trunc('month', now())
  ) as new_customers
from public.orders o;

alter table public.brands enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_variants enable row level security;
alter table public.product_images enable row level security;
alter table public.carts enable row level security;
alter table public.cart_items enable row level security;
alter table public.addresses enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.reviews enable row level security;
alter table public.vehicle_profiles enable row level security;
alter table public.oil_recommendations enable row level security;
alter table public.oil_change_reminders enable row level security;
alter table public.promos enable row level security;
alter table public.stock_movements enable row level security;
alter table public.notifications enable row level security;
alter table public.articles enable row level security;
alter table public.admin_chats enable row level security;
alter table public.chat_messages enable row level security;
alter table public.store_settings enable row level security;
alter table public.role_permissions enable row level security;
alter table public.delivery_assignments enable row level security;
alter table public.return_refund_requests enable row level security;
alter table public.profiles enable row level security;

drop policy if exists "profiles_select_self_or_admin" on public.profiles;
create policy "profiles_select_self_or_admin"
on public.profiles
for select
to authenticated
using (auth.uid() = id or public.is_admin());

drop policy if exists "profiles_update_self_or_admin" on public.profiles;
create policy "profiles_update_self_or_admin"
on public.profiles
for update
to authenticated
using (auth.uid() = id or public.is_admin())
with check (auth.uid() = id or public.is_admin());

drop policy if exists "brands_read_active" on public.brands;
create policy "brands_read_active"
on public.brands
for select
to public
using (is_active = true or public.is_admin());

drop policy if exists "brands_admin_manage" on public.brands;
create policy "brands_admin_manage"
on public.brands
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "categories_read_active" on public.categories;
create policy "categories_read_active"
on public.categories
for select
to public
using (is_active = true or public.is_admin());

drop policy if exists "categories_admin_manage" on public.categories;
create policy "categories_admin_manage"
on public.categories
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "products_read_active" on public.products;
create policy "products_read_active"
on public.products
for select
to public
using ((is_active = true and status = 'active') or public.is_admin());

drop policy if exists "products_admin_manage" on public.products;
create policy "products_admin_manage"
on public.products
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "product_variants_read_active" on public.product_variants;
create policy "product_variants_read_active"
on public.product_variants
for select
to public
using (
  exists (
    select 1
    from public.products p
    where p.id = product_variants.product_id
      and ((p.is_active = true and p.status = 'active') or public.is_admin())
  )
);

drop policy if exists "product_variants_admin_manage" on public.product_variants;
create policy "product_variants_admin_manage"
on public.product_variants
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "product_images_read_active" on public.product_images;
create policy "product_images_read_active"
on public.product_images
for select
to public
using (
  exists (
    select 1
    from public.products p
    where p.id = product_images.product_id
      and ((p.is_active = true and p.status = 'active') or public.is_admin())
  )
);

drop policy if exists "product_images_admin_manage" on public.product_images;
create policy "product_images_admin_manage"
on public.product_images
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "carts_own_manage" on public.carts;
create policy "carts_own_manage"
on public.carts
for all
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "cart_items_own_manage" on public.cart_items;
create policy "cart_items_own_manage"
on public.cart_items
for all
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.carts c
    where c.id = cart_items.cart_id
      and c.user_id = auth.uid()
  )
)
with check (
  public.is_admin()
  or exists (
    select 1
    from public.carts c
    where c.id = cart_items.cart_id
      and c.user_id = auth.uid()
  )
);

drop policy if exists "addresses_own_manage" on public.addresses;
create policy "addresses_own_manage"
on public.addresses
for all
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "orders_own_read_or_admin_or_courier" on public.orders;
create policy "orders_own_read_or_admin_or_courier"
on public.orders
for select
to authenticated
using (
  public.is_admin()
  or auth.uid() = user_id
  or exists (
    select 1
    from public.delivery_assignments da
    where da.order_id = orders.id
      and da.courier_id = auth.uid()
  )
);

drop policy if exists "orders_own_insert" on public.orders;
create policy "orders_own_insert"
on public.orders
for insert
to authenticated
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "orders_admin_manage" on public.orders;
create policy "orders_admin_manage"
on public.orders
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "orders_courier_update_assigned" on public.orders;
create policy "orders_courier_update_assigned"
on public.orders
for update
to authenticated
using (
  public.is_courier()
  and exists (
    select 1
    from public.delivery_assignments da
    where da.order_id = orders.id
      and da.courier_id = auth.uid()
  )
)
with check (
  public.is_courier()
  and exists (
    select 1
    from public.delivery_assignments da
    where da.order_id = orders.id
      and da.courier_id = auth.uid()
  )
);

drop policy if exists "order_items_read_own_or_admin_or_courier" on public.order_items;
create policy "order_items_read_own_or_admin_or_courier"
on public.order_items
for select
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and (
        o.user_id = auth.uid()
        or exists (
          select 1
          from public.delivery_assignments da
          where da.order_id = o.id
            and da.courier_id = auth.uid()
        )
      )
  )
);

drop policy if exists "order_items_insert_own_or_admin" on public.order_items;
create policy "order_items_insert_own_or_admin"
on public.order_items
for insert
to authenticated
with check (
  public.is_admin()
  or exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.user_id = auth.uid()
  )
);

drop policy if exists "order_items_admin_manage" on public.order_items;
create policy "order_items_admin_manage"
on public.order_items
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "reviews_public_read" on public.reviews;
create policy "reviews_public_read"
on public.reviews
for select
to public
using (is_published = true or public.is_admin() or auth.uid() = user_id);

drop policy if exists "reviews_insert_completed_order" on public.reviews;
create policy "reviews_insert_completed_order"
on public.reviews
for insert
to authenticated
with check (
  auth.uid() = user_id
  and exists (
    select 1
    from public.orders o
    where o.id = reviews.order_id
      and o.user_id = auth.uid()
      and o.order_status = 'completed'
  )
  and public.is_completed_order_product(auth.uid(), product_id)
);

drop policy if exists "reviews_update_own_or_admin" on public.reviews;
create policy "reviews_update_own_or_admin"
on public.reviews
for update
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "reviews_admin_delete" on public.reviews;
create policy "reviews_admin_delete"
on public.reviews
for delete
to authenticated
using (public.is_admin());

drop policy if exists "vehicle_profiles_own_manage" on public.vehicle_profiles;
create policy "vehicle_profiles_own_manage"
on public.vehicle_profiles
for all
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "oil_recommendations_read" on public.oil_recommendations;
create policy "oil_recommendations_read"
on public.oil_recommendations
for select
to public
using (is_active = true or public.is_admin());

drop policy if exists "oil_recommendations_admin_manage" on public.oil_recommendations;
create policy "oil_recommendations_admin_manage"
on public.oil_recommendations
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "oil_change_reminders_own_manage" on public.oil_change_reminders;
create policy "oil_change_reminders_own_manage"
on public.oil_change_reminders
for all
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "promos_public_read_active" on public.promos;
create policy "promos_public_read_active"
on public.promos
for select
to public
using (is_active = true or public.is_admin());

drop policy if exists "promos_admin_manage" on public.promos;
create policy "promos_admin_manage"
on public.promos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "stock_movements_admin_manage" on public.stock_movements;
create policy "stock_movements_admin_manage"
on public.stock_movements
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "notifications_own_read" on public.notifications;
create policy "notifications_own_read"
on public.notifications
for select
to authenticated
using (auth.uid() = user_id or public.is_admin());

drop policy if exists "notifications_own_update" on public.notifications;
create policy "notifications_own_update"
on public.notifications
for update
to authenticated
using (auth.uid() = user_id or public.is_admin())
with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "notifications_admin_manage" on public.notifications;
create policy "notifications_admin_manage"
on public.notifications
for insert
to authenticated
with check (public.is_admin());

drop policy if exists "articles_public_read_published" on public.articles;
create policy "articles_public_read_published"
on public.articles
for select
to public
using (status = 'published' or public.is_admin());

drop policy if exists "articles_admin_manage" on public.articles;
create policy "articles_admin_manage"
on public.articles
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admin_chats_customer_or_admin_read" on public.admin_chats;
create policy "admin_chats_customer_or_admin_read"
on public.admin_chats
for select
to authenticated
using (public.is_admin() or customer_id = auth.uid());

drop policy if exists "admin_chats_customer_create" on public.admin_chats;
create policy "admin_chats_customer_create"
on public.admin_chats
for insert
to authenticated
with check (customer_id = auth.uid() or public.is_admin());

drop policy if exists "admin_chats_admin_update" on public.admin_chats;
create policy "admin_chats_admin_update"
on public.admin_chats
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "chat_messages_chat_members_read" on public.chat_messages;
create policy "chat_messages_chat_members_read"
on public.chat_messages
for select
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.admin_chats ac
    where ac.id = chat_messages.chat_id
      and ac.customer_id = auth.uid()
  )
);

drop policy if exists "chat_messages_chat_members_insert" on public.chat_messages;
create policy "chat_messages_chat_members_insert"
on public.chat_messages
for insert
to authenticated
with check (
  public.is_admin()
  or (
    sender_user_id = auth.uid()
    and exists (
      select 1
      from public.admin_chats ac
      where ac.id = chat_messages.chat_id
        and ac.customer_id = auth.uid()
    )
  )
);

drop policy if exists "store_settings_public_read" on public.store_settings;
create policy "store_settings_public_read"
on public.store_settings
for select
to public
using (true);

drop policy if exists "store_settings_admin_manage" on public.store_settings;
create policy "store_settings_admin_manage"
on public.store_settings
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "role_permissions_admin_manage" on public.role_permissions;
create policy "role_permissions_admin_manage"
on public.role_permissions
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "delivery_assignments_admin_manage" on public.delivery_assignments;
create policy "delivery_assignments_admin_manage"
on public.delivery_assignments
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "delivery_assignments_courier_read_own" on public.delivery_assignments;
create policy "delivery_assignments_courier_read_own"
on public.delivery_assignments
for select
to authenticated
using (public.is_admin() or courier_id = auth.uid());

drop policy if exists "delivery_assignments_courier_update_own" on public.delivery_assignments;
create policy "delivery_assignments_courier_update_own"
on public.delivery_assignments
for update
to authenticated
using (public.is_courier() and courier_id = auth.uid())
with check (public.is_courier() and courier_id = auth.uid());

drop policy if exists "return_refund_requests_own_read_or_admin" on public.return_refund_requests;
create policy "return_refund_requests_own_read_or_admin"
on public.return_refund_requests
for select
to authenticated
using (public.is_admin() or user_id = auth.uid());

drop policy if exists "return_refund_requests_own_insert" on public.return_refund_requests;
create policy "return_refund_requests_own_insert"
on public.return_refund_requests
for insert
to authenticated
with check (user_id = auth.uid() or public.is_admin());

drop policy if exists "return_refund_requests_admin_update" on public.return_refund_requests;
create policy "return_refund_requests_admin_update"
on public.return_refund_requests
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

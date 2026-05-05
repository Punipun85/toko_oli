from __future__ import annotations

import json
import pathlib
import re
import urllib.parse
import urllib.request
from urllib.error import HTTPError, URLError


ROOT = pathlib.Path(r"C:\Users\Asus\vsc\vscode\android\toko_oli")
DOWNLOAD_DIR = ROOT / "supabase" / "storage_seed" / "product-images"
MIGRATION_PATH = (
    ROOT / "supabase" / "migrations" / "20260504143000_repoint_product_images_to_storage.sql"
)
SUPABASE_URL = "https://cyuepjhmvrtyhsidfvhm.supabase.co"
SUPABASE_KEY = "sb_publishable_bzjyyYlRGZyhMym9ooKvmg_yiOPE2yc"


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value).strip("-").lower()
    return slug or "image"


def fetch_products() -> list[dict[str, object]]:
    req = urllib.request.Request(
        f"{SUPABASE_URL}/rest/v1/produk?select=id_produk,nama_produk,gambar&limit=500",
        headers={
            "apikey": SUPABASE_KEY,
            "Authorization": f"Bearer {SUPABASE_KEY}",
        },
    )
    with urllib.request.urlopen(req) as response:
        return json.load(response)


def ensure_download(url: str, name: str) -> str:
    parsed = urllib.parse.urlparse(url)
    ext = pathlib.Path(parsed.path).suffix or ".png"
    filename = f"{slugify(name)}{ext}"
    destination = DOWNLOAD_DIR / filename
    if not destination.exists():
        try:
            with urllib.request.urlopen(url) as response:
                content_type = response.info().get_content_type()
                if not content_type.startswith("image/"):
                    raise ValueError(f"Unexpected content type: {content_type}")
                destination.write_bytes(response.read())
        except (HTTPError, URLError, ValueError):
            filename = f"{slugify(name)}.svg"
            destination = DOWNLOAD_DIR / filename
            destination.write_text(build_placeholder_svg(name), encoding="utf-8")
    return filename


def build_placeholder_svg(name: str) -> str:
    safe_name = name.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="640" height="640" viewBox="0 0 640 640">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#2B2F35" />
      <stop offset="100%" stop-color="#111417" />
    </linearGradient>
  </defs>
  <rect width="640" height="640" rx="48" fill="url(#bg)" />
  <rect x="40" y="40" width="560" height="560" rx="36" fill="none" stroke="#FF6B00" stroke-width="6" />
  <text x="320" y="230" text-anchor="middle" fill="#FFB693" font-size="34" font-family="Arial, sans-serif" font-weight="700">PERTAMINA</text>
  <text x="320" y="320" text-anchor="middle" fill="#F4F5F7" font-size="30" font-family="Arial, sans-serif" font-weight="700">{safe_name}</text>
  <text x="320" y="392" text-anchor="middle" fill="#C3C8CE" font-size="22" font-family="Arial, sans-serif">Image placeholder stored in Supabase</text>
</svg>
"""


def main() -> None:
    DOWNLOAD_DIR.mkdir(parents=True, exist_ok=True)
    products = fetch_products()

    unique_urls: dict[str, str] = {}
    for product in products:
        image_url = (product.get("gambar") or "").strip()
        if not image_url:
            continue
        unique_urls.setdefault(image_url, str(product.get("nama_produk") or "product-image"))

    storage_url_by_source: dict[str, str] = {}
    for source_url, product_name in unique_urls.items():
        filename = ensure_download(source_url, product_name)
        storage_url_by_source[source_url] = (
            f"{SUPABASE_URL}/storage/v1/object/public/product-images/product-images/{filename}"
        )

    lines = ["-- Repoint product image URLs to Supabase Storage public URLs"]
    for source_url, storage_url in storage_url_by_source.items():
        escaped_source = source_url.replace("'", "''")
        escaped_storage = storage_url.replace("'", "''")
        lines.append(
            "update public.produk "
            f"set gambar = '{escaped_storage}' "
            f"where gambar = '{escaped_source}';"
        )

    MIGRATION_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Downloaded {len(storage_url_by_source)} unique images")
    print(f"Wrote migration: {MIGRATION_PATH.name}")


if __name__ == "__main__":
    main()

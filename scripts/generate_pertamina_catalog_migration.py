from __future__ import annotations

import pathlib

import pandas as pd


ROOT = pathlib.Path(r"C:\Users\Asus\vsc\vscode\android\toko_oli")
SOURCE_XLSX = pathlib.Path(r"C:\Users\Asus\Downloads\pertamina_lube_super_detail.xlsx")
MIGRATION_PATH = ROOT / "supabase" / "migrations" / "20260428103000_replace_catalog_from_excel.sql"
SEED_PATH = ROOT / "supabase" / "seed.sql"

IMAGE_MAP: dict[tuple[str, str], str] = {
    ("Fastron", "Platinum Racing"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/46e07-fastron-platinumracing.png",
    ("Fastron", "Platinum"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/b862b-fastron-platinum.png",
    ("Fastron", "Gold"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/1f4cd-fastron-gold1.png",
    ("Fastron", "Techno"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/ccff3-fastron-techno.png",
    ("Fastron", "Eco Green"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/e16d0-fastron-ecogreen.png",
    ("Fastron", "Diesel"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/86fd0-fastron-diesel.png",
    ("Enduro", "4T Sport"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/158ca-enduro-sport.png",
    ("Enduro", "4T Racing"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/6acd9-enduro-racing.png",
    ("Enduro", "4T"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/79102-enduro-4t.png",
    ("Enduro", "Matic V"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/1c9c1-enduro-maticv.png",
    ("Enduro", "Matic"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/9c97d-enduro-matic.png",
    ("Enduro", "Matic G"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/4ab74-enduro-racingg.png",
    ("Enduro", "Gear Matic"): "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/a55e2-enduro-maticgear.png",
    ("Meditran", "SX"): "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20SX%204L.png",
    ("Meditran", "SC"): "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20SC%205L.png",
    ("Meditran", "S"): "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20S%205L.png",
}

CATEGORY_IDS = {
    "Diesel": 1,
    "Mobil": 2,
    "Motor": 3,
}


def sql_escape(value: object) -> str:
    return str(value).replace("'", "''")


def build_description(row: pd.Series) -> str:
    return (
        f"Kategori: {row['Kategori']}. "
        f"Seri: {row['Seri']}. "
        f"Produk: {row['Produk']}. "
        f"Viskositas: {row['Viskositas']}. "
        f"Tipe: {row['Tipe']}. "
        f"Kemasan: {row['Kemasan']}. "
        f"Isi/Karton: {row['Isi/Karton']}. "
        f"Total Liter: {int(row['Total Liter'])}. "
        "Harga belum tersedia pada file sumber Excel."
    )


def main() -> None:
    df = pd.read_excel(SOURCE_XLSX)
    lines: list[str] = [
        "-- Generated from pertamina_lube_super_detail.xlsx",
        "alter table public.produk add column if not exists seri varchar(50);",
        "alter table public.produk add column if not exists isi_karton varchar(20);",
        "alter table public.produk add column if not exists total_liter integer;",
        "alter table public.produk add column if not exists sumber_data varchar(255);",
        "",
        "truncate table public.produk, public.kategori, public.merk restart identity cascade;",
        "",
        "insert into public.kategori (id_kategori, nama_kategori) values",
        "  (1, 'Diesel'),",
        "  (2, 'Mobil'),",
        "  (3, 'Motor');",
        "",
        "insert into public.merk (id_merk, nama_merk) values",
        "  (1, 'Pertamina');",
        "",
        "insert into public.produk (",
        "  id_produk,",
        "  id_kategori,",
        "  id_merk,",
        "  nama_produk,",
        "  harga,",
        "  sae,",
        "  volume,",
        "  tipe,",
        "  deskripsi,",
        "  gambar,",
        "  seri,",
        "  isi_karton,",
        "  total_liter,",
        "  sumber_data",
        ") values",
    ]

    values: list[str] = []
    for idx, row in enumerate(df.to_dict(orient="records"), start=1):
        seri = row["Seri"]
        produk = row["Produk"]
        nama_produk = f"{seri} {produk}".strip()
        gambar = IMAGE_MAP[(seri, produk)]
        desc = build_description(pd.Series(row))
        values.append(
            "  ("
            f"{idx}, "
            f"{CATEGORY_IDS[row['Kategori']]}, "
            "1, "
            f"'{sql_escape(nama_produk)}', "
            "0.00, "
            f"'{sql_escape(row['Viskositas'])}', "
            f"'{sql_escape(row['Kemasan'])}', "
            f"'{sql_escape(row['Tipe'])}', "
            f"'{sql_escape(desc)}', "
            f"'{sql_escape(gambar)}', "
            f"'{sql_escape(seri)}', "
            f"'{sql_escape(row['Isi/Karton'])}', "
            f"{int(row['Total Liter'])}, "
            "'pertamina_lube_super_detail.xlsx'"
            ")"
        )

    lines.append(",\n".join(values) + ";")
    lines.extend(
        [
            "",
            "select setval(",
            "  pg_get_serial_sequence('public.kategori', 'id_kategori'),",
            "  coalesce((select max(id_kategori) from public.kategori), 1),",
            "  true",
            ");",
            "",
            "select setval(",
            "  pg_get_serial_sequence('public.merk', 'id_merk'),",
            "  coalesce((select max(id_merk) from public.merk), 1),",
            "  true",
            ");",
            "",
            "select setval(",
            "  pg_get_serial_sequence('public.produk', 'id_produk'),",
            "  coalesce((select max(id_produk) from public.produk), 1),",
            "  true",
            ");",
            "",
        ]
    )

    sql_text = "\n".join(lines)
    MIGRATION_PATH.write_text(sql_text, encoding="utf-8")
    SEED_PATH.write_text(sql_text, encoding="utf-8")
    print(f"Wrote {len(df)} products to {MIGRATION_PATH.name}")


if __name__ == "__main__":
    main()

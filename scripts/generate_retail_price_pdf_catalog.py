from __future__ import annotations

import pathlib
import re


ROOT = pathlib.Path(__file__).resolve().parents[1]
MIGRATION_PATH = ROOT / "supabase" / "migrations" / "20260430143000_replace_catalog_from_retail_price_pdf.sql"
SEED_PATH = ROOT / "supabase" / "seed.sql"
SOURCE_LABEL = "PL baru per 20 April 2026 (Retail).pdf"

CATEGORY_IDS = {
    "Diesel": 1,
    "Mobil": 2,
    "Motor": 3,
    "Transmisi": 4,
    "Coolant": 5,
    "Gemuk": 6,
}

IMAGE_RULES = [
    ("FASTRON PLATINUM RACING", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/46e07-fastron-platinumracing.png"),
    ("FASTRON PLATINUM FULLY SYN", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/b862b-fastron-platinum.png"),
    ("FASTRON GOLD", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/1f4cd-fastron-gold1.png"),
    ("FASTRON TECHNO", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/ccff3-fastron-techno.png"),
    ("FASTRON ECOGREEN", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/e16d0-fastron-ecogreen.png"),
    ("FASTRON DIESEL", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/86fd0-fastron-diesel.png"),
    ("ENDURO 4T SPORT", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/158ca-enduro-sport.png"),
    ("ENDURO 4T RACING", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/6acd9-enduro-racing.png"),
    ("ENDURO RACING PLATINUM", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/6acd9-enduro-racing.png"),
    ("ENDURO MATIC V", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/1c9c1-enduro-maticv.png"),
    ("ENDURO GEAR MATIC", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/a55e2-enduro-maticgear.png"),
    ("ENDURO 4T MATIC G", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/4ab74-enduro-racingg.png"),
    ("ENDURO 4T MATIC", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/9c97d-enduro-matic.png"),
    ("ENDURO MATIC S", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/9c97d-enduro-matic.png"),
    ("ENDURO 4T", "https://www.pertaminalubricants.com/assets/images/data/image_product_detail/new/79102-enduro-4t.png"),
    ("MEDITRAN SX", "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20SX%204L.png"),
    ("MEDITRAN SC", "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20SC%205L.png"),
    ("MEDITRAN S", "https://www.pertaminalubricants.com/assets/uploads/lubes/New%20Meditran%20S%205L.png"),
]

KNOWN_SAE = {
    "MEDITRAN S. 40": "40",
    "MEDITRAN SC": "15W-40",
    "MEDITRAN SX": "15W-40",
    "MESRAN B. 40": "40",
    "MESRAN 40": "40",
    "ENDURO 4T": "20W-50",
    "ENDURO 4T RACING": "10W-40",
    "ENDURO 4T MATIC": "10W-30",
    "ENDURO 4T MATIC G": "20W-40",
    "ENDURO RACING S": "10W-40",
    "FASTRON PLATINUM RACING": "10W-60",
    "FASTRON PLATINUM FULLY SYN": "0W-40",
}

ROWS = [
    ("MEDITRAN S. 40", "2 X 10", "776.577", "85.423", "862.000"),
    ("MEDITRAN S. 40", "4 X 5", "790.090", "86.910", "877.000"),
    ("MEDITRAN S. 40", "20 X 1", "871.171", "95.829", "967.000"),
    ("MEDITRAN S. 40", "18 Ltr", "678.649", "74.651", "753.300"),
    ("MESRAN B. 40", "2 X 10", "756.757", "83.243", "840.000"),
    ("MESRAN B. 40", "6 X 4", "942.703", "103.697", "1.046.400"),
    ("MESRAN B. 40", "4 X 5", "763.063", "83.937", "847.000"),
    ("MESRAN B. 40", "20 X 1", "858.559", "94.441", "953.000"),
    ("MESRAN 40", "6 X 4", "896.216", "98.584", "994.800"),
    ("MESRAN 40", "20 X 1", "815.315", "89.685", "905.000"),
    ("MESRANIA 2 T / OB", "20 X 1", "820.721", "90.279", "911.000"),
    ("MESRANIA 2T/ SUPER", "20 X 1", "913.514", "100.486", "1.014.000"),
    ("RORED EP. A.90", "6 X 4", "1.067.027", "117.373", "1.184.400"),
    ("RORED EP. A.140", "6 X 4", "1.125.405", "123.795", "1.249.200"),
    ("RORED EP. A.90", "4 X 5", "864.865", "95.135", "960.000"),
    ("RORED EP. A.140", "4 X 5", "918.919", "101.081", "1.020.000"),
    ("RORED EP. A.90", "20 X 1", "1.010.811", "111.189", "1.122.000"),
    ("RORED HD. A.90", "6 X 4", "1.168.649", "128.551", "1.297.200"),
    ("RORED HD. A.140", "6 X 4", "1.228.108", "135.092", "1.363.200"),
    ("RORED HD. A.90", "4 X 5", "947.748", "104.252", "1.052.000"),
    ("RORED HD. A.140", "4 X 5", "993.694", "109.306", "1.103.000"),
    ("MEDITRAN SC", "20 X 1", "948.649", "104.351", "1.053.000"),
    ("MEDITRAN SC", "2 X 10", "868.468", "95.532", "964.000"),
    ("MEDITRAN SC", "4 X 5", "881.982", "97.018", "979.000"),
    ("GEMUK PERTAMINA SGX / PAIL", "16 KG", "1.046.486", "115.114", "1.161.600"),
    ("MESRAN SUPER", "6 X 4", "958.919", "105.481", "1.064.400"),
    ("MESRAN SUPER", "20 X 1", "828.829", "91.171", "920.000"),
    ("MESRAN SUPER", "24 X 0,8", "920.000", "101.200", "1.021.200"),
    ("MESRAN SUPER MOTOR", "24 X 0,8", "809.730", "89.070", "898.800"),
    ("PRIMA XP 20W-50", "6 X 4", "1.015.135", "111.665", "1.126.800"),
    ("PRIMA XP 20W-50", "6 X 1", "271.892", "29.908", "301.800"),
    ("MEDITRAN SX", "20 X 1", "986.486", "108.514", "1.095.000"),
    ("MEDITRAN SX", "2 X 10", "890.090", "97.910", "988.000"),
    ("MEDITRAN SX", "6 X 4", "1.082.162", "119.038", "1.201.200"),
    ("MEDITRAN SX BIO SAE15W-40", "20 X 1", "500.901", "55.099", "556.000"),
    ("MEDITRAN SX BIO SAE15W-40", "6 X 4", "565.946", "62.254", "628.200"),
    ("FASTRON TECHNO (SN 10W-40)", "6 X 1", "431.351", "47.449", "478.800"),
    ("FASTRON TECHNO (SN 10W-40)", "6 X 4", "1.681.081", "184.919", "1.866.000"),
    ("FASTRON GOLD (SM 0W-20)", "6 X 1", "635.405", "69.895", "705.300"),
    ("FASTRON GOLD (SM 0W-20)", "6 X 4", "2.447.568", "269.232", "2.716.800"),
    ("FASTRON GOLD (SM 5W-30)", "6 X 1", "772.162", "84.938", "857.100"),
    ("FASTRON GOLD (SM 5W-30)", "6 X 4", "2.967.568", "326.432", "3.294.000"),
    ("FASTRON ECOGREEN (0W-20)", "6 X 3,5", "1.241.081", "136.519", "1.377.600"),
    ("FASTRON ECOGREEN (5W-30)", "6 X 3,5", "1.213.784", "133.516", "1.347.300"),
    ("FASTRON ECOGREEN (0W-20)", "6 X 1", "360.270", "39.630", "399.900"),
    ("FASTRON ECOGREEN (5W-30)", "6 X 1", "347.838", "38.262", "386.100"),
    ("FASTRON DIESEL (15W-40)", "6 X 1", "419.459", "46.141", "465.600"),
    ("FASTRON DIESEL (15W-40)", "6 X 4", "1.607.568", "176.832", "1.784.400"),
    ("ENDURO 4T", "6 X 0,8", "246.486", "27.114", "273.600"),
    ("ENDURO 4T", "6 X 1", "289.189", "31.811", "321.000"),
    ("ENDURO RACING PLATINUM", "6 X 1", "1.170.811", "128.789", "1.299.600"),
    ("ENDURO 4T SPORT 5W-30", "6 X 1", "1.066.757", "117.343", "1.184.100"),
    ("ENDURO 4T RACING", "6 X 1", "364.595", "40.105", "404.700"),
    ("ENDURO 4T RACING", "6 X 0,8", "294.054", "32.346", "326.400"),
    ("ENDURO 4T MATIC", "6 X 0,8", "268.919", "29.581", "298.500"),
    ("ENDURO GEAR MATIC", "24 X 120", "329.730", "36.270", "366.000"),
    ("ENDURO 4T MATIC", "6 X 1", "318.919", "35.081", "354.000"),
    ("ENDURO 4T MATIC G", "6 X 0,8", "242.703", "26.697", "269.400"),
    ("ENDURO 4T MATIC G", "6 X 1", "292.432", "32.168", "324.600"),
    ("ENDURO MATIC V 10W-40 SN", "6 X 1", "305.405", "33.595", "339.000"),
    ("ENDURO MATIC S 10W-30 SL", "6 X 0,8", "235.405", "25.895", "261.300"),
    ("ENDURO MATIC S 10W-30 SL", "6 X 0,65", "187.297", "20.603", "207.900"),
    ("ENDURO RACING S", "6 X 0,8", "240.000", "26.400", "266.400"),
    ("PERTAMINA ATF", "6 X 1", "336.486", "37.014", "373.500"),
    ("RADIATOR COOLANT (30%)", "6 X 1", "174.054", "19.146", "193.200"),
    ("RADIATOR COOLANT (30%)", "6 X 4", "614.054", "67.546", "681.600"),
    ("ENVIRO", "6 X 0,8", "265.405", "29.195", "294.600"),
    ("RORED MTF 80W-90 GL 4", "6 X 1", "402.703", "44.297", "447.000"),
    ("FASTRON TECHNO 15W-40", "6 X 1", "363.514", "39.987", "403.501"),
    ("FASTRON TECHNO 15W-40", "6 X 4", "1.417.297", "155.903", "1.573.200"),
    ("MEDITRAN SX PLUS 15W-40", "4 X 5", "938.739", "103.261", "1.042.000"),
    ("MEDITRAN SX PLUS 15W-40", "6 X 1", "296.757", "32.643", "329.400"),
    ("FASTRON TECHNO 5W-30", "6 X 1", "461.081", "50.719", "511.800"),
    ("FASTRON TECHNO 5W-30", "6 X 4", "1.795.676", "197.524", "1.993.200"),
    ("FASTRON DIESEL 5W-30", "6 X 1", "466.757", "51.343", "518.100"),
    ("FASTRON DIESEL 5W-30", "6 X 4", "1.841.081", "202.519", "2.043.600"),
    ("FASTRON PLATINUM RACING", "6 X 1", "1.444.324", "158.876", "1.603.200"),
    ("FASTRON PLATINUM RACING", "6 X 4", "5.654.054", "621.946", "6.276.000"),
    ("FASTRON PLATINUM FULLY SYN", "6 X 1", "1.177.838", "129.562", "1.307.400"),
    ("FASTRON PLATINUM FULLY SYN", "6 X 4", "4.545.946", "500.054", "5.046.000"),
    ("FASTRON TECHNO 0W-20", "6 X 1", "421.622", "46.378", "468.000"),
    ("FASTRON TECHNO 0W-20", "6 X 4", "1.659.459", "182.541", "1.842.000"),
]


def sql_escape(value: object) -> str:
    return str(value).replace("'", "''")


def money(value: str) -> int:
    return int(value.replace(".", ""))


def rupiah(value: str) -> str:
    return f"Rp {value}"


def pretty_name(name: str) -> str:
    text = name.replace(" / ", "/").replace("/ ", "/").replace(" /", "/")
    text = re.sub(r"\s+", " ", text).strip().title()
    replacements = {
        "Atf": "ATF",
        "Bio": "BIO",
        "Ep": "EP",
        "Gl": "GL",
        "Hd": "HD",
        "Mtf": "MTF",
        "Ob": "OB",
        "Ppn": "PPN",
        "Sae": "SAE",
        "Sc": "SC",
        "Sgx": "SGX",
        "Sl": "SL",
        "Sm": "SM",
        "Sn": "SN",
        "Sx": "SX",
        "Xp": "XP",
    }
    for before, after in replacements.items():
        text = re.sub(rf"\b{before}\b", after, text)
    text = re.sub(r"\bSae(?=\d)", "SAE", text)
    return text.replace("A.90", "A.90").replace("A.140", "A.140")


def infer_category(name: str) -> str:
    if "RORED" in name or "ATF" in name:
        return "Transmisi"
    if "COOLANT" in name:
        return "Coolant"
    if "GEMUK" in name:
        return "Gemuk"
    if "ENDURO" in name or "MESRANIA" in name or "MOTOR" in name or name == "ENVIRO":
        return "Motor"
    if "MEDITRAN" in name or "DIESEL" in name:
        return "Diesel"
    return "Mobil"


def infer_series(name: str) -> str:
    for series in ("FASTRON", "ENDURO", "MEDITRAN", "MESRANIA", "MESRAN", "RORED", "PRIMA", "PERTAMINA", "RADIATOR", "ENVIRO", "GEMUK"):
        if name.startswith(series):
            return pretty_name(series)
    return "Pertamina"


def infer_type(category: str) -> str:
    return {
        "Diesel": "Diesel Engine Oil",
        "Mobil": "Engine Oil",
        "Motor": "Motorcycle Oil",
        "Transmisi": "Transmission Oil",
        "Coolant": "Coolant",
        "Gemuk": "Grease",
    }[category]


def infer_sae(name: str) -> str:
    if name in KNOWN_SAE:
        return KNOWN_SAE[name]
    match = re.search(r"SAE\s*([0-9]{1,2}W-[0-9]{2})", name)
    if match:
        return match.group(1)
    match = re.search(r"([0-9]{1,3}W-[0-9]{2})", name)
    if match:
        return match.group(1)
    match = re.search(r"\bA\.?\s*([0-9]{2,3})\b", name)
    if match:
        return f"A.{match.group(1)}"
    if "COOLANT (30%)" in name:
        return "30%"
    return "-"


def image_for(name: str) -> str:
    for needle, image_url in IMAGE_RULES:
        if needle in name:
            return image_url
    return ""


def build_description(name: str, uk: str, exc_ppn: str, ppn_11: str, inc_ppn: str) -> str:
    return (
        "Daftar harga retail outlet Pelumas Pertamina Solo per 20 April 2026. "
        f"Kemasan doos: {uk}. "
        f"Harga EXC PPN: {rupiah(exc_ppn)}; PPN 11%: {rupiah(ppn_11)}; "
        f"Harga INC PPN 11%: {rupiah(inc_ppn)}."
    )


def main() -> None:
    lines = [
        f"-- Generated from {SOURCE_LABEL}",
        "alter table public.produk add column if not exists seri varchar(50);",
        "alter table public.produk add column if not exists isi_karton varchar(20);",
        "alter table public.produk add column if not exists total_liter integer;",
        "alter table public.produk add column if not exists sumber_data varchar(255);",
        "alter table public.produk add column if not exists harga_exc_ppn numeric(10, 2);",
        "alter table public.produk add column if not exists ppn_11 numeric(10, 2);",
        "",
        "truncate table public.produk, public.kategori, public.merk restart identity cascade;",
        "",
        "insert into public.kategori (id_kategori, nama_kategori) values",
        "  (1, 'Diesel'),",
        "  (2, 'Mobil'),",
        "  (3, 'Motor'),",
        "  (4, 'Transmisi'),",
        "  (5, 'Coolant'),",
        "  (6, 'Gemuk');",
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
        "  sumber_data,",
        "  harga_exc_ppn,",
        "  ppn_11",
        ") values",
    ]

    values = []
    for index, (raw_name, uk, exc_ppn, ppn_11, inc_ppn) in enumerate(ROWS, start=1):
        category = infer_category(raw_name)
        name = pretty_name(raw_name)
        description = build_description(raw_name, uk, exc_ppn, ppn_11, inc_ppn)
        values.append(
            "  ("
            f"{index}, "
            f"{CATEGORY_IDS[category]}, "
            "1, "
            f"'{sql_escape(name)}', "
            f"{money(inc_ppn)}.00, "
            f"'{sql_escape(infer_sae(raw_name))}', "
            f"'{sql_escape(uk)}', "
            f"'{sql_escape(infer_type(category))}', "
            f"'{sql_escape(description)}', "
            f"'{sql_escape(image_for(raw_name))}', "
            f"'{sql_escape(infer_series(raw_name))}', "
            f"'{sql_escape(uk)}', "
            f"'{SOURCE_LABEL}', "
            f"{money(exc_ppn)}.00, "
            f"{money(ppn_11)}.00"
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
    print(f"Wrote {len(ROWS)} retail price rows to {MIGRATION_PATH.name} and seed.sql")


if __name__ == "__main__":
    main()

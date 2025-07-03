// --- Model Kategori ---
class Kategori {
  final int id;
  final String kategori;
  final String slug;
  final String icon;
  final String createdAt;
  final String updatedAt;

  Kategori({
    required this.id,
    required this.kategori,
    required this.slug,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    // print('DEBUG Kategori.fromJson: Parsing data: $json'); // Untuk debugging
    return Kategori(
      id: json['id'] as int,
      kategori: json['kategori'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kategori': kategori,
    'slug': slug,
    'icon': icon,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// --- Model Satuan ---
class Satuan {
  final int id;
  final String satuan;
  final String createdAt;
  final String updatedAt;

  Satuan({
    required this.id,
    required this.satuan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Satuan.fromJson(Map<String, dynamic> json) {
    // print('DEBUG Satuan.fromJson: Parsing data: $json'); // Untuk debugging
    return Satuan(
      id: json['id'] as int,
      satuan: json['satuan'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'satuan': satuan,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// --- Model Datum (yang Anda sebut Product) ---
class Datum {
  final int id;
  final int kategoriId;
  final int satuanId;
  final String namaProduk;
  final String slug;
  final String deskripsi;
  final int hargaBeli;
  final int hargaJual;
  final int promo;
  final int percentage;
  final int stok;
  final int isActive;
  final String image;
  final String createdAt;
  final String updatedAt;
  final Kategori? kategori; // Opsional, bisa null
  final Satuan? satuan; // Opsional, bisa null

  Datum({
    required this.id,
    required this.kategoriId,
    required this.satuanId,
    required this.namaProduk,
    required this.slug,
    required this.deskripsi,
    required this.hargaBeli,
    required this.hargaJual,
    required this.promo,
    required this.percentage,
    required this.stok,
    required this.isActive,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.kategori,
    this.satuan,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    // print('DEBUG Datum.fromJson: Parsing data: $json'); // AKTIFKAN UNTUK DEBUGGING

    try {
      return Datum(
        id: json['id'] as int,
        kategoriId: json['kategori_id'] as int,
        satuanId: json['satuan_id'] as int,
        namaProduk: json['nama_produk'] as String,
        slug: json['slug'] as String,
        deskripsi: json['deskripsi'] as String,
        hargaBeli: json['harga_beli'] as int,
        hargaJual: json['harga_jual'] as int,
        promo: json['promo'] as int,
        percentage: json['percentage'] as int,
        stok: json['stok'] as int,
        isActive: json['is_active'] as int,
        image: json['image'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        // Parsing objek nested Kategori dan Satuan
        kategori:
            json['kategori'] != null
                ? Kategori.fromJson(json['kategori'] as Map<String, dynamic>)
                : null,
        satuan:
            json['satuan'] != null
                ? Satuan.fromJson(json['satuan'] as Map<String, dynamic>)
                : null,
      );
    } catch (e) {
      // print('ERROR Datum.fromJson: Gagal parsing: $e, JSON: $json'); // AKTIFKAN UNTUK DEBUGGING
      rethrow; // Re-throw error untuk melacak masalah
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kategori_id': kategoriId,
    'satuan_id': satuanId,
    'nama_produk': namaProduk,
    'slug': slug,
    'deskripsi': deskripsi,
    'harga_beli': hargaBeli,
    'harga_jual': hargaJual,
    'promo': promo,
    'percentage': percentage,
    'stok': stok,
    'is_active': isActive,
    'image': image,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'kategori': kategori?.toJson(),
    'satuan': satuan?.toJson(),
  };
}

class BarangUnik {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;

  BarangUnik({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
  });

  factory BarangUnik.fromFirestore(Map<String, dynamic> data, String id) {
    return BarangUnik(
      id: id,
      nama: data['nama'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      harga: data['harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
    };
  }
}

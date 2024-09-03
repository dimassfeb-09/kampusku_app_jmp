class Mahasiswa {
  final int? id;
  final String nama;
  final String ttl;
  final String jenisKelamin;
  final String alamat;

  Mahasiswa({
    this.id,
    required this.nama,
    required this.ttl,
    required this.jenisKelamin,
    required this.alamat,
  });

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'] as int?,
      nama: map['nama'] as String? ?? '', // Default to empty string if null
      ttl: map['ttl'] as String? ?? '', // Default to empty string if null
      jenisKelamin: map['jenisKelamin'] as String? ?? '',
      alamat: map['alamat'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'ttl': ttl,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
    };
  }
}

class PemilihModel {
  final String id;
  final String nama;
  final String nim;
  final String prodi;
  bool sudahVoting;

  PemilihModel({
    required this.id,
    required this.nama,
    required this.nim,
    required this.prodi,
    this.sudahVoting = false,
  });

  factory PemilihModel.fromJson(Map<String, dynamic> json) {
    return PemilihModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      nim: json['nim'] as String,
      prodi: json['prodi'] as String,
      sudahVoting: json['sudahVoting'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'prodi': prodi,
      'sudahVoting': sudahVoting,
    };
  }
}

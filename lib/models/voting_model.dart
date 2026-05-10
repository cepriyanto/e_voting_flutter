class VotingModel {
  final String idPemilih;
  final int idKandidat;
  final DateTime waktuVoting;

  VotingModel({
    required this.idPemilih,
    required this.idKandidat,
    required this.waktuVoting,
  });

  factory VotingModel.fromJson(Map<String, dynamic> json) {
    return VotingModel(
      idPemilih: json['idPemilih'] as String,
      idKandidat: json['idKandidat'] as int,
      waktuVoting: DateTime.parse(json['waktuVoting'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPemilih': idPemilih,
      'idKandidat': idKandidat,
      'waktuVoting': waktuVoting.toIso8601String(),
    };
  }

  String get candidateName {
    // This would need access to candidates list, for now return placeholder
    return 'Kandidat $idKandidat';
  }

  String get status => 'Berhasil';

  DateTime get dateTime => waktuVoting;

  int get candidateId => idKandidat;
}

import 'dart:convert';

import '../models/kandidat_model.dart';
import '../models/voting_model.dart';
import '../models/user_model.dart';
import '../models/pemilih_model.dart';
import 'local_storage_service.dart';

class VotingService {
  static const String _votingKey = 'all_votings';
  static const String _pemilihKey = 'all_pemilih';

  static List<KandidatModel> getCandidates() {
    return [
      KandidatModel(
        id: 1,
        number: 1,
        name: 'Andea Farhan',
        vision: 'Menjadikan organisasi lebih aktif dan disiplin',
        mission: 'Meningkatkan solidaritas mahasiswa',
        program: 'Aplikasi aspirasi, sesi tanya jawab online, dan dukungan prestasi akademik.',
        initials: 'AF',
      ),
      KandidatModel(
        id: 2,
        number: 2,
        name: 'Muhammad Saputra',
        vision: 'Membawa perubahan positif dan kreatif',
        mission: 'Membuat program kerja inovatif',
        program: 'Workshop kepemimpinan, bakti sosial, dan pengembangan UKM.',
        initials: 'MS',
      ),
      KandidatModel(
        id: 3,
        number: 3,
        name: 'Dimas',
        vision: 'Membangun organisasi yang transparan',
        mission: 'Mengutamakan kerja sama dan tanggung jawab',
        program: 'Platform voting digital, sesi konsultasi, dan penguatan kebijakan kampus.',
        initials: 'D',
      ),
    ];
  }

  Future<List<VotingModel>> _getAllVotings() async {
    final prefs = await LocalStorageService.prefs;
    final raw = prefs.getString(_votingKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) => VotingModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> _saveAllVotings(List<VotingModel> votings) async {
    final prefs = await LocalStorageService.prefs;
    final encoded = jsonEncode(votings.map((v) => v.toJson()).toList());
    await prefs.setString(_votingKey, encoded);
  }

  Future<List<PemilihModel>> _getAllPemilih() async {
    final prefs = await LocalStorageService.prefs;
    final raw = prefs.getString(_pemilihKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) => PemilihModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> _saveAllPemilih(List<PemilihModel> pemilih) async {
    final prefs = await LocalStorageService.prefs;
    final encoded = jsonEncode(pemilih.map((p) => p.toJson()).toList());
    await prefs.setString(_pemilihKey, encoded);
  }

  Future<String?> voting(String idPemilih, int idKandidat) async {
    final pemilihList = await _getAllPemilih();
    final pemilih = pemilihList.firstWhere(
      (p) => p.id == idPemilih,
      orElse: () => PemilihModel(id: '', nama: '', nim: '', prodi: ''),
    );
    if (pemilih.id.isEmpty) {
      return 'Pemilih tidak ditemukan.';
    }
    if (pemilih.sudahVoting) {
      return 'Anda sudah melakukan voting.';
    }

    // Update pemilih sudah voting
    pemilih.sudahVoting = true;
    final index = pemilihList.indexWhere((p) => p.id == idPemilih);
    if (index != -1) {
      pemilihList[index] = pemilih;
      await _saveAllPemilih(pemilihList);
    }

    // Simpan voting
    final votings = await _getAllVotings();
    final voting = VotingModel(
      idPemilih: idPemilih,
      idKandidat: idKandidat,
      waktuVoting: DateTime.now(),
    );
    votings.add(voting);
    await _saveAllVotings(votings);

    return null;
  }

  Future<List<Map<String, dynamic>>> hitungHasil() async {
    final votings = await _getAllVotings();
    final candidates = getCandidates();
    final results = <Map<String, dynamic>>[];

    for (final candidate in candidates) {
      final suara = votings.where((v) => v.idKandidat == candidate.id).length;
      results.add({
        'id': candidate.id,
        'nama': candidate.name,
        'suara': suara,
      });
    }

    return results;
  }

  // Legacy methods for compatibility
  Future<bool> hasVoted(String nim) async {
    final pemilihList = await _getAllPemilih();
    final pemilih = pemilihList.firstWhere(
      (p) => p.nim == nim,
      orElse: () => PemilihModel(id: '', nama: '', nim: '', prodi: ''),
    );
    return pemilih.sudahVoting;
  }

  Future<List<VotingModel>> getHistory(String nim) async {
    final pemilihList = await _getAllPemilih();
    final pemilih = pemilihList.firstWhere(
      (p) => p.nim == nim,
      orElse: () => PemilihModel(id: '', nama: '', nim: '', prodi: ''),
    );
    if (pemilih.id.isEmpty) return [];
    final votings = await _getAllVotings();
    return votings.where((v) => v.idPemilih == pemilih.id).toList();
  }

  Future<String?> vote(KandidatModel candidate, UserModel user) async {
    final pemilihList = await _getAllPemilih();
    var pemilih = pemilihList.firstWhere(
      (p) => p.nim == user.nim,
      orElse: () => PemilihModel(id: '', nama: '', nim: '', prodi: ''),
    );
    if (pemilih.id.isEmpty) {
      // Buat pemilih baru jika belum ada
      pemilih = PemilihModel(
        id: user.nim,
        nama: user.name,
        nim: user.nim,
        prodi: user.prodi,
      );
      pemilihList.add(pemilih);
      await _saveAllPemilih(pemilihList);
    }
    return await voting(pemilih.id, candidate.id);
  }
}

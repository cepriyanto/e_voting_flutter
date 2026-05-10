import 'package:flutter/foundation.dart';

import '../models/kandidat_model.dart';
import '../models/user_model.dart';
import '../models/voting_model.dart';
import '../services/voting_service.dart';

class VotingProvider extends ChangeNotifier {
  final _votingService = VotingService();
  List<KandidatModel> candidates = [];
  List<VotingModel> history = [];
  bool hasVoted = false;
  bool isLoading = false;
  String? message;

  VotingProvider() {
    candidates = VotingService.getCandidates();
  }

  Future<void> loadHistory(String nim) async {
    isLoading = true;
    notifyListeners();
    history = await _votingService.getHistory(nim);
    hasVoted = await _votingService.hasVoted(nim);
    isLoading = false;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getVotingResults() async {
    return await _votingService.hitungHasil();
  }

  Future<bool> vote(KandidatModel candidate, UserModel user) async {
    isLoading = true;
    message = null;
    notifyListeners();

    final error = await _votingService.vote(candidate, user);
    if (error != null) {
      message = error;
      isLoading = false;
      notifyListeners();
      return false;
    }

    await loadHistory(user.nim);
    isLoading = false;
    message = 'Voting berhasil!';
    notifyListeners();
    return true;
  }
}

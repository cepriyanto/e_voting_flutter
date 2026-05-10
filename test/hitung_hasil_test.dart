import 'package:flutter_test/flutter_test.dart';
import 'package:voting/models/kandidat_model.dart';
import 'package:voting/models/user_model.dart';
import 'package:voting/services/voting_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Hitung Hasil Voting Tests', () {
    late VotingService votingService;

    setUp(() {
      votingService = VotingService();
    });

    test('hitungHasil should return empty list when no votes', () async {
      final results = await votingService.hitungHasil();
      expect(results, isEmpty);
    });

    test('hitungHasil should calculate correct vote counts', () async {
      // Create test users
      final users = [
        UserModel(nim: '111111111', name: 'User 1', prodi: 'TI', password: 'pass1'),
        UserModel(nim: '222222222', name: 'User 2', prodi: 'SI', password: 'pass2'),
        UserModel(nim: '333333333', name: 'User 3', prodi: 'TE', password: 'pass3'),
        UserModel(nim: '444444444', name: 'User 4', prodi: 'TI', password: 'pass4'),
      ];

      final candidates = VotingService.getCandidates();

      // User 1 votes for candidate 0
      await votingService.vote(candidates[0], users[0]);
      // User 2 votes for candidate 0
      await votingService.vote(candidates[0], users[1]);
      // User 3 votes for candidate 1
      await votingService.vote(candidates[1], users[2]);
      // User 4 votes for candidate 2
      await votingService.vote(candidates[2], users[3]);

      final results = await votingService.hitungHasil();

      expect(results.length, 3);

      // Find results for each candidate
      final candidate0Result = results.firstWhere((r) => r['id'] == candidates[0].id);
      final candidate1Result = results.firstWhere((r) => r['id'] == candidates[1].id);
      final candidate2Result = results.firstWhere((r) => r['id'] == candidates[2].id);

      expect(candidate0Result['suara'], 2); // 2 votes
      expect(candidate1Result['suara'], 1); // 1 vote
      expect(candidate2Result['suara'], 1); // 1 vote

      expect(candidate0Result['nama'], candidates[0].name);
      expect(candidate1Result['nama'], candidates[1].name);
      expect(candidate2Result['nama'], candidates[2].name);
    });

    test('hitungHasil should handle multiple votes for same candidate', () async {
      final users = [
        UserModel(nim: '111111111', name: 'User 1', prodi: 'TI', password: 'pass1'),
        UserModel(nim: '222222222', name: 'User 2', prodi: 'SI', password: 'pass2'),
        UserModel(nim: '333333333', name: 'User 3', prodi: 'TE', password: 'pass3'),
      ];

      final candidate = VotingService.getCandidates()[0];

      // All users vote for the same candidate
      for (final user in users) {
        await votingService.vote(candidate, user);
      }

      final results = await votingService.hitungHasil();

      final candidateResult = results.firstWhere((r) => r['id'] == candidate.id);
      expect(candidateResult['suara'], 3);
    });

    test('hitungHasil should include all candidates even with zero votes', () async {
      // Vote for only one candidate
      final user = UserModel(nim: '111111111', name: 'User 1', prodi: 'TI', password: 'pass1');
      final candidate = VotingService.getCandidates()[0];
      await votingService.vote(candidate, user);

      final results = await votingService.hitungHasil();

      expect(results.length, 3); // All 3 candidates should be included

      final votedCandidate = results.firstWhere((r) => r['id'] == candidate.id);
      expect(votedCandidate['suara'], 1);

      // Check that other candidates have 0 votes
      final otherCandidates = results.where((r) => r['id'] != candidate.id);
      for (final result in otherCandidates) {
        expect(result['suara'], 0);
      }
    });
  });
}

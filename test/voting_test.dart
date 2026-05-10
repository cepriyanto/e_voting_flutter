import 'package:flutter_test/flutter_test.dart';
import 'package:voting/models/kandidat_model.dart';
import 'package:voting/models/user_model.dart';
import 'package:voting/models/voting_model.dart';
import 'package:voting/services/voting_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('VotingService Tests', () {
    late VotingService votingService;

    setUp(() {
      votingService = VotingService();
    });

    test('getCandidates returns list of candidates', () {
      final candidates = VotingService.getCandidates();
      expect(candidates, isNotEmpty);
      expect(candidates.length, 3);
      expect(candidates[0].name, 'Ahmad Fauzi');
    });

    test('vote should succeed for valid user and candidate', () async {
      final user = UserModel(
        nim: '123456789',
        name: 'Test User',
        prodi: 'Teknik Informatika',
        password: 'password',
      );
      final candidate = VotingService.getCandidates()[0];

      final error = await votingService.vote(candidate, user);
      expect(error, isNull);
    });

    test('vote should fail if user already voted', () async {
      final user = UserModel(
        nim: '123456789',
        name: 'Test User',
        prodi: 'Teknik Informatika',
        password: 'password',
      );
      final candidate = VotingService.getCandidates()[0];

      // First vote should succeed
      await votingService.vote(candidate, user);

      // Second vote should fail
      final error = await votingService.vote(candidate, user);
      expect(error, isNotNull);
      expect(error, contains('sudah voting'));
    });

    test('hasVoted should return true after voting', () async {
      final user = UserModel(
        nim: '987654321',
        name: 'Test User 2',
        prodi: 'Sistem Informasi',
        password: 'password2',
      );
      final candidate = VotingService.getCandidates()[1];

      expect(await votingService.hasVoted(user.nim), false);

      await votingService.vote(candidate, user);

      expect(await votingService.hasVoted(user.nim), true);
    });

    test('getHistory should return voting history for user', () async {
      final user = UserModel(
        nim: '555555555',
        name: 'Test User 3',
        prodi: 'Teknik Elektro',
        password: 'password3',
      );
      final candidate = VotingService.getCandidates()[2];

      await votingService.vote(candidate, user);

      final history = await votingService.getHistory(user.nim);
      expect(history, isNotEmpty);
      expect(history.length, 1);
      expect(history[0].idKandidat, candidate.id);
      expect(history[0].idPemilih, user.nim);
    });
  });
}

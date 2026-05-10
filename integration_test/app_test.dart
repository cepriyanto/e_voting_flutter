import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:voting/main.dart';
import 'package:voting/providers/auth_provider.dart';
import 'package:voting/providers/voting_provider.dart';
import 'package:voting/utils/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E-Voting App Integration Test', () {
    testWidgets('Complete voting flow', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => VotingProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should start at login page
      expect(find.text('Login'), findsOneWidget);

      // Navigate to register
      await tester.tap(find.text('Belum punya akun? Daftar'));
      await tester.pumpAndSettle();

      // Fill registration form
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), '123456789');
      await tester.enterText(find.byType(TextFormField).at(2), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(3), 'Teknik Informatika');

      // Tap register button
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      // Should navigate to dashboard
      expect(find.text('Selamat Datang'), findsOneWidget);

      // Navigate to candidates page
      await tester.tap(find.byIcon(Icons.people));
      await tester.pumpAndSettle();

      // Should see candidates list
      expect(find.text('Daftar Kandidat'), findsOneWidget);

      // Tap on first candidate
      await tester.tap(find.text('Ahmad Fauzi').first);
      await tester.pumpAndSettle();

      // Should see candidate detail
      expect(find.text('Detail Kandidat'), findsOneWidget);

      // Vote for candidate
      await tester.tap(find.text('Vote'));
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Voting berhasil!'), findsOneWidget);

      // Navigate to history
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Should see voting history
      expect(find.text('Riwayat Voting'), findsOneWidget);
      expect(find.text('Ahmad Fauzi'), findsOneWidget);

      // Navigate to results
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();

      // Should see voting results
      expect(find.text('Hasil Pemilihan Kandidat'), findsOneWidget);

      // Logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Should be back at login
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Prevent duplicate voting', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => VotingProvider()),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Login with existing user
      await tester.enterText(find.byType(TextFormField).at(0), '123456789');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Navigate to candidates
      await tester.tap(find.byIcon(Icons.people));
      await tester.pumpAndSettle();

      // Try to vote again
      await tester.tap(find.text('Ahmad Fauzi').first);
      await tester.pumpAndSettle();

      // Vote button should not be available or show error
      expect(find.text('Vote'), findsNothing);
    });
  });
}

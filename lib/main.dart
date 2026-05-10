import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/voting_provider.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/dashboard/dashboard_page.dart';
import 'views/kandidat/kandidat_page.dart';
import 'views/kandidat/detail_kandidat_page.dart';
import 'views/riwayat/riwayat_page.dart';
import 'views/hasil/hasil_voting_page.dart';
import 'views/profile/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VotingApp());
}

class VotingApp extends StatelessWidget {
  const VotingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VotingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Voting Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
          textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.textPrimary)),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          Routes.login: (_) => const LoginPage(),
          Routes.register: (_) => const RegisterPage(),
          Routes.dashboard: (_) => const DashboardPage(),
          Routes.kandidat: (_) => const KandidatPage(),
          Routes.detailKandidat: (_) => const DetailKandidatPage(),
          Routes.riwayat: (_) => const RiwayatPage(),
          Routes.hasilVoting: (_) => const HasilVotingPage(),
          Routes.profile: (_) => ProfilePage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isLoggedIn) {
      return const DashboardPage();
    }

    return const LoginPage();
  }
}

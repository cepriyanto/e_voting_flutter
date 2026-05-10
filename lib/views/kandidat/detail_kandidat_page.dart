import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/kandidat_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voting_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/drawer_widget.dart';
import '../../utils/constants.dart';

class DetailKandidatPage extends StatelessWidget {
  const DetailKandidatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kandidat = ModalRoute.of(context)!.settings.arguments as KandidatModel;
    final auth = context.watch<AuthProvider>();
    final voting = context.watch<VotingProvider>();
    final hasVoted = voting.hasVoted;
    final buttonLabel = hasVoted ? 'Anda sudah voting' : 'Vote Kandidat Ini';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Kandidat'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: AppColors.secondary.withAlpha(36), blurRadius: 18)],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.secondary.withAlpha(36),
                        child: Text(kandidat.initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                      ),
                      const SizedBox(height: 16),
                      Text(kandidat.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text('No Urut ${kandidat.number}', style: const TextStyle(color: AppColors.textSecondary)),
                      ),
                      const SizedBox(height: 22),
                      _DetailItem(label: 'Visi', value: kandidat.vision),
                      _DetailItem(label: 'Misi', value: kandidat.mission),
                      _DetailItem(label: 'Program Kerja', value: kandidat.program),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: buttonLabel,
              onPressed: hasVoted || auth.user == null
                  ? () {}
                  : () async {
                      final result = await context.read<VotingProvider>().vote(kandidat, auth.user!);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result ? 'Voting berhasil!' : context.read<VotingProvider>().message ?? 'Gagal voting'),
                          backgroundColor: result ? AppColors.success : AppColors.danger,
                        ),
                      );
                      if (result) {
                        Navigator.pushNamed(context, Routes.riwayat);
                      }
                    },
              enabled: !hasVoted && auth.user != null,
              color: hasVoted ? Colors.grey.shade400 : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/voting_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/kandidat_card.dart';
import '../../utils/constants.dart';

class KandidatPage extends StatelessWidget {
  const KandidatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final voting = context.watch<VotingProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kandidat'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih salah satu kandidat terbaik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Lihat visi, misi, dan program kerja candidate.', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: voting.candidates.length,
                itemBuilder: (context, index) {
                  final candidate = voting.candidates[index];
                  return KandidatCard(
                    kandidat: candidate,
                    onDetailTap: () {
                      Navigator.pushNamed(context, Routes.detailKandidat, arguments: candidate);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

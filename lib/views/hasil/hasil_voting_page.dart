import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/voting_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer_widget.dart';

class HasilVotingPage extends StatefulWidget {
  const HasilVotingPage({super.key});

  @override
  State<HasilVotingPage> createState() => _HasilVotingPageState();
}

class _HasilVotingPageState extends State<HasilVotingPage> {
  List<Map<String, dynamic>> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final votingProvider = context.read<VotingProvider>();
    results = await votingProvider.getVotingResults();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hasil Voting'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Pemilihan Kandidat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Total suara dan persentase kandidat.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : results.isEmpty
                      ? const Center(
                          child: Text('Belum ada voting dilakukan.'),
                        )
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = results[index];
                            final totalVotes = results.fold<int>(0, (sum, r) => sum + (r['suara'] as int));
                            final percentage = totalVotes > 0 ? ((result['suara'] as int) / totalVotes * 100).round() : 0;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result['nama'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          '${result['suara']} suara',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '$percentage%',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    LinearProgressIndicator(
                                      value: totalVotes > 0 ? (result['suara'] as int) / totalVotes : 0,
                                      backgroundColor: AppColors.background,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
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

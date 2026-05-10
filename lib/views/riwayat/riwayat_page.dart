import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/voting_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer_widget.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<VotingProvider>().loadHistory(auth.user!.nim);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final voting = context.watch<VotingProvider>();
    final history = voting.history;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Voting'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: voting.isLoading
            ? const Center(child: CircularProgressIndicator())
            : history.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history, size: 64, color: AppColors.secondary),
                      SizedBox(height: 18),
                      Text('Belum ada riwayat voting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Lakukan voting untuk melihat riwayat Anda.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.candidateName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(item.status, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text('Tanggal: ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} ${item.dateTime.hour.toString().padLeft(2, '0')}:${item.dateTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              Text('Nomor Kandidat: ${item.candidateId}', style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: user == null
            ? const Center(child: Text('Pengguna tidak ditemukan'))
            : Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: AppColors.secondary.withAlpha(46),
                    child: Text(user.name.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(user.prodi, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppColors.secondary.withAlpha(20), blurRadius: 18)]),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Data Diri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _InfoRow(label: 'Nama', value: user.name),
                        const SizedBox(height: 12),
                        _InfoRow(label: 'NIM', value: user.nim),
                        const SizedBox(height: 12),
                        _InfoRow(label: 'Prodi', value: user.prodi),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    label: 'Logout',
                    color: AppColors.danger,
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textSecondary))),
      ],
    );
  }
}

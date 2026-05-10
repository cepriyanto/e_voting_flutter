import 'package:flutter/material.dart';

import '../models/kandidat_model.dart';
import '../utils/colors.dart';

class KandidatCard extends StatelessWidget {
  final KandidatModel kandidat;
  final VoidCallback onDetailTap;

  const KandidatCard({
    super.key,
    required this.kandidat,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: AppColors.secondary.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.secondary.withAlpha(36),
              child: Text(
                kandidat.initials,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kandidat.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'No Urut ${kandidat.number}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onDetailTap,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(130, 48),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.secondary.withAlpha(64),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Lihat Detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

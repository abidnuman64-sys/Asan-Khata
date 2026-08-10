import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/party.dart';
import '../theme/app_theme.dart';

class PartyCard extends StatelessWidget {
  final Party party;
  final VoidCallback onTap;

  const PartyCard({
    super.key,
    required this.party,
    required this.onTap,
  });

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  @override
  Widget build(BuildContext context) {
    final isGave = party.balance < 0;
    final isGot = party.balance > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          radius: 22,
          child: Text(
            party.name.isNotEmpty ? party.name.substring(0, 1) : 'A',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          party.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          'آخرین لین دین: ${party.lastDate}',
          style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatPKR(party.balance),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isGave
                    ? AppColors.gaveRed
                    : isGot
                        ? AppColors.gotGreen
                        : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isGot ? 'آپ نے لینے ہیں' : isGave ? 'آپ نے دینے ہیں' : 'سیٹل ہو گیا',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isGave
                    ? AppColors.gaveRed
                    : isGot
                        ? AppColors.gotGreen
                        : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

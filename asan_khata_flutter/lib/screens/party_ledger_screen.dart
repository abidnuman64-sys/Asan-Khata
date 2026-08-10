import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/receipt_dialog.dart';
import '../widgets/transaction_modal.dart';

class PartyLedgerScreen extends StatelessWidget {
  final int partyId;

  const PartyLedgerScreen({super.key, required this.partyId});

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  void _sendWhatsAppReminder(BuildContext context, String name, String phone, double balance) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final msg = "محترم $name صاحب، آسان کھاتہ (علی جنرل اسٹور) کے مطابق آپ کا بقایا ${formatPKR(balance)} ہے۔ برائے کرم جلد ادائیگی کریں۔ شکریہ!";
    final url = Uri.parse("https://wa.me/92${cleanPhone.length >= 10 ? cleanPhone.substring(cleanPhone.length - 10) : cleanPhone}?text=${Uri.encodeComponent(msg)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('واٹس ایپ کھولنے میں ناکامی')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final party = provider.parties.firstWhere(
      (p) => p.id == partyId,
      orElse: () => provider.parties.first,
    );

    final txs = provider.transactions.where((t) => t.partyId == party.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(party.name),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Party Summary Header Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(party.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('📞 ${party.phone}', style: const TextStyle(fontSize: 13, color: AppColors.textMutedLight)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatPKR(party.balance),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: party.balance >= 0 ? AppColors.gotGreen : AppColors.gaveRed,
                                  ),
                                ),
                                Text(
                                  party.balance >= 0 ? 'آپ نے لینے ہیں' : 'آپ نے دینے ہیں',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: party.balance >= 0 ? AppColors.gotGreen : AppColors.gaveRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // WhatsApp Reminder Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gotGreen,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _sendWhatsAppReminder(context, party.name, party.phone, party.balance),
                            icon: const Icon(Icons.chat, size: 18),
                            label: const Text('💬 واٹس ایپ بقایا یاد دہانی بھیجیں'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Transaction History List Header
                const Text(
                  'ہسٹری لین دین (Transaction History)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Clickable Timeline Transactions List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: txs.length,
                  itemBuilder: (context, index) {
                    final tx = txs[index];
                    final isGave = tx.type == 'gave';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => TransactionReceiptDialog(tx: tx),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '📅 ${tx.date} • ${tx.mode}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isGave ? AppColors.gaveRedLight : AppColors.gotGreenLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isGave ? 'دیے (قرضہ)' : 'لیے (وصولی)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isGave ? AppColors.gaveRed : AppColors.gotGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tx.note.isNotEmpty ? tx.note : 'بلا تفصیل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(
                                '${isGave ? '-' : '+'}${formatPKR(tx.amount)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isGave ? AppColors.gaveRed : AppColors.gotGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Contextual Locked Action Buttons Fixed at Bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gaveRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => TransactionModal(
                          defaultType: 'gave',
                          partyId: party.id,
                          isLocked: true,
                        ),
                      );
                    },
                    child: const Text('🔴 دیے (قرضہ)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gotGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => TransactionModal(
                          defaultType: 'got',
                          partyId: party.id,
                          isLocked: true,
                        ),
                      );
                    },
                    child: const Text('🟢 لیے (وصولی)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

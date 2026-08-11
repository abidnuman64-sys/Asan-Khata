import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/party.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class TransactionReceiptDialog extends StatelessWidget {
  final LedgerTransaction tx;

  const TransactionReceiptDialog({super.key, required this.tx});

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final party = provider.parties.firstWhere(
      (p) => p.id == tx.partyId,
      orElse: () => provider.parties.isNotEmpty ? provider.parties.first : Party(id: 0, name: '', phone: '', type: 'customer', balance: 0, lastDate: ''),
    );

    final isGave = tx.type == 'gave';
    final typeLabel = isGave ? '🔴 دیے (قرضہ / Udhar)' : '🟢 لیے (وصولی / Payment Received)';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '🧾 اینٹری رسید #${tx.id.toString().substring(tx.id.toString().length - 4)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Store Header
              Center(
                child: Column(
                  children: [
                    Text(
                      provider.businessName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${provider.address} • 📞 ${provider.phone}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تاریخ: ${tx.date}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                    ),
                    const Divider(height: 20, thickness: 1),
                  ],
                ),
              ),

              // Details
              _buildRow('کھاتہ دار کا نام:', party.name, isBold: true),
              _buildRow('فون نمبر:', party.phone),
              _buildRow('ادائیگی کا طریقہ:', '💳 ${tx.mode}'),
              _buildRow('اینٹری کی قسم:', typeLabel, isBold: true),
              _buildRow('تفصیل / نوٹ:', tx.note.isNotEmpty ? tx.note : 'بلا تفصیل'),
              const Divider(height: 20, thickness: 2),

              // Total Amount Box
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('رقم (Total Amount):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    '${isGave ? '-' : '+'}${formatPKR(tx.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isGave ? AppColors.gaveRed : AppColors.gotGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gotGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('پی ڈی ایف پرنٹ یا سیو کی جا رہی ہے...')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('PDF ڈاؤن لوڈ'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.gaveRedLight,
                foregroundColor: AppColors.gaveRed,
              ),
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('ڈیلیٹ کی تصدیق'),
                    content: const Text('کیا آپ واقعی یہ اینٹری ڈیلیٹ کرنا چاہتے ہیں؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('منسوخ'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.gaveRed),
                        onPressed: () {
                          Navigator.pop(ctx);
                          provider.deleteTransaction(tx.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('اینٹری ڈیلیٹ کر دی گئی ہے')),
                          );
                        },
                        child: const Text('ڈیلیٹ کریں', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_modal.dart';

class ProfitLossScreen extends StatelessWidget {
  const ProfitLossScreen({super.key});

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  void _openExpenseReceiptDialog(BuildContext context, Expense exp, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('🧾 خرچہ رسید #${exp.id.toString().substring(exp.id.toString().length - 4)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.businessName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text('${provider.address} • 📞 ${provider.phone}', style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
              Text('تاریخ: ${exp.date}', style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('خرچے کی قسم:'), Text(exp.category, style: const TextStyle(fontWeight: FontWeight.bold))],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('تفصیل / نوٹ:'), Text(exp.name, style: const TextStyle(fontWeight: FontWeight.bold))],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('کل رقم:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(formatPKR(exp.amount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.gaveRed)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.gotGreen, foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text('پرنٹ / PDF'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: AppColors.gaveRedLight, foregroundColor: AppColors.gaveRed),
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  provider.deleteExpense(exp.id);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isProfit = provider.netProfit >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📈 پرافٹ اور لاس (Profit & Loss)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.primary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const ExpenseModal(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Profit / Loss Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'مجموعی نفع / نقصان (Net Profit = Revenue - Expenses)',
                      style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${isProfit ? '+' : '-'}${formatPKR(provider.netProfit)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? AppColors.gotGreen : AppColors.gaveRed,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isProfit ? AppColors.gotGreenLight : AppColors.gaveRedLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isProfit ? AppColors.gotGreen : AppColors.gaveRed),
                      ),
                      child: Text(
                        isProfit ? '🟢 ${provider.profitMargin.toStringAsFixed(1)}% منافع (Net Profit Margin)' : '🔴 نقصان (Loss)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isProfit ? AppColors.gotGreen : AppColors.gaveRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Revenue vs Expenses Split Grid (RTL Flow)
            Row(
              children: [
                // Right Side in RTL: Total Revenue (Green)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.gotGreenLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gotGreen.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('مجموعی آمدنی (Total Revenue)', style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                        const SizedBox(height: 4),
                        Text(formatPKR(provider.totalRevenue), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gotGreen)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Left Side in RTL: Total Expenses (Red)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.gaveRedLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gaveRed.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('مجموعی اخراجات (Total Expenses)', style: TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                        const SizedBox(height: 4),
                        Text(formatPKR(provider.totalExpenses), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gaveRed)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Performance Bar Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊 ماہانہ آمدنی بمقابلہ اخراجات (Revenue vs Expenses)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: CustomPaint(
                        size: const Size(double.infinity, 160),
                        painter: MonthlyChartPainter(totalExp: provider.totalExpenses),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Expenses History List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📋 حالیہ اخراجات کی لسٹ (Recent Expenses)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const ExpenseModal(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('نیا خرچہ', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.expenses.length,
              itemBuilder: (context, index) {
                final exp = provider.expenses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () => _openExpenseReceiptDialog(context, exp, provider),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.gaveRedLight,
                      child: Text('💸', style: TextStyle(fontSize: 18)),
                    ),
                    title: Text(exp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('📅 ${exp.date} • ${exp.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('-${formatPKR(exp.amount)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.gaveRed)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => provider.deleteExpense(exp.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyChartPainter extends CustomPainter {
  final double totalExp;

  MonthlyChartPainter({required this.totalExp});

  @override
  void paint(Canvas canvas, Size size) {
    final months = ['مئی', 'جون', 'جولائی', 'اگست'];
    final revenues = [110000.0, 125000.0, 138000.0, 145800.0];
    final expenses = [85000.0, 90000.0, 92000.0, totalExp];

    final paintRev = Paint()..color = AppColors.gotGreen;
    final paintExp = Paint()..color = AppColors.gaveRed;

    final double barWidth = size.width / 12;
    final double gap = size.width / 4;

    for (int i = 0; i < months.length; i++) {
      final double x = (i * gap) + 20;

      final double revH = (revenues[i] / 170000.0) * size.height * 0.8;
      final double expH = (expenses[i] / 170000.0) * size.height * 0.8;

      // Draw Revenue Bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - revH - 20, barWidth, revH),
          const Radius.circular(4),
        ),
        paintRev,
      );

      // Draw Expense Bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + barWidth + 4, size.height - expH - 20, barWidth, expH),
          const Radius.circular(4),
        ),
        paintExp,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

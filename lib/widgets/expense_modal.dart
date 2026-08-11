import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ExpenseModal extends StatefulWidget {
  const ExpenseModal({super.key});

  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  String _category = 'Stock';
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💸 نیا خرچہ درج کریں (Log New Expense)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Picker
            const Text('خرچے کی قسم (Category)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Stock', child: Text('📦 اسٹاک خرید (Stock Purchase)')),
                DropdownMenuItem(value: 'Rent', child: Text('🏪 دکان کا کرایہ (Store Rent)')),
                DropdownMenuItem(value: 'Utilities', child: Text('⚡ بجلی کا بل و یوٹیلٹیز (Utilities)')),
                DropdownMenuItem(value: 'Salaries', child: Text('👤 ملازم کی تنخواہ (Staff Salary)')),
                DropdownMenuItem(value: 'Other', child: Text('💸 متفرق اخراجات (Other Expense)')),
              ],
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),

            // Note
            const Text('تفصیل / نام (Expense Note)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'مثال: جنریٹر فیول یا چائے ناشتہ...',
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            const Text('خرچے کی رقم (Amount PKR)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '0',
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gaveRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final amount = double.tryParse(_amountController.text) ?? 0.0;
                  if (amount <= 0 || _noteController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('براہ کرم تمام معلومات درج کریں')),
                    );
                    return;
                  }

                  provider.addExpense(
                    category: _category,
                    name: _noteController.text.trim(),
                    amount: amount,
                    date: DateTime.now().toString().substring(0, 10),
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('خرچہ کامیابی سے درج ہو گیا ہے!')),
                  );
                },
                child: const Text('💾 خرچہ محفوظ کریں', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

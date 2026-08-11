import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/party.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class TransactionModal extends StatefulWidget {
  final String defaultType; // 'gave' or 'got'
  final int? partyId;
  final bool isLocked;

  const TransactionModal({
    super.key,
    this.defaultType = 'gave',
    this.partyId,
    this.isLocked = false,
  });

  @override
  State<TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends State<TransactionModal> {
  late String _entryType;
  late int? _selectedPartyId;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _paymentMode = 'Cash';

  @override
  void initState() {
    super.initState();
    _entryType = widget.defaultType;
    _selectedPartyId = widget.partyId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addAmount(double val) {
    double current = double.tryParse(_amountController.text) ?? 0.0;
    _amountController.text = (current + val).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final parties = provider.parties;

    if (_selectedPartyId == null && parties.isNotEmpty) {
      _selectedPartyId = parties.first.id;
    }

    final selectedParty = parties.firstWhere(
      (p) => p.id == _selectedPartyId,
      orElse: () => parties.isNotEmpty ? parties.first : Party(id: 0, name: '', phone: '', type: 'customer', balance: 0, lastDate: ''),
    );

    final isGave = _entryType == 'gave';

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
            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isGave ? '🔴' : '🟢'} نیا لین دین درج کریں ${widget.isLocked ? "🔒 (${selectedParty.name})" : ""}',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action Toggle Tabs (Contextual Locking)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isGave ? AppColors.gaveRed : Colors.grey.shade200,
                      foregroundColor: isGave ? Colors.white : Colors.black87,
                      elevation: isGave ? 2 : 0,
                    ),
                    onPressed: (widget.isLocked && !isGave)
                        ? null
                        : () => setState(() => _entryType = 'gave'),
                    child: Text('🔴 دیے (قرضہ) ${widget.isLocked && isGave ? "🔒" : ""}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isGave ? AppColors.gotGreen : Colors.grey.shade200,
                      foregroundColor: !isGave ? Colors.white : Colors.black87,
                      elevation: !isGave ? 2 : 0,
                    ),
                    onPressed: (widget.isLocked && isGave)
                        ? null
                        : () => setState(() => _entryType = 'got'),
                    child: Text('🟢 لیے (وصولی) ${widget.isLocked && !isGave ? "🔒" : ""}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Party Picker
            const Text(
              'کھاتہ دار کا نام',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              initialValue: _selectedPartyId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: parties.map((p) {
                return DropdownMenuItem<int>(
                  value: p.id,
                  child: Text(p.name),
                );
              }).toList(),
              onChanged: widget.isLocked
                  ? null
                  : (val) => setState(() => _selectedPartyId = val),
            ),
            const SizedBox(height: 16),

            // Amount Input
            const Text(
              'رقم (PKR)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
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
            const SizedBox(height: 8),

            // Quick Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionChip(label: const Text('+100'), onPressed: () => _addAmount(100)),
                ActionChip(label: const Text('+500'), onPressed: () => _addAmount(500)),
                ActionChip(label: const Text('+1000'), onPressed: () => _addAmount(1000)),
                ActionChip(label: const Text('+5000'), onPressed: () => _addAmount(5000)),
              ],
            ),
            const SizedBox(height: 16),

            // Note
            const Text(
              'تفصیل / اینٹری نوٹ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'مثال: 5 بوری آٹا یا نقد...',
              ),
            ),
            const SizedBox(height: 16),

            // Payment Mode
            const Text(
              'ادائیگی کا طریقہ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _paymentMode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('نقد (Cash)')),
                DropdownMenuItem(value: 'EasyPaisa', child: Text('ایزی پیسہ (EasyPaisa)')),
                DropdownMenuItem(value: 'JazzCash', child: Text('جاز کیش (JazzCash)')),
                DropdownMenuItem(value: 'Bank', child: Text('بینک ٹرانسفر (Bank)')),
              ],
              onChanged: (val) => setState(() => _paymentMode = val!),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGave ? AppColors.gaveRed : AppColors.gotGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final amount = double.tryParse(_amountController.text) ?? 0.0;
                  if (amount <= 0 || _selectedPartyId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('براہ کرم درست رقم درج کریں')),
                    );
                    return;
                  }

                  provider.addTransaction(
                    partyId: _selectedPartyId!,
                    type: _entryType,
                    amount: amount,
                    note: _noteController.text.trim(),
                    mode: _paymentMode,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isGave ? 'قرضہ اینٹری کامیابی سے درج ہو گئی ہے!' : 'وصولی اینٹری کامیابی سے درج ہو گئی ہے!',
                      ),
                    ),
                  );
                },
                child: Text(
                  isGave ? '🔴 قرضہ محفوظ کریں' : '🟢 وصولی محفوظ کریں',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

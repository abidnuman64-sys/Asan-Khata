import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/party.dart';
import '../providers/app_provider.dart';

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
  // 1. Controllers & State variables
  late String _entryType;
  late int? _selectedPartyId;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String paymentMethod = 'نقد (Cash)'; // Default payment method
  
  bool get isGaveSelected => _entryType == 'gave'; // Checks if "دیے" is selected

  @override
  void initState() {
    super.initState();
    _entryType = widget.defaultType;
    _selectedPartyId = widget.partyId;
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _addAmount(double val) {
    double current = double.tryParse(amountController.text) ?? 0.0;
    amountController.text = (current + val).toStringAsFixed(0);
  }

  // 2. Save Transaction Function
  void saveTransaction() async {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0 || _selectedPartyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم درست رقم درج کریں')),
      );
      return;
    }

    String note = noteController.text.trim();
    final provider = Provider.of<AppProvider>(context, listen: false);

    // Save transaction to local state & storage persistence
    provider.addTransaction(
      partyId: _selectedPartyId!,
      type: isGaveSelected ? 'gave' : 'got', // دیے یا لیے
      amount: amount,
      note: note,
      mode: paymentMethod,
    );

    // Clear fields & close dialog returning true for screen refresh
    amountController.clear();
    noteController.clear();
    Navigator.pop(context, true); // True passed so calling screen refreshes
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
                  '${isGaveSelected ? '🔴' : '🟢'} نیا لین دین درج کریں ${widget.isLocked ? "🔒 (${selectedParty.name})" : ""}',
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
                      backgroundColor: isGaveSelected ? Colors.red : Colors.grey.shade200,
                      foregroundColor: isGaveSelected ? Colors.white : Colors.black87,
                      elevation: isGaveSelected ? 2 : 0,
                    ),
                    onPressed: (widget.isLocked && !isGaveSelected)
                        ? null
                        : () => setState(() => _entryType = 'gave'),
                    child: Text('🔴 دیے (قرضہ) ${widget.isLocked && isGaveSelected ? "🔒" : ""}'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isGaveSelected ? Colors.green : Colors.grey.shade200,
                      foregroundColor: !isGaveSelected ? Colors.white : Colors.black87,
                      elevation: !isGaveSelected ? 2 : 0,
                    ),
                    onPressed: (widget.isLocked && isGaveSelected)
                        ? null
                        : () => setState(() => _entryType = 'got'),
                    child: Text('🟢 لیے (وصولی) ${widget.isLocked && !isGaveSelected ? "🔒" : ""}'),
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
              controller: amountController,
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

            // Note Input
            const Text(
              'تفصیل / اینٹری نوٹ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'مثال: 5 بوری آٹا یا نقد...',
              ),
            ),
            const SizedBox(height: 16),

            // Payment Mode Selection
            const Text(
              'ادائیگی کا طریقہ (Payment Method)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: paymentMethod,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: const [
                DropdownMenuItem(value: 'نقد (Cash)', child: Text('نقد (Cash)')),
                DropdownMenuItem(value: 'ایزی پیسہ (EasyPaisa)', child: Text('ایزی پیسہ (EasyPaisa)')),
                DropdownMenuItem(value: 'جاز کیش (JazzCash)', child: Text('جاز کیش (JazzCash)')),
                DropdownMenuItem(value: 'بینک ٹرانسفر (Bank)', child: Text('بینک ٹرانسفر (Bank)')),
              ],
              onChanged: (val) => setState(() => paymentMethod = val!),
            ),
            const SizedBox(height: 24),

            // 3. Button Code (UI):
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGaveSelected ? Colors.red : Colors.green,
                ),
                onPressed: saveTransaction,
                child: Text(
                  isGaveSelected ? 'قرضہ محفوظ کریں' : 'وصولی محفوظ کریں',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

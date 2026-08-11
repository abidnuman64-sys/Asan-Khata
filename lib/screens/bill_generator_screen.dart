import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/bill.dart';
import '../models/party.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class BillGeneratorScreen extends StatefulWidget {
  const BillGeneratorScreen({super.key});

  @override
  State<BillGeneratorScreen> createState() => _BillGeneratorScreenState();
}

class _BillGeneratorScreenState extends State<BillGeneratorScreen> {
  int? _selectedPartyId;
  final _phoneController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  String _paymentStatus = 'Unpaid';

  final List<BillItem> _currentItems = [
    BillItem(name: 'آٹا 10 کلو', qty: 1, price: 1500),
    BillItem(name: 'گھی 2 کلو', qty: 1, price: 2000),
  ];

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  double get _subtotal {
    double sum = 0;
    for (var i in _currentItems) {
      sum += i.total;
    }
    return sum;
  }

  double get _tax => (_subtotal * 0.18).roundToDouble();

  double get _discount => double.tryParse(_discountController.text) ?? 0.0;

  double get _grandTotal => (_subtotal + _tax - _discount) > 0 ? (_subtotal + _tax - _discount) : 0.0;

  void _addItemRow() {
    setState(() {
      _currentItems.add(BillItem(name: 'نیا آئٹم', qty: 1, price: 500));
    });
  }

  void _removeItemRow(int index) {
    if (_currentItems.length > 1) {
      setState(() {
        _currentItems.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final parties = provider.parties;

    if (_selectedPartyId == null && parties.isNotEmpty) {
      _selectedPartyId = parties.first.id;
      _phoneController.text = parties.first.phone;
    }

    final selectedParty = parties.firstWhere(
      (p) => p.id == _selectedPartyId,
      orElse: () => parties.isNotEmpty ? parties.first : Party(id: 0, name: '', phone: '', type: 'customer', balance: 0, lastDate: ''),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧾 بل جنریٹر (Bill Generator)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bill Form Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('🧾 نیا بل بنائیں (New Invoice)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 12),

                    // Party Picker
                    const Text('گاہک یا دکاندار کا نام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedPartyId,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: parties.map((p) {
                        return DropdownMenuItem<int>(
                          value: p.id,
                          child: Text('${p.name} (${p.phone})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedPartyId = val;
                          final p = parties.firstWhere((element) => element.id == val);
                          _phoneController.text = p.phone;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Phone Input
                    const Text('موبائل فون نمبر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    // Itemized Table Header
                    const Text('آئٹمز کی فہرست (Itemized List)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    // Items List Rows
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _currentItems.length,
                      itemBuilder: (context, index) {
                        final item = _currentItems[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: TextEditingController(text: item.name),
                                  onChanged: (val) => item.name = val,
                                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'آئٹم'),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: TextEditingController(text: item.qty.toStringAsFixed(0)),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() => item.qty = double.tryParse(val) ?? 1),
                                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Qty'),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: TextEditingController(text: item.price.toStringAsFixed(0)),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => setState(() => item.price = double.tryParse(val) ?? 0),
                                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Price'),
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _removeItemRow(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),

                    // Add Item Button
                    OutlinedButton.icon(
                      onPressed: _addItemRow,
                      icon: const Icon(Icons.add, color: AppColors.primary),
                      label: const Text('➕ نیا آئٹم شامل کریں (Add Item)', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),

                    // Totals Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildTotalRow('ذیلی رقم (Subtotal):', formatPKR(_subtotal)),
                          _buildTotalRow('ٹیکس (GST 18%):', formatPKR(_tax)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('رعایت (Discount PKR):'),
                              SizedBox(
                                width: 80,
                                height: 36,
                                child: TextField(
                                  controller: _discountController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          _buildTotalRow('کل واجب الادا (Grand Total):', formatPKR(_grandTotal), isGrand: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Status
                    const Text('ادائیگی کی صورتحال', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _paymentStatus,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Paid', child: Text('🟢 ادا شدہ (Paid)')),
                        DropdownMenuItem(value: 'Unpaid', child: Text('🔴 بقیہ (Unpaid)')),
                        DropdownMenuItem(value: 'Partial', child: Text('🟡 ادھورا (Partial)')),
                      ],
                      onChanged: (val) => setState(() => _paymentStatus = val!),
                    ),
                    const SizedBox(height: 16),

                    // Save Bill Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (_selectedPartyId == null) return;
                        final newBill = SavedBill(
                          id: DateTime.now().millisecondsSinceEpoch,
                          partyId: _selectedPartyId!,
                          partyName: selectedParty.name,
                          phone: _phoneController.text,
                          items: List.from(_currentItems),
                          totals: BillTotals(
                            subtotal: _subtotal,
                            tax: _tax,
                            discount: _discount,
                            grandTotal: _grandTotal,
                          ),
                          status: _paymentStatus,
                          date: DateTime.now().toString().substring(0, 16),
                        );

                        provider.addBill(newBill);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('بل محفوظ ہو گیا! کل رقم: ${formatPKR(_grandTotal)}')),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('💾 بل محفوظ کریں', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Saved Bills List View Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📋 محفوظ شدہ بل (Saved Bills)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Chip(label: Text('${provider.bills.length}')),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.bills.length,
              itemBuilder: (context, index) {
                final bill = provider.bills[index];
                final isPaid = bill.status == 'Paid';
                final isUnpaid = bill.status == 'Unpaid';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(bill.partyName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('📅 ${bill.date} • ${isPaid ? "🟢 ادا شدہ" : isUnpaid ? "🔴 بقیہ" : "🟡 ادھورا"}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(formatPKR(bill.totals.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('بل #${bill.id.toString().substring(bill.id.toString().length - 4)} پی ڈی ایف پرنٹ کی جا رہی ہے...')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            provider.deleteBill(bill.id);
                          },
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

  Widget _buildTotalRow(String label, String val, {bool isGrand = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isGrand ? FontWeight.bold : FontWeight.normal, fontSize: isGrand ? 15 : 13)),
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isGrand ? 16 : 14, color: isGrand ? AppColors.primary : Colors.black87)),
        ],
      ),
    );
  }
}

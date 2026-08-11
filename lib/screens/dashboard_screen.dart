import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/party_card.dart';
import 'party_ledger_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _activeTab = 'customers'; // 'customers' or 'suppliers'
  final _searchController = TextEditingController();

  String formatPKR(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "Rs ${formatter.format(amount.abs())}";
  }

  void _openAddPartyModal(BuildContext context, String type) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                type == 'customer' ? '➕ نیا گاہک شامل کریں' : '➕ نیا سپلائر شامل کریں',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'نام (Name)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'موبائل نمبر (Phone)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == 'customer' ? AppColors.gotGreen : AppColors.gaveRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    Provider.of<AppProvider>(context, listen: false).addParty(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      type: type,
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('محفوظ کریں', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isDark = provider.isDarkMode;

    final filteredParties = provider.parties.where((p) {
      final matchesTab = _activeTab == 'customers' ? p.type == 'customer' : p.type == 'supplier';
      final query = _searchController.text.trim().toLowerCase();
      final matchesSearch = query.isEmpty || p.name.toLowerCase().contains(query) || p.phone.contains(query);
      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 18,
              child: const Text('AGS', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Text(provider.businessName),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => provider.toggleDarkMode(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Balance Summary Card
            Card(
              elevation: 3,
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text('کل بقایا (Net Balance)', style: TextStyle(fontSize: 13, color: AppColors.textMutedLight)),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.netBalance >= 0 ? '+' : '-'}${formatPKR(provider.netBalance)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: provider.netBalance >= 0 ? AppColors.gotGreen : AppColors.gaveRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // RTL Flow Split Cards
                    Row(
                      children: [
                        // Right Side in RTL: You Will Get (Green)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.gotGreenLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gotGreen.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                const Text('آپ نے لینے ہیں', style: TextStyle(fontSize: 12, color: AppColors.gotGreen, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                  formatPKR(provider.totalYouWillGet),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gotGreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Left Side in RTL: You Will Give (Red)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.gaveRedLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gaveRed.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                const Text('آپ نے دینے ہیں', style: TextStyle(fontSize: 12, color: AppColors.gaveRed, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                  formatPKR(provider.totalYouWillGive),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gaveRed),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Color Correction
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gotGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _openAddPartyModal(context, 'customer'),
                    child: const Text('➕ نیا گاہک', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gaveRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _openAddPartyModal(context, 'supplier'),
                    child: const Text('➕ نیا سپلائر', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Tabs
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Center(child: Text('گاہک (${provider.parties.where((p)=>p.type=='customer').length})')),
                    selected: _activeTab == 'customers',
                    onSelected: (val) => setState(() => _activeTab = 'customers'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Center(child: Text('سپلائرز (${provider.parties.where((p)=>p.type=='supplier').length})')),
                    selected: _activeTab == 'suppliers',
                    onSelected: (val) => setState(() => _activeTab = 'suppliers'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'نام یا نمبر تلاش کریں...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 16),

            // Clean Parties List View
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredParties.length,
              itemBuilder: (context, index) {
                final party = filteredParties[index];
                return PartyCard(
                  party: party,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartyLedgerScreen(partyId: party.id),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

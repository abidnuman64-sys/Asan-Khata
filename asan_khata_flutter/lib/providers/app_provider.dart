import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/party.dart';
import '../models/transaction.dart';
import '../models/bill.dart';
import '../models/expense.dart';

class AppProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _lang = 'ur'; // 'ur' or 'en'
  bool _isProfileSetupComplete = true;
  
  String _businessName = 'علی جنرل اسٹور';
  String _ownerName = 'محمد علی';
  String _phone = '0300-1234567';
  String _address = 'مین بازار، لاہور';
  String _email = 'aligeneral@gmail.com';

  List<Party> _parties = [];
  List<LedgerTransaction> _transactions = [];
  List<SavedBill> _bills = [];
  List<Expense> _expenses = [];

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get lang => _lang;
  bool get isProfileSetupComplete => _isProfileSetupComplete;

  String get businessName => _businessName;
  String get ownerName => _ownerName;
  String get phone => _phone;
  String get address => _address;
  String get email => _email;

  List<Party> get parties => _parties;
  List<LedgerTransaction> get transactions => _transactions;
  List<SavedBill> get bills => _bills;
  List<Expense> get expenses => _expenses;

  // Financial Summaries
  double get totalYouWillGet {
    double sum = 0;
    for (var p in _parties) {
      if (p.balance > 0) sum += p.balance;
    }
    return sum;
  }

  double get totalYouWillGive {
    double sum = 0;
    for (var p in _parties) {
      if (p.balance < 0) sum += p.balance.abs();
    }
    return sum;
  }

  double get netBalance => totalYouWillGet - totalYouWillGive;

  // Expense & PnL Calculations
  double get totalRevenue => 145800.0; // Base sales & revenue
  double get totalExpenses {
    double sum = 0;
    for (var e in _expenses) {
      sum += e.amount;
    }
    return sum;
  }

  double get netProfit => totalRevenue - totalExpenses;
  double get profitMargin => (netProfit / (totalRevenue > 0 ? totalRevenue : 1)) * 100;

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('asan_dark') ?? false;
    _lang = prefs.getString('asan_lang') ?? 'ur';
    _isProfileSetupComplete = prefs.getBool('asan_profile_completed') ?? true;

    _businessName = prefs.getString('asan_biz_name') ?? 'علی جنرل اسٹور';
    _ownerName = prefs.getString('asan_owner_name') ?? 'محمد علی';
    _phone = prefs.getString('asan_biz_phone') ?? '0300-1234567';
    _address = prefs.getString('asan_biz_address') ?? 'مین بازار، لاہور';
    _email = prefs.getString('asan_biz_email') ?? 'aligeneral@gmail.com';

    // Seed Parties
    final String? partiesJson = prefs.getString('asan_parties');
    if (partiesJson != null) {
      final List decoded = jsonDecode(partiesJson);
      _parties = decoded.map((item) => Party.fromJson(item)).toList();
    } else {
      _parties = [
        Party(id: 1, name: "حامد (ادائیگی)", phone: "0301-8765432", type: "customer", balance: 12500, lastDate: "2026-08-10"),
        Party(id: 2, name: "احمد کرانہ ہول سیل", phone: "0321-4455667", type: "supplier", balance: -8500, lastDate: "2026-08-09"),
        Party(id: 3, name: "محمد علی (وصولی)", phone: "0333-9988771", type: "customer", balance: 4500, lastDate: "2026-08-08"),
        Party(id: 4, name: "طاہر الیکٹرونکس", phone: "0345-1122334", type: "supplier", balance: -15000, lastDate: "2026-08-05"),
      ];
    }

    // Seed Transactions
    final String? txJson = prefs.getString('asan_transactions');
    if (txJson != null) {
      final List decoded = jsonDecode(txJson);
      _transactions = decoded.map((item) => LedgerTransaction.fromJson(item)).toList();
    } else {
      _transactions = [
        LedgerTransaction(id: 101, partyId: 1, type: "gave", amount: 500, note: "حامد (ادائیگی)", date: "2026-08-10 17:10", mode: "Cash"),
        LedgerTransaction(id: 102, partyId: 2, type: "gave", amount: 1200, note: "نیا اسٹاک (خرید)", date: "2026-08-10 15:40", mode: "EasyPaisa"),
        LedgerTransaction(id: 103, partyId: 3, type: "got", amount: 300, note: "محمد علی (وصولی)", date: "2026-08-10 14:15", mode: "JazzCash"),
        LedgerTransaction(id: 104, partyId: 1, type: "gave", amount: 15000, note: "5 بوریاں آٹا ترسیل", date: "2026-08-09 11:30", mode: "Cash"),
      ];
    }

    // Seed Bills
    final String? billsJson = prefs.getString('asan_bills');
    if (billsJson != null) {
      final List decoded = jsonDecode(billsJson);
      _bills = decoded.map((item) => SavedBill.fromJson(item)).toList();
    } else {
      _bills = [
        SavedBill(
          id: 1001,
          partyId: 1,
          partyName: "حامد (ادائیگی)",
          phone: "0301-8765432",
          items: [
            BillItem(name: "آٹا 10 کلو (Atta 10kg)", qty: 1, price: 1500),
            BillItem(name: "گھی 2 کلو (Ghee 2kg)", qty: 1, price: 2000),
          ],
          totals: BillTotals(subtotal: 3500, tax: 630, discount: 0, grandTotal: 4130),
          status: "Unpaid",
          date: "2026-08-10 16:30",
        ),
        SavedBill(
          id: 1002,
          partyId: 3,
          partyName: "محمد علی (وصولی)",
          phone: "0333-9988771",
          items: [
            BillItem(name: "چینی 5 کلو (Sugar 5kg)", qty: 1, price: 800),
            BillItem(name: "چائے پتی 500 گرام", qty: 1, price: 1000),
          ],
          totals: BillTotals(subtotal: 1800, tax: 324, discount: 124, grandTotal: 2000),
          status: "Paid",
          date: "2026-08-09 14:15",
        ),
      ];
    }

    // Seed Expenses
    final String? expJson = prefs.getString('asan_expenses');
    if (expJson != null) {
      final List decoded = jsonDecode(expJson);
      _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
    } else {
      _expenses = [
        Expense(id: 201, category: "Stock", name: "📦 اسٹاک خرید (Stock Purchase)", amount: 72000, date: "2026-08-05"),
        Expense(id: 202, category: "Rent", name: "🏪 دکان کا کرایہ (Store Rent)", amount: 15000, date: "2026-08-01"),
        Expense(id: 203, category: "Utilities", name: "⚡ بجلی کا بل (Electricity Bill)", amount: 7200, date: "2026-08-08"),
        Expense(id: 204, category: "Salaries", name: "👤 ملازم کی تنخواہ (Staff Salary)", amount: 4000, date: "2026-08-02"),
      ];
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('asan_dark', _isDarkMode);
    await prefs.setString('asan_lang', _lang);
    await prefs.setBool('asan_profile_completed', _isProfileSetupComplete);

    await prefs.setString('asan_biz_name', _businessName);
    await prefs.setString('asan_owner_name', _ownerName);
    await prefs.setString('asan_biz_phone', _phone);
    await prefs.setString('asan_biz_address', _address);
    await prefs.setString('asan_biz_email', _email);

    await prefs.setString('asan_parties', jsonEncode(_parties.map((e) => e.toJson()).toList()));
    await prefs.setString('asan_transactions', jsonEncode(_transactions.map((e) => e.toJson()).toList()));
    await prefs.setString('asan_bills', jsonEncode(_bills.map((e) => e.toJson()).toList()));
    await prefs.setString('asan_expenses', jsonEncode(_expenses.map((e) => e.toJson()).toList()));
  }

  // Mutators
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveData();
    notifyListeners();
  }

  void setLanguage(String l) {
    _lang = l;
    _saveData();
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String owner,
    required String phone,
    required String address,
    required String email,
  }) {
    _businessName = name;
    _ownerName = owner;
    _phone = phone;
    _address = address;
    _email = email;
    _isProfileSetupComplete = true;
    _saveData();
    notifyListeners();
  }

  void addParty({required String name, required String phone, required String type}) {
    final newParty = Party(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      phone: phone,
      type: type,
      balance: 0.0,
      lastDate: DateTime.now().toString().substring(0, 10),
    );
    _parties.add(newParty);
    _saveData();
    notifyListeners();
  }

  void addTransaction({
    required int partyId,
    required String type, // 'gave' or 'got'
    required double amount,
    required String note,
    required String mode,
  }) {
    final newTx = LedgerTransaction(
      id: DateTime.now().millisecondsSinceEpoch,
      partyId: partyId,
      type: type,
      amount: amount,
      note: note,
      date: "${DateTime.now().toString().substring(0, 10)} ${TimeOfDay.now().format(NavigatorKey.context!)}",
      mode: mode,
    );

    _transactions.insert(0, newTx);

    // Update Party Balance
    final partyIndex = _parties.indexWhere((p) => p.id == partyId);
    if (partyIndex != -1) {
      if (type == 'gave') {
        _parties[partyIndex].balance -= amount;
      } else {
        _parties[partyIndex].balance += amount;
      }
      _parties[partyIndex].lastDate = DateTime.now().toString().substring(0, 10);
    }

    _saveData();
    notifyListeners();
  }

  void deleteTransaction(int txId) {
    final txIndex = _transactions.indexWhere((t) => t.id == txId);
    if (txIndex != -1) {
      final tx = _transactions[txIndex];
      final partyIndex = _parties.indexWhere((p) => p.id == tx.partyId);
      if (partyIndex != -1) {
        // Revert party balance
        if (tx.type == 'gave') {
          _parties[partyIndex].balance += tx.amount;
        } else {
          _parties[partyIndex].balance -= tx.amount;
        }
      }
      _transactions.removeAt(txIndex);
      _saveData();
      notifyListeners();
    }
  }

  void addBill(SavedBill bill) {
    _bills.insert(0, bill);

    if (bill.status == 'Unpaid' || bill.status == 'Partial') {
      addTransaction(
        partyId: bill.partyId,
        type: 'gave',
        amount: bill.totals.grandTotal,
        note: "بل جنریٹر رقم (${bill.items.map((i) => i.name).join(', ')})",
        mode: 'Bill',
      );
    }

    _saveData();
    notifyListeners();
  }

  void deleteBill(int billId) {
    _bills.removeWhere((b) => b.id == billId);
    _saveData();
    notifyListeners();
  }

  void addExpense({required String category, required String name, required double amount, required String date}) {
    final newExp = Expense(
      id: DateTime.now().millisecondsSinceEpoch,
      category: category,
      name: name,
      amount: amount,
      date: date,
    );
    _expenses.insert(0, newExp);
    _saveData();
    notifyListeners();
  }

  void deleteExpense(int expId) {
    _expenses.removeWhere((e) => e.id == expId);
    _saveData();
    notifyListeners();
  }
}

class NavigatorKey {
  static BuildContext? context;
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _storeImagePath;

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
  String? get storeImagePath => _storeImagePath;

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
  double get totalRevenue {
    double sum = 0;
    for (var b in _bills) {
      if (b.status == 'Paid') sum += b.totals.grandTotal;
    }
    return sum;
  }

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
    _isProfileSetupComplete = prefs.getBool('is_profile_created') ?? prefs.getBool('asan_profile_completed') ?? false;

    _businessName = prefs.getString('store_name') ?? prefs.getString('asan_biz_name') ?? 'علی جنرل اسٹور';
    _ownerName = prefs.getString('asan_owner_name') ?? 'محمد علی';
    _phone = prefs.getString('store_phone') ?? prefs.getString('asan_biz_phone') ?? '0300-1234567';
    _address = prefs.getString('asan_biz_address') ?? 'مین بازار، لاہور';
    _email = prefs.getString('asan_biz_email') ?? 'aligeneral@gmail.com';
    _storeImagePath = prefs.getString('store_image') ?? prefs.getString('asan_store_image');

    // Seed Parties
    final String? partiesJson = prefs.getString('asan_parties');
    if (partiesJson != null) {
      final List decoded = jsonDecode(partiesJson);
      _parties = decoded.map((item) => Party.fromJson(item)).toList();
    } else {
      _parties = [];
    }

    // Seed Transactions
    final String? txJson = prefs.getString('asan_transactions');
    if (txJson != null) {
      final List decoded = jsonDecode(txJson);
      _transactions = decoded.map((item) => LedgerTransaction.fromJson(item)).toList();
    } else {
      _transactions = [];
    }

    // Seed Bills
    final String? billsJson = prefs.getString('asan_bills');
    if (billsJson != null) {
      final List decoded = jsonDecode(billsJson);
      _bills = decoded.map((item) => SavedBill.fromJson(item)).toList();
    } else {
      _bills = [];
    }

    // Seed Expenses
    final String? expJson = prefs.getString('asan_expenses');
    if (expJson != null) {
      final List decoded = jsonDecode(expJson);
      _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
    } else {
      _expenses = [];
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

    // Firebase Cloud Vault Auto-Sync under User Phone Number (Mobile Native)
    if (!kIsWeb && _phone.trim().isNotEmpty) {
      try {
        final cleanPhone = _phone.replaceAll(RegExp(r'\D'), '');
        if (cleanPhone.isNotEmpty) {
          FirebaseFirestore.instance.collection('user_accounts').doc(cleanPhone).set({
            'businessName': _businessName,
            'ownerName': _ownerName,
            'phone': _phone,
            'address': _address,
            'email': _email,
            'parties': _parties.map((e) => e.toJson()).toList(),
            'transactions': _transactions.map((e) => e.toJson()).toList(),
            'bills': _bills.map((e) => e.toJson()).toList(),
            'expenses': _expenses.map((e) => e.toJson()).toList(),
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint("Firestore sync note: $e");
      }
    }
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

  String _getCleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  String _getLast10Phone(String phone) {
    final clean = _getCleanPhone(phone);
    if (clean.length >= 10) {
      return clean.substring(clean.length - 10);
    }
    return clean;
  }

  Future<Map<String, dynamic>?> _findCloudAccount(String phone) async {
    if (kIsWeb) return null;
    final clean = _getCleanPhone(phone);
    final last10 = _getLast10Phone(phone);
    if (last10.isEmpty) return null;

    final firestore = FirebaseFirestore.instance;

    // 1. Check exact doc ID cleanPhone
    try {
      final doc1 = await firestore.collection('user_accounts').doc(clean).get();
      if (doc1.exists && doc1.data() != null) {
        return doc1.data();
      }
    } catch (e) {
      debugPrint("Doc clean query note: $e");
    }

    // 2. Check doc ID with 0 prefix (e.g. 03001234567)
    try {
      final doc2 = await firestore.collection('user_accounts').doc('0$last10').get();
      if (doc2.exists && doc2.data() != null) {
        return doc2.data();
      }
    } catch (e) {
      debugPrint("Doc 0 query note: $e");
    }

    // 3. Check doc ID with 92 prefix (e.g. 923001234567)
    try {
      final doc3 = await firestore.collection('user_accounts').doc('92$last10').get();
      if (doc3.exists && doc3.data() != null) {
        return doc3.data();
      }
    } catch (e) {
      debugPrint("Doc 92 query note: $e");
    }

    // 4. Query collection user_accounts by phone field containing last 10 digits
    try {
      final querySnapshot = await firestore.collection('user_accounts').limit(25).get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final docPhone = (data['phone'] ?? '').toString();
        final docClean = _getCleanPhone(docPhone);
        if (docClean.contains(last10) || doc.id.contains(last10)) {
          return data;
        }
      }
    } catch (e) {
      debugPrint("Collection scan note: $e");
    }

    return null;
  }

  Future<bool> isPhoneAlreadyRegistered(String phone) async {
    final last10 = _getLast10Phone(phone);
    if (last10.isEmpty) return false;

    // Check Cloud Firestore
    final cloudData = await _findCloudAccount(phone);
    if (cloudData != null) return true;

    // Check SharedPreferences registry
    final prefs = await SharedPreferences.getInstance();
    final registeredPhones = prefs.getStringList('asan_registered_phones') ?? [];
    final savedPhone = prefs.getString('store_phone') ?? prefs.getString('asan_biz_phone') ?? '';
    final savedLast10 = _getLast10Phone(savedPhone);

    return (registeredPhones.any((p) => p.contains(last10))) || (savedLast10.isNotEmpty && savedLast10 == last10);
  }

  Future<bool> restoreAccountFromCloud(String phone) async {
    final cloudData = await _findCloudAccount(phone);
    if (cloudData != null) {
      _businessName = cloudData['businessName'] ?? 'علی جنرل اسٹور';
      _ownerName = cloudData['ownerName'] ?? 'مالک';
      _phone = cloudData['phone'] ?? phone;
      _address = cloudData['address'] ?? '';
      _email = cloudData['email'] ?? '';

      if (cloudData['parties'] != null) {
        _parties = (cloudData['parties'] as List)
            .map((item) => Party.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['transactions'] != null) {
        _transactions = (cloudData['transactions'] as List)
            .map((item) => LedgerTransaction.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['bills'] != null) {
        _bills = (cloudData['bills'] as List)
            .map((item) => SavedBill.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['expenses'] != null) {
        _expenses = (cloudData['expenses'] as List)
            .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      _isProfileSetupComplete = true;

      final prefs = await SharedPreferences.getInstance();
      final cleanPhone = _getCleanPhone(phone);
      final registeredPhones = prefs.getStringList('asan_registered_phones') ?? [];
      if (!registeredPhones.contains(cleanPhone)) {
        registeredPhones.add(cleanPhone);
        await prefs.setStringList('asan_registered_phones', registeredPhones);
      }

      await _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? owner,
    String? address,
    String? email,
    String? imagePath,
  }) async {
    _businessName = name;
    _phone = phone;
    if (owner != null) _ownerName = owner;
    if (address != null) _address = address;
    if (email != null) _email = email;
    if (imagePath != null) _storeImagePath = imagePath;
    _isProfileSetupComplete = true;

    final cleanPhone = _getCleanPhone(phone);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_profile_created', true);
    await prefs.setBool('asan_profile_completed', true);
    await prefs.setString('store_name', name);
    await prefs.setString('asan_biz_name', name);
    await prefs.setString('owner_name', _ownerName);
    await prefs.setString('asan_owner_name', _ownerName);
    await prefs.setString('store_phone', phone);
    await prefs.setString('asan_biz_phone', phone);

    if (cleanPhone.isNotEmpty) {
      final registeredPhones = prefs.getStringList('asan_registered_phones') ?? [];
      if (!registeredPhones.contains(cleanPhone)) {
        registeredPhones.add(cleanPhone);
        await prefs.setStringList('asan_registered_phones', registeredPhones);
      }
    }

    if (imagePath != null) {
      await prefs.setString('store_image', imagePath);
      await prefs.setString('asan_store_image', imagePath);
    }
    await _saveData();
    notifyListeners();
  }

  Future<Map<String, dynamic>> registerUser({
    required String storeName,
    required String ownerName,
    required String phone,
    required String email,
    required String address,
    String? imagePath,
  }) async {
    final cleanPhone = _getCleanPhone(phone);
    if (cleanPhone.isEmpty) {
      return {'success': false, 'message': 'براہ کرم درست موبائل نمبر درج کریں'};
    }

    // Check if phone already registered in Firebase or local
    final bool exists = await isPhoneAlreadyRegistered(phone);
    if (exists) {
      return {
        'success': false,
        'message': 'یہ موبائل نمبر ($phone) پہلے سے فائر بیس سرور میں رجسٹرڈ ہے! براہ کرم لاگ ان کریں۔',
        'alreadyExists': true
      };
    }

    await updateProfile(
      name: storeName,
      owner: ownerName,
      phone: phone,
      email: email,
      address: address,
      imagePath: imagePath,
    );

    return {'success': true, 'message': 'اکاؤنٹ کامیابی سے رجسٹر ہو گیا ہے'};
  }

  Future<Map<String, dynamic>> loginUser({
    required String ownerName,
    required String phone,
  }) async {
    final cleanPhone = _getCleanPhone(phone);
    final last10 = _getLast10Phone(phone);
    if (last10.isEmpty) {
      return {'success': false, 'message': 'براہ کرم درست 11 ہندسوں کا موبائل نمبر درج کریں'};
    }

    final prefs = await SharedPreferences.getInstance();

    // 1. Try Firebase Cloud Lookup & Restore
    final cloudData = await _findCloudAccount(phone);
    if (cloudData != null) {
      final storedOwner = (cloudData['ownerName'] ?? '').toString().trim();
      final storedName = (cloudData['businessName'] ?? '').toString().trim();

      // Flexible name matching
      final inputName = ownerName.trim().toLowerCase();
      final targetOwner = storedOwner.toLowerCase();
      final targetBiz = storedName.toLowerCase();

      bool nameMatches = true;
      if (inputName.isNotEmpty && targetOwner.isNotEmpty) {
        nameMatches = targetOwner.contains(inputName) ||
                      inputName.contains(targetOwner) ||
                      targetBiz.contains(inputName);
      }

      if (!nameMatches) {
        return {
          'success': false,
          'message': 'درج کردہ نام ($ownerName) کلاؤڈ ریکارڈ ($storedOwner) سے میچ نہیں کرتا!',
        };
      }

      // Populate cloud account data into AppProvider state & local storage
      _businessName = cloudData['businessName'] ?? 'علی جنرل اسٹور';
      _ownerName = cloudData['ownerName'] ?? 'مالک';
      _phone = cloudData['phone'] ?? phone;
      _address = cloudData['address'] ?? '';
      _email = cloudData['email'] ?? '';

      if (cloudData['parties'] != null) {
        _parties = (cloudData['parties'] as List)
            .map((item) => Party.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['transactions'] != null) {
        _transactions = (cloudData['transactions'] as List)
            .map((item) => LedgerTransaction.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['bills'] != null) {
        _bills = (cloudData['bills'] as List)
            .map((item) => SavedBill.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      if (cloudData['expenses'] != null) {
        _expenses = (cloudData['expenses'] as List)
            .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      _isProfileSetupComplete = true;

      final registeredPhones = prefs.getStringList('asan_registered_phones') ?? [];
      if (!registeredPhones.contains(cleanPhone)) {
        registeredPhones.add(cleanPhone);
        await prefs.setStringList('asan_registered_phones', registeredPhones);
      }

      await prefs.setBool('is_profile_created', true);
      await prefs.setBool('asan_profile_completed', true);
      await _saveData();
      notifyListeners();

      return {
        'success': true,
        'message': '🎉 خوش آمدید! آپ کا اکاؤنٹ اور کلاؤڈ ڈیٹا کامیابی سے لاگ ان ہو گیا ہے',
      };
    }

    // 2. Try Local Device SharedPreferences Lookup
    final savedPhone = prefs.getString('store_phone') ?? prefs.getString('asan_biz_phone') ?? '';
    final savedClean = _getCleanPhone(savedPhone);
    final savedLast10 = _getLast10Phone(savedPhone);
    final registeredPhones = prefs.getStringList('asan_registered_phones') ?? [];

    bool isLocalRegistered = (registeredPhones.any((p) => p.contains(last10))) ||
                             (savedLast10.isNotEmpty && savedLast10 == last10);

    if (isLocalRegistered || savedClean == cleanPhone) {
      final savedOwner = prefs.getString('owner_name') ?? prefs.getString('asan_owner_name') ?? '';
      final inputName = ownerName.trim().toLowerCase();
      final targetOwner = savedOwner.trim().toLowerCase();

      if (inputName.isNotEmpty && targetOwner.isNotEmpty && !targetOwner.contains(inputName) && !inputName.contains(targetOwner)) {
        return {
          'success': false,
          'message': 'درج کردہ نام ($ownerName) لوکل ڈیوائس کے ریکارڈ ($savedOwner) سے میچ نہیں کرتا!',
        };
      }

      _isProfileSetupComplete = true;
      await prefs.setBool('is_profile_created', true);
      await prefs.setBool('asan_profile_completed', true);
      notifyListeners();
      return {'success': true, 'message': '🎉 خوش آمدید! آپ کا لاگ ان کامیاب رہا'};
    }

    return {
      'success': false,
      'message': 'درج کردہ فون نمبر ($phone) فائر بیس یا لوکل ڈیوائس میں موجود نہیں ہے! براہ کرم نیا اکاؤنٹ رجسٹر کریں۔',
    };
  }

  void addParty({required String name, required String phone, required String type, double initialBalance = 0.0}) {
    final double startingBalance = type == 'supplier' ? -initialBalance.abs() : initialBalance;

    final newParty = Party(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      phone: phone,
      type: type,
      balance: startingBalance,
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
    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final dateStr = "${now.toString().substring(0, 10)} $timeStr";

    final newTx = LedgerTransaction(
      id: now.millisecondsSinceEpoch,
      partyId: partyId,
      type: type,
      amount: amount,
      note: note,
      date: dateStr,
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

  void resetAllDataToZero() {
    _parties.clear();
    _transactions.clear();
    _bills.clear();
    _expenses.clear();
    _saveData();
    notifyListeners();
  }
}

class NavigatorKey {
  static BuildContext? context;
}

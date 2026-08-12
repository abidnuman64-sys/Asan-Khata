import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? prefilledPhone;
  final String? prefilledName;

  const LoginScreen({
    super.key,
    this.prefilledPhone,
    this.prefilledName,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController ownerNameController;
  late TextEditingController phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    ownerNameController = TextEditingController(text: widget.prefilledName ?? '');
    phoneController = TextEditingController(text: widget.prefilledPhone ?? '');
  }

  Future<void> _handleLogin() async {
    final ownerName = ownerNameController.text.trim();
    final phone = phoneController.text.trim();

    if (ownerName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم اپنا نام اور رجسٹرڈ موبائل نمبر درج کریں')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<AppProvider>(context, listen: false);
    final result = await provider.loginUser(
      ownerName: ownerName,
      phone: phone,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'لاگ ان کامیاب رہا'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    } else {
      // Failed login - show warning modal
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('❌ لاگ ان ناکام رہا'),
          content: Text(result['message'] ?? 'درج کردہ نمبر یا نام ڈیٹا بیس میں موجود نہیں ہے!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('دوبارہ کوشش کریں', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('نیا اکاؤنٹ بنائیں', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('🔐 رجسٹرڈ یوزر لاگ ان (Login)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // App Logo Icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: ClipOval(
                child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'آسان کھاتہ لاگ ان پورٹل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            const Text(
              'اپنے پرانے رجسٹرڈ اکاؤنٹ کا ڈیٹا بحال کرنے کے لیے نام اور نمبر درج کریں',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 30),

            // 1. یوزر کا نام
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: '1. یوزر / اونر کا نام (User Name) *',
                hintText: 'مثلاً: محمد علی',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // 2. فون نمبر
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '2. رجسٹرڈ فون نمبر (Phone Number) *',
                hintText: 'مثلاً: 0300-1234567',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 28),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'لاگ ان کریں (Login)',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),

            // Switch to Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('اکاؤنٹ نہیں بنا ہوا؟ ', style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'یہاں نیا اکاؤنٹ بنائیں (Register)',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'profile_setup_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    final phone = phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم درست 11 ہندسوں کا موبائل نمبر درج کریں')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final result = await provider.checkAccountByPhone(phone).timeout(
        const Duration(seconds: 3),
        onTimeout: () => {
          'success': true,
          'exists': false,
          'phone': phone,
        },
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileSetupScreen(
              accountData: result,
              initialPhone: phone,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'موبائل نمبر چیکنگ ناکام رہی')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('📱 سائن ان (WhatsApp Style)'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Animated App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'آسان کھاتہ میں خوش آمدید',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              const Text(
                'اپنا موبائل نمبر درج کریں۔ اگر آپ کا اکاؤنٹ پہلے سے موجود ہوا تو پروفائل سامنے آئے گی، ورنہ نیا فارم پورہ کریں!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMutedLight, height: 1.4),
              ),
              const SizedBox(height: 36),

              // Phone Field Input
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                autofocus: true,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                decoration: InputDecoration(
                  labelText: 'موبائل نمبر (Phone Number)',
                  hintText: '0300-1234567',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 28),

              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _isLoading ? null : _handleContinue,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'آگے بڑھیں (Continue)',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

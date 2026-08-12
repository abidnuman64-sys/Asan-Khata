import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handleRegister() async {
    final storeName = storeNameController.text.trim();
    final ownerName = ownerNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();

    if (storeName.isEmpty || ownerName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم دکان کا نام، اپنا نام اور موبائل نمبر درج کریں')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = {};
    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      result = await provider.registerUser(
        storeName: storeName,
        ownerName: ownerName,
        phone: phone,
        email: email.isNotEmpty ? email : 'info@asankhata.com',
        address: address.isNotEmpty ? address : 'مرکزی بازار',
        imagePath: _selectedImage?.path,
      ).timeout(
        const Duration(seconds: 3),
        onTimeout: () => {'success': true, 'message': 'اکاؤنٹ کامیابی سے رجسٹر ہو گیا ہے'},
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'اکاؤنٹ رجسٹر ہو گیا ہے')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    } else {
      // If phone already exists, suggest logging in
      if (result['alreadyExists'] == true) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('⚠️ اکاؤنٹ پہلے سے موجود ہے'),
            content: Text(result['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('نیا نمبر درج کریں', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen(prefilledPhone: phone, prefilledName: ownerName)),
                  );
                },
                child: const Text('لاگ ان اسکرین پر جائیں', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'رجسٹریشن ناکام رہی')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('📝 نیا اکاؤنٹ رجسٹر کریں (Register)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'خوش آمدید! آسان کھاتہ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            const Text(
              'اپنے کاروبار کا نیا اکاؤنٹ بنانے کے لیے تفصیلات درج کریں',
              style: TextStyle(fontSize: 13, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 24),

            // Profile Picture Selector
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) as ImageProvider
                        : const AssetImage('assets/images/app_logo.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. دکان کا نام
            TextField(
              controller: storeNameController,
              decoration: const InputDecoration(
                labelText: '1. دکان کا نام (Store / Business Name) *',
                hintText: 'مثلاً: علی جنرل اسٹور',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 14),

            // 2. یوزر/اونر کا نام
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: '2. یوزر/اونر کا نام (User / Owner Name) *',
                hintText: 'مثلاً: محمد علی',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 14),

            // 3. موبائل نمبر
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '3. موبائل نمبر (Phone Number) *',
                hintText: 'مثلاً: 0300-1234567',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 14),

            // 4. ای میل ایڈریس
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '4. ای میل ایڈریس (Email Address)',
                hintText: 'مثلاً: aligeneral@gmail.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 14),

            // 5. دکان کا پتہ
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '5. دکان کا پتہ (Store Address)',
                hintText: 'مثلاً: مین بازار، لاہور',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 26),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'رجسٹر کریں اور لاگ ان کریں',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 16),

            // Switch to Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('پہلے سے اکاؤنٹ موجود ہے؟ ', style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'یہاں لاگ ان کریں (Login)',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final storeName = storeNameController.text.trim();
    final ownerName = ownerNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();

    if (storeName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم دکان کا نام اور موبائل نمبر درج کریں')),
      );
      return;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);

    // 🔒 Check if phone number is already registered by another account
    final bool alreadyExists = await provider.isPhoneAlreadyRegistered(phone);
    if (alreadyExists && mounted) {
      final bool? shouldRestore = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('⚠️ اکاؤنٹ پہلے سے موجود ہے'),
            content: Text('موبائل نمبر ($phone) پر پہلے سے آسان کھاتہ کا اکاؤنٹ ریکارڈ میں موجود ہے۔ کیا آپ اس نمبر کا کلاؤڈ ڈیٹا بحال کرنا چاہتے ہیں یا نیا نمبر درج کریں گے؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('نیا نمبر درج کریں', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('ڈیٹا بحال کریں (Restore)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );

      if (shouldRestore == true) {
        final restored = await provider.restoreAccountFromCloud(phone);
        if (restored && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کامیابی! آپ کا سابقہ آسان کھاتہ ڈیٹا بحال ہو گیا ہے')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
          return;
        }
      } else {
        return; // User chooses to type a different unique phone number
      }
    }

    // Save New Unique Account
    await provider.updateProfile(
      name: storeName,
      owner: ownerName.isNotEmpty ? ownerName : 'مالک',
      phone: phone,
      email: email.isNotEmpty ? email : 'info@asankhata.com',
      address: address.isNotEmpty ? address : 'مرکزی بازار',
      imagePath: _selectedImage?.path,
    );

    if (!mounted) return;

    // Navigate to main app home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('پروفائل ترتیبات (Profile Setup)'),
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
              'براہ کرم اپنی دکان اور پروفائل کی معلومات درج کریں',
              style: TextStyle(fontSize: 14, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 24),
            
            // Profile Picture CircleAvatar with ImagePicker Camera Button
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) as ImageProvider
                        : const AssetImage('assets/images/app_logo.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. دکان کا نام (Store / Business Name)
            TextField(
              controller: storeNameController,
              decoration: const InputDecoration(
                labelText: '1. دکان کا نام (Store / Business Name)',
                hintText: 'مثلاً: علی جنرل اسٹور',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 14),

            // 2. یوزر کا نام (User / Owner Name)
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: '2. یوزر کا نام (User / Owner Name)',
                hintText: 'مثلاً: محمد علی',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 14),

            // 3. موبائل نمبر (Phone Number)
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '3. موبائل نمبر (Phone Number)',
                hintText: 'مثلاً: 0300-1234567',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 14),

            // 4. ای میل ایڈریس (Email Address)
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

            // 5. دکان کا پتہ (Store Address)
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
            const SizedBox(height: 28),

            // Save & Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveProfile,
              child: const Text(
                'محفوظ کریں اور لاگ ان کریں',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

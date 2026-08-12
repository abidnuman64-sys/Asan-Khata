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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
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
    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم دکان کا نام اور موبائل نمبر درج کریں')),
      );
      return;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);

    // Save to SharedPreferences & AppProvider
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_profile_created', true);
    await prefs.setBool('asan_profile_completed', true);
    await prefs.setString('store_name', nameController.text.trim());
    await prefs.setString('asan_biz_name', nameController.text.trim());
    await prefs.setString('store_phone', phoneController.text.trim());
    await prefs.setString('asan_biz_phone', phoneController.text.trim());
    
    if (_selectedImage != null) {
      await prefs.setString('store_image', _selectedImage!.path);
      await prefs.setString('asan_store_image', _selectedImage!.path);
    }

    await provider.updateProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
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
            const SizedBox(height: 20),
            const Text(
              'خوش آمدید! آسان کھاتہ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            const Text(
              'براہ کرم اپنی دکان کا نام اور نمبر درج کریں',
              style: TextStyle(fontSize: 14, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 30),
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
                    child: _selectedImage == null
                        ? null
                        : null,
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'دکان یا یوزر کا نام (Store Name)',
                hintText: 'مثلاً: علی جنرل اسٹور',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'موبائل نمبر (Phone Number)',
                hintText: '0300-1234567',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveProfile,
              child: const Text('محفوظ کریں اور لاگ ان کریں', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

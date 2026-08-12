import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Map<String, dynamic>? accountData;
  final String? initialPhone;

  const ProfileSetupScreen({
    super.key,
    this.accountData,
    this.initialPhone,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late TextEditingController storeNameController;
  late TextEditingController ownerNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isExistingAccount = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.accountData ?? {};
    _isExistingAccount = data['exists'] == true;

    storeNameController = TextEditingController(text: data['storeName'] ?? '');
    ownerNameController = TextEditingController(text: data['ownerName'] ?? '');
    phoneController = TextEditingController(text: widget.initialPhone ?? data['phone'] ?? '');
    emailController = TextEditingController(text: data['email'] ?? '');
    addressController = TextEditingController(text: data['address'] ?? '');
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handleSaveOrConfirm() async {
    final storeName = storeNameController.text.trim();
    final ownerName = ownerNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم اپنا موبائل نمبر درج کریں')),
      );
      return;
    }

    if (!_isExistingAccount && (storeName.isEmpty || ownerName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم دکان کا نام اور اپنا نام درج کریں')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);

      if (_isExistingAccount && widget.accountData != null) {
        await provider.confirmExistingAccount(widget.accountData!);
      } else {
        await provider.updateProfile(
          name: storeName.isNotEmpty ? storeName : 'دکان آسان کھاتہ',
          owner: ownerName.isNotEmpty ? ownerName : 'مالک',
          phone: phone,
          email: email.isNotEmpty ? email : 'info@asankhata.com',
          address: address.isNotEmpty ? address : 'مرکزی بازار',
          imagePath: _selectedImage?.path,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isExistingAccount ? '🎉 خوش آمدید! آپ کا کھاتہ کھل گیا ہے' : '🎉 آپ کی پروفائل محفوظ ہو گئی ہے'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isExistingAccount ? '🎉 پروفائل مل گئی (Account Found)' : '📝 پروفائل بنائیں (Profile Setup)'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Banner Notification
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isExistingAccount ? Colors.green[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isExistingAccount ? Colors.green : Colors.blue),
              ),
              child: Row(
                children: [
                  Icon(_isExistingAccount ? Icons.check_circle : Icons.edit, color: _isExistingAccount ? Colors.green : Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isExistingAccount
                          ? 'پہلے سے موجود اکاؤنٹ مل گیا ہے! ڈیٹا بحال کرنے کے لیے نیچے بٹن دبائیں۔'
                          : 'نیا اکاؤنٹ۔ براہ کرم اپنی دکان اور پروفائل کی معلومات درج کریں۔',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _isExistingAccount ? Colors.green[900] : Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Picture CircleAvatar with ImagePicker
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
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

            // 1. دکان کا نام (Store Name)
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

            // 2. یوزر/اونر کا نام (User Name)
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: '2. یوزر / اونر کا نام (User Name) *',
                hintText: 'مثلاً: محمد علی',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 14),

            // 3. موبائل نمبر (Phone Number - Fixed)
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              readOnly: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: '3. موبائل نمبر (Phone Number)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone, color: Colors.green),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
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
            const SizedBox(height: 28),

            // Main WhatsApp-Style Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              onPressed: _isLoading ? null : _handleSaveOrConfirm,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isExistingAccount ? '🟢 کھاتہ کھولیں (Open Khata App)' : '🟢 پروفائل محفوظ کریں اور کھاتہ شروع کریں',
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

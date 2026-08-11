import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _openEditProfileModal(BuildContext context, AppProvider provider) {
    final nameController = TextEditingController(text: provider.businessName);
    final ownerController = TextEditingController(text: provider.ownerName);
    final phoneController = TextEditingController(text: provider.phone);
    final addressController = TextEditingController(text: provider.address);
    final emailController = TextEditingController(text: provider.email);

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('✏️ پروفائل ایڈٹ کریں (Edit Profile)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'دکان کا نام (Business Name)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: ownerController, decoration: const InputDecoration(labelText: 'مالک کا نام (Owner Name)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'موبائل نمبر (Phone)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: 'پتہ (Address)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'ای میل (Email)', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    provider.updateProfile(
                      name: nameController.text.trim(),
                      owner: ownerController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: addressController.text.trim(),
                      email: emailController.text.trim(),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('پروفائل کامیاب سے اپ ڈیٹ ہو گئی ہے!')),
                    );
                  },
                  child: const Text('💾 پروفائل محفوظ کریں', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ ترتیبات / پروفائل (Settings)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary,
                          child: const Text('AGS', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: AppColors.primaryDark,
                            child: const Icon(Icons.camera_alt, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provider.businessName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('📞 ${provider.phone}', style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _openEditProfileModal(context, provider),
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('ترمیم', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Settings
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('📱 ایپ کی ترتیبات (App Settings)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
                    title: const Text('ڈارک موڈ (Dark Mode)'),
                    value: provider.isDarkMode,
                    onChanged: (_) => provider.toggleDarkMode(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: const Text('زبان کی تبدیلی (Language)'),
                    trailing: Text(provider.lang == 'ur' ? 'اردو (Urdu) ›' : 'English ›', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      provider.setLanguage(provider.lang == 'ur' ? 'en' : 'ur');
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services, color: AppColors.gaveRed),
                    title: const Text('تمام ڈیٹا صاف کریں (Reset All to Rs 0)', style: TextStyle(color: AppColors.gaveRed, fontWeight: FontWeight.bold)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ری سیٹ کی تصدیق'),
                          content: const Text('کیا آپ واقعی تمام کھاتے اور اینٹریز مٹا کر 0 پر ری سیٹ کرنا چاہتے ہیں؟'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('منسوخ')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.gaveRed),
                              onPressed: () {
                                Navigator.pop(ctx);
                                provider.resetAllDataToZero();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تمام ڈیٹا ری سیٹ ہو گیا ہے')),
                                );
                              },
                              child: const Text('ری سیٹ کریں', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Support & Legal
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('ℹ️ مدد اور قانونی (Support & Legal)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: AppColors.primary),
                    title: const Text('ہیلپ سینٹر (Help Center)'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                    title: const Text('پرائیویسی پالیسی (Privacy Policy)'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gaveRedLight,
                foregroundColor: AppColors.gaveRed,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('لاگ آؤٹ کی تصدیق'),
                    content: const Text('کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('منسوخ')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.gaveRed),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('لاگ آؤٹ', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('لاگ آؤٹ کریں (Log out)', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _prodiController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = UserModel(
      name: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      prodi: _prodiController.text.trim(),
      password: _passwordController.text.trim(),
    );
    final error = await authProvider.register(user);
    if (!mounted) return;

    if (error == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil. Silakan login.'), backgroundColor: AppColors.success),
      );
      navigator.pop();
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text(error), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text('Buat akun untuk memulai voting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Nama Lengkap',
                  controller: _nameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'NIM',
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.trim().isEmpty ? 'NIM tidak boleh kosong' : null,
                  prefixIcon: const Icon(Icons.badge, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Prodi',
                  controller: _prodiController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Prodi tidak boleh kosong' : null,
                  prefixIcon: const Icon(Icons.school, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) => value == null || value.trim().length < 6 ? 'Password minimal 6 karakter' : null,
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Konfirmasi Password',
                  controller: _confirmController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                ),
                const SizedBox(height: 26),
                CustomButton(
                  label: auth.isLoading ? 'Memproses...' : 'DAFTAR',
                  onPressed: auth.isLoading ? () {} : () => _register(context),
                  enabled: !auth.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

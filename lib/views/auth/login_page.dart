import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/voting_provider.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final votingProvider = Provider.of<VotingProvider>(context, listen: false);
    final success = await authProvider.login(_nimController.text.trim(), _passwordController.text.trim());
    if (!mounted) return;

    if (success && authProvider.user != null) {
      await votingProvider.loadHistory(authProvider.user!.nim);
      if (!mounted) return;
      navigator.pushNamedAndRemoveUntil(Routes.dashboard, (route) => false);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(authProvider.message ?? 'Login gagal'), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.how_to_vote, color: Colors.white, size: 38),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk untuk melanjutkan voting ketua kelas informatika 4A',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: '',
                      hintText: 'Masukkan NIM',
                      controller: _nimController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'NIM tidak boleh kosong';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: auth.isLoading ? 'Memproses...' : 'LOGIN',
                      onPressed: auth.isLoading ? () {} : () => _login(context),
                      enabled: !auth.isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?', style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.register),
                    child: const Text('Daftar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

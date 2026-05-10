import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  String? _message;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null && _user!.nim.isNotEmpty;
  String? get message => _message;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      final current = await _authService.getCurrentUser();
      if (current != null && current.nim.isNotEmpty) {
        _user = current;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String nim, String password) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    final result = await _authService.login(nim, password);
    if (result == null) {
      _message = 'NIM atau password salah.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = result;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<String?> register(UserModel user) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    final error = await _authService.register(user);
    _isLoading = false;
    _message = error;
    notifyListeners();
    return error;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }
}

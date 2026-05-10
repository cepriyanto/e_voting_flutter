import '../models/user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  Future<List<UserModel>> _loadUsers() async {
    return LocalStorageService.getUsers();
  }

  Future<UserModel?> login(String nim, String password) async {
    final users = await _loadUsers();
    final matched = users.where((user) => user.nim == nim && user.password == password);
    if (matched.isEmpty) {
      return null;
    }
    final user = matched.first;
    await LocalStorageService.setLogin(user.nim);
    return user;
  }

  Future<String?> register(UserModel user) async {
    final users = await _loadUsers();
    final exists = users.any((item) => item.nim == user.nim);
    if (exists) {
      return 'NIM sudah terdaftar.';
    }
    users.add(user);
    await LocalStorageService.saveUsers(users);
    return null;
  }

  Future<bool> isLoggedIn() async {
    return LocalStorageService.isLoggedIn();
  }

  Future<UserModel?> getCurrentUser() async {
    final loggedNim = await LocalStorageService.getLoggedNim();
    if (loggedNim == null) return null;
    final users = await _loadUsers();
    final matched = users.where((user) => user.nim == loggedNim).toList();
    if (matched.isEmpty) return null;
    return matched.first;
  }

  Future<void> logout() async {
    await LocalStorageService.clearLogin();
  }
}

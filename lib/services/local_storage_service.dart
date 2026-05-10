import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/voting_model.dart';
import '../utils/constants.dart';

class LocalStorageService {
  LocalStorageService._();

  static Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  static Future<List<UserModel>> getUsers() async {
    final prefs = await LocalStorageService.prefs;
    final raw = prefs.getString(PrefKeys.users);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  static Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await LocalStorageService.prefs;
    final encoded = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString(PrefKeys.users, encoded);
  }

  static Future<void> setLogin(String nim) async {
    final prefs = await LocalStorageService.prefs;
    await prefs.setBool(PrefKeys.loggedIn, true);
    await prefs.setString(PrefKeys.loggedNim, nim);
  }

  static Future<void> clearLogin() async {
    final prefs = await LocalStorageService.prefs;
    await prefs.setBool(PrefKeys.loggedIn, false);
    await prefs.remove(PrefKeys.loggedNim);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await LocalStorageService.prefs;
    return prefs.getBool(PrefKeys.loggedIn) ?? false;
  }

  static Future<String?> getLoggedNim() async {
    final prefs = await LocalStorageService.prefs;
    return prefs.getString(PrefKeys.loggedNim);
  }

  static Future<List<VotingModel>> getVotingHistory(String nim) async {
    final prefs = await LocalStorageService.prefs;
    final raw = prefs.getString(PrefKeys.voteHistory(nim));
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((item) => VotingModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveVotingHistory(String nim, List<VotingModel> history) async {
    final prefs = await LocalStorageService.prefs;
    final encoded = jsonEncode(history.map((item) => item.toJson()).toList());
    await prefs.setString(PrefKeys.voteHistory(nim), encoded);
  }

  static Future<bool> hasVoted(String nim) async {
    final prefs = await LocalStorageService.prefs;
    return prefs.getBool(PrefKeys.voteStatus(nim)) ?? false;
  }

  static Future<void> setHasVoted(String nim, bool value) async {
    final prefs = await LocalStorageService.prefs;
    await prefs.setBool(PrefKeys.voteStatus(nim), value);
  }
}

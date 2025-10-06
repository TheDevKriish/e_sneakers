import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const _kUsers = 'registered_users';
  static const _kCurrentUser = 'current_user';

  static Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString(_kUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersData);
      
      if (users.any((user) => user['email'] == email)) {
        return false;
      }
      
      users.add({
        'name': name,
        'email': email,
        'password': password,
        'isAdmin': email.endsWith('@admin.com'),
        'registeredAt': DateTime.now().toIso8601String(),
      });
      
      await prefs.setString(_kUsers, jsonEncode(users));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString(_kUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersData);
      
      final user = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => null,
      );
      
      if (user != null) {
        await prefs.setString(_kCurrentUser, jsonEncode(user));
        return Map<String, dynamic>.from(user);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_kCurrentUser);
      if (userData != null) {
        return Map<String, dynamic>.from(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = await getCurrentUser();
      if (currentUser == null) return false;
      
      final usersData = prefs.getString(_kUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersData);
      
      final userIndex = users.indexWhere((user) => user['email'] == currentUser['email']);
      if (userIndex >= 0) {
        users[userIndex]['name'] = name;
        users[userIndex]['email'] = email;
        await prefs.setString(_kUsers, jsonEncode(users));
        
        currentUser['name'] = name;
        currentUser['email'] = email;
        await prefs.setString(_kCurrentUser, jsonEncode(currentUser));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser['password'] != oldPassword) {
        return false;
      }
      
      final usersData = prefs.getString(_kUsers) ?? '[]';
      final List<dynamic> users = jsonDecode(usersData);
      
      final userIndex = users.indexWhere((user) => user['email'] == currentUser['email']);
      if (userIndex >= 0) {
        users[userIndex]['password'] = newPassword;
        await prefs.setString(_kUsers, jsonEncode(users));
        
        currentUser['password'] = newPassword;
        await prefs.setString(_kCurrentUser, jsonEncode(currentUser));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCurrentUser);
    } catch (e) {
      // Handle error silently
    }
  }   
}

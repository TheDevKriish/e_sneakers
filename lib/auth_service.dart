import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      bool isAdmin = email.toLowerCase().endsWith('@admin.com');

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'isAdmin': isAdmin,
        'phone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Account created successfully',
        'user': {
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'isAdmin': isAdmin,
        }
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak (min 6 characters)';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['uid'] = userCredential.user!.uid;
        return {'success': true, 'user': userData};
      } else {
        bool isAdmin = email.toLowerCase().endsWith('@admin.com');
        Map<String, dynamic> userData = {
          'uid': userCredential.user!.uid,
          'name': email.split('@')[0],
          'email': email,
          'isAdmin': isAdmin,
          'phone': '',
          'address': '',
        };
        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
        return {'success': true, 'user': userData};
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['uid'] = currentUser.uid;
        userData['email'] = currentUser.email;
        return userData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? address,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      Map<String, dynamic> updates = {'name': name};
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;

      await _firestore.collection('users').doc(currentUser.uid).update(updates);

      return {'success': true, 'message': 'Profile updated successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Update failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(newPassword);

      return {'success': true, 'message': 'Password changed successfully'};
    } on FirebaseAuthException catch (e) {
      String message = 'Password change failed';
      if (e.code == 'wrong-password') {
        message = 'Current password is incorrect';
      } else if (e.code == 'weak-password') {
        message = 'New password is too weak';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent'};
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}


// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class AuthService {
//   static const _kUsers = 'registered_users';
//   static const _kCurrentUser = 'current_user';

//   static Future<bool> signup({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final usersData = prefs.getString(_kUsers) ?? '[]';
//       final List<dynamic> users = jsonDecode(usersData);
      
//       if (users.any((user) => user['email'] == email)) {
//         return false;
//       }
      
//       users.add({
//         'name': name,
//         'email': email,
//         'password': password,
//         'isAdmin': email.endsWith('@admin.com'),
//         'registeredAt': DateTime.now().toIso8601String(),
//       });
      
//       await prefs.setString(_kUsers, jsonEncode(users));
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<Map<String, dynamic>?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final usersData = prefs.getString(_kUsers) ?? '[]';
//       final List<dynamic> users = jsonDecode(usersData);
      
//       final user = users.firstWhere(
//         (user) => user['email'] == email && user['password'] == password,
//         orElse: () => null,
//       );
      
//       if (user != null) {
//         await prefs.setString(_kCurrentUser, jsonEncode(user));
//         return Map<String, dynamic>.from(user);
//       }
      
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<Map<String, dynamic>?> getCurrentUser() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userData = prefs.getString(_kCurrentUser);
//       if (userData != null) {
//         return Map<String, dynamic>.from(jsonDecode(userData));
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<bool> updateProfile({
//     required String name,
//     required String email,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final currentUser = await getCurrentUser();
//       if (currentUser == null) return false;
      
//       final usersData = prefs.getString(_kUsers) ?? '[]';
//       final List<dynamic> users = jsonDecode(usersData);
      
//       final userIndex = users.indexWhere((user) => user['email'] == currentUser['email']);
//       if (userIndex >= 0) {
//         users[userIndex]['name'] = name;
//         users[userIndex]['email'] = email;
//         await prefs.setString(_kUsers, jsonEncode(users));
        
//         currentUser['name'] = name;
//         currentUser['email'] = email;
//         await prefs.setString(_kCurrentUser, jsonEncode(currentUser));
//         return true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<bool> changePassword({
//     required String oldPassword,
//     required String newPassword,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final currentUser = await getCurrentUser();
//       if (currentUser == null || currentUser['password'] != oldPassword) {
//         return false;
//       }
      
//       final usersData = prefs.getString(_kUsers) ?? '[]';
//       final List<dynamic> users = jsonDecode(usersData);
      
//       final userIndex = users.indexWhere((user) => user['email'] == currentUser['email']);
//       if (userIndex >= 0) {
//         users[userIndex]['password'] = newPassword;
//         await prefs.setString(_kUsers, jsonEncode(users));
        
//         currentUser['password'] = newPassword;
//         await prefs.setString(_kCurrentUser, jsonEncode(currentUser));
//         return true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<void> logout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_kCurrentUser);
//     } catch (e) {
//       // Handle error silently
//     }
//   }   
// }

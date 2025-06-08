import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app_flutter/models/user_model.dart';
import 'package:meditation_app_flutter/config/config.dart';
import 'package:meditation_app_flutter/services/http_client.dart';

class AuthService {
  final HttpClient _httpClient = HttpClient();
  static const String _userKey = 'user_data';

  // Save user data to local storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get user data from local storage
  Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Clear auth data (logout)
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await _httpClient.clearCookies();
  }

  // Register a new user
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _httpClient.post(
        '/api/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        final user = User.fromJson(data['user']);
        await _saveUserData(user);
        return {'success': true, 'user': user};
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Error de registro',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión. Por favor, intente de nuevo.',
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (kDebugMode) {
      print('AuthService: Starting login for email: $email');
    }
    
    try {
      if (kDebugMode) {
        print('AuthService: Sending login request to /api/auth/login');
      }
      
      final response = await _httpClient.post(
        '/api/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (kDebugMode) {
        print('AuthService: Received response with status: ${response.statusCode}');
        print('AuthService: Response body: ${response.body}');
      }

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('AuthService: Login successful, parsing user data');
        }
        
        final user = User.fromJson(data);
        
        if (kDebugMode) {
          print('AuthService: Saving user data to local storage');
        }
        
        await _saveUserData(user);
        
        if (kDebugMode) {
          print('AuthService: User data saved, returning success');
        }
        
        return {'success': true, 'user': user};
      } else {
        final errorMessage = data['message'] ?? 'Error de autenticación';
        
        if (kDebugMode) {
          print('AuthService: Login failed: $errorMessage');
        }
        
        return {
          'success': false, 
          'message': errorMessage,
        };
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('AuthService: Exception during login: $e');
        print('Stack trace: $stackTrace');
      }
      
      return {
        'success': false,
        'message': 'Error de conexión. Por favor, intente de nuevo.',
      };
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _httpClient.post('/api/auth/logout');
    } catch (e) {
      // Ignore errors during logout
    } finally {
      await clearAuthData();
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final response = await _httpClient.get('/api/auth/profile');

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final user = User.fromJson(userData);
        await _saveUserData(user);
        return user;
      } else {
        await clearAuthData();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final response = await _httpClient.get('/api/auth/profile');
      if (response.statusCode == 200) {
        // Update user data if needed
        final userData = jsonDecode(response.body);
        await _saveUserData(User.fromJson(userData));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile(String name, String email, {String? currentPassword, String? newPassword}) async {
    try {
      final Map<String, dynamic> body = {
        'name': name,
        'email': email,
      };

      // Only include password fields if they are provided
      if (currentPassword != null && currentPassword.isNotEmpty && 
          newPassword != null && newPassword.isNotEmpty) {
        body['current_password'] = currentPassword;
        body['new_password'] = newPassword;
      }

      final response = await _httpClient.put(
        '/api/auth/profile',
        body: body,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final user = User.fromJson(data);
        await _saveUserData(user);
        return {
          'success': true, 
          'user': user,
          'message': 'Profile updated successfully',
        };
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService - updateProfile error: $e');
      }
      return {
        'success': false,
        'message': 'Failed to update profile. Please try again.',
      };
    }
  }

  // Change user password
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _httpClient.put(
        '/api/auth/change-password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Update the user data if the response includes it
        if (data['user'] != null) {
          final user = User.fromJson(data['user']);
          await _saveUserData(user);
        }
        
        return {
          'success': true, 
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService - changePassword error: $e');
      }
      return {
        'success': false,
        'message': 'Failed to change password. Please try again.',
      };
    }
  }
}

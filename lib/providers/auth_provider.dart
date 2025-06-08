import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/models/user_model.dart';
import 'package:meditation_app_flutter/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // State
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  // Initialize auth state
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.getCurrentUser();
      if (response['success'] == true) {
        _user = response['user'] as User?;
        _isInitialized = true;
      } else {
        _error = response['message'] ?? 'Failed to initialize user session';
      }
    } catch (e) {
      _error = 'Error initializing authentication: ${e.toString()}';
      if (kDebugMode) {
        print('AuthProvider - initialize error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check authentication status (async version that refreshes the user)
  Future<bool> checkAuthentication() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_user != null) return true;
    
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final response = await _authService.getCurrentUser();
        if (response['success'] == true) {
          _user = response['user'] as User?;
          notifyListeners();
          return _user != null;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('AuthProvider - checkAuthentication error: $e');
      }
      return false;
    }
  }

  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(name, email, password);
      
      if (result['success'] == true) {
        _user = result['user'];
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      _isLoading = false;
      if (kDebugMode) {
        print('AuthProvider - register error: $e');
      }
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    if (kDebugMode) {
      print('AuthProvider: Starting login process for email: $email');
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (kDebugMode) {
        print('AuthProvider: Calling _authService.login...');
      }
      
      final result = await _authService.login(email, password);
      
      if (kDebugMode) {
        print('AuthProvider: Login result: $result');
      }
      
      if (result['success'] == true) {
        if (kDebugMode) {
          print('AuthProvider: Login successful, updating user state');
        }
        
        _user = result['user'];
        _isLoading = false;
        _isInitialized = true;
        notifyListeners();
        
        if (kDebugMode) {
          print('AuthProvider: User state updated, returning true');
        }
        
        return true;
      } else {
        _error = result['message'] ?? 'Login failed';
        _isLoading = false;
        
        if (kDebugMode) {
          print('AuthProvider: Login failed: $_error');
        }
        
        notifyListeners();
        return false;
      }
    } catch (e, stackTrace) {
      _error = 'Login failed. Please check your connection and try again.';
      _isLoading = false;
      
      if (kDebugMode) {
        print('AuthProvider: Login error: $e');
        print('Stack trace: $stackTrace');
      }
      
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      if (kDebugMode) {
        print('AuthProvider: Starting logout process');
      }
      
      // Clear user data from provider
      _user = null;
      _isLoading = false;
      _isInitialized = true;
      _error = null;
      
      // Notify listeners before clearing auth data
      notifyListeners();
      
      // Clear auth data from service (including cookies and cache)
      await _authService.logout();
      
      if (kDebugMode) {
        print('AuthProvider: Logout completed successfully');
      }
    } catch (e, stackTrace) {
      _error = 'Logout failed. Please try again.';
      _isLoading = false;
      
      if (kDebugMode) {
        print('AuthProvider: Error during logout: $e');
        print('Stack trace: $stackTrace');
      }
      
      // Still notify listeners to update UI
      notifyListeners();
      
      // Rethrow to allow UI to handle the error if needed
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
  
  // Get auth token (for API requests)
  Future<String?> getToken() async {
    if (_user == null) return null;
    // If you need to store and retrieve a token separately, implement this
    return null;
  }
  
  /// Updates the user's profile image
  /// Returns true if the update was successful, false otherwise
  Future<bool> updateProfileImage(String imagePath) async {
    if (_isLoading) {
      debugPrint('Profile image upload already in progress');
      return false;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Starting profile image upload...');
      final result = await _authService.updateProfileImage(imagePath);
      
      if (result['success'] == true && result['imageUrl'] != null) {
        final imageUrl = result['imageUrl'];
        debugPrint('Profile image upload successful. Image URL: $imageUrl');
        
        // Update the current user with the new image URL
        if (_user != null) {
          _user = _user!.copyWith(profileImageUrl: imageUrl);
          debugPrint('Updated local user with new profile image URL');
          notifyListeners();
          return true;
        }
        
        _error = 'User not found in local storage';
        debugPrint(_error!);
        return false;
      } else {
        // Handle specific error cases
        final errorMessage = result['message'] ?? 'Failed to update profile image';
        final statusCode = result['statusCode'];
        
        if (statusCode != null) {
          if (statusCode == 401) {
            _error = 'Session expired. Please log in again.';
          } else if (statusCode >= 500) {
            _error = 'Server error. Please try again later.';
          } else if (statusCode == 413) {
            _error = 'Image file is too large. Please select a smaller image.';
          } else {
            _error = errorMessage;
          }
        } else {
          _error = errorMessage;
        }
        
        debugPrint('Error updating profile image: $_error (Status: $statusCode)');
        return false;
      }
    } on TimeoutException catch (e) {
      _error = 'Request timed out. Please check your internet connection and try again.';
      debugPrint('Profile image upload timeout: $e');
      return false;
    } on SocketException catch (e) {
      _error = 'Network error. Please check your internet connection.';
      debugPrint('Network error during profile image upload: $e');
      return false;
    } catch (e, stackTrace) {
      _error = 'An unexpected error occurred. Please try again.';
      debugPrint('Unexpected error updating profile image: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      
      if (_error != null) {
        debugPrint('Final error state: $_error');
      } else {
        debugPrint('Profile image update completed successfully');
      }
    }
  }
  
  // Update user profile
  Future<Map<String, dynamic>> updateProfile(String name, String email, {String? currentPassword, String? newPassword}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.updateProfile(
        name, 
        email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      _isLoading = false;
      
      if (result['success'] == true) {
        _user = result['user'];
        notifyListeners();
        return {
          'success': true,
          'message': result['message'] ?? 'Profile updated successfully',
        };
      } else {
        _error = result['message'] ?? 'Failed to update profile';
        notifyListeners();
        return {
          'success': false,
          'message': _error,
        };
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to update profile. Please try again.';
      if (kDebugMode) {
        print('AuthProvider - updateProfile error: $e');
      }
      notifyListeners();
      return {
        'success': false,
        'message': _error,
      };
    }
  }
  
  // Change user password
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.changePassword(currentPassword, newPassword);
      
      _isLoading = false;
      
      if (result['success'] == true) {
        // If the API returns the updated user, update it
        if (result['user'] != null) {
          _user = result['user'];
        }
        notifyListeners();
        return {
          'success': true,
          'message': result['message'] ?? 'Password changed successfully',
        };
      } else {
        _error = result['message'] ?? 'Failed to change password';
        notifyListeners();
        return {
          'success': false,
          'message': _error,
        };
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to change password. Please try again.';
      if (kDebugMode) {
        print('AuthProvider - changePassword error: $e');
      }
      notifyListeners();
      return {
        'success': false,
        'message': _error,
      };
    }
  }
}

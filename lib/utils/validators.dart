import 'package:flutter/material.dart';

/// A utility class for form validation.
class Validators {
  /// Validates that the input is not empty.
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates that the input is a valid email address.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email validation pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates that the input meets a minimum length requirement.
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    return null;
  }

  /// Validates that the input does not exceed a maximum length.
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validates that the input contains at least one number.
  static String? containsNumber(String? value, {String? fieldName}) {
    if (value != null && !RegExp(r'\d').hasMatch(value)) {
      return '${fieldName ?? 'This field'} must contain at least one number';
    }
    return null;
  }

  /// Validates that the input contains at least one uppercase letter.
  static String? containsUppercase(String? value, {String? fieldName}) {
    if (value != null && !RegExp(r'[A-Z]').hasMatch(value)) {
      return '${fieldName ?? 'This field'} must contain at least one uppercase letter';
    }
    return null;
  }

  
  /// Validates that the input contains at least one lowercase letter.
  static String? containsLowercase(String? value, {String? fieldName}) {
    if (value != null && !RegExp(r'[a-z]').hasMatch(value)) {
      return '${fieldName ?? 'This field'} must contain at least one lowercase letter';
    }
    return null;
  }

  /// Validates that the input contains at least one special character.
  static String? containsSpecialChar(String? value, {String? fieldName}) {
    if (value != null && !RegExp(r'[!@#\$%^&*(),.?\":{}|<>]').hasMatch(value)) {
      return '${fieldName ?? 'This field'} must contain at least one special character';
    }
    return null;
  }

  /// Validates that the input is a strong password.
  /// A strong password must be at least 8 characters long and contain
  /// at least one uppercase letter, one lowercase letter, one number, and one special character.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    if (!RegExp(r'[!@#\$%^&*(),.?\":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  /// Validates that two values match (e.g., password confirmation).
  static FormFieldValidator<String> match(TextEditingController matchController, {String? errorText}) {
    return (value) {
      if (value != matchController.text) {
        return errorText ?? 'Values do not match';
      }
      return null;
    };
  }

  /// Combines multiple validators into a single validator.
  /// Returns the first error encountered, or null if all validators pass.
  static FormFieldValidator<T> combine<T>(List<FormFieldValidator<T>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}

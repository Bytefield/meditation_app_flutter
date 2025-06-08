import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Represents an error from the API
class ApiError {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiError({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiError.fromResponse(http.Response response) {
    try {
      final Map<String, dynamic> body = json.decode(response.body);
      return ApiError(
        message: body['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
        data: body,
      );
    } catch (e) {
      return ApiError(
        message: 'Failed to parse error response',
        statusCode: response.statusCode,
        data: response.body,
      );
    }
  }

  factory ApiError.fromException(dynamic error) {
    if (error is ApiError) return error;
    
    if (error is http.ClientException) {
      return ApiError(
        message: 'Network error: ${error.message}',
        statusCode: 0,
        data: error.toString(),
      );
    }

    return ApiError(
      message: error?.toString() ?? 'An unknown error occurred',
      statusCode: 0,
      data: error?.toString(),
    );
  }

  @override
  String toString() => 'ApiError: $message (Status: $statusCode)';
}

/// Handles API errors and formats them for display to the user
class ApiErrorHandler {
  /// Handles an error from an API call and returns a user-friendly message
  static String handleError(dynamic error, {String? defaultMessage}) {
    if (error is ApiError) {
      return _getUserFriendlyMessage(error);
    } else if (error is http.Response) {
      return _getUserFriendlyMessage(ApiError.fromResponse(error));
    } else if (error is String) {
      return error;
    } else {
      debugPrint('Unhandled error type: ${error.runtimeType}');
      return defaultMessage ?? 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handles an error and shows a snackbar with the error message
  static void showErrorSnackBar(
    BuildContext context, {
    required dynamic error,
    String? defaultMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    final message = handleError(error, defaultMessage: defaultMessage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Converts an API error to a user-friendly message
  static String _getUserFriendlyMessage(ApiError error) {
    final statusCode = error.statusCode;
    final message = error.message;

    // Handle common HTTP status codes
    switch (statusCode) {
      case 400:
        return message.isNotEmpty ? message : 'Invalid request. Please check your input.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 408:
        return 'The request timed out. Please check your internet connection and try again.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Our servers are currently unavailable. Please try again later.';
      default:
        return message.isNotEmpty ? message : 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handles network-related errors
  static String handleNetworkError(dynamic error) {
    if (error is String) {
      return error;
    } else if (error is http.ClientException) {
      return 'Network error: ${error.message}';
    } else if (error is FormatException) {
      return 'Invalid server response. Please try again.';
    } else if (error is TypeError) {
      return 'Type error: ${error.toString()}';
    } else {
      return 'Network error. Please check your connection and try again.';
    }
  }

  /// Checks if the error is due to a network issue
  static bool isNetworkError(dynamic error) {
    return error is http.ClientException || 
           error is FormatException ||
           (error is ApiError && [0, 408, 502, 503, 504].contains(error.statusCode));
  }

  /// Checks if the error is due to an authentication issue
  static bool isAuthError(dynamic error) {
    return (error is ApiError && error.statusCode == 401) ||
           (error is http.Response && error.statusCode == 401);
  }

  /// Logs the error for debugging purposes
  static void logError(dynamic error, {String? context}) {
    if (error is ApiError) {
      debugPrint('''
      [API Error] ${context ?? 'Error occurred'}
      Message: ${error.message}
      Status Code: ${error.statusCode}
      Data: ${error.data}
      ''');
    } else if (error is http.Response) {
      debugPrint('''
      [HTTP Error] ${context ?? 'Error occurred'}
      Status Code: ${error.statusCode}
      Body: ${error.body}
      ''');
    } else {
      debugPrint('''
      [Error] ${context ?? 'Error occurred'}
      $error
      ${error?.stackTrace ?? StackTrace.current}
      ''');
    }
  }
}

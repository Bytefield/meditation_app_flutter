import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show BaseRequest, Response, StreamedResponse;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app_flutter/config/config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  late SharedPreferences _prefs;
  final String _cookieKey = 'app_cookies';
  Map<String, String> _cookies = {};
  
  factory HttpClient() {
    return _instance;
  }
  
  HttpClient._internal() {
    _init();
  }
  
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCookies();
  }
  
  void _loadCookies() {
    final cookiesString = _prefs.getString(_cookieKey);
    if (cookiesString != null) {
      _cookies = Map<String, String>.from(jsonDecode(cookiesString));
    }
  }
  
  Future<void> _saveCookies() async {
    await _prefs.setString(_cookieKey, jsonEncode(_cookies));
  }
  
  void _updateCookies(Map<String, String> headers) {
    if (kDebugMode) {
      print('HttpClient: Updating cookies from headers: $headers');
    }
    
    // Handle 'set-cookie' header (case-insensitive)
    final cookieHeader = headers.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase() == 'set-cookie',
          orElse: () => const MapEntry('', ''),
        )
        .value;

    if (cookieHeader.isNotEmpty) {
      if (kDebugMode) {
        print('HttpClient: Found set-cookie header: $cookieHeader');
      }
      
      // Split multiple cookies if present
      final cookieStrings = cookieHeader.split(',');
      
      for (var cookieStr in cookieStrings) {
        // Extract the cookie name and value (everything before the first '=')
        final cookieParts = cookieStr.split(';')[0].split('=');
        
        if (cookieParts.length >= 2) {
          final key = cookieParts[0].trim();
          // Join the rest in case the cookie value contains '='
          final value = cookieParts.sublist(1).join('=').trim();
          
          if (key.isNotEmpty) {
            if (kDebugMode) {
              print('HttpClient: Setting cookie: $key=$value');
            }
            _cookies[key] = value;
          }
        }
      }
      
      _saveCookies();
    } else if (kDebugMode) {
      print('HttpClient: No set-cookie header found in response');
    }
  }
  
  Map<String, String> _getRequestHeaders([Map<String, String>? headers]) {
    final requestHeaders = Map<String, String>.from(_defaultHeaders);
    
    // Add cookies to headers
    if (_cookies.isNotEmpty) {
      final cookieString = _cookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
      requestHeaders['Cookie'] = cookieString;
    }
    
    // Add custom headers
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    
    return requestHeaders;
  }
  
  // Helper method to handle the response
  Future<http.Response> _handleResponse(http.StreamedResponse response) async {
    final responseString = await response.stream.bytesToString();
    final responseHeaders = response.headers;
    
    // Update cookies from response
    if (responseHeaders.containsKey('set-cookie')) {
      _updateCookies(responseHeaders);
    }
    
    return http.Response(
      responseString,
      response.statusCode,
      headers: responseHeaders,
      request: response.request,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
  
  // GET request
  Future<http.Response> get(String path, {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    final uri = Uri.parse('${AppConfig.apiUrl}$path').replace(
      queryParameters: queryParams,
    );
    
    if (kDebugMode) {
      print('HttpClient: Sending GET request to $uri');
      print('HttpClient: Headers: ${_getRequestHeaders(headers)}');
    }
    
    try {
      final response = await http.get(
        uri,
        headers: _getRequestHeaders(headers),
      );
      
      if (kDebugMode) {
        print('HttpClient: Received response with status: ${response.statusCode}');
        print('HttpClient: Response headers: ${response.headers}');
        print('HttpClient: Response body: ${response.body}');
      }
      
      _updateCookies(response.headers);
      
      if (kDebugMode) {
        print('HttpClient: Updated cookies: $_cookies');
      }
      
      return response;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('HttpClient: Error during GET request: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
  
  // POST request
  Future<http.Response> post(String path, {dynamic body, Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('HttpClient: Sending POST request to $path');
      print('HttpClient: Headers: ${_getRequestHeaders(headers)}');
      print('HttpClient: Body: $body');
    }
    
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiUrl}$path'),
        headers: _getRequestHeaders(headers),
        body: body is Map || body is List ? jsonEncode(body) : body,
      );
      
      if (kDebugMode) {
        print('HttpClient: Received response with status: ${response.statusCode}');
        print('HttpClient: Response headers: ${response.headers}');
        print('HttpClient: Response body: ${response.body}');
      }
      
      _updateCookies(response.headers);
      
      if (kDebugMode) {
        print('HttpClient: Updated cookies: $_cookies');
      }
      
      return response;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('HttpClient: Error during POST request: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }
  
  // PUT request
  Future<http.Response> put(String path, {dynamic body, Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _getRequestHeaders(headers),
      body: body is Map || body is List ? jsonEncode(body) : body,
    );
    
    _updateCookies(response.headers);
    return response;
  }
  
  // DELETE request
  Future<http.Response> delete(String path, {dynamic body, Map<String, String>? headers}) async {
    final request = http.Request('DELETE', Uri.parse('${AppConfig.apiUrl}$path'))
      ..headers.addAll(_getRequestHeaders(headers));
    
    if (body != null) {
      request.body = body is Map || body is List ? jsonEncode(body) : body.toString();
    }
    
    final response = await request.send();
    return _handleResponse(response);
  }
  
  // Clear all cookies
  Future<void> clearCookies() async {
    _cookies.clear();
    await _prefs.remove(_cookieKey);
  }
  
  // Check if user is authenticated
  bool get isAuthenticated => _cookies.isNotEmpty;
}

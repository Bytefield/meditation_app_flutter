import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app_flutter/config/config.dart';
import 'package:meditation_app_flutter/l10n/app_localizations.dart';
import 'package:meditation_app_flutter/services/http_client.dart';

class ImageUploadService {
  final HttpClient _httpClient = HttpClient();
  final ImagePicker _picker = ImagePicker();

  /// Shows a dialog to select image source (camera or gallery)
  Future<File?> pickImageSource(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: Text(l10n.cancel),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  /// Uploads the image to the server
  /// Returns a map with 'success' boolean and either 'imageUrl' or 'message'
  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    try {
      // Check file size (max 5MB)
      final fileSize = await imageFile.length();
      const maxSize = 5 * 1024 * 1024; // 5MB
      
      if (fileSize > maxSize) {
        return {
          'success': false,
          'message': 'Image size should be less than 5MB',
        };
      }

      // Create multipart request
      final uri = Uri.parse('${AppConfig.apiUrl}/api/users/upload-profile-image');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file
      final stream = http.ByteStream(imageFile.openRead()..cast());
      final length = fileSize;
      
      final multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);

      // Add authorization header if needed
      final authToken = await _httpClient.getAuthToken();
      if (authToken != null) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'imageUrl': responseData['imageUrl'] ?? responseData['url'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 
                     responseData['error'] ?? 
                     'Failed to upload image. Status code: ${response.statusCode}',
        };
      }
    } catch (e, stackTrace) {
      debugPrint('Error uploading image: $e');
      debugPrint('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Error uploading image: ${e.toString()}',
      };
    }
  }
  
  /// Compresses the image file to reduce size
  Future<File> _compressImage(File file) async {
    // For now, just return the original file
    // In a real app, you might want to use a package like `flutter_image_compress`
    // to reduce the image size before uploading
    return file;
  }
}

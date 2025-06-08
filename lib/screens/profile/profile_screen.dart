import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/auth_provider.dart';
import 'package:meditation_app_flutter/providers/locale_provider.dart';
import 'package:meditation_app_flutter/theme/app_theme.dart';
import 'package:meditation_app_flutter/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:meditation_app_flutter/screens/profile/change_password_screen.dart';
import 'package:meditation_app_flutter/screens/profile/language_selection_screen.dart';
import 'package:meditation_app_flutter/l10n/app_localizations.dart';
import 'package:meditation_app_flutter/services/image_upload_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImageUploadService _imageUploadService = ImageUploadService();
  bool _isUploading = false;

  @override
  Future<void> _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        await context.read<AuthProvider>().logout();
      }
    }
  }


  
  Future<void> _pickAndUploadImage(BuildContext context) async {
    if (_isUploading) return;
    
    if (!mounted) return;
    
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // Show image source selection
      final file = await _imageUploadService.pickImageSource(context);
      if (file == null || !mounted) return;
      
      setState(() => _isUploading = true);
      
      // Show uploading indicator
      final loadingSnackBar = SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(l10n.uploadingImage),
          ],
        ),
        duration: const Duration(seconds: 30), // Long duration to prevent premature dismissal
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
      
      // Show loading snackbar
      scaffoldMessenger.removeCurrentSnackBar();
      scaffoldMessenger.showSnackBar(loadingSnackBar);
      
      // Upload the image
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.updateProfileImage(file.path);
      
      // Dismiss the loading snackbar
      if (mounted) {
        scaffoldMessenger.hideCurrentSnackBar();
        
        // Show result
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              success ? l10n.profileImageUpdated : l10n.errorUpdatingImage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in _pickAndUploadImage: $e');
        print('Stack trace: $stackTrace');
      }
      
      if (mounted) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              '${l10n.errorUpdatingImage} ${e.toString().split('.').first}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: l10n.retry,
              textColor: Colors.white,
              onPressed: () => _pickAndUploadImage(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = context.watch<AuthProvider>().user;
    final l10n = AppLocalizations.of(context)!;
    final isGuest = user == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Image with Upload Button
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(0.1),
                  ),
                  child: (user?.profileImageUrl?.isNotEmpty ?? false)
                      ? ClipOval(
                          child: Image.network(
                            user!.profileImageUrl!,
                            width: 136,
                            height: 136,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(colorScheme),
                          ),
                        )
                      : _buildDefaultAvatar(colorScheme),
                ),
                if (!isGuest)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 24, color: Colors.white),
                        onPressed: () => _pickAndUploadImage(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // User Info
            Text(
              user?.name ?? l10n.guest,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? l10n.guestEmail,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 24),
            // Account Section
            Text(
              l10n.account,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(l10n.editProfile),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(l10n.changePassword),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // App Section
            Text(
              l10n.app,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(l10n.notifications),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement notifications toggle
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.language),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<LocaleProvider>(
                          builder: (context, localeProvider, _) {
                            // Only show supported languages (English and Spanish)
                            final languageCode = localeProvider.locale.languageCode;
                            String languageName;
                            
                            if (languageCode == 'es') {
                              languageName = l10n.spanish;
                            } else {
                              // Default to English if the language is not Spanish
                              languageName = l10n.english;
                            }
                            
                            return Text(
                              languageName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageSelectionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  ),
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // App Version
            Center(
              child: Text(
                'Versión 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Icon(
      Icons.account_circle,
      size: 136,
      color: colorScheme.primary.withOpacity(0.5),
    );
  }
}

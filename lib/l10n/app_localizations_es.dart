// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rago Meditación';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get logoutConfirmation =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get currentPassword => 'Contraseña Actual';

  @override
  String get newPassword => 'Nueva Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get passwordRequirements => 'La contraseña debe contener:';

  @override
  String get passwordMinLength => 'Al menos 6 caracteres';

  @override
  String get passwordUppercase => 'Al menos una letra mayúscula';

  @override
  String get passwordNumber => 'Al menos un número';

  @override
  String get passwordMatch => 'Las contraseñas deben coincidir';

  @override
  String get profileUpdated => 'Perfil actualizado correctamente';

  @override
  String get passwordChanged => 'Contraseña cambiada exitosamente';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get german => 'Alemán';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Portugués';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get invalidEmail => 'Por favor ingresa un correo electrónico válido';

  @override
  String get invalidPassword =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get profile => 'Mi Perfil';

  @override
  String get account => 'Cuenta';

  @override
  String get app => 'Aplicación';

  @override
  String get guest => 'Invitado';

  @override
  String get guestEmail => 'invitado@ejemplo.com';

  @override
  String get profileImageUpdated =>
      'Imagen de perfil actualizada correctamente';

  @override
  String get errorUpdatingImage =>
      'Error al actualizar la imagen de perfil. Por favor, inténtalo de nuevo.';

  @override
  String get uploadingImage => 'Subiendo imagen...';

  @override
  String get selectImageSource => 'Seleccionar origen de la imagen';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get retry => 'Reintentar';
}

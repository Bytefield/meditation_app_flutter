import 'package:flutter/material.dart';

/// A service that handles navigation throughout the app.
/// This provides a central place to handle all navigation logic.
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  /// Get the current context
  BuildContext? get context => navigatorKey.currentContext;

  /// Get the current state
  NavigatorState? get _navigator => navigatorKey.currentState;

  /// Check if we can pop the current route
  bool get canPop => _navigator?.canPop() ?? false;

  /// Push a named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Push a named route and remove all previous routes
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator!.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  /// Push a named route and remove all previous routes
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator!.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Pop the current route
  void pop<T extends Object?>([T? result]) {
    if (canPop) {
      _navigator!.pop<T>(result);
    }
  }

  /// Pop until a route with the given name is found
  void popUntil(String routeName) {
    _navigator!.popUntil((route) => route.settings.name == routeName);
  }

  /// Push a route and remove all previous routes
  Future<T?> pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    return pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false, // This removes all previous routes
      arguments: arguments,
    );
  }

  /// Push a route as a dialog
  Future<T?> pushDialog<T extends Object?>(
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return _navigator!.push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => useSafeArea ? SafeArea(child: dialog) : dialog,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        settings: routeSettings,
        opaque: false,
      ),
    );
  }

  /// Show a snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
    Color? backgroundColor,
    SnackBarBehavior? behavior,
  }) {
    final context = this.context;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: behavior,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onActionPressed ?? () {},
                textColor: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }

  /// Show a dialog with a title and message
  Future<T?> showAlertDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    final context = this.context;
    if (context == null) return Future<T?>.value(null);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title, style: textTheme.titleLarge),
        content: Text(message, style: textTheme.bodyMedium),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText ?? 'OK'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showAlertDialog<bool>(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    return result ?? false;
  }

  /// Show a bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
  }) {
    final context = this.context;
    if (context == null) return Future<T?>.value(null);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      builder: (context) => child,
    );
  }
}

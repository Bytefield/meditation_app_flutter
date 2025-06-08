import 'package:flutter/material.dart';

/// A customizable loading indicator with support for both circular and linear progress indicators.
class LoadingIndicator extends StatelessWidget {
  /// The size of the indicator (only applicable for circular indicator)
  final double size;
  
  /// The width of the indicator line/bar
  final double strokeWidth;
  
  /// The color of the indicator
  final Color? color;
  
  /// Whether to show a linear progress indicator instead of circular
  final bool isLinear;
  
  /// Background color for the indicator (only applicable for linear indicator)
  final Color? backgroundColor;
  
  /// The value of the indicator (between 0.0 and 1.0)
  final double? value;
  
  /// Whether to show the indicator in the center of the screen
  final bool center;

  const LoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.color,
    this.isLinear = false,
    this.backgroundColor,
    this.value,
    this.center = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final indicator = isLinear
        ? LinearProgressIndicator(
            value: value,
            backgroundColor: backgroundColor ?? colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? colorScheme.primary,
            ),
            minHeight: strokeWidth,
          )
        : SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              value: value,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? colorScheme.primary,
              ),
            ),
          );

    return center ? Center(child: indicator) : indicator;
  }
}

/// A full-screen loading indicator with optional message
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool showLogo;
  final Color? backgroundColor;

  const FullScreenLoading({
    Key? key,
    this.message,
    this.showLogo = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: backgroundColor ?? theme.scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Icon(
                Icons.self_improvement,
                size: 60,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
            ],
            const LoadingIndicator(size: 40, strokeWidth: 3),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

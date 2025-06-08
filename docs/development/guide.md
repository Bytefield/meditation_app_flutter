# Development Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Project Setup](#project-setup)
3. [Development Workflow](#development-workflow)
4. [Coding Standards](#coding-standards)
5. [Testing](#testing)
6. [Pull Requests](#pull-requests)
7. [Code Review](#code-review)
8. [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- **Flutter SDK**: 3.19.0 or higher
- **Dart SDK**: 3.3.0 or higher
- **Node.js**: 18.x LTS or higher
- **MongoDB**: 6.0 or higher (or MongoDB Atlas)
- **Git**: Latest stable version
- **IDE**: VS Code (recommended) or Android Studio/IntelliJ

### Recommended VS Code Extensions

- Dart
- Flutter
- Pubspec Assist
- Dart Data Class Generator
- Bloc (if using BLoC pattern)
- Flutter Widget Snippets
- Prettier - Code formatter
- YAML
- JSON Tools

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/rago-meditation-app.git
cd rago-meditation-app
```

### 2. Install Dependencies

#### Frontend

```bash
# Install Flutter dependencies
flutter pub get

# Generate code for models, etc.
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Backend

```bash
cd server
npm install
```

### 3. Environment Setup

#### Frontend

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Update the `.env` file with your local configuration:
   ```env
   # API Configuration
   API_BASE_URL=http://localhost:3000
   
   # Feature Flags
   ENABLE_ANALYTICS=false
   
   # Other configurations...
   ```

#### Backend

1. Copy the example environment file:
   ```bash
   cd server
   cp .env.example .env
   ```

2. Update the `.env` file with your local configuration:
   ```env
   # Server Configuration
   PORT=3000
   NODE_ENV=development
   
   # Database
   MONGODB_URI=mongodb://localhost:27017/rago_meditation
   
   # JWT
   JWT_SECRET=your_jwt_secret
   JWT_EXPIRES_IN=15m
   JWT_REFRESH_EXPIRES_IN=7d
   
   # CORS
   CORS_ORIGIN=http://localhost:3001
   ```

### 4. Start Development Servers

#### Frontend

```bash
# For mobile development
flutter run

# For web development
flutter run -d chrome

# For web with hot restart
flutter run -d chrome --web-port=3001 --web-hostname=0.0.0.0 --web-renderer=html
```

#### Backend

```bash
# Start in development mode with hot-reload
npm run dev

# Or start in production mode
npm start
```

## Development Workflow

### Branch Naming Conventions

Use the following prefix for your branches:

- `feature/` - New features or enhancements
- `bugfix/` - Bug fixes
- `hotfix/` - Critical production fixes
- `release/` - Release preparation
- `chore/` - Maintenance tasks

Example: `feature/user-authentication`

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries

Examples:
```
feat(auth): add email verification
fix(api): handle null pointer in user service
docs: update README with setup instructions
```

### Pull Request Process

1. Create a new branch from `main`
2. Make your changes
3. Write tests for your changes
4. Run tests and ensure all pass
5. Update documentation if needed
6. Push your branch and create a pull request
7. Request review from at least one team member
8. Address any review comments
9. Once approved, squash and merge your PR

## Coding Standards

### Dart/Flutter

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use `camelCase` for variables, parameters, and methods
- Use `PascalCase` for classes, enums, and typedefs
- Use `UPPER_CASE` for constants and enums
- Use `_private` for private members
- Always specify types for public APIs
- Keep lines under 100 characters
- Use trailing commas for better git diffs

### File Organization

- One class per file
- Group related files in the same directory
- Use barrel files (`index.dart`) to export related files
- Keep the widget tree shallow and extract widgets into separate files when needed

### Naming Conventions

- Widget files: `snake_case_widget.dart` (e.g., `login_button.dart`)
- Widget classes: `PascalCase` (e.g., `LoginButton`)
- Model files: `snake_case_model.dart` (e.g., `user_model.dart`)
- Service files: `snake_case_service.dart` (e.g., `auth_service.dart`)
- Utility files: `snake_case_utils.dart` (e.g., `date_utils.dart`)

### State Management

- Use `Provider` for app-wide state
- Keep business logic in services
- Use `ChangeNotifier` for simple state
- For complex UIs, consider using `flutter_bloc` or `riverpod`

### Error Handling

- Use `try/catch` for async operations
- Create custom exception classes
- Show user-friendly error messages
- Log errors for debugging

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests in a specific file
flutter test test/auth/auth_test.dart

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

```
test/
  ├── unit/
  │   ├── services/
  │   └── models/
  ├── widget/
  └── integration/
```

### Writing Tests

- Test one thing per test case
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Use mocks for external dependencies
- Test edge cases and error conditions

Example test:

```dart
group('AuthService', () {
  late AuthService authService;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    authService = AuthService(apiClient: mockApiClient);
  });

  test('login returns user when successful', () async {
    // Arrange
    when(mockApiClient.post(
      '/auth/login',
      data: anyNamed('data'),
    )).thenAnswer((_) async => {
          'id': '1',
          'name': 'Test User',
          'email': 'test@example.com',
          'token': 'test_token',
        });

    // Act
    final result = await authService.login('test@example.com', 'password');

    // Assert
    expect(result.user.email, 'test@example.com');
    expect(result.token, isNotEmpty);
  });
});
```

## Pull Requests

### Creating a Pull Request

1. Make sure your branch is up to date with `main`
2. Run all tests and ensure they pass
3. Update documentation if needed
4. Push your branch to the remote repository
5. Create a pull request on GitHub
6. Fill out the PR template
7. Request reviews from relevant team members

### PR Template

```markdown
## Description

[Describe the changes in this PR]

## Related Issues

- Fixes #issue_number

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Refactoring

## Testing

- [ ] I have added/updated unit tests for these changes
- [ ] I have tested these changes manually
- [ ] I have tested these changes on both iOS and Android

## Screenshots/Videos (if applicable)

[Add screenshots or screen recordings if UI changes were made]

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published in dependent modules
```

## Code Review

### Review Process

1. Assign reviewers based on the changes
2. Reviewers should respond within 24 hours
3. Use the "Request changes" option for significant issues
4. Use comments for minor suggestions
5. Resolve conversations when they're addressed

### Review Guidelines

- Check for code quality and consistency
- Ensure proper error handling
- Verify test coverage
- Check for security vulnerabilities
- Verify documentation is up to date
- Consider performance implications

### Common Issues to Look For

- Memory leaks
- Race conditions
- Security vulnerabilities
- Performance bottlenecks
- Inconsistent error handling
- Missing test coverage
- Code duplication
- Violations of the style guide

## Troubleshooting

### Common Issues

**Flutter: Command not found**
- Ensure Flutter is in your PATH
- Run `flutter doctor` to verify installation

**Dependency conflicts**
- Run `flutter pub upgrade --major-versions`
- Check `pubspec.yaml` for version constraints

**Build failures**
- Run `flutter clean`
- Delete `pubspec.lock` and run `flutter pub get`
- Invalidate caches and restart IDE

**iOS build issues**
- Run `pod install` in the `ios` directory
- Open Xcode and clean build folder

**Android build issues**
- Run `flutter clean`
- Delete `.gradle` and `.idea` folders
- Invalidate caches and restart Android Studio

### Debugging

**Flutter DevTools**
```bash
# Start DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Connect to a running app
flutter run --debug
```

**Logging**
```dart
import 'dart:developer' as developer;

void someMethod() {
  developer.log('log me', name: 'my.app.category');
  
  // Debug print
  debugPrint('Debug message');
  
  // Print with stack trace
  print(StackTrace.current);
}
```

**Network Debugging**
```dart
// In your main.dart
void main() {
  // Enable network traffic logging
  HttpClient client = HttpClient();
  client.findProxy = (uri) {
    debugPrint('Proxy for $uri');
    return 'DIRECT';
  };
  
  // Or use a package like http_logger
  runApp(MyApp());
}
```

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Dart DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Flutter API Reference](https://api.flutter.dev/)

## Getting Help

If you need help:

1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
3. Join the [Flutter Community](https://flutter.dev/community)
4. File an issue in the repository
5. Ask in the team's Slack/Teams channel

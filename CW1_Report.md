# CW1 Report: Kreative Kindle — Mobile Application Development

---

## 1. Introduction

Kreative Kindle is a cross-platform mobile application built with Flutter, designed to support early childhood learning for children aged 3–8. The application serves two primary user roles: **parents**, who monitor their child's progress and post updates, and **instructors**, who manage and guide learning activities. The app delivers structured, age-appropriate content across six learning domains: arts and crafts, literacy and phonics, storytelling, numeracy, thinking skills, and science and nature.

The application was developed following an agile sprint-based methodology, with this report covering the complete implementation delivered across the project sprints. The technical stack comprises Flutter (Dart) for the mobile front end, with a Node.js (Express) and MongoDB back end providing RESTful API services. The report details the application architecture, feature implementation, hardware sensor integration, testing strategy, and key technical challenges encountered during development.

---

## 2. Application Architecture

### 2.1 Clean Architecture with MVVM

The application is structured around the **Clean Architecture** pattern, separating concerns into three distinct layers:

- **Presentation Layer**: Flutter widgets, pages, and ViewModels (state notifiers) responsible solely for UI rendering and user interaction.
- **Domain Layer**: Business logic encapsulated in use cases (e.g., `LoginUseCase`, `SignupUseCase`) and abstract repository interfaces that define data contracts independently of their implementation.
- **Data Layer**: Concrete implementations of repositories, remote data sources (Dio HTTP client), and local data sources (Hive and SharedPreferences).

This separation ensures that the UI has no direct knowledge of the data source, making the codebase maintainable and testable. Each feature is self-contained under `lib/features/`, following a module structure of `presentation/`, `domain/`, and `data/`.

### 2.2 State Management

State management is handled entirely by **Flutter Riverpod** (v3.0.3), using `StateNotifierProvider` for mutable state and `FutureProvider` for asynchronous data fetching. Key providers include:

- `authViewModelProvider` — manages login/signup state and JWT token lifecycle.
- `themeProvider` — drives the application theme (light/dark) with `SharedPreferences` persistence.
- `mediaViewModelProvider` — handles image upload state.

Riverpod was chosen over alternatives such as Provider or Bloc due to its compile-time safety, superior testability, and ability to declare dependencies declaratively without `BuildContext`.

### 2.3 Networking

All HTTP communication is performed through **Dio**, configured in `ApiClient` with a base URL, 30-second timeouts, and two interceptors: an `_AuthInterceptor` that automatically injects JWT Bearer tokens from `FlutterSecureStorage` into protected requests, and a `PrettyDioLogger` active only in debug mode for request/response inspection.

---

## 3. Feature Implementation

### 3.1 Authentication

The authentication flow supports registration and login for both parent and instructor roles. On registration, the user provides a full name, email address, home address, and password; the role is set to `"parent"` by default, with instructors registered separately. On successful login, the returned JWT is persisted in `FlutterSecureStorage` and automatically attached to subsequent API requests via the auth interceptor. A token-refresh mechanism clears storage on receiving a 401 Unauthorized response.

### 3.2 Dashboard and Navigation

The main application shell is a five-tab bottom navigation bar providing access to: Updates, Settings, Home, Profile, and More. The Home tab presents a personalised greeting based on the user's role, a grid of eight feature tiles navigating to specific learning domains, and a contextual hint prompting users to shake the device.

### 3.3 Activity Library

The activity library presents six curated learning activities, each containing a description, age group, difficulty level, a materials list, and ordered step-by-step instructions. Each activity detail page is rendered with a gradient header, emoji icon, and a highlighted active step that responds to sensor-driven navigation (see Section 4).

### 3.4 Updates (Posts)

Instructors and parents can create posts with a title, body text, associated materials, learning outcomes, and an optional image. Images are uploaded to the Express back end via multipart form-data and served from a static `/uploads/` route. A known defect in early sprints — where the `post['image']` field stored only a filename rather than a full URL — was corrected by constructing the full URL at the client: `rawImage.startsWith('http') ? rawImage : '$baseUrl/uploads/$rawImage'`.

### 3.5 Profile and Settings

The Profile page allows users to upload a profile photo. A persistent image URL is saved to `SharedPreferences` after each successful upload to prevent the image from disappearing on app restart — a regression identified and resolved during this sprint. The Settings page provides a manual dark mode toggle, notification preferences, and an about section, with theme state persisted across sessions.

---

## 4. Hardware Sensor Integration

A key deliverable of the final sprint was the integration of four hardware sensors, each serving a genuine in-app use case rather than existing as standalone test screens.

### 4.1 Accelerometer — Shake to Discover

The accelerometer event stream from `sensors_plus` is listened to within `DashboardPage`. When the resultant magnitude of the acceleration vector exceeds 15 m/s² — the threshold chosen to distinguish intentional shaking from casual movement — and the user is on the Home tab, a `_ActivitySuggestionSheet` bottom sheet is displayed. This sheet presents a randomly selected activity with its emoji, title, category, and duration, along with a direct "Start Activity" shortcut. A 1,500 ms debounce prevents the sheet from triggering repeatedly. This feature addresses the use case of a child who has free time and wants an instant activity recommendation.

### 4.2 Gyroscope — Hands-Free Step Navigation

During craft activities, a child's hands are often occupied with materials, making screen interaction impractical. The gyroscope stream monitors Y-axis angular velocity; a tilt exceeding ±2.5 rad/s advances or retreats the currently highlighted step within `ActivityDetailPage`, with a 700 ms debounce to prevent rapid successive jumps. A tilt-hint label is displayed alongside the step counter (e.g., "2/5") to make the affordance discoverable.

### 4.3 Proximity Sensor — Automatic Activity Pause

Using the `proximity_sensor` package, the application detects when the device is placed face-down (proximity event value 0) and overlays a full-screen pause indicator, pausing the activity. When the device is lifted, the overlay is removed and the activity resumes. This supports the real-world scenario where a parent or child needs to briefly attend to something else mid-activity.

### 4.4 Platform Brightness — Auto Dark Mode

Rather than relying solely on a manual toggle, the application implements `WidgetsBindingObserver.didChangePlatformBrightness()` in `KreativeKindleApp`. Whenever the device's system Night Mode or ambient-light–triggered dark mode changes, the `ThemeNotifier.setTheme(bool)` method is called, switching the application theme to match instantly. This ensures the app is visually comfortable at all times without user intervention.

---

## 5. Testing

### 5.1 Unit Tests (20 tests)

Unit tests are located in `test/unit/` and cover pure Dart logic without UI dependencies. Tests validate:

- `AuthApiModel` serialisation and deserialisation (4 tests) — verifying that `toLoginJson()`, `toRegisterJson()`, and `fromJson()` behave correctly, including the security requirement that password is never stored from a server response.
- `ThemeNotifier` state transitions (3 tests) — confirming initial state, `setTheme(true)` activation, and no-op behaviour when the state is unchanged.
- Input validators, LoginDTO, token service, and repository mocks (13 tests) — covering email format validation, password length rules, token storage, and repository contract verification using `mocktail`.

One test (`auth_validation_fail_test.dart`) is intentionally constructed to fail, demonstrating a known edge case where weak passwords were not rejected.

### 5.2 Widget Tests (20 tests)

Widget tests in `test/widget/` validate UI components in isolation using dummy widgets that mirror the real application's component design:

- Feature tile rendering, tap callback, and label display (3 tests).
- Activity suggestion sheet content and dismiss behaviour (2 tests).
- Dark mode toggle switch state (2 tests).
- Settings row toggle interaction (3 tests).
- Progress bar rendering and percentage display (2 tests).
- Onboarding content title and subtitle visibility (2 tests).
- Login/signup screen field presence, snackbar display, and loading button state (remaining 6 tests).

One widget test (`navigation_test.dart`) intentionally fails to document a real bug where navigation to an unregistered route causes an exception.

### 5.3 Coverage

Test coverage data is generated via `flutter test --coverage`, producing `coverage/lcov.info`. Of the 40 tests, **38 pass** and **2 fail intentionally**, giving a pass rate of 95%.

---

## 6. Challenges and Solutions

**Physical device deployment**: During testing on a Samsung SM E225F, the debug APK (~80 MB) failed to install due to insufficient on-device storage. The solution was to build a split-per-ABI release APK (`flutter build apk --release --split-per-abi`), reducing the arm64 binary to 19.3 MB.

**Backend network access**: The Express server was initially configured to listen only on `localhost` and its CORS policy only allowed `http://localhost:3000`. For the mobile device to reach the server over Wi-Fi, the server was rebound to `0.0.0.0` and CORS was updated to `origin: true`.

**Deprecated Flutter APIs**: The Dart SDK version (^3.9.2) flagged `.withOpacity()` as deprecated. All colour opacity calls were migrated to `.withValues(alpha: x)`, and `Slider.activeColor` was replaced with `SliderTheme`.

---

## 7. Conclusion

Kreative Kindle successfully delivers a feature-complete early-learning mobile application meeting all sprint deliverables. The integration of hardware sensors as genuine in-app affordances — rather than demonstration screens — significantly enhances the user experience by making interactions natural and contextual. The clean architecture ensures the codebase is maintainable and the comprehensive test suite (40 tests across unit and widget layers) provides confidence in correctness. The application is deployed and verified on a physical Android 13 device, with the Express + MongoDB back end accessible over a local Wi-Fi network.

---

*Word count: approximately 1,500 words*

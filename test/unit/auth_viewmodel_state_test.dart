import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kreative_kindle/features/auth/data/models/auth_api_model.dart';
import 'package:kreative_kindle/features/auth/data/repositories/auth_api_repository.dart';
import 'package:kreative_kindle/features/auth/presentation/view_model/auth_viewmodel.dart';

// Mock the concrete repository — mocktail intercepts all method calls via
// noSuchMethod so we never need to provide real remote/networkInfo instances.
class _MockRepo extends Mock implements AuthApiRepository {}

// Fake for registerFallbackValue — AuthApiModel is passed to repo.register()
class _FakeAuthApiModel extends Fake implements AuthApiModel {}

// FlutterSecureStorage channel name (flutter_secure_storage v10)
const _kSecureStorageChannel =
    MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(_FakeAuthApiModel());
  });

  setUp(() {
    // Stub platform channels so AuthViewModel constructor doesn't throw
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_kSecureStorageChannel, (_) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_kSecureStorageChannel, null);
  });

  // ── AuthState data class ──────────────────────────────────────────────────

  group('AuthState', () {
    test('PASS: default state — isLoading false, no token, no error', () {
      const s = AuthState();
      expect(s.isLoading, false);
      expect(s.token, null);
      expect(s.error, null);
    });

    test('PASS: copyWith(isLoading: true) sets loading, preserves token', () {
      const s = AuthState(token: 'existing_token');
      final updated = s.copyWith(isLoading: true);
      expect(updated.isLoading, true);
      expect(updated.token, 'existing_token');
    });

    test('PASS: copyWith(error: msg) stores error message', () {
      const s = AuthState();
      final updated = s.copyWith(error: 'Invalid credentials');
      expect(updated.error, 'Invalid credentials');
      expect(updated.isLoading, false);
    });

    test('PASS: copyWith(token: jwt) stores token in new state', () {
      const s = AuthState();
      final updated = s.copyWith(token: 'jwt_token_abc');
      expect(updated.token, 'jwt_token_abc');
      expect(updated.isLoading, false);
    });

    test('PASS: copyWith with null error clears a previously set error', () {
      const s = AuthState(error: 'old error');
      final updated = s.copyWith(isLoading: false, error: null);
      expect(updated.error, null);
    });
  });

  // ── AuthViewModel state transitions (real class, mocked repo) ─────────────

  group('AuthViewModel state', () {
    late _MockRepo repo;
    late AuthViewModel vm;

    setUp(() {
      repo = _MockRepo();
      // Instantiating the real AuthViewModel; _loadToken() calls
      // _storage.read() which hits the mocked channel → returns null → OK
      vm = AuthViewModel(repo);
    });

    test('PASS: initial state is unauthenticated (token=null, loading=false)',
        () {
      expect(vm.state.token, null);
      expect(vm.state.isLoading, false);
      expect(vm.state.error, null);
    });

    test('PASS: login success stores token and clears loading', () async {
      when(() => repo.login(any(), any())).thenAnswer(
        (_) async =>
            {'token': 'bearer_jwt', 'userId': 'uid1', 'email': 'a@b.com'},
      );
      final result = await vm.login(email: 'a@b.com', password: 'pass123');
      expect(result, true);
      expect(vm.state.token, 'bearer_jwt');
      expect(vm.state.isLoading, false);
      expect(vm.state.error, null);
    });

    test('PASS: login failure sets error and clears loading', () async {
      when(() => repo.login(any(), any()))
          .thenThrow(Exception('Wrong credentials'));
      final result = await vm.login(email: 'x@y.com', password: 'bad');
      expect(result, false);
      expect(vm.state.error, isNotNull);
      expect(vm.state.isLoading, false);
      expect(vm.state.token, null);
    });

    test('PASS: signup success returns to idle state (no error)', () async {
      when(() => repo.register(any())).thenAnswer((_) async => true);
      final result = await vm.signup(
        fullName: 'Alice',
        email: 'alice@test.com',
        address: '10 Main St',
        password: 'pass123',
      );
      expect(result, true);
      expect(vm.state.isLoading, false);
      expect(vm.state.error, null);
    });

    test('PASS: signup failure sets error and clears loading', () async {
      when(() => repo.register(any()))
          .thenThrow(Exception('Email already exists'));
      final result = await vm.signup(
        fullName: 'Bob',
        email: 'bob@test.com',
        address: '5 Oak Ave',
        password: 'pass456',
      );
      expect(result, false);
      expect(vm.state.error, isNotNull);
      expect(vm.state.isLoading, false);
    });

    test('PASS: forgotPassword success clears loading with no error', () async {
      when(() => repo.forgotPassword(any())).thenAnswer((_) async {});
      final result = await vm.forgotPassword('user@test.com');
      expect(result, true);
      expect(vm.state.isLoading, false);
      expect(vm.state.error, null);
    });
  });
}

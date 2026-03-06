import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kreative_kindle/features/auth/domain/repositories/auth_repository.dart';
import 'package:kreative_kindle/features/auth/domain/usecases/login_usecase.dart';
import 'package:kreative_kindle/features/auth/domain/usecases/signup_usecase.dart';

class _MockRepo extends Mock implements AuthRepository {}

void main() {
  // ── LoginUseCase ───────────────────────────────────────────────────────────

  group('LoginUseCase', () {
    late _MockRepo repo;
    late LoginUseCase useCase;

    setUp(() {
      repo = _MockRepo();
      useCase = LoginUseCase(repo);
    });

    test('PASS: returns true when repository.login succeeds', () async {
      when(() => repo.login(any(), any())).thenAnswer((_) async => true);
      final result = await useCase.call('user@test.com', 'password123');
      expect(result, true);
    });

    test('PASS: returns false when repository.login returns false', () async {
      when(() => repo.login(any(), any())).thenAnswer((_) async => false);
      final result = await useCase.call('user@test.com', 'wrongpass');
      expect(result, false);
    });

    test('PASS: delegates email and password to repository unchanged', () async {
      when(() => repo.login(any(), any())).thenAnswer((_) async => true);
      await useCase.call('alice@example.com', 'securePass1');
      verify(() => repo.login('alice@example.com', 'securePass1')).called(1);
    });

    test('PASS: propagates exception thrown by repository', () async {
      when(() => repo.login(any(), any()))
          .thenThrow(Exception('Network error'));
      expect(
        () => useCase.call('x@y.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });

    test('PASS: calls repository exactly once per login invocation', () async {
      when(() => repo.login(any(), any())).thenAnswer((_) async => true);
      await useCase.call('test@test.com', 'pass123');
      verify(() => repo.login(any(), any())).called(1);
    });
  });

  // ── SignupUseCase ──────────────────────────────────────────────────────────

  group('SignupUseCase', () {
    late _MockRepo repo;
    late SignupUseCase useCase;

    setUp(() {
      repo = _MockRepo();
      useCase = SignupUseCase(repo);
    });

    test('PASS: completes without error when repository succeeds', () async {
      when(() => repo.signup(any(), any())).thenAnswer((_) async {});
      await expectLater(
        useCase.call('newuser@test.com', 'password123'),
        completes,
      );
    });

    test('PASS: delegates email and password to repository unchanged', () async {
      when(() => repo.signup(any(), any())).thenAnswer((_) async {});
      await useCase.call('bob@example.com', 'mypass456');
      verify(() => repo.signup('bob@example.com', 'mypass456')).called(1);
    });

    test('PASS: propagates exception from repository', () async {
      when(() => repo.signup(any(), any()))
          .thenThrow(Exception('Email already exists'));
      expect(
        () => useCase.call('dup@test.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });

    test('PASS: calls repository exactly once per signup attempt', () async {
      when(() => repo.signup(any(), any())).thenAnswer((_) async {});
      await useCase.call('one@test.com', 'pass123');
      verify(() => repo.signup(any(), any())).called(1);
    });

    test('PASS: two sequential calls each delegate to repository independently',
        () async {
      when(() => repo.signup(any(), any())).thenAnswer((_) async {});
      await useCase.call('user1@test.com', 'pass1');
      await useCase.call('user2@test.com', 'pass2');
      verify(() => repo.signup(any(), any())).called(2);
    });
  });
}

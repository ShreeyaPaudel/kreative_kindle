import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/mocks.dart';

void main() {
  test('AuthRepository.login returns token on success', () async {
    final repo = MockAuthRepository();

    when(
      () => repo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => 'token123');

    final token = await repo.login(email: 'x@y.com', password: '123456');

    expect(token, 'token123');
    verify(() => repo.login(email: 'x@y.com', password: '123456')).called(1);
  });

  test('AuthRepository.register completes on success', () async {
    final repo = MockAuthRepository();

    when(
      () => repo.register(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await repo.register(email: 'x@y.com', password: '123456');

    verify(() => repo.register(email: 'x@y.com', password: '123456')).called(1);
  });
}

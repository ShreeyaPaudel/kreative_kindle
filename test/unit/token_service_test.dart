import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/mocks.dart';

void main() {
  test('TokenService saveToken called with correct token', () async {
    final tokenService = MockTokenService();
    when(() => tokenService.saveToken(any())).thenAnswer((_) async {});

    await tokenService.saveToken('abc123');

    verify(() => tokenService.saveToken('abc123')).called(1);
  });

  test('TokenService getToken returns token', () async {
    final tokenService = MockTokenService();
    when(() => tokenService.getToken()).thenAnswer((_) async => 'tok');

    final token = await tokenService.getToken();

    expect(token, 'tok');
    verify(() => tokenService.getToken()).called(1);
  });
}

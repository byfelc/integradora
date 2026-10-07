import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tdimp_mobile/services/match_api.dart';

void main() {
  test('latest consulta GET /api/v1/matches con limit y playerId', () async {
    late Uri called;
    final client = MockClient((req) async {
      called = req.url;
      return http.Response(jsonEncode([]), 200);
    });

    final api = MatchApi(client: client, baseUrl: 'https://api.test/');
    final result = await api.latest(limit: 5, playerId: 'hikari');

    expect(result, isEmpty);
    expect(called.path, '/api/v1/matches');
    expect(called.queryParameters['limit'], '5');
    expect(called.queryParameters['playerId'], 'hikari');
  });

  test('latest lanza MatchApiException si el servidor falla', () async {
    final client = MockClient((_) async => http.Response('error', 503));
    final api = MatchApi(client: client, baseUrl: 'https://api.test');

    await expectLater(api.latest(), throwsA(isA<MatchApiException>()));
  });
}

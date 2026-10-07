import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/match.dart';

/// Cliente de la API compartida. La URL se inyecta al compilar:
///   flutter build apk --dart-define=API_BASE_URL=https://...
class MatchApi {
  MatchApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? defaultBaseUrl).replaceAll(RegExp(r'/$'), '');

  static const String defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  final http.Client _client;
  final String _baseUrl;

  Future<List<Match>> latest({int limit = 10, String? playerId}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/matches').replace(
      queryParameters: {
        'limit': '$limit',
        if (playerId != null) 'playerId': playerId,
      },
    );
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw MatchApiException(res.statusCode);
    }
    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => Match.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}

class MatchApiException implements Exception {
  const MatchApiException(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'MatchApiException($statusCode)';
}

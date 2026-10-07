import 'package:flutter_test/flutter_test.dart';
import 'package:tdimp_mobile/models/match.dart';

void main() {
  test('Match.fromJson lee los campos del contrato', () {
    final m = Match.fromJson({
      'id': 1,
      'sessionId': '8a1f7c2e-0000-4000-8000-000000000001',
      'playerId': 'tsuki',
      'score': 1500,
      'durationSeconds': 420,
      'levelReached': 2,
      'progressPercent': 35,
      'outcome': 'COMPLETED',
      'materialsCollected': 6,
      'itemsCrafted': 2,
      'finishedAt': '2026-10-06T20:15:00Z',
      'gameVersion': '0.3.0',
      'receivedAt': '2026-10-06T20:15:01Z',
    });

    expect(m.playerId, 'tsuki');
    expect(m.score, 1500);
    expect(m.completed, isTrue);
    expect(m.finishedAt.isUtc, isTrue);
  });
}

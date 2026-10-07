/// Modelo alineado con MatchResponse de shared/contracts/openapi.yaml.
class Match {
  const Match({
    required this.id,
    required this.playerId,
    required this.score,
    required this.durationSeconds,
    required this.levelReached,
    required this.progressPercent,
    required this.outcome,
    required this.finishedAt,
  });

  final int id;
  final String playerId;
  final int score;
  final int durationSeconds;
  final int levelReached;
  final int progressPercent;
  final String outcome;
  final DateTime finishedAt;

  bool get completed => outcome == 'COMPLETED';

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int,
      playerId: json['playerId'] as String,
      score: json['score'] as int,
      durationSeconds: json['durationSeconds'] as int,
      levelReached: json['levelReached'] as int,
      progressPercent: json['progressPercent'] as int,
      outcome: json['outcome'] as String,
      finishedAt: DateTime.parse(json['finishedAt'] as String),
    );
  }
}

package mx.utch.tdimp.api.match;

public record PlayerStats(
        String playerId,
        long matchesPlayed,
        int bestScore,
        long totalPlaySeconds,
        int highestLevel,
        double completionRate) {
}

package mx.utch.tdimp.api.match;

import java.time.Instant;
import java.util.UUID;

public record MatchResponse(
        Long id,
        UUID sessionId,
        String playerId,
        int score,
        int durationSeconds,
        int levelReached,
        int progressPercent,
        MatchOutcome outcome,
        int materialsCollected,
        int itemsCrafted,
        Instant finishedAt,
        String gameVersion,
        Instant receivedAt) {

    public static MatchResponse of(Match m) {
        return new MatchResponse(m.getId(), m.getSessionId(), m.getPlayerId(), m.getScore(),
                m.getDurationSeconds(), m.getLevelReached(), m.getProgressPercent(), m.getOutcome(),
                m.getMaterialsCollected(), m.getItemsCrafted(), m.getFinishedAt(), m.getGameVersion(),
                m.getReceivedAt());
    }
}

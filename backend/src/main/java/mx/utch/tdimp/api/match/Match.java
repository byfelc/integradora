package mx.utch.tdimp.api.match;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "matches")
public class Match {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "session_id", nullable = false, unique = true)
    private UUID sessionId;

    @Column(name = "player_id", nullable = false, length = 64)
    private String playerId;

    @Column(nullable = false)
    private int score;

    @Column(name = "duration_seconds", nullable = false)
    private int durationSeconds;

    @Column(name = "level_reached", nullable = false)
    private int levelReached;

    @Column(name = "progress_percent", nullable = false)
    private int progressPercent;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private MatchOutcome outcome;

    @Column(name = "materials_collected", nullable = false)
    private int materialsCollected;

    @Column(name = "items_crafted", nullable = false)
    private int itemsCrafted;

    @Column(name = "finished_at", nullable = false)
    private Instant finishedAt;

    @Column(name = "game_version", nullable = false, length = 20)
    private String gameVersion;

    @Column(name = "received_at", nullable = false)
    private Instant receivedAt;

    protected Match() {
        // requerido por JPA
    }

    public static Match from(MatchRequest r) {
        Match m = new Match();
        m.sessionId = r.sessionId();
        m.playerId = r.playerId();
        m.score = r.score();
        m.durationSeconds = r.durationSeconds();
        m.levelReached = r.levelReached();
        m.progressPercent = r.progressPercent();
        m.outcome = r.outcome();
        m.materialsCollected = r.materialsCollected() == null ? 0 : r.materialsCollected();
        m.itemsCrafted = r.itemsCrafted() == null ? 0 : r.itemsCrafted();
        m.finishedAt = r.finishedAt();
        m.gameVersion = r.gameVersion();
        return m;
    }

    @PrePersist
    void onCreate() {
        if (receivedAt == null) {
            receivedAt = Instant.now();
        }
    }

    public Long getId() {
        return id;
    }

    public UUID getSessionId() {
        return sessionId;
    }

    public String getPlayerId() {
        return playerId;
    }

    public int getScore() {
        return score;
    }

    public int getDurationSeconds() {
        return durationSeconds;
    }

    public int getLevelReached() {
        return levelReached;
    }

    public int getProgressPercent() {
        return progressPercent;
    }

    public MatchOutcome getOutcome() {
        return outcome;
    }

    public int getMaterialsCollected() {
        return materialsCollected;
    }

    public int getItemsCrafted() {
        return itemsCrafted;
    }

    public Instant getFinishedAt() {
        return finishedAt;
    }

    public String getGameVersion() {
        return gameVersion;
    }

    public Instant getReceivedAt() {
        return receivedAt;
    }
}

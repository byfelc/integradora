package mx.utch.tdimp.api.match;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.util.UUID;

/** Cuerpo de POST /api/v1/matches. Las reglas replican el esquema MatchRequest del contrato. */
public record MatchRequest(
        @NotNull UUID sessionId,
        @NotBlank @Size(max = 64) String playerId,
        @NotNull @Min(0) Integer score,
        @NotNull @Min(1) Integer durationSeconds,
        @NotNull @Min(1) Integer levelReached,
        @NotNull @Min(0) @Max(100) Integer progressPercent,
        @NotNull MatchOutcome outcome,
        @Min(0) Integer materialsCollected,
        @Min(0) Integer itemsCrafted,
        @NotNull Instant finishedAt,
        @NotBlank @Size(max = 20) String gameVersion) {
}

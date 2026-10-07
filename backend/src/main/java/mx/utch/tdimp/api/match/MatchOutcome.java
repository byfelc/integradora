package mx.utch.tdimp.api.match;

/** Resultado de una partida; debe coincidir con MatchOutcome en shared/contracts/openapi.yaml. */
public enum MatchOutcome {
    COMPLETED,
    FAILED,
    ABANDONED
}

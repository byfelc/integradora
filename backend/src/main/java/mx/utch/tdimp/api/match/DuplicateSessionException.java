package mx.utch.tdimp.api.match;

import java.util.UUID;

public class DuplicateSessionException extends RuntimeException {

    public DuplicateSessionException(UUID sessionId) {
        super("La sesión " + sessionId + " ya fue registrada");
    }
}

package mx.utch.tdimp.api.match;

public class PlayerNotFoundException extends RuntimeException {

    public PlayerNotFoundException(String playerId) {
        super("El jugador " + playerId + " no tiene partidas registradas");
    }
}

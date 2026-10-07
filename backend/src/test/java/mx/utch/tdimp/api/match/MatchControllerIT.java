package mx.utch.tdimp.api.match;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;
import mx.utch.tdimp.api.AbstractPostgresIT;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

/** Integración: controlador → servicio → repositorio → PostgreSQL real (Testcontainers). */
class MatchControllerIT extends AbstractPostgresIT {

    @Autowired
    private MockMvc mvc;

    @Autowired
    private MatchRepository repository;

    @BeforeEach
    void clean() {
        repository.deleteAll();
    }

    private static String body(UUID session, String player, int score, String outcome) {
        return """
            {"sessionId":"%s","playerId":"%s","score":%d,"durationSeconds":420,
             "levelReached":2,"progressPercent":35,"outcome":"%s",
             "materialsCollected":6,"itemsCrafted":2,
             "finishedAt":"2026-10-06T20:15:00Z","gameVersion":"0.3.0"}
            """.formatted(session, player, score, outcome);
    }

    private void postMatch(UUID session, String player, int score, String outcome) throws Exception {
        mvc.perform(post("/api/v1/matches").header("X-Telemetry-Key", TELEMETRY_KEY)
                        .contentType(MediaType.APPLICATION_JSON).content(body(session, player, score, outcome)))
                .andExpect(status().isCreated());
    }

    @Test
    void registraPartidaYLaDevuelveConId() throws Exception {
        mvc.perform(post("/api/v1/matches").header("X-Telemetry-Key", TELEMETRY_KEY)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body(UUID.randomUUID(), "tsuki", 1500, "COMPLETED")))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").isNumber())
                .andExpect(jsonPath("$.playerId").value("tsuki"))
                .andExpect(jsonPath("$.receivedAt").isString());
    }

    @Test
    void sinLlaveDeTelemetriaResponde401() throws Exception {
        mvc.perform(post("/api/v1/matches").contentType(MediaType.APPLICATION_JSON)
                        .content(body(UUID.randomUUID(), "tsuki", 10, "FAILED")))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void sesionDuplicadaResponde409() throws Exception {
        UUID session = UUID.randomUUID();
        postMatch(session, "tsuki", 100, "FAILED");
        mvc.perform(post("/api/v1/matches").header("X-Telemetry-Key", TELEMETRY_KEY)
                        .contentType(MediaType.APPLICATION_JSON).content(body(session, "tsuki", 100, "FAILED")))
                .andExpect(status().isConflict());
    }

    @Test
    void datosInvalidosResponden400ConCampos() throws Exception {
        mvc.perform(post("/api/v1/matches").header("X-Telemetry-Key", TELEMETRY_KEY)
                        .contentType(MediaType.APPLICATION_JSON).content(body(UUID.randomUUID(), "tsuki", -5, "COMPLETED")))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fields.score").exists());
    }

    @Test
    void listaUltimasPartidasDelJugador() throws Exception {
        postMatch(UUID.randomUUID(), "tsuki", 100, "FAILED");
        postMatch(UUID.randomUUID(), "tsuki", 200, "COMPLETED");
        postMatch(UUID.randomUUID(), "hikari", 300, "COMPLETED");

        mvc.perform(get("/api/v1/matches").param("playerId", "tsuki"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)));
    }

    @Test
    void estadisticasDelJugador() throws Exception {
        postMatch(UUID.randomUUID(), "hikari", 300, "COMPLETED");
        postMatch(UUID.randomUUID(), "hikari", 900, "FAILED");

        mvc.perform(get("/api/v1/players/hikari/stats"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.matchesPlayed").value(2))
                .andExpect(jsonPath("$.bestScore").value(900))
                .andExpect(jsonPath("$.completionRate").value(50.0));
    }

    @Test
    void jugadorInexistenteResponde404() throws Exception {
        mvc.perform(get("/api/v1/players/nadie/stats")).andExpect(status().isNotFound());
    }
}

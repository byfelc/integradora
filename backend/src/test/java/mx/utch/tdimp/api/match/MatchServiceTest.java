package mx.utch.tdimp.api.match;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

/** Pruebas unitarias: lógica de negocio aislada, sin base de datos (se ejecutan en cada push). */
@ExtendWith(MockitoExtension.class)
class MatchServiceTest {

    @Mock
    private MatchRepository repository;

    private MatchService service;

    @BeforeEach
    void setUp() {
        service = new MatchService(repository);
    }

    static MatchRequest request(String player, int score, int level, MatchOutcome outcome) {
        return new MatchRequest(UUID.randomUUID(), player, score, 300, level, 50, outcome,
                4, 1, Instant.parse("2026-10-06T20:00:00Z"), "0.3.0");
    }

    @Test
    void registraPartidaNueva() {
        MatchRequest req = request("tsuki", 1200, 2, MatchOutcome.COMPLETED);
        when(repository.existsBySessionId(req.sessionId())).thenReturn(false);
        when(repository.saveAndFlush(any(Match.class))).thenAnswer(inv -> inv.getArgument(0));

        MatchResponse res = service.register(req);

        assertThat(res.playerId()).isEqualTo("tsuki");
        assertThat(res.score()).isEqualTo(1200);
        assertThat(res.materialsCollected()).isEqualTo(4);
    }

    @Test
    void rechazaSesionDuplicada() {
        MatchRequest req = request("tsuki", 10, 1, MatchOutcome.FAILED);
        when(repository.existsBySessionId(req.sessionId())).thenReturn(true);

        assertThatThrownBy(() -> service.register(req)).isInstanceOf(DuplicateSessionException.class);
        verify(repository, never()).saveAndFlush(any());
    }

    @Test
    void camposOpcionalesNulosSeGuardanEnCero() {
        MatchRequest req = new MatchRequest(UUID.randomUUID(), "hikari", 5, 60, 1, 10,
                MatchOutcome.ABANDONED, null, null, Instant.now(), "0.3.0");
        Match m = Match.from(req);
        assertThat(m.getMaterialsCollected()).isZero();
        assertThat(m.getItemsCrafted()).isZero();
    }

    @Test
    void calculaEstadisticasDelJugador() {
        when(repository.findByPlayerId("tsuki")).thenReturn(List.of(
                Match.from(request("tsuki", 900, 1, MatchOutcome.FAILED)),
                Match.from(request("tsuki", 1500, 3, MatchOutcome.COMPLETED)),
                Match.from(request("tsuki", 700, 2, MatchOutcome.COMPLETED))));

        PlayerStats stats = service.stats("tsuki");

        assertThat(stats.matchesPlayed()).isEqualTo(3);
        assertThat(stats.bestScore()).isEqualTo(1500);
        assertThat(stats.totalPlaySeconds()).isEqualTo(900);
        assertThat(stats.highestLevel()).isEqualTo(3);
        assertThat(stats.completionRate()).isEqualTo(66.7);
    }

    @Test
    void jugadorSinPartidasLanzaNoEncontrado() {
        when(repository.findByPlayerId("nadie")).thenReturn(List.of());
        assertThatThrownBy(() -> service.stats("nadie")).isInstanceOf(PlayerNotFoundException.class);
    }

    @Test
    void limiteSeAcotaEntreUnoYCincuenta() {
        assertThat(MatchService.clamp(0)).isEqualTo(1);
        assertThat(MatchService.clamp(10)).isEqualTo(10);
        assertThat(MatchService.clamp(500)).isEqualTo(50);
    }

    @Test
    void listaPorJugadorUsaConsultaFiltrada() {
        when(repository.findByPlayerIdOrderByFinishedAtDesc(eq("tsuki"), any(PageRequest.class)))
                .thenReturn(List.of());
        assertThat(service.latest("tsuki", 10)).isEmpty();
        verify(repository).findByPlayerIdOrderByFinishedAtDesc("tsuki", PageRequest.of(0, 10));
    }
}

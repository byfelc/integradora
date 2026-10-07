package mx.utch.tdimp.api.match;

import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MatchRepository extends JpaRepository<Match, Long> {

    boolean existsBySessionId(UUID sessionId);

    List<Match> findAllByOrderByFinishedAtDesc(Pageable pageable);

    List<Match> findByPlayerIdOrderByFinishedAtDesc(String playerId, Pageable pageable);

    List<Match> findByPlayerId(String playerId);
}

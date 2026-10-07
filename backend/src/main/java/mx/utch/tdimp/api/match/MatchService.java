package mx.utch.tdimp.api.match;

import java.util.List;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MatchService {

    static final int MAX_LIMIT = 50;

    private final MatchRepository repository;

    public MatchService(MatchRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public MatchResponse register(MatchRequest request) {
        if (repository.existsBySessionId(request.sessionId())) {
            throw new DuplicateSessionException(request.sessionId());
        }
        try {
            return MatchResponse.of(repository.saveAndFlush(Match.from(request)));
        } catch (DataIntegrityViolationException e) {
            // carrera entre dos envíos simultáneos de la misma sesión
            throw new DuplicateSessionException(request.sessionId());
        }
    }

    @Transactional(readOnly = true)
    public List<MatchResponse> latest(String playerId, int limit) {
        PageRequest page = PageRequest.of(0, clamp(limit));
        List<Match> matches = (playerId == null || playerId.isBlank())
                ? repository.findAllByOrderByFinishedAtDesc(page)
                : repository.findByPlayerIdOrderByFinishedAtDesc(playerId, page);
        return matches.stream().map(MatchResponse::of).toList();
    }

    @Transactional(readOnly = true)
    public PlayerStats stats(String playerId) {
        List<Match> matches = repository.findByPlayerId(playerId);
        if (matches.isEmpty()) {
            throw new PlayerNotFoundException(playerId);
        }
        long completed = matches.stream().filter(m -> m.getOutcome() == MatchOutcome.COMPLETED).count();
        int best = matches.stream().mapToInt(Match::getScore).max().orElse(0);
        long seconds = matches.stream().mapToLong(Match::getDurationSeconds).sum();
        int level = matches.stream().mapToInt(Match::getLevelReached).max().orElse(0);
        double rate = Math.round(completed * 1000.0 / matches.size()) / 10.0;
        return new PlayerStats(playerId, matches.size(), best, seconds, level, rate);
    }

    static int clamp(int limit) {
        return Math.max(1, Math.min(limit, MAX_LIMIT));
    }
}

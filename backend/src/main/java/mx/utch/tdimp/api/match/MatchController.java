package mx.utch.tdimp.api.match;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class MatchController {

    private final MatchService service;

    public MatchController(MatchService service) {
        this.service = service;
    }

    @PostMapping("/matches")
    @ResponseStatus(HttpStatus.CREATED)
    public MatchResponse registerMatch(@Valid @RequestBody MatchRequest request) {
        return service.register(request);
    }

    @GetMapping("/matches")
    public List<MatchResponse> listMatches(
            @RequestParam(required = false) String playerId,
            @RequestParam(defaultValue = "10") int limit) {
        return service.latest(playerId, limit);
    }

    @GetMapping("/players/{playerId}/stats")
    public PlayerStats getPlayerStats(@PathVariable String playerId) {
        return service.stats(playerId);
    }
}

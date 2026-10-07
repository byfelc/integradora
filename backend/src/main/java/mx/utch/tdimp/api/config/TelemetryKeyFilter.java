package mx.utch.tdimp.api.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Solo el videojuego puede registrar partidas: exige el header X-Telemetry-Key
 * en POST /api/v1/matches. La llave real vive como secreto TELEMETRY_API_KEY.
 */
@Component
public class TelemetryKeyFilter extends OncePerRequestFilter {

    static final String HEADER = "X-Telemetry-Key";

    private final byte[] expected;

    public TelemetryKeyFilter(@Value("${telemetry.api-key}") String apiKey) {
        this.expected = apiKey.getBytes(StandardCharsets.UTF_8);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !("POST".equals(request.getMethod()) && "/api/v1/matches".equals(request.getRequestURI()));
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String provided = request.getHeader(HEADER);
        if (provided == null || !MessageDigest.isEqual(expected, provided.getBytes(StandardCharsets.UTF_8))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Llave de telemetría inválida");
            return;
        }
        chain.doFilter(request, response);
    }
}

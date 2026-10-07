package mx.utch.tdimp.api.config;

import java.util.LinkedHashMap;
import java.util.Map;
import mx.utch.tdimp.api.match.DuplicateSessionException;
import mx.utch.tdimp.api.match.PlayerNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<ApiError> invalid(MethodArgumentNotValidException e) {
        Map<String, String> fields = new LinkedHashMap<>();
        e.getBindingResult().getFieldErrors()
                .forEach(f -> fields.putIfAbsent(f.getField(), f.getDefaultMessage()));
        return build(HttpStatus.BAD_REQUEST, "Datos de partida inválidos", fields);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    ResponseEntity<ApiError> unreadable(HttpMessageNotReadableException e) {
        return build(HttpStatus.BAD_REQUEST, "El cuerpo de la petición no es JSON válido", Map.of());
    }

    @ExceptionHandler(DuplicateSessionException.class)
    ResponseEntity<ApiError> duplicate(DuplicateSessionException e) {
        return build(HttpStatus.CONFLICT, e.getMessage(), Map.of());
    }

    @ExceptionHandler(PlayerNotFoundException.class)
    ResponseEntity<ApiError> notFound(PlayerNotFoundException e) {
        return build(HttpStatus.NOT_FOUND, e.getMessage(), Map.of());
    }

    private static ResponseEntity<ApiError> build(HttpStatus status, String message, Map<String, String> fields) {
        return ResponseEntity.status(status).body(new ApiError(status.value(), message, fields));
    }
}

package mx.utch.tdimp.api.config;

import java.util.Map;

public record ApiError(int status, String message, Map<String, String> fields) {
}

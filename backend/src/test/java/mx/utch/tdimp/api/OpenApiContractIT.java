package mx.utch.tdimp.api;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import org.yaml.snakeyaml.Yaml;

/**
 * Prueba de contrato: todo endpoint (ruta + método) declarado en
 * shared/contracts/openapi.yaml debe existir en la API que realmente expone el backend
 * (springdoc genera /v3/api-docs a partir de los controladores).
 * Si alguien borra o renombra un endpoint que consumen los clientes, el pipeline falla.
 */
class OpenApiContractIT extends AbstractPostgresIT {

    private static final Path CONTRACT = Path.of("..", "shared", "contracts", "openapi.yaml");

    @Autowired
    private MockMvc mvc;

    @Test
    @SuppressWarnings("unchecked")
    void cadaEndpointDelContratoEstaImplementado() throws Exception {
        Map<String, Object> contract;
        try (InputStream in = Files.newInputStream(CONTRACT)) {
            contract = new Yaml().load(in);
        }
        Map<String, Map<String, Object>> paths = (Map<String, Map<String, Object>>) contract.get("paths");

        String json = mvc.perform(get("/v3/api-docs")).andReturn().getResponse().getContentAsString();
        JsonNode implemented = new ObjectMapper().readTree(json).path("paths");

        List<String> missing = new ArrayList<>();
        paths.forEach((path, ops) -> ops.keySet().forEach(method -> {
            if (implemented.path(path).path(method).isMissingNode()) {
                missing.add(method.toUpperCase() + " " + path);
            }
        }));

        assertThat(missing).as("Endpoints del contrato sin implementar").isEmpty();
    }
}

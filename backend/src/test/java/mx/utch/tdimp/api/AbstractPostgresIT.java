package mx.utch.tdimp.api;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;

/**
 * Base de las pruebas de integración: levanta UN PostgreSQL real en contenedor
 * (Testcontainers) compartido por todas las clases *IT. Flyway aplica las
 * migraciones al arrancar, así que cada ejecución valida también el esquema.
 * En GitHub Actions (ubuntu-latest) Docker ya está disponible.
 */
@SpringBootTest(properties = "telemetry.api-key=test-key")
@AutoConfigureMockMvc
public abstract class AbstractPostgresIT {

    protected static final String TELEMETRY_KEY = "test-key";

    static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:16-alpine");

    static {
        POSTGRES.start();
    }

    @DynamicPropertySource
    static void datasource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
    }
}

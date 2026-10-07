-- V1: tabla de partidas registradas por el videojuego.
-- Regla del equipo: una migración aplicada NUNCA se edita; se crea V2, V3...
CREATE TABLE matches (
    id                  BIGSERIAL PRIMARY KEY,
    session_id          UUID         NOT NULL UNIQUE,
    player_id           VARCHAR(64)  NOT NULL,
    score               INTEGER      NOT NULL CHECK (score >= 0),
    duration_seconds    INTEGER      NOT NULL CHECK (duration_seconds > 0),
    level_reached       INTEGER      NOT NULL CHECK (level_reached >= 1),
    progress_percent    INTEGER      NOT NULL CHECK (progress_percent BETWEEN 0 AND 100),
    outcome             VARCHAR(16)  NOT NULL,
    materials_collected INTEGER      NOT NULL DEFAULT 0,
    items_crafted       INTEGER      NOT NULL DEFAULT 0,
    finished_at         TIMESTAMPTZ  NOT NULL,
    game_version        VARCHAR(20)  NOT NULL,
    received_at         TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE INDEX idx_matches_player_finished ON matches (player_id, finished_at DESC);

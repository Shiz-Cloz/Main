-- Safe, repeatable migration for the five tables reported missing by FreeDB.
-- Select the application's existing database before running this file.
-- No tables or records are dropped.

CREATE TABLE IF NOT EXISTS submission_attempts (
    ip VARCHAR(45) NOT NULL PRIMARY KEY,
    `count` INT NOT NULL DEFAULT 0,
    window_start DATETIME NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sheet_documents (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    title VARCHAR(120) NOT NULL DEFAULT 'Untitled sheet',
    cells LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sheet_documents_owner_updated (owner_id, updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS competency_templates (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    title VARCHAR(120) NOT NULL DEFAULT 'Untitled template',
    layout_json LONGTEXT NOT NULL,
    min_salary_grade TINYINT UNSIGNED NULL DEFAULT NULL,
    max_salary_grade TINYINT UNSIGNED NULL DEFAULT NULL,
    region VARCHAR(100) NULL DEFAULT NULL,
    field_name VARCHAR(100) NULL DEFAULT NULL,
    is_shared TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_competency_templates_owner_updated (owner_id, updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    office_scope VARCHAR(40) NOT NULL DEFAULT 'REGIONAL_OFFICE',
    title VARCHAR(255) NOT NULL,
    salary_grade TINYINT UNSIGNED NOT NULL,
    leadership_level CHAR(1) NULL,
    UNIQUE KEY uq_scope_title (office_scope, title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS positions_seed_state_v2 (
    id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
    seed_version SMALLINT UNSIGNED NOT NULL
) ENGINE=InnoDB;

INSERT IGNORE INTO positions_seed_state_v2 (id, seed_version) VALUES (1, 0);

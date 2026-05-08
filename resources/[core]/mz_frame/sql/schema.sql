CREATE TABLE IF NOT EXISTS `players` (
    `id`            INT          NOT NULL AUTO_INCREMENT,   -- Internal DB primary key, never exposed
    `ingame_id`     INT          NOT NULL UNIQUE,           -- Custom display ID assigned on first join
    `identifier`    VARCHAR(255) NOT NULL,                  -- Steam/license identifier (permanent)
    `first_name`    VARCHAR(50)  NOT NULL,                  -- Set during character creation
    `last_name`     VARCHAR(50)  NOT NULL,                  -- Set during character creation
    `last_location` VARCHAR(255) NOT NULL,                  -- Updated on player disconnect
    `sex` ENUM('male', 'female') NOT NULL,                  -- Set during character creation
    `created_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP, -- When the character was first created
    `last_seen`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_identifier` (`identifier`),
    UNIQUE KEY `uq_ingame_id`  (`ingame_id`)
);

CREATE TABLE IF NOT EXISTS `ingame_id_pool` (
    `ingame_id`  INT  NOT NULL AUTO_INCREMENT,
    `player_id`  INT  NOT NULL,
    PRIMARY KEY (`ingame_id`),
    FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
);
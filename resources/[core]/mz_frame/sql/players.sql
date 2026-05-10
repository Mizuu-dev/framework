CREATE TABLE IF NOT EXISTS `players` (
    `id`            INT          NOT NULL AUTO_INCREMENT,   -- Internal DB primary key, never exposed
    `ingame_id`     INT          NOT NULL UNIQUE,           -- Custom display ID assigned 
    `identifier`    VARCHAR(255) NOT NULL,                  -- Steam/license identifier (permanent)
    `first_name`    VARCHAR(50)  NOT NULL,                  -- Set during character creation
    `last_name`     VARCHAR(50)  NOT NULL,                  -- Set during character creation
    `last_location` VARCHAR(255) NOT NULL,                  -- Updated on player disconnect
    `sex` ENUM('male', 'female') NOT NULL,                  -- Set during character creation
    `role`          VARCHAR(50)  NOT NULL DEFAULT 'user',   -- Role assigned via /setgroup
    `created_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP, -- When the character was first created
    `last_seen`     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_identifier` (`identifier`),
    UNIQUE KEY `uq_ingame_id`  (`ingame_id`)
);

ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `role` VARCHAR(50) NOT NULL DEFAULT 'user';
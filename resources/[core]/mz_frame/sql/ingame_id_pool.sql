CREATE TABLE IF NOT EXISTS `ingame_id_pool` (
    `ingame_id`  INT  NOT NULL AUTO_INCREMENT,
    `player_id`  INT  NOT NULL,
    PRIMARY KEY (`ingame_id`),
    FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE
);
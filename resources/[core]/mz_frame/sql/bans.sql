CREATE TABLE IF NOT EXISTS `bans` (
    `id`          INT          NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(255) NOT NULL,
    `reason`      VARCHAR(255) NOT NULL DEFAULT 'No reason given',
    `banned_by`   INT          NOT NULL,
    `created_at`  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);

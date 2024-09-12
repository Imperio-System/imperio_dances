CREATE TABLE `imperio_dances` (
	`id` INT(5) NOT NULL AUTO_INCREMENT,
	`job` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`url` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`name` VARCHAR(150) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`thumbUrl` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`thumbTitle` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`duration` INT(5) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `id_UNIQUE` (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;
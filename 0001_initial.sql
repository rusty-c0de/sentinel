CREATE TABLE `incidents` (
	`id` text PRIMARY KEY NOT NULL,
	`site_id` text NOT NULL,
	`title` text NOT NULL,
	`summary` text NOT NULL,
	`severity` text NOT NULL,
	`status` text NOT NULL,
	`log_key` text,
	`file_name` text,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL,
	FOREIGN KEY (`site_id`) REFERENCES `installations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `incidents_site_idx` ON `incidents` (`site_id`);--> statement-breakpoint
CREATE TABLE `installations` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`region` text NOT NULL,
	`lat` real NOT NULL,
	`lng` real NOT NULL,
	`contact_name` text NOT NULL,
	`contact_email` text NOT NULL,
	`contact_phone` text NOT NULL,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `login_limits` (
	`key` text PRIMARY KEY NOT NULL,
	`attempts` integer NOT NULL,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `sessions` (
	`token_hash` text PRIMARY KEY NOT NULL,
	`expires_at` integer NOT NULL
);

CREATE TABLE `observations` (
	`id` text PRIMARY KEY NOT NULL,
	`incident_id` text NOT NULL,
	`site_id` text NOT NULL,
	`source_ip` text NOT NULL,
	`target_ip` text,
	`target_port` integer,
	`protocol` text NOT NULL,
	`username` text NOT NULL,
	`event_type` text NOT NULL,
	`outcome` text NOT NULL,
	`occurred_at` text,
	`source_label` text NOT NULL,
	`source_lat` real,
	`source_lng` real,
	`precision` text NOT NULL,
	`line_number` integer NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`incident_id`) REFERENCES `incidents`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`site_id`) REFERENCES `installations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `observations_source_idx` ON `observations` (`source_ip`);--> statement-breakpoint
CREATE INDEX `observations_incident_idx` ON `observations` (`incident_id`);--> statement-breakpoint
CREATE TABLE `source_locations` (
	`source_ip` text PRIMARY KEY NOT NULL,
	`label` text NOT NULL,
	`lat` real NOT NULL,
	`lng` real NOT NULL,
	`precision` text NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
ALTER TABLE `incidents` ADD `log_hash` text;--> statement-breakpoint
CREATE UNIQUE INDEX `incident_log_hash_idx` ON `incidents` (`site_id`,`log_hash`);
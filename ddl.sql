SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `molajo` DEFAULT CHARACTER SET utf8 ;
USE `molajo` ;

-- -----------------------------------------------------
-- Table `molajo`.`actions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`actions` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`actions` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Actions Primary Key' ,
  `title` VARCHAR(255) NOT NULL DEFAULT ' ' ,
  `protected` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `idx_actions_table_title` ON `molajo`.`actions` (`title` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`applications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`applications` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`applications` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Application Primary Key' ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `name` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Title' ,
  `path` VARCHAR(2048) NOT NULL DEFAULT ' ' COMMENT 'URL Alias' ,
  `description` MEDIUMTEXT NULL DEFAULT NULL ,
  `custom_fields` MEDIUMTEXT NULL DEFAULT NULL ,
  `parameters` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Configurable Parameter Values' ,
  `metadata` MEDIUMTEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `molajo`.`catalog_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`catalog_types` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`catalog_types` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Actions Primary Key' ,
  `title` VARCHAR(255) NOT NULL DEFAULT '' ,
  `extension_instance_id` INT(11) NULL ,
  `protected` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `model_type` VARCHAR(255) NULL ,
  `model_name` VARCHAR(45) NULL ,
  `primary_category_id` INT(11) NULL ,
  `source_table` VARCHAR(255) NOT NULL DEFAULT '' ,
  `slug` VARCHAR(45) NULL ,
  `routable` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `molajo`.`catalog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`catalog` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`catalog` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Assets Primary Key' ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `source_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Content Primary Key' ,
  `routable` TINYINT(1)  NOT NULL DEFAULT 0 ,
  `menuitem_type` VARCHAR(255) NOT NULL DEFAULT ' ' ,
  `sef_request` VARCHAR(2048) NOT NULL DEFAULT ' ' COMMENT 'URL' ,
  `redirect_to_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `view_group_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'FK to the #__groupings table' ,
  `primary_category_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `tinyurl` VARCHAR(255) NOT NULL DEFAULT ' ' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_catalog_catalog_types`
    FOREIGN KEY (`catalog_type_id` )
    REFERENCES `molajo`.`catalog_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7011
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `sef_request` ON `molajo`.`catalog` (`sef_request` ASC) ;

CREATE INDEX `index_catalog_catalog_types` ON `molajo`.`catalog` (`catalog_type_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`extension_sites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`extension_sites` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`extension_sites` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL DEFAULT ' ' ,
  `enabled` TINYINT(1) NOT NULL DEFAULT 0 ,
  `location` VARCHAR(2048) NOT NULL ,
  `custom_fields` MEDIUMTEXT NULL ,
  `parameters` MEDIUMTEXT NULL ,
  `metadata` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `molajo`.`extensions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`extensions` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`extensions` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `extension_site_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `subtitle` VARCHAR(255) NOT NULL DEFAULT '' ,
  `language` CHAR(7) NULL ,
  `translation_of_id` INT(11) NULL ,
  `ordering` INT(11) NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_extensions_extension_sites`
    FOREIGN KEY (`extension_site_id` )
    REFERENCES `molajo`.`extension_sites` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2551
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_extensions_extension_sites_index` ON `molajo`.`extensions` (`extension_site_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`view_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`view_groups` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`view_groups` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `view_group_name_list` TEXT NOT NULL ,
  `view_group_id_list` TEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `molajo`.`extension_instances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`extension_instances` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`extension_instances` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key' ,
  `extension_id` INT(11) UNSIGNED NOT NULL ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL ,
  `title` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Title' ,
  `subtitle` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Subtitle' ,
  `path` VARCHAR(2048) NULL ,
  `alias` VARCHAR(255) NOT NULL DEFAULT ' ' ,
  `content_text` MEDIUMTEXT NULL ,
  `protected` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `featured` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `stickied` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `status` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Published State 2: Archived 1: Published 0: Unpublished -1: Trashed -2: Spam -10 Version' ,
  `start_publishing_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Publish Begin Date and Time' ,
  `stop_publishing_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Publish End Date and Time' ,
  `version` INT(11) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Version Number' ,
  `version_of_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Primary ID for this Version' ,
  `status_prior_to_version` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'State value prior to creating this version copy and changing the state to Version' ,
  `created_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Created Date and Time' ,
  `created_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Created by User ID' ,
  `modified_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Modified Date' ,
  `modified_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Modified By User ID' ,
  `checked_out_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Checked out Date and Time' ,
  `checked_out_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Checked out by User Id' ,
  `root` INT(11) NOT NULL ,
  `parent_id` INT(11) NOT NULL ,
  `lft` INT(11) NOT NULL ,
  `rgt` INT(11) NOT NULL ,
  `lvl` INT(11) NOT NULL ,
  `home` TINYINT(4) NULL ,
  `custom_fields` MEDIUMTEXT NULL ,
  `parameters` MEDIUMTEXT NULL COMMENT 'Attributes (Custom Fields)' ,
  `metadata` MEDIUMTEXT NULL ,
  `language` CHAR(7) NOT NULL DEFAULT 'en-GB' ,
  `translation_of_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `ordering` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Ordering' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_extension_instances_extensions`
    FOREIGN KEY (`extension_id` )
    REFERENCES `molajo`.`extensions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `extension_instances_extensions_index` ON `molajo`.`extension_instances` (`extension_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`content` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`content` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Primary Key' ,
  `extension_instance_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `title` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Title' ,
  `subtitle` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Subtitle' ,
  `path` VARCHAR(2048) NOT NULL DEFAULT '' ,
  `alias` VARCHAR(255) NOT NULL DEFAULT ' ' ,
  `content_text` MEDIUMTEXT NULL ,
  `protected` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `featured` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `stickied` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `status` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Published State 2: Archived 1: Published 0: Unpublished -1: Trashed -2: Spam -10 Version' ,
  `start_publishing_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Publish Begin Date and Time' ,
  `stop_publishing_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Publish End Date and Time' ,
  `version` INT(11) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Version Number' ,
  `version_of_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Primary ID for this Version' ,
  `status_prior_to_version` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'State value prior to creating this version copy and changing the state to Version' ,
  `created_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Created Date and Time' ,
  `created_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Created by User ID' ,
  `modified_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Modified Date' ,
  `modified_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Modified By User ID' ,
  `checked_out_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Checked out Date and Time' ,
  `checked_out_by` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Checked out by User Id' ,
  `root` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `parent_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `lft` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `rgt` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `lvl` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `home` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `custom_fields` MEDIUMTEXT NULL ,
  `parameters` MEDIUMTEXT NULL COMMENT 'Attributes (Custom Fields)' ,
  `metadata` MEDIUMTEXT NULL ,
  `language` CHAR(7) NOT NULL DEFAULT 'en-GB' ,
  `translation_of_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `ordering` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Ordering' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_content_extension_instances`
    FOREIGN KEY (`extension_instance_id` )
    REFERENCES `molajo`.`extension_instances` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_content_extension_instances_index` ON `molajo`.`content` (`extension_instance_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`group_view_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`group_view_groups` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`group_view_groups` (
  `group_id` INT(11) UNSIGNED NOT NULL COMMENT 'FK to the #__group table.' ,
  `view_group_id` INT(11) UNSIGNED NOT NULL COMMENT 'FK to the #__groupings table.' ,
  PRIMARY KEY (`view_group_id`, `group_id`) ,
  CONSTRAINT `fk_group_view_groups_view_groups`
    FOREIGN KEY (`view_group_id` )
    REFERENCES `molajo`.`view_groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_view_groups_groups`
    FOREIGN KEY (`group_id` )
    REFERENCES `molajo`.`content` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_group_view_groups_view_groups_index` ON `molajo`.`group_view_groups` (`view_group_id` ASC) ;

CREATE INDEX `fk_group_view_groups_groups_index` ON `molajo`.`group_view_groups` (`group_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`view_group_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`view_group_permissions` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`view_group_permissions` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `view_group_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__groups.id' ,
  `asset_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__assets.id' ,
  `action_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__actions.id' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_view_group_permissions_view_groups`
    FOREIGN KEY (`view_group_id` )
    REFERENCES `molajo`.`view_groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_view_group_permissions_actions`
    FOREIGN KEY (`action_id` )
    REFERENCES `molajo`.`actions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_view_group_permissions_assets`
    FOREIGN KEY (`asset_id` )
    REFERENCES `molajo`.`catalog` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_view_group_permissions_view_groups_index` ON `molajo`.`view_group_permissions` (`view_group_id` ASC) ;

CREATE INDEX `fk_view_group_permissions_actions_index` ON `molajo`.`view_group_permissions` (`action_id` ASC) ;

CREATE INDEX `fk_view_group_permissions_assets_index` ON `molajo`.`view_group_permissions` (`asset_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`group_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`group_permissions` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`group_permissions` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `group_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #_groups.id' ,
  `catalog_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__assets.id' ,
  `action_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__actions.id' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_group_permissions_actions`
    FOREIGN KEY (`action_id` )
    REFERENCES `molajo`.`actions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_permissions_content`
    FOREIGN KEY (`group_id` )
    REFERENCES `molajo`.`content` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_permissions_assets`
    FOREIGN KEY (`catalog_id` )
    REFERENCES `molajo`.`catalog` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_group_permissions_actions_index` ON `molajo`.`group_permissions` (`action_id` ASC) ;

CREATE INDEX `fk_group_permissions_content_index` ON `molajo`.`group_permissions` (`group_id` ASC) ;

CREATE INDEX `fk_group_permissions_assets_index` ON `molajo`.`group_permissions` (`catalog_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`sessions` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`sessions` (
  `session_id` VARCHAR(32) NOT NULL ,
  `application_id` INT(11) UNSIGNED NOT NULL ,
  `session_time` VARCHAR(14) NULL DEFAULT ' ' ,
  `data` LONGTEXT NULL ,
  `user_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`session_id`) ,
  CONSTRAINT `fk_sessions_applications`
    FOREIGN KEY (`application_id` )
    REFERENCES `molajo`.`applications` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sessions_applications_index` ON `molajo`.`sessions` (`application_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`users` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `username` VARCHAR(255) NOT NULL ,
  `first_name` VARCHAR(100) NULL DEFAULT '' ,
  `last_name` VARCHAR(150) NULL DEFAULT '' ,
  `full_name` CHAR(255) NULL ,
  `content_text` MEDIUMTEXT NULL ,
  `email` VARCHAR(255) NULL DEFAULT '  ' ,
  `password` VARCHAR(100) NOT NULL DEFAULT '  ' ,
  `block` TINYINT(4) NOT NULL DEFAULT 0 ,
  `register_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `activation_datetime` DATETIME NULL ,
  `last_visit_datetime` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
  `custom_fields` MEDIUMTEXT NULL ,
  `parameters` MEDIUMTEXT NULL COMMENT 'Configurable Parameter Values' ,
  `metadata` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `last_name_first_name` ON `molajo`.`users` (`last_name` ASC, `first_name` ASC) ;

CREATE UNIQUE INDEX `username` ON `molajo`.`users` (`username` ASC) ;

CREATE UNIQUE INDEX `email` ON `molajo`.`users` (`email` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`user_applications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`user_applications` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`user_applications` (
  `user_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__users.id' ,
  `application_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__applications.id' ,
  PRIMARY KEY (`application_id`, `user_id`) ,
  CONSTRAINT `fk_user_applications_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `molajo`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_applications_applications`
    FOREIGN KEY (`application_id` )
    REFERENCES `molajo`.`applications` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_user_applications_users_index` ON `molajo`.`user_applications` (`user_id` ASC) ;

CREATE INDEX `fk_user_applications_applications_index` ON `molajo`.`user_applications` (`application_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`user_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`user_groups` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`user_groups` (
  `user_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__users.id' ,
  `group_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__groups.id' ,
  PRIMARY KEY (`group_id`, `user_id`) ,
  CONSTRAINT `fk_user_groups_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `molajo`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_groups_groups`
    FOREIGN KEY (`group_id` )
    REFERENCES `molajo`.`content` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_molajo_user_groups_molajo_users_index` ON `molajo`.`user_groups` (`user_id` ASC) ;

CREATE INDEX `fk_molajo_user_groups_molajo_groups_index` ON `molajo`.`user_groups` (`group_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`application_extension_instances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`application_extension_instances` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`application_extension_instances` (
  `application_id` INT(11) UNSIGNED NOT NULL ,
  `extension_instance_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`application_id`, `extension_instance_id`) ,
  CONSTRAINT `fk_application_extensions_applications`
    FOREIGN KEY (`application_id` )
    REFERENCES `molajo`.`applications` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_application_extension_instances_extension_instances`
    FOREIGN KEY (`extension_instance_id` )
    REFERENCES `molajo`.`extension_instances` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_application_extensions_applications_index` ON `molajo`.`application_extension_instances` (`application_id` ASC) ;

CREATE INDEX `fk_application_extension_instances_extension_instances_index` ON `molajo`.`application_extension_instances` (`extension_instance_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`sites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`sites` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`sites` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Application Primary Key' ,
  `catalog_type_id` INT(11) UNSIGNED NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT ' ' COMMENT 'Title' ,
  `path` VARCHAR(2048) NOT NULL DEFAULT ' ' COMMENT 'URL Alias' ,
  `base_url` VARCHAR(2048) NOT NULL DEFAULT ' ' ,
  `description` MEDIUMTEXT NULL DEFAULT NULL ,
  `custom_fields` MEDIUMTEXT NULL DEFAULT NULL ,
  `parameters` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Configurable Parameter Values' ,
  `metadata` MEDIUMTEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `molajo`.`catalog_categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`catalog_categories` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`catalog_categories` (
  `catalog_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `category_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`catalog_id`, `category_id`) ,
  CONSTRAINT `fk_catalog_categories_catalog`
    FOREIGN KEY (`catalog_id` )
    REFERENCES `molajo`.`catalog` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_catalog_categories_categories`
    FOREIGN KEY (`category_id` )
    REFERENCES `molajo`.`content` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_catalog_categories_catalog_index` ON `molajo`.`catalog_categories` (`catalog_id` ASC) ;

CREATE INDEX `fk_catalog_categories_categories_index` ON `molajo`.`catalog_categories` (`category_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`site_applications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`site_applications` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`site_applications` (
  `site_id` INT(11) UNSIGNED NOT NULL ,
  `application_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`site_id`, `application_id`) ,
  CONSTRAINT `fk_site_applications_sites`
    FOREIGN KEY (`site_id` )
    REFERENCES `molajo`.`sites` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_site_applications_applications`
    FOREIGN KEY (`application_id` )
    REFERENCES `molajo`.`applications` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_site_applications_sites_index` ON `molajo`.`site_applications` (`site_id` ASC) ;

CREATE INDEX `fk_site_applications_applications_index` ON `molajo`.`site_applications` (`application_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`site_extension_instances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`site_extension_instances` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`site_extension_instances` (
  `site_id` INT(11) UNSIGNED NOT NULL ,
  `extension_instance_id` INT(11) UNSIGNED NOT NULL ,
  PRIMARY KEY (`site_id`, `extension_instance_id`) ,
  CONSTRAINT `fk_site_extension_instances_sites`
    FOREIGN KEY (`site_id` )
    REFERENCES `molajo`.`sites` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_site_extension_instances_extension_instances`
    FOREIGN KEY (`extension_instance_id` )
    REFERENCES `molajo`.`extension_instances` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_site_extension_instances_sites_index` ON `molajo`.`site_extension_instances` (`site_id` ASC) ;

CREATE INDEX `fk_site_extension_instances_extension_instances_index` ON `molajo`.`site_extension_instances` (`extension_instance_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`user_view_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`user_view_groups` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`user_view_groups` (
  `user_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__users.id' ,
  `view_group_id` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign Key to #__groups.id' ,
  PRIMARY KEY (`view_group_id`, `user_id`) ,
  CONSTRAINT `fk_user_view_groups_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `molajo`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_view_groups_view_groups`
    FOREIGN KEY (`view_group_id` )
    REFERENCES `molajo`.`view_groups` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_user_groups_users_index` ON `molajo`.`user_view_groups` (`user_id` ASC) ;

CREATE INDEX `fk_user_view_groups_view_groups_index` ON `molajo`.`user_view_groups` (`view_group_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`user_activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`user_activity` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`user_activity` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Foreign Key to #__users.id' ,
  `action_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `catalog_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `activity_datetime` DATETIME NULL ,
  `ip_address` VARCHAR(15) NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_user_applications_users_fk`
    FOREIGN KEY (`user_id` )
    REFERENCES `molajo`.`users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_activity_stream_assets_fk`
    FOREIGN KEY (`catalog_id` )
    REFERENCES `molajo`.`catalog` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_activity_stream_action_types_fk'`
    FOREIGN KEY (`action_id` )
    REFERENCES `molajo`.`actions` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_user_activity_user_index` ON `molajo`.`user_activity` (`user_id` ASC) ;

CREATE INDEX `fk_user_activity_assets_index` ON `molajo`.`user_activity` (`catalog_id` ASC) ;

CREATE INDEX `fk_user_activity_action_index` ON `molajo`.`user_activity` (`action_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`catalog_activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`catalog_activity` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`catalog_activity` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `catalog_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `user_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `action_id` INT(11) UNSIGNED NOT NULL DEFAULT 0 ,
  `rating` TINYINT(4) UNSIGNED NOT NULL DEFAULT 0 ,
  `activity_datetime` DATETIME NULL ,
  `ip_address` VARCHAR(15) NOT NULL DEFAULT '' ,
  `custom_fields` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_catalog_activity_catalog1`
    FOREIGN KEY (`catalog_id` )
    REFERENCES `molajo`.`catalog` (`catalog_type_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_catalog_activity_catalog1` ON `molajo`.`catalog_activity` (`catalog_id` ASC) ;


-- -----------------------------------------------------
-- Table `molajo`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `molajo`.`log` ;

CREATE  TABLE IF NOT EXISTS `molajo`.`log` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `priority` INT(11) NOT NULL ,
  `message` MEDIUMTEXT NULL ,
  `date` DATETIME NULL ,
  `category` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

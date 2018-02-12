-- -----------------------------------------------------
-- Table `Template`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Template` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `Title` VARCHAR(30) NOT NULL ,
  PRIMARY KEY (`id`)  )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `References`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `References` (
  `url` VARCHAR(400) NOT NULL ,
  `Templates_id` INT NOT NULL ,
  PRIMARY KEY (`url`, `Templates_id`)  ,
  INDEX `fk_References_Template_idx` (`Templates_id` ASC)  ,
  CONSTRAINT `fk_References_Template`
    FOREIGN KEY (`Template_id`)
    REFERENCES `Template` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

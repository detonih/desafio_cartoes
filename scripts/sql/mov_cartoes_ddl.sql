SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mov_cartoes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mov_cartoes` ;
USE `mov_cartoes` ;

-- -----------------------------------------------------
-- Table `mov_cartoes`.`associado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mov_cartoes`.`associado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(100) NOT NULL,
  `dt_nasc` DATE NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mov_cartoes`.`conta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mov_cartoes`.`conta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(50) NOT NULL,
  `data_criacao` TIMESTAMP NULL,
  `id_associado` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `id_associado_idx` (`id_associado` ASC) VISIBLE,
  CONSTRAINT `id_associado`
    FOREIGN KEY (`id_associado`)
    REFERENCES `mov_cartoes`.`associado` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mov_cartoes`.`cartao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mov_cartoes`.`cartao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `num_cartao` BIGINT NOT NULL,
  `nom_impresso` VARCHAR(100) NOT NULL,
  `data_criacao` TIMESTAMP NULL,
  `id_conta` INT NOT NULL,
  `id_associado_cartao` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `num_cartao_UNIQUE` (`num_cartao` ASC) VISIBLE,
  INDEX `id_conta_idx` (`id_conta` ASC) VISIBLE,
  INDEX `id_associado_idx` (`id_associado_cartao` ASC) VISIBLE,
  CONSTRAINT `id_conta`
    FOREIGN KEY (`id_conta`)
    REFERENCES `mov_cartoes`.`conta` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_associado_cartao`
    FOREIGN KEY (`id_associado_cartao`)
    REFERENCES `mov_cartoes`.`associado` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mov_cartoes`.`movimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mov_cartoes`.`movimento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `vlr_transacao` DECIMAL(10,2) NULL,
  `des_transacao` VARCHAR(100) NULL,
  `data_movimento` TIMESTAMP NOT NULL,
  `id_cartao` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `id_cartao_idx` (`id_cartao` ASC) VISIBLE,
  CONSTRAINT `id_cartao`
    FOREIGN KEY (`id_cartao`)
    REFERENCES `mov_cartoes`.`cartao` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

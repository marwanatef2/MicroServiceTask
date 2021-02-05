-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Type` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Document`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Document` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Status` ENUM('available', 'circulated', 'mailed') NULL,
  `Type_id` INT NULL,
  `External` TINYINT ZEROFILL NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  INDEX `fk_Document_Type_idx` (`Type_id` ASC) VISIBLE,
  CONSTRAINT `fk_Document_Type`
    FOREIGN KEY (`Type_id`)
    REFERENCES `mydb`.`Type` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Receipt` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Number` VARCHAR(45) NULL,
  `Date` DATE NULL,
  `Document_id` INT NOT NULL,
  PRIMARY KEY (`Id`, `Document_id`),
  INDEX `fk_Receipt_Document1_idx` (`Document_id` ASC) VISIBLE,
  CONSTRAINT `fk_Receipt_Document1`
    FOREIGN KEY (`Document_id`)
    REFERENCES `mydb`.`Document` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Draft`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Draft` (
  `Id` INT NOT NULL,
  `Description` VARCHAR(255) NULL,
  `Document_Id` INT NOT NULL,
  PRIMARY KEY (`Id`, `Document_Id`),
  INDEX `fk_Draft_Document1_idx` (`Document_Id` ASC) VISIBLE,
  CONSTRAINT `fk_Draft_Document1`
    FOREIGN KEY (`Document_Id`)
    REFERENCES `mydb`.`Document` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Department` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(100) NOT NULL,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `PhoneNo` VARCHAR(11) NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Employee` (
  `Department_Id` INT NOT NULL,
  `User_Id` INT NOT NULL,
  PRIMARY KEY (`Department_Id`, `User_Id`),
  INDEX `fk_Employee_User1_idx` (`User_Id` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_Department1`
    FOREIGN KEY (`Department_Id`)
    REFERENCES `mydb`.`Department` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Employee_User1`
    FOREIGN KEY (`User_Id`)
    REFERENCES `mydb`.`User` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Copy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Copy` (
  `Id` INT NOT NULL,
  `Draft_Id` INT NOT NULL,
  `Draft_Document_Id` INT NOT NULL,
  `Employeer_Id` INT NOT NULL,
  PRIMARY KEY (`Id`, `Draft_Id`, `Draft_Document_Id`, `Employeer_Id`),
  INDEX `fk_Copy_Draft1_idx` (`Draft_Id` ASC, `Draft_Document_Id` ASC) VISIBLE,
  INDEX `fk_Copy_Employee1_idx` (`Employeer_Id` ASC) VISIBLE,
  CONSTRAINT `fk_Copy_Draft1`
    FOREIGN KEY (`Draft_Id` , `Draft_Document_Id`)
    REFERENCES `mydb`.`Draft` (`Id` , `Document_Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Copy_Employee1`
    FOREIGN KEY (`Employeer_Id`)
    REFERENCES `mydb`.`Employee` (`User_Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customer` (
  `Address` VARCHAR(255) NOT NULL,
  `User_Id` INT NOT NULL,
  PRIMARY KEY (`User_Id`),
  CONSTRAINT `fk_Customer_User1`
    FOREIGN KEY (`User_Id`)
    REFERENCES `mydb`.`User` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Document_Circulation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Document_Circulation` (
  `Employeer_Id` INT NOT NULL,
  `Document_Id` INT NOT NULL,
  `Date` DATE NOT NULL,
  PRIMARY KEY (`Employeer_Id`, `Document_Id`, `Date`),
  INDEX `fk_Employee_has_Document_Document1_idx` (`Document_Id` ASC) VISIBLE,
  INDEX `fk_Employee_has_Document_Employee1_idx` (`Employeer_Id` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_has_Document_Employee1`
    FOREIGN KEY (`Employeer_Id`)
    REFERENCES `mydb`.`Employee` (`User_Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Employee_has_Document_Document1`
    FOREIGN KEY (`Document_Id`)
    REFERENCES `mydb`.`Document` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Document_Change`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Document_Change` (
  `User_Id` INT NOT NULL,
  `Document_Id` INT NOT NULL,
  `Date` DATE NOT NULL,
  `ChangeDescription` VARCHAR(255) NULL,
  PRIMARY KEY (`User_Id`, `Document_Id`, `Date`),
  INDEX `fk_User_has_Document_Document1_idx` (`Document_Id` ASC) VISIBLE,
  INDEX `fk_User_has_Document_User1_idx` (`User_Id` ASC) VISIBLE,
  CONSTRAINT `fk_User_has_Document_User1`
    FOREIGN KEY (`User_Id`)
    REFERENCES `mydb`.`User` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_User_has_Document_Document1`
    FOREIGN KEY (`Document_Id`)
    REFERENCES `mydb`.`Document` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Request` (
  `Customer_User_Id` INT NOT NULL,
  `Document_Id` INT NOT NULL,
  PRIMARY KEY (`Customer_User_Id`, `Document_Id`),
  INDEX `fk_Customer_has_Document_Document1_idx` (`Document_Id` ASC) VISIBLE,
  INDEX `fk_Customer_has_Document_Customer1_idx` (`Customer_User_Id` ASC) VISIBLE,
  CONSTRAINT `fk_Customer_has_Document_Customer1`
    FOREIGN KEY (`Customer_User_Id`)
    REFERENCES `mydb`.`Customer` (`User_Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Customer_has_Document_Document1`
    FOREIGN KEY (`Document_Id`)
    REFERENCES `mydb`.`Document` (`Id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

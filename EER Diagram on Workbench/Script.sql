-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema VNC
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `VNC` ;

-- -----------------------------------------------------
-- Schema VNC
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `VNC` DEFAULT CHARACTER SET utf8 ;
USE `VNC` ;

-- -----------------------------------------------------
-- Table `VNC`.`Channel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Channel` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Channel` (
  `freqancy` VARCHAR(40) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `FEC` VARCHAR(5) NOT NULL,
  `polarisation` VARCHAR(20) NOT NULL,
  UNIQUE INDEX `freqancy_UNIQUE` (`freqancy` ASC),
  PRIMARY KEY (`freqancy`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Ads`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Ads` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Ads` (
  `sponser_name` VARCHAR(30) NOT NULL,
  `duration` INT NOT NULL,
  `price_per_minute` FLOAT NOT NULL,
  PRIMARY KEY (`sponser_name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Program`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Program` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Program` (
  `ID` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Show`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Show` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Show` (
  `program_ID` INT NOT NULL,
  `Ads_sponser_name` VARCHAR(30) NOT NULL,
  `channel_freqancy` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`program_ID`, `Ads_sponser_name`, `channel_freqancy`),
  INDEX `fk_program_has_Ads_Ads1_idx` (`Ads_sponser_name` ASC),
  INDEX `fk_program_has_Ads_program_idx` (`program_ID` ASC),
  INDEX `fk_program_has_Ads_channel1_idx` (`channel_freqancy` ASC),
  CONSTRAINT `fk_program_has_Ads_program`
    FOREIGN KEY (`program_ID`)
    REFERENCES `VNC`.`Program` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_has_Ads_Ads1`
    FOREIGN KEY (`Ads_sponser_name`)
    REFERENCES `VNC`.`Ads` (`sponser_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_program_has_Ads_channel1`
    FOREIGN KEY (`channel_freqancy`)
    REFERENCES `VNC`.`Channel` (`freqancy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Studio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Studio` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Studio` (
  `studio_id` INT NOT NULL,
  `location` VARCHAR(45) NOT NULL,
  `channel_freqancy` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`studio_id`),
  INDEX `fk_studio_channel1_idx` (`channel_freqancy` ASC),
  CONSTRAINT `fk_studio_channel1`
    FOREIGN KEY (`channel_freqancy`)
    REFERENCES `VNC`.`Channel` (`freqancy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Department` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Department` (
  `dname` VARCHAR(45) NOT NULL,
  `channel_freqancy` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`dname`),
  INDEX `fk_department_channel1_idx` (`channel_freqancy` ASC),
  CONSTRAINT `fk_department_channel1`
    FOREIGN KEY (`channel_freqancy`)
    REFERENCES `VNC`.`Channel` (`freqancy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Person` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Person` (
  `ssn` VARCHAR(45) NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `b_date` VARCHAR(45) NOT NULL,
  `sex` VARCHAR(10) NOT NULL,
  `nationality` VARCHAR(45) NOT NULL,
  `channel_freqancy` VARCHAR(40) NULL,
  PRIMARY KEY (`ssn`),
  INDEX `fk_person_channel1_idx` (`channel_freqancy` ASC),
  CONSTRAINT `fk_person_channel1`
    FOREIGN KEY (`channel_freqancy`)
    REFERENCES `VNC`.`Channel` (`freqancy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Staff` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Staff` (
  `Person_ssn` VARCHAR(30) NOT NULL,
  `job_title` VARCHAR(20) NOT NULL,
  `monthly_salary` DECIMAL(10,2) NOT NULL,
  `department_dname` VARCHAR(45) NULL,
  INDEX `fk_staff_department1_idx` (`department_dname` ASC),
  INDEX `fk_Staff_Person1_idx` (`Person_ssn` ASC),
  PRIMARY KEY (`Person_ssn`),
  CONSTRAINT `fk_staff_department1`
    FOREIGN KEY (`department_dname`)
    REFERENCES `VNC`.`Department` (`dname`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Staff_Person1`
    FOREIGN KEY (`Person_ssn`)
    REFERENCES `VNC`.`Person` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Director` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Director` (
  `dssn` VARCHAR(30) NOT NULL,
  INDEX `fk_Director_Staff1_idx` (`dssn` ASC),
  PRIMARY KEY (`dssn`),
  CONSTRAINT `fk_Director_Staff1`
    FOREIGN KEY (`dssn`)
    REFERENCES `VNC`.`Staff` (`Person_ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Season`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Season` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Season` (
  `number` INT NOT NULL,
  `start_date` VARCHAR(60) NOT NULL,
  `program_ID` INT NULL,
  `dssn` VARCHAR(30) NULL,
  PRIMARY KEY (`number`),
  INDEX `fk_season_program1_idx` (`program_ID` ASC),
  INDEX `fk_Season_Director1_idx` (`dssn` ASC),
  CONSTRAINT `fk_season_program1`
    FOREIGN KEY (`program_ID`)
    REFERENCES `VNC`.`Program` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Season_Director1`
    FOREIGN KEY (`dssn`)
    REFERENCES `VNC`.`Director` (`dssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Episode`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Episode` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Episode` (
  `enumber` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `content` VARCHAR(200) NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `season_number` INT NULL,
  `end_date` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`season_number`),
  CONSTRAINT `fk_episode_season1`
    FOREIGN KEY (`season_number`)
    REFERENCES `VNC`.`Season` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Department_Location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Department_Location` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Department_Location` (
  `location` VARCHAR(45) NOT NULL,
  `Department_dname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Department_dname`),
  CONSTRAINT `fk_Department_Location_Department1`
    FOREIGN KEY (`Department_dname`)
    REFERENCES `VNC`.`Department` (`dname`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Engineer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Engineer` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Engineer` (
  `essn` VARCHAR(30) NOT NULL,
  `eng_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`essn`),
  CONSTRAINT `fk_Engineer_Staff1`
    FOREIGN KEY (`essn`)
    REFERENCES `VNC`.`Staff` (`Person_ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Device`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Device` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Device` (
  `serial_number` VARCHAR(50) NOT NULL,
  `model` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `cost` FLOAT NOT NULL,
  `date_of_purchase` VARCHAR(50) NOT NULL,
  `essn` VARCHAR(30) NULL,
  PRIMARY KEY (`serial_number`),
  INDEX `fk_Device_Engineer1_idx` (`essn` ASC),
  CONSTRAINT `fk_Device_Engineer1`
    FOREIGN KEY (`essn`)
    REFERENCES `VNC`.`Engineer` (`essn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Use`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Use` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Use` (
  `device_serial_number` VARCHAR(50) NULL,
  `Studio_studio_id` INT NULL,
  PRIMARY KEY (`device_serial_number`),
  INDEX `fk_device_has_studio_device1_idx` (`device_serial_number` ASC),
  INDEX `fk_device_has_studio_Studio1_idx` (`Studio_studio_id` ASC),
  CONSTRAINT `fk_device_has_studio_device1`
    FOREIGN KEY (`device_serial_number`)
    REFERENCES `VNC`.`Device` (`serial_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_device_has_studio_Studio1`
    FOREIGN KEY (`Studio_studio_id`)
    REFERENCES `VNC`.`Studio` (`studio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Person_Phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Person_Phone` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Person_Phone` (
  `Person_ssn` VARCHAR(30) NOT NULL,
  `phone` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`Person_ssn`),
  CONSTRAINT `fk_Person_Phone_Person1`
    FOREIGN KEY (`Person_ssn`)
    REFERENCES `VNC`.`Person` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Manger`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Manger` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Manger` (
  `Person_ssn` VARCHAR(30) NOT NULL,
  `department_dname` VARCHAR(45) NOT NULL,
  `monthly_salary` DECIMAL(10,2) NOT NULL,
  INDEX `fk_manger_department1_idx` (`department_dname` ASC),
  INDEX `fk_Manger_Person1_idx` (`Person_ssn` ASC),
  PRIMARY KEY (`Person_ssn`),
  CONSTRAINT `fk_manger_department1`
    FOREIGN KEY (`department_dname`)
    REFERENCES `VNC`.`Department` (`dname`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manger_Person1`
    FOREIGN KEY (`Person_ssn`)
    REFERENCES `VNC`.`Person` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Guest`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Guest` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Guest` (
  `Person_ssn` VARCHAR(30) NOT NULL,
  `hourly_salary` DECIMAL(10,2) NOT NULL,
  INDEX `fk_Guest_Person1_idx` (`Person_ssn` ASC),
  PRIMARY KEY (`Person_ssn`),
  CONSTRAINT `fk_Guest_Person1`
    FOREIGN KEY (`Person_ssn`)
    REFERENCES `VNC`.`Person` (`ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Presenter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Presenter` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Presenter` (
  `pssn` VARCHAR(30) NOT NULL,
  `program_ID` INT NULL,
  INDEX `fk_presenter_program1_idx` (`program_ID` ASC),
  PRIMARY KEY (`pssn`),
  CONSTRAINT `fk_presenter_program1`
    FOREIGN KEY (`program_ID`)
    REFERENCES `VNC`.`Program` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Presenter_Staff1`
    FOREIGN KEY (`pssn`)
    REFERENCES `VNC`.`Staff` (`Person_ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Sport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Sport` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Sport` (
  `program_ID` INT NOT NULL,
  INDEX `fk_sport_program1_idx` (`program_ID` ASC),
  PRIMARY KEY (`program_ID`),
  CONSTRAINT `fk_sport_program1`
    FOREIGN KEY (`program_ID`)
    REFERENCES `VNC`.`Program` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`News`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`News` ;

CREATE TABLE IF NOT EXISTS `VNC`.`News` (
  `program_ID` INT NOT NULL,
  INDEX `fk_news_program1_idx` (`program_ID` ASC),
  PRIMARY KEY (`program_ID`),
  CONSTRAINT `fk_news_program1`
    FOREIGN KEY (`program_ID`)
    REFERENCES `VNC`.`Program` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Live_match`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Live_match` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Live_match` (
  `date` VARCHAR(45) NOT NULL,
  `start_time` TIME NOT NULL,
  `home_team_name` VARCHAR(45) NOT NULL,
  `away_team_name` VARCHAR(45) NOT NULL,
  `away_team_score` VARCHAR(45) NOT NULL,
  `home_team_score` VARCHAR(45) NOT NULL,
  `sport_program_ID` INT NOT NULL,
  PRIMARY KEY (`sport_program_ID`),
  CONSTRAINT `fk_live_match_sport1`
    FOREIGN KEY (`sport_program_ID`)
    REFERENCES `VNC`.`Sport` (`program_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`Live_news`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`Live_news` ;

CREATE TABLE IF NOT EXISTS `VNC`.`Live_news` (
  `date` VARCHAR(45) NOT NULL,
  `content` VARCHAR(200) NOT NULL,
  `source` VARCHAR(400) NOT NULL,
  `news_program_ID` INT NOT NULL,
  PRIMARY KEY (`news_program_ID`),
  CONSTRAINT `fk_live_news_news1`
    FOREIGN KEY (`news_program_ID`)
    REFERENCES `VNC`.`News` (`program_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `VNC`.`appears_on`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VNC`.`appears_on` ;

CREATE TABLE IF NOT EXISTS `VNC`.`appears_on` (
  `Guest_Person_ssn` VARCHAR(30) NULL,
  `Episode_season_number` INT NULL,
  PRIMARY KEY (`Guest_Person_ssn`, `Episode_season_number`),
  INDEX `fk_Guest_has_Episode_Episode1_idx` (`Episode_season_number` ASC),
  INDEX `fk_Guest_has_Episode_Guest1_idx` (`Guest_Person_ssn` ASC),
  CONSTRAINT `fk_Guest_has_Episode_Guest1`
    FOREIGN KEY (`Guest_Person_ssn`)
    REFERENCES `VNC`.`Guest` (`Person_ssn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Guest_has_Episode_Episode1`
    FOREIGN KEY (`Episode_season_number`)
    REFERENCES `VNC`.`Episode` (`season_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Data for table `VNC`.`Channel`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('540 MHz', 'VNC News', 'Cairo, Egypt', 'news', '3\\4', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('720 MHz', 'VNC Sport', 'Port Said', 'sport', '2\\3', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('100.5 FM', 'VNC music ', 'Sharm El Sheikh', 'music', '5\\6', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('630 MHz', 'Movie Channel', 'Hurghada', 'Movie', '3\\4', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('106.7 FM', 'Jazz FM', 'Hurghada', 'music', '5\\7', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('800 MHz', 'EduVision', 'Hurghada', 'Educational', '5\\6', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('104.2 FM', 'Comedy Radio', 'Hurghada', 'Movie', '3\\4', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('835.6 MHz', 'Sports Network ', 'Giza', 'Sports', '4/5', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('456.8 MHz', 'Cooking Channel ', 'Giza', 'Cooking', '3/4', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('702.3 MHz', 'Comedy Central', 'Giza', 'Comedy', '5/6', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('589.7 MHz', 'Health & Wellness TV', 'Helwan', 'Health', '2/3', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('623.1 MHz', 'History Channel', 'Helwan', 'Histroy', '7/8', 'Circular');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('784.5 MHz', 'Tech News Network', 'Helwan', 'Tech', '4/5', 'Vertical');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('567.8 MHz', 'Fashion TV', 'Cairo', 'Fashion', '3/4', 'Horizontal');
INSERT INTO `VNC`.`Channel` (`freqancy`, `Name`, `location`, `type`, `FEC`, `polarisation`) VALUES ('690.2 MHz', 'Home Improvement TV ', 'Suez', 'Improvemnt', '6/7', 'Vertical');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Ads`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('ABC Electronics', 30, 200);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('XYZ Motors', 15, 150);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Fashion Boutique', 60, 300);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Tech Innovators', 45, 250);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Healthy Living', 20, 180);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Home Decor Co.', 40, 220);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Sports Gear Inc.', 30, 200);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Beauty Trends', 25, 190);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Travel Agency', 35, 210);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Gourmet Delights', 50, 280);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Fitness Essentials', 40, 230);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Pet Care Products', 20, 170);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Global Tech Summit', 60, 350);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Adventure Apparel', 30, 190);
INSERT INTO `VNC`.`Ads` (`sponser_name`, `duration`, `price_per_minute`) VALUES ('Home Improvement Co.', 45, 240);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Program`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (1, 'Morning News', 'News', 'Start your day with breaking news and updates.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (2, 'Sports Talk', 'Talk Show', 'Engaging discussions on the latest sports happenings.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (3, 'Music Mix', 'Music', 'A curated mix of music across various genres.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (4, 'Science Hour', 'Educational', 'Dive deep into the world of science and technology.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (5, 'Movie Night', 'Movies', 'Exclusive movie premieres, reviews, and interviews.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (6, 'Jazz Sessions', 'Music', 'Relaxing jazz tunes for a laid-back musical journey.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (7, 'Comedy Central', 'Comedy', 'Non-stop laughter with stand-up comedy and sketches.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (8, 'Nature Discovery', 'Educational', 'Explore the wonders of nature and environmental science.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (9, 'Top 40 Countdown', 'Music', 'Countdown of the week\'s top charting songs.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (10, 'Evening News', 'News', 'Comprehensive coverage of evening news and events.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (11, 'Tech Insights', 'Technology', 'Stay updated on the latest in the world of technology.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (12, 'Health and Wellness', 'Lifestyle', 'Tips and discussions for a healthy and balanced life.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (13, 'Travel Adventures', 'Lifestyle', 'Explore the world through travel stories and adventures.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (14, 'Historical Chronicles', 'Documentary', 'Journey through historical events and their impact.');
INSERT INTO `VNC`.`Program` (`ID`, `name`, `type`, `description`) VALUES (15, 'Business Insights', 'Business', 'In-depth analysis and insights into the business world.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Show`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (1, 'ABC Electronics', '540 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (2, 'XYZ Motors', '720 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (3, 'Fashion Boutique', '100.5 FM');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (4, 'Tech Innovators', '630 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (5, 'Healthy Living', '106.7 FM');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (6, 'Home Decor Co.', '800 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (7, 'Sports Gear Inc.', '104.2 FM');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (8, 'Beauty Trends', '835.6 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (9, 'Travel Agency', '456.8 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (10, 'Gourmet Delights', '702.3 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (11, 'Fitness Essentials', '589.7 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (12, 'Pet Care Products', '623.1 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (13, 'Global Tech Summit', '784.5 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (14, 'Adventure Apparel', '567.8 MHz');
INSERT INTO `VNC`.`Show` (`program_ID`, `Ads_sponser_name`, `channel_freqancy`) VALUES (15, 'Home Improvement Co.', '690.2 MHz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Studio`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (102, '15th Street, Maadi, Cairo', '540 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (106, 'Zamalek District, Cairo', '720 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (110, 'Nasr City, Cairo', '100.5 FM');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (114, 'Dokki, Giza, Cairo', '630 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (118, 'Heliopolis, Cairo', '106.7 FM');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (122, 'Mohandessin, Giza, Cairo', '800 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (126, 'Maadi, Cairo', '104.2 FM');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (130, 'Garden City, Cairo', '835.6 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (134, 'Zamalek, Cairo', '456.8 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (138, '6th of October City, Cairo', '702.3 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (142, 'New Cairo, Cairo', '589.7 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (146, 'Downtown Cairo, Cairo', '623.1 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (150, 'Sheikh Zayed City, Giza, Cairo', '784.5 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (154, 'Maadi Degla, Cairo', '567.8 MHz');
INSERT INTO `VNC`.`Studio` (`studio_id`, `location`, `channel_freqancy`) VALUES (158, 'Agouza, Giza, Cairo', '690.2 MHz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Department`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('News sports Department', '540 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Marketing dns Department', '720 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Design formal Department', '100.5 FM');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Radio fm Department', '630 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Production ps Department', '106.7 FM');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Content  Department', '800 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('finance department', '104.2 FM');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('IT department', '835.6 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('News Department', '456.8 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Marketing Department', '702.3 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Production Department', '589.7 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Design Department', '623.1 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Radio Department', '784.5 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Content Creation Department', '567.8 MHz');
INSERT INTO `VNC`.`Department` (`dname`, `channel_freqancy`) VALUES ('Sports Department', '690.2 MHz');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Person`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('200', 'Alaa', 'Hassan ', '01/01/2004', 'Male', 'Egypt', '540 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('201', 'Omar ', 'Saeed', '02/02/2004', 'Male', 'Egypt', '720 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('202', 'Mohamed', 'Hesham', '04/08/2004', 'Male', 'Egypt', '100.5 FM');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('203', 'Mohamed ', 'Ashraf', '04/04/2004', 'Male', 'Egypt', '630 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('204', 'Abdelrahman', 'Abdelsatar', '05/05/2004', 'Male', 'Egypt', '106.7 FM');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('205', 'Ahmed', ' Hassan', '15/01/1980', 'Male', 'Egypt', '800 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('206', 'Fatima ', 'Ahmed', '23/05/1995', 'Female', 'Egypt', '104.2 FM');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('207', 'Omar', 'Ali', '11/07/1988', 'Male', 'Egypt', '835.6 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('208', 'Nora ', 'Mustafa', '03/12/1976', 'Female', 'Egypt', '456.8 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('209', 'Ahmed', 'Mahmoud', '20/08/1992', 'Male', 'Egypt', '702.3 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('210', 'Hala', 'Ramadan', '02/05/1985', 'Female', 'Egypt', '589.7 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('211', 'Karim', 'Hussein', '15/12/1978', 'Male', 'Egypt', '623.1 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('212', 'Rania', 'Mohamed', '07/10/1990', 'Female', 'Egypt', '784.5 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('213', 'Mahmoud', 'Abdel', '09/03/1982', 'Male', 'Egypt', '567.8 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('214', 'Aisha', 'Ibrahim', '18/06/1991', 'Female', 'Egypt', '690.2 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('215', 'Tarek ', 'Abdel-Rahim', '29/12/1987', 'Male', 'Egypt', '732.9 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('216', 'Nour ', 'El-Din Said', '04/08/1979', 'Male', 'Egypt', '894.1 MHz');
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('217', 'Mona', 'Kamal', '11/12/1985', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('218', 'Amr', 'Farouk', '24/07/1993', 'Male', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('219', 'Yasmin', 'Hassan', '02/05/1984', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('220', 'Khaled', 'Ibrahim', '19/09/1989', 'Male', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('221', 'Nada', 'Mahmoud', '14/03/1986', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('222', 'Ahmed', 'Kamal', '27/10/1983', 'Male', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('223', 'Hana', 'Adel', '06/09/1992', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('224', 'Youssef', 'Samir', '22/01/1981', 'Male', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('225', 'Salma', 'Farid', '12/03/1988', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('226', 'Ahmed', 'Hossam', '17/05/1990', 'Male', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('227', 'Amira', 'Reda', '28/08/1977', 'Female', 'Egypt', NULL);
INSERT INTO `VNC`.`Person` (`ssn`, `fname`, `lname`, `b_date`, `sex`, `nationality`, `channel_freqancy`) VALUES ('228', 'Adel', 'Mohamed', '09/06/1984', 'Male', 'Egypt', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Staff`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('200', 'News Anchor', 2130, 'News Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('201', 'Social Media Manager', 5140, 'Marketing Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('202', 'Video Editor', 2000, 'Design Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('203', 'Senior Journalist', 3000, 'Radio Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('204', 'Graphic Designer', 2130, 'Production Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('205', 'Radio Show Host', 2000, 'Content Creation Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('206', 'TV Producer', 3571, 'finance department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('207', 'Senior Journalist', 4300, 'News sports Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('208', 'Video Editor', 2300, 'Radio fm Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('209', 'Radio Show Host', 4564, 'IT department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('210', 'Senior Journalist', 3345, 'Production ps Department');
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('211', 'Social Media Manager', 3446, NULL);
INSERT INTO `VNC`.`Staff` (`Person_ssn`, `job_title`, `monthly_salary`, `department_dname`) VALUES ('212', 'Content Writer', 2345, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Director`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Director` (`dssn`) VALUES ('234-56-7890');
INSERT INTO `VNC`.`Director` (`dssn`) VALUES ('567-89-0123');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Season`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (1, '01/01/2022', 1, '234-56-7890');
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (2, '01/04/2022', 2, '567-89-0123');
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (3, '01/07/2022', 3, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (4, '01/10/2022', 4, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (5, '01/01/2023', 5, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (6, '01/04/2023', 6, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (7, '01/07/2023', 7, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (8, '01/10/2023', 8, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (9, '01/01/2023', 9, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (10, '01/04/2023', 10, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (11, '01/07/2023', 11, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (12, '01/10/2023', 12, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (13, '01/01/2024', 13, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (14, '01/04/2024', 14, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (15, '01/07/2024', 15, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (16, '01/10/2024', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (17, '01/01/2025', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (18, '01/04/2025', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (19, '01/07/2025', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (20, '01/10/2025', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (21, '01/01/2026', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (22, '01/04/2026', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (23, '01/07/2026', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (24, '01/10/2026', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (25, '01/01/2027', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (26, '01/04/2027', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (27, '01/07/2027', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (28, '01/10/2027', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (29, '01/01/2028', NULL, NULL);
INSERT INTO `VNC`.`Season` (`number`, `start_date`, `program_ID`, `dssn`) VALUES (30, '01/04/2028', NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Episode`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (1, '\"Pilot\"', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'The first episode introduces the main characters and sets the stage for the series.', 1, '31/03/2022');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (2, '\"The Awakening\"', 'In this episode, the protagonist discovers their hidden powers.', 'As the plot thickens, the characters face new challenges.', 2, '30/06/2022');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (3, '\"Dark Secrets\"', 'Secrets from the past are revealed, leading to unexpected twists.', 'Viewers learn more about the characters\' backgrounds.', 3, '30/09/2022');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (4, '\"New Horizons\"', 'A new chapter begins with new characters and storylines.', 'The second season kicks off with exciting developments.', 4, '31/12/2022');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (5, '\"The Chase\"', 'The characters embark on a thrilling chase to uncover a mystery.', 'Action-packed episode filled with suspense and intrigue.', 5, '31/03/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (6, '\"Forgotten Memories\"', 'The protagonists grapple with forgotten memories that resurface.', 'Emotional and introspective, this episode explores the characters\' pasts.', 6, '30/06/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (7, '\"City of Shadows\"', 'The setting shifts to a mysterious city with its own set of challenges.', 'A visually stunning episode that introduces a new environment.', 7, '30/09/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (8, '\"Alliances\"', 'Characters form alliances as they face a common enemy.', 'Political intrigue and strategic alliances take center stage.', 8, '31/12/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (9, '\"Into the Abyss\"', 'The characters confront a formidable adversary in a dark abyss.', 'Tension rises as the protagonists confront their greatest challenge yet.', 9, '31/03/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (10, '\"New Beginnings\"', 'A fresh start for the characters as they navigate a changed world.', 'The fourth season opens with a sense of renewal and new story arcs.', 10, '30/06/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (11, '\"Shattered Bonds\"', 'Relationships are tested as the characters face personal challenges.', 'Emotionally charged episode with intense character dynamics.', 11, '30/09/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (12, '\"Rising Tensions\"', 'Tensions escalate within the group, leading to confrontations.', 'The plot thickens as conflicts reach a boiling point.', 12, '31/12/2023');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (13, '\"Echoes of the Past\"', 'Characters revisit their past, uncovering forgotten truths.', 'Flashbacks and revelations add depth to the characters\' backstories.', 13, '31/03/2024');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (14, '\"Crossroads\"', 'Characters reach a crossroads, forcing them to make crucial decisions.', 'A pivotal episode that shapes the direction of the narrative.', 14, '30/06/2024');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (15, '\"Eclipsed Destiny\"', 'Destiny takes an unexpected turn, altering the course of events.', 'A plot-twisting episode that keeps viewers on the edge of their seats.', 15, '30/09/2024');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (16, '\"Lost in Time\"', 'A time-traveling adventure unravels mysteries from the past and future.', 'The sixth season kicks off with a mind-bending exploration of time.', 16, '31/12/2024');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (17, '\"Fateful Encounters\"', 'Characters face fateful encounters that shape their destinies.', 'Unexpected meetings and alliances redefine the characters\' paths.', 17, '31/03/2025');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (18, '\"Parallel Realities\"', 'Reality shifts as characters find themselves in parallel worlds.', 'A visually stunning episode that explores alternate realities.', 18, '30/06/2025');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (19, '\"Beyond the Horizon\"', 'Characters embark on a journey beyond known boundaries.', 'Exploration and discovery are at the forefront of this adventurous episode.', 19, '30/09/2025');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (20, '\"Whispers in the Wind\"', 'Mysterious whispers lead the characters to a hidden truth.', 'Atmospheric episode with an air of mystery and suspense.', 20, '31/12/2025');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (21, '\"Convergence\"', 'Multiple storylines converge in a climactic and action-packed episode.', 'The narrative reaches a pivotal moment with converging plotlines.', 21, '31/03/2026');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (22, '\"Awakening Powers\"', 'New powers and abilities awaken within the characters.', 'Action-packed episode as characters discover and harness new abilities.', 22, '30/06/2026');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (23, '\"Veil of Shadows\"', 'A mysterious veil shrouds the characters, leading to unexpected challenges.', 'Dark and suspenseful episode that adds an element of mystery.', 23, '30/09/2026');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (24, '\"Reckoning\"', 'The characters face the consequences of their past actions.', 'Intense and emotionally charged episode with reckoning and redemption.', 24, '31/12/2026');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (25, '\"City of Lights\"', 'The setting shifts to a vibrant city with its own unique challenges.', 'A visually captivating episode that introduces a new urban landscape.', 25, '31/03/2027');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (26, '\"Threads of Destiny\"', 'Threads of destiny interweave as characters\' fates become entangled.', 'Complex and intertwined storylines shape the characters\' destinies.', 26, '30/06/2027');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (27, '\"Abyssal Depths\"', 'Characters plunge into abyssal depths, confronting hidden truths.', 'A suspenseful and atmospheric episode with revelations from the depths.', 27, '30/09/2027');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (28, '\"Eternal Beginnings\"', 'The tenth season commences with eternal themes and new story arcs.', 'A fresh start and new beginnings mark the opening of the tenth season.', 28, '31/12/2027');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (29, '\"Shifting Sands\"', 'Sands of time shift as characters navigate through temporal challenges.', 'Time-traveling elements add complexity to the plot in this engaging episode.', 29, '31/03/2028');
INSERT INTO `VNC`.`Episode` (`enumber`, `title`, `content`, `description`, `season_number`, `end_date`) VALUES (30, '\"Harmony Restored\"', 'The quest for harmony and balance becomes the central theme.', 'The season reaches a harmonious conclusion with resolutions and revelations.', 30, '30/06/2028');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Department_Location`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('First floor, apartment 3 ', 'News Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('First floor, apartment 4 ', 'Marketing Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('Fourth floor, apartment 1', 'Design Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('First floor, apartment 6', 'Radio Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('Fourth floor, apartment 3', 'Production Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('Second  floor, apartment 8', 'Content Creation Department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('First floor, apartment 9', 'finance department');
INSERT INTO `VNC`.`Department_Location` (`location`, `Department_dname`) VALUES ('Fifth floor, apartments 5 and 3', 'IT department');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Engineer`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Engineer` (`essn`, `eng_type`) VALUES ('200', 'Broadcast Engineer\n');
INSERT INTO `VNC`.`Engineer` (`essn`, `eng_type`) VALUES ('201', 'Audio Engineer\n');
INSERT INTO `VNC`.`Engineer` (`essn`, `eng_type`) VALUES ('202', 'Video Engineer');
INSERT INTO `VNC`.`Engineer` (`essn`, `eng_type`) VALUES ('203', 'Transmission Engineer\n');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Device`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('300', 'X-1000', 'Camera', 5000, '15/03/2022', '200');
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('301', 'X-200', 'Microphone Pro', 800, '20/05/2022', '201');
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('302', 'V-500', 'Video Mixer', 10000, '10/02/2022', '202');
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('303', 'L-700', 'Lighting Kit', 7500, '08/04/2022', '203');
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('304', 'A-300', 'Audio Interface', 1200, '25/01/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('305', 'T-800', 'Teleprompter', 3500, '05/06/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('306', 'E-1', 'Editing Software', 2000, '12/07/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('307', 'T-200', 'Tripod', 500, '03/09/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('308', 'G-400', 'Green Screen', 1800, '18/08/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('309', 'S-600', 'Streaming Encoder', 4200, '30/11/2022', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('310', 'D-1200', 'Drone', 6000, '15/01/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('311', 'VR-1', 'Virtual Reality Headset', 2500, '20/02/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('312', 'S-800', 'Satellite Uplink', 12000, '10/03/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('313', 'M-300', 'Studio Monitor', 1000, '05/04/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('314', 'C-700', '360-Degree Camera', 3800, '12/05/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('315', 'G-200', 'Graphics Tablet', 900, '18/06/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('316', 'W-100', 'Wireless Microphone', 1300, '25/07/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('317', 'R-500', 'Robotic Camera', 8500, '30/08/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('318', 'A-400', 'Audio Mixer', 2300, '15/09/2023', NULL);
INSERT INTO `VNC`.`Device` (`serial_number`, `model`, `type`, `cost`, `date_of_purchase`, `essn`) VALUES ('319', 'L-800', 'LED Video Wall', 15000, '20/10/2023', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Use`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('300', 102);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('301', 106);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('302', 110);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('303', 114);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('304', 118);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('305', 122);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('306', 126);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('307', 130);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('308', 134);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('309', 142);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('310', 146);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('311', 150);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('312', 154);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('313', 158);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('314', NULL);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('315', NULL);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('316', NULL);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('317', NULL);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('318', NULL);
INSERT INTO `VNC`.`Use` (`device_serial_number`, `Studio_studio_id`) VALUES ('319', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Person_Phone`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('200', '0107-346-342');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('201', '0158-241-754');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('202', '0116-414-786');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('203', '0121-614-746');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('204', '0100-134-146');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('205', '0100-123-456');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('206', '0111-234-567');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('207', '0122-345-678');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('208', '0102-456-789');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('209', '0112-567-890');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('210', '0123-678-901');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('211', '0103-789-012');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('212', '0113-890-123');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('213', '0104-567-890');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('214', '0114-678-901');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('215', '0124-789-012');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('216', '0105-890-123');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('217', '0115-901-234');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('218', '0125-012-345');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('219', '0106-123-456');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('220', '0116-234-567');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('221', '0107-345-678');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('222', '0117-456-789');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('223', '0127-567-890');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('224', '0108-678-901');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('225', '0118-789-012');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('226', '0128-901-234');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('227', '0109-012-345');
INSERT INTO `VNC`.`Person_Phone` (`Person_ssn`, `phone`) VALUES ('228', '0119-123-45');

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Manger`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('213', 'News Department', 7000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('214', 'Marketing Department', 20000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('215', 'Design Department', 70000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('216', 'Radio Department', 66000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('217', 'Production Department', 23000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('218', 'Content Creation Department', 17000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('219', 'finance department', 8000);
INSERT INTO `VNC`.`Manger` (`Person_ssn`, `department_dname`, `monthly_salary`) VALUES ('220', 'IT department', 9900);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Guest`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Guest` (`Person_ssn`, `hourly_salary`) VALUES ('221', 670);
INSERT INTO `VNC`.`Guest` (`Person_ssn`, `hourly_salary`) VALUES ('222', 500);
INSERT INTO `VNC`.`Guest` (`Person_ssn`, `hourly_salary`) VALUES ('223', 450);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Presenter`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Presenter` (`pssn`, `program_ID`) VALUES ('234-56-7890', 1);
INSERT INTO `VNC`.`Presenter` (`pssn`, `program_ID`) VALUES ('567-89-0123', 2);
INSERT INTO `VNC`.`Presenter` (`pssn`, `program_ID`) VALUES ('890-12-3456', 3);
INSERT INTO `VNC`.`Presenter` (`pssn`, `program_ID`) VALUES ('345-67-8901', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Sport`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Sport` (`program_ID`) VALUES (1);
INSERT INTO `VNC`.`Sport` (`program_ID`) VALUES (2);
INSERT INTO `VNC`.`Sport` (`program_ID`) VALUES (3);
INSERT INTO `VNC`.`Sport` (`program_ID`) VALUES (4);
INSERT INTO `VNC`.`Sport` (`program_ID`) VALUES (5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`News`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`News` (`program_ID`) VALUES (6);
INSERT INTO `VNC`.`News` (`program_ID`) VALUES (7);
INSERT INTO `VNC`.`News` (`program_ID`) VALUES (8);
INSERT INTO `VNC`.`News` (`program_ID`) VALUES (9);
INSERT INTO `VNC`.`News` (`program_ID`) VALUES (10);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Live_match`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('15/12/2022', '06:00:00', 'Team A', 'Team B', '1', '2', 1);
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('20/11/2022', '03:30:00', 'Team C', 'Team D', '3', '0', 2);
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('05/01/2022', '08:15:00', 'Team E', 'Team F', '2', '1', 3);
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('10/02/2022', '07:45:00', 'Team G', 'Team H', '3', '2', 4);
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('18/03/2022', '02:00:00', 'Team I', 'Team J', '1', '3', 5);
INSERT INTO `VNC`.`Live_match` (`date`, `start_time`, `home_team_name`, `away_team_name`, `away_team_score`, `home_team_score`, `sport_program_ID`) VALUES ('25/05/2022', '05:30:00', 'Team K', 'Team L', '1', '1', 6);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`Live_news`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`Live_news` (`date`, `content`, `source`, `news_program_ID`) VALUES ('15/12/2022', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vel justo nec est fermentum consectetur.', 'News Network A', 6);
INSERT INTO `VNC`.`Live_news` (`date`, `content`, `source`, `news_program_ID`) VALUES ('20/11/2022', 'Sed cursus ante dapibus diam. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Integer nec odio. Praesent libero.', 'Breaking News B', 7);
INSERT INTO `VNC`.`Live_news` (`date`, `content`, `source`, `news_program_ID`) VALUES ('05/01/2023', 'Nullam id dolor id nibh ultricies vehicula ut id elit. Donec ullamcorper nulla non metus auctor fringilla.', 'News Source C', 8);
INSERT INTO `VNC`.`Live_news` (`date`, `content`, `source`, `news_program_ID`) VALUES ('10/02/2023', 'Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.', 'Global News D', 9);
INSERT INTO `VNC`.`Live_news` (`date`, `content`, `source`, `news_program_ID`) VALUES ('18/03/2023', 'Curabitur blandit tempus porttitor. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Nullam quis risus eget urna mollis ornare.', 'Latest Updates E', 10);

COMMIT;


-- -----------------------------------------------------
-- Data for table `VNC`.`appears_on`
-- -----------------------------------------------------
START TRANSACTION;
USE `VNC`;
INSERT INTO `VNC`.`appears_on` (`Guest_Person_ssn`, `Episode_season_number`) VALUES ('789-01-2345', 1);
INSERT INTO `VNC`.`appears_on` (`Guest_Person_ssn`, `Episode_season_number`) VALUES ('234-56-7890', 2);
INSERT INTO `VNC`.`appears_on` (`Guest_Person_ssn`, `Episode_season_number`) VALUES ('567-89-0123', 3);

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

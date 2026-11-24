CREATE DATABASE IF NOT EXISTS dtp_db;
USE dtp_db;

CREATE TABLE dtp (
    dtp_code VARCHAR(20) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    location VARCHAR(255) NOT NULL,
    dtp_datetime DATETIME NOT NULL,
    injured_count INT DEFAULT 0 CHECK (injured_count >= 0),
    dead_count INT DEFAULT 0 CHECK (dead_count >= 0),
    road_condition VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'зарегистрировано'
);

CREATE TABLE drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE NOT NULL,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    experience INT DEFAULT 0 CHECK (experience >= 0),
    address VARCHAR(255),
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE vehicles (
    vin VARCHAR(17) PRIMARY KEY,
    plate_number VARCHAR(10) NOT NULL UNIQUE,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    v_type VARCHAR(30) NOT NULL,
    `year` INT CHECK (`year` >= 1900),
    v_state VARCHAR(30) NOT NULL DEFAULT 'зарегистрировано'
);

CREATE TABLE inspectors (
    inspector_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    `position` VARCHAR(50) NOT NULL
);

CREATE TABLE investigators (
    investigator_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    specialization VARCHAR(100)
);

CREATE TABLE experts (
    expert_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    specialization VARCHAR(100),
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE knowledge_areas (
    article_code VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE protocols (
    protocol_id INT PRIMARY KEY AUTO_INCREMENT,
    dtp_code VARCHAR(20) NOT NULL,
    inspector_id INT NOT NULL,
    protocol_datetime DATETIME NOT NULL,
    damage_desc TEXT,
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (inspector_id) REFERENCES inspectors(inspector_id) ON DELETE RESTRICT
);

CREATE TABLE resolutions (
    resolution_id INT PRIMARY KEY AUTO_INCREMENT,
    dtp_code VARCHAR(20) NOT NULL,
    issue_date DATE NOT NULL,
    article_code VARCHAR(50) NOT NULL,
    penalty VARCHAR(50) NOT NULL,
    guilty_driver_id INT NOT NULL,
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (guilty_driver_id) REFERENCES drivers(driver_id) ON DELETE RESTRICT
);

CREATE TABLE cases (
    case_id INT PRIMARY KEY AUTO_INCREMENT,
    dtp_code VARCHAR(20) NOT NULL,
    investigator_id INT NOT NULL,
    issue_date DATE NOT NULL,
    deadline DATE,
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (investigator_id) REFERENCES investigators(investigator_id) ON DELETE RESTRICT
);

CREATE TABLE write_off_acts (
    act_id INT PRIMARY KEY AUTO_INCREMENT,
    dtp_code VARCHAR(20) NOT NULL,
    act_date DATE NOT NULL,
    reason VARCHAR(255),
    admin_signature VARCHAR(100),
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE
);

CREATE TABLE participation_drivers (
    dtp_code VARCHAR(20) NOT NULL,
    driver_id INT NOT NULL,
    role VARCHAR(30) NOT NULL,
    guilt_degree INT CHECK (guilt_degree >= 0 AND guilt_degree <= 100),
    PRIMARY KEY (dtp_code, driver_id),
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

CREATE TABLE participation_vehicles (
    dtp_code VARCHAR(20) NOT NULL,
    vin VARCHAR(17) NOT NULL,
    role VARCHAR(30),
    damage_desc TEXT,
    PRIMARY KEY (dtp_code, vin),
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (vin) REFERENCES vehicles(vin) ON DELETE CASCADE
);

CREATE TABLE dtp_knowledge_areas (
    dtp_code VARCHAR(20) NOT NULL,
    article_code VARCHAR(50) NOT NULL,
    PRIMARY KEY (dtp_code, article_code),
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (article_code) REFERENCES knowledge_areas(article_code) ON DELETE CASCADE
);

CREATE TABLE expert_examinations (
    dtp_code VARCHAR(20) NOT NULL,
    expert_id INT NOT NULL,
    appoint_date DATE NOT NULL,
    result TEXT,
    PRIMARY KEY (dtp_code, expert_id),
    FOREIGN KEY (dtp_code) REFERENCES dtp(dtp_code) ON DELETE CASCADE,
    FOREIGN KEY (expert_id) REFERENCES experts(expert_id) ON DELETE CASCADE
);
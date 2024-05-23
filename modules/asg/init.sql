-- init.sql
CREATE DATABASE IF NOT EXISTS ticket;

USE ticket;

CREATE TABLE IF NOT EXISTS users (
    us_id VARCHAR(30) PRIMARY KEY,
    us_pw VARCHAR(30),
    us_name VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS events (
    et_id VARCHAR(30) PRIMARY KEY,
    et_name VARCHAR(30),
    et_stime DATETIME,
    et_etime DATETIME
);

CREATE TABLE IF NOT EXISTS tickets (
    tk_id VARCHAR(30) PRIMARY KEY,
    et_id VARCHAR(30),
    us_id VARCHAR(30),
    FOREIGN KEY (et_id) REFERENCES events(et_id),
    FOREIGN KEY (us_id) REFERENCES users(us_id)
);

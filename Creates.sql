DROP DATABASE IF EXISTS travel_agency;
CREATE DATABASE IF NOT EXISTS travel_agency;
USE travel_agency;

CREATE TABLE IF NOT EXISTS branch(
br_code INT(11) DEFAULT '0' ,
br_street VARCHAR(30) DEFAULT 'unkown',
br_num INT(4) NOT NULL,
br_city VARCHAR(30) NOT NULL,
PRIMARY KEY (br_code)
);

CREATE TABLE IF NOT EXISTS worker(
wrk_AT CHAR(10) NOT NULL,
wrk_name VARCHAR(20) DEFAULT 'uknown',
wrk_lname VARCHAR(20) DEFAULT 'uknown',
wrk_salary FLOAT(7,2) NOT NULL ,
wrk_br_code INT(11) NOT NULL ,
PRIMARY KEY(wrk_AT),
CONSTRAINT worker_br_code FOREIGN KEY(wrk_br_code) REFERENCES branch(br_code)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS admin(
adm_AT CHAR(10) NOT NULL,
adm_type ENUM ('LOGISTICS' , 'ADMINISTRATIVE' , 'ACCOUNTING') ,
adm_diploma VARCHAR(200) DEFAULT 'Uknown',
PRIMARY KEY(adm_AT),
CONSTRAINT adminAT FOREIGN KEY (adm_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS driver(
drv_at CHAR(10) NOT NULL,
drv_license ENUM ('A' , 'B' , 'C' , 'D'),
drv_route ENUM ('LOCAL' , 'ABROAD'),
drv_experience TINYINT(4) DEFAULT '0',
PRIMARY KEY(drv_AT),
CONSTRAINT driver_AT FOREIGN KEY(drv_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS guide(
gui_AT CHAR(10) NOT NULL,
gui_cv TEXT NOT NULL,
PRIMARY KEY(gui_AT),
CONSTRAINT guide_AT FOREIGN KEY(gui_AT) REFERENCES worker(wrk_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS languages(
lng_gui_AT CHAR(10) NOT NULL,
lng_language VARCHAR(30) DEFAULT 'Uknown',
PRIMARY KEY(lng_gui_AT),
CONSTRAINT lng_guide_AT FOREIGN KEY(lng_gui_AT) REFERENCES guide(gui_AT)
ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE if NOT EXISTS manages(
mng_adm_AT CHAR(10) NOT NULL, 
mng_br_code INT(11) NOT NULL,
PRIMARY KEY(mng_adm_AT,mng_br_code),
CONSTRAINT admin_AT FOREIGN KEY(mng_adm_AT) REFERENCES admin(adm_AT)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT branch_code FOREIGN KEY(mng_br_code) REFERENCES branch(br_code)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS phones(
ph_br_code INT(11) NOT NULL,
ph_number CHAR(10) NOT NULL,
CONSTRAINT phocode FOREIGN KEY (ph_br_code) REFERENCES branch(br_code)
ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS trip(
tr_id INT(11) AUTO_INCREMENT,
tr_departure DATETIME NOT NULL,
tr_return DATETIME NOT NULL,
tr_maxseats TINYINT(4) NOT NULL,
tr_cost FLOAT(7,2) NOT NULL,
tr_br_code INT(11) NOT NULL,
tr_gui_AT CHAR(10) NOT NULL,
tr_drv_AT CHAR(10) NOT NULL,
PRIMARY KEY (tr_id),
CONSTRAINT brcodeoftrip FOREIGN KEY (tr_br_code) REFERENCES branch(br_code)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT atofguide FOREIGN KEY (tr_gui_AT) REFERENCES guide(gui_AT)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT atofdriver FOREIGN KEY (tr_drv_AT) REFERENCES driver(drv_AT)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS event(
ev_tr_id INT(11) ,
ev_start DATETIME NOT NULL,
ev_end DATETIME NOT NULL,
ev_descr TEXT NOT NULL,
CONSTRAINT idoftrip FOREIGN KEY (ev_tr_id) REFERENCES trip(tr_id)
ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS destination(
dst_id INT(11) AUTO_INCREMENT,
dst_name VARCHAR(50) DEFAULT 'Uknown',
dst_descr TEXT NOT NULL,
dst_rtype ENUM('LOCAL','ABROAD'),
dst_language VARCHAR(30) DEFAULT 'Uknown',
dst_location INT(11) ,
PRIMARY KEY(dst_id),
CONSTRAINT destination_id FOREIGN KEY(dst_location) REFERENCES destination(dst_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS travel_to(
to_tr_id INT(11) AUTO_INCREMENT,
to_dst_id INT(11),
to_arrival DATETIME NOT NULL,
to_departure DATETIME NOT NULL,
PRIMARY KEY(to_tr_id,to_dst_id),
CONSTRAINT to_trip_id FOREIGN KEY(to_tr_id) REFERENCES trip(tr_id)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT to_destination_id FOREIGN KEY(to_dst_id) REFERENCES destination(dst_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reservation(
res_tr_id INT(11) AUTO_INCREMENT,
res_seatnum TINYINT(4) NOT NULL ,
res_name VARCHAR(20) DEFAULT 'Uknown',
res_lname VARCHAR(20) DEFAULT 'Uknown',
res_isadult ENUM('ADULT','MINOR'),
PRIMARY KEY(res_tr_id,res_seatnum),
CONSTRAINT res_trip_id FOREIGN KEY(res_tr_id) REFERENCES trip(tr_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IT(
it_AT CHAR(10) NOT NULL,
password VARCHAR(20) DEFAULT 'password',
start_date DATETIME NOT NULL,
end_date DATETIME NOT NULL,
PRIMARY KEY(it_at),
CONSTRAINT it_wrk_at FOREIGN KEY(it_AT) REFERENCES worker(wrk_AT)
ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS log (
action VARCHAR(20) NOT NULL,
user VARCHAR(20) NOT NULL,
time TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS offers (
    promo_code INT(11) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    cost_per_person FLOAT NOT NULL,
    destination_id INT NOT NULL,
    PRIMARY KEY (promo_code),
    FOREIGN KEY (destination_id) REFERENCES destination(dst_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reservation_offers (
    booking_code INT AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    promo_code INT(11) NOT NULL,
    down_payment FLOAT NOT NULL,
    PRIMARY KEY (booking_code),
    FOREIGN KEY (promo_code) REFERENCES offers(promo_code)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS temp_table(		#Dhlwsh voithitikou pinaka temp_table me skopo tin proswrinh apothikeysh twn onomatwn toy file prin thn eisagwgh ston reservation_offers
	first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL
);
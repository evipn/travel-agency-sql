DROP PROCEDURE IF EXISTS new_drv;  			
DELIMITER $
CREATE PROCEDURE new_drv (IN drv_at CHAR(10), IN drv_name VARCHAR(20), IN drv_lname VARCHAR(20),								# Procedure eisagwghs neou odhgou sto branch me tous ligoterous odhgous (3.1.3.1)
                           IN drv_salary FLOAT(7,2), IN drv_license ENUM('A' , 'B' , 'C' , 'D'),
                           IN drv_route ENUM('LOCAL' , 'ABROAD' ), IN drv_experience TINYINT(4))
BEGIN
  DECLARE br_code INT DEFAULT 1;
  DECLARE driver_count INT;

  SELECT COUNT(drv_at) INTO driver_count
  FROM worker INNER JOIN driver ON worker.wrk_at = driver.drv_at
  WHERE worker.wrk_br_code = 1;

  IF (SELECT COUNT(drv_at)
      FROM worker INNER JOIN driver ON worker.wrk_at = driver.drv_at
      WHERE worker.wrk_br_code = 2) < driver_count THEN
    SET driver_count = (SELECT COUNT(drv_at)
                        FROM worker INNER JOIN driver ON worker.wrk_at = driver.drv_at
                        WHERE worker.wrk_br_code = 2);
    SET br_code = 2;
  END IF;

  IF (SELECT COUNT(drv_at)
      FROM worker INNER JOIN driver ON worker.wrk_at = driver.drv_at
      WHERE worker.wrk_br_code = 3) < driver_count THEN
    SET br_code = 3;
  END IF;

  INSERT INTO worker (wrk_at, wrk_name, wrk_lname, wrk_salary, wrk_br_code)
  VALUES (drv_at, drv_name, drv_lname, drv_salary, br_code);
  
  INSERT INTO driver (drv_at, drv_license, drv_route, drv_experience)
  VALUES (drv_at, drv_license, drv_route, drv_experience);
  
END$
DELIMITER ;

DROP PROCEDURE IF EXISTS trip_info;
DELIMITER $
CREATE PROCEDURE trip_info (IN br_code INT(11), IN first_date DATETIME, IN second_date DATETIME)   						# Procedure pou dinei tis plhrofories tou taksidiou ,an h hmeromhnia anaxwrhshs tou taksidiou emperiexetai sto diasthma pou dinw (3.1.3.2)
BEGIN
  SELECT trip.tr_cost, trip.tr_maxseats, worker1.wrk_name as driver_name, worker1.wrk_lname as driver_lname,
         worker2.wrk_name as guider_name, worker2.wrk_lname as guider_lname, trip.tr_departure, trip.tr_return
  FROM trip
  INNER JOIN worker AS worker1 ON trip.tr_drv_AT = worker1.wrk_AT
  INNER JOIN worker AS worker2 ON trip.tr_gui_AT = worker2.wrk_AT
  WHERE trip.tr_br_code = br_code AND trip.tr_departure BETWEEN first_date AND second_date;
END$
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_admin;
DELIMITER $
CREATE PROCEDURE delete_admin(IN first_name VARCHAR(20), IN last_name VARCHAR(20)) 					# Procedure pou diagrafei enan admin ,efoson den einai manager tou upokatasthmatos (3.1.3.3)
BEGIN
DECLARE admin_AT CHAR(10);
DECLARE manager_br INT(11);

SELECT wrk_AT INTO admin_AT
FROM worker
WHERE wrk_name = first_name AND wrk_lname = last_name AND wrk_AT IN (SELECT adm_AT FROM admin);

SELECT mng_br_code INTO manager_br
FROM manages
WHERE mng_adm_AT = admin_AT;

IF manager_br IS NOT NULL THEN
  SELECT 'The admin is a branch manager and cannot be deleted';
ELSE
  DELETE FROM admin WHERE adm_AT = admin_AT;
  DELETE FROM worker WHERE wrk_AT = admin_AT;
END IF;
END$
DELIMITER ;

DROP PROCEDURE IF EXISTS loading_data;	
DELIMITER $
CREATE PROCEDURE loading_data()														#Dhmiourgia stored procedure me skopo to load tou reservation_offers mesw toy temp_table
BEGIN

	DECLARE  num_loops INT;
    DECLARE promo_code TINYINT;
    DECLARE promo_check INT;
    DECLARE down_payment INT;
    DECLARE counter INT;
     
    SET num_loops = 0;
    SET counter = 0;
    SET promo_code = 5;
    
  WHILE num_loops < 6 DO
  
	INSERT INTO reservation_offers ( first_name, last_name, promo_code, down_payment)
	SELECT first_name, last_name, promo_code, FLOOR(50 + (RAND() * 150))
	FROM temp_table;
    
	SET num_loops = num_loops + 1;
    SET counter = counter  + 1;

    IF counter MOD 2 = 0 THEN
      SET promo_code = promo_code + 5;
    END IF;
  END WHILE;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS customers_by_down_payment_idx;
CREATE INDEX idx_down_payment ON reservation_offers (down_payment);
DELIMITER $
CREATE PROCEDURE customers_by_down_payment_idx(IN price1 FLOAT, IN price2 FLOAT)	#Stored procedure me th xrhsh index
BEGIN
    
    SELECT reservation_offers.first_name, reservation_offers.last_name,reservation_offers.down_payment
    FROM reservation_offers
    WHERE  reservation_offers.down_payment BETWEEN price1 AND price2;
	
END $;
DELIMITER ;									

DROP PROCEDURE IF EXISTS customers_by_last_name_idx;
CREATE INDEX idx_last_name ON reservation_offers (last_name);
DELIMITER $
CREATE PROCEDURE customers_by_last_name_idx(IN lname VARCHAR(20))				
BEGIN
	
	SELECT reservation_offers.last_name, reservation_offers.first_name, reservation_offers.promo_code, count(*) 
    FROM reservation_offers
    WHERE last_name LIKE 'lname'
    GROUP BY reservation_offers.last_name, reservation_offers.first_name, reservation_offers.promo_code;

END $
DELIMITER ;											

CALL loading_data();																	#Call procedure wste na perastoun ta records ston pinaka reservation_offers
CALL new_drv('AM00000061', 'Vasilikos', 'Nikolaou', 20000.0, 'B', 'ABROAD', 65);
CALL trip_info( 2 , '2023-01-12' , '2023-02-21' );
CALL delete_admin('Xristina' , 'Vasileiou');
CALL customers_by_down_payment_idx(150, 200);											#Call procedure me th xrhsh index
CALL customers_by_last_name_idx('Moyer');
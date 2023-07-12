DROP TRIGGER IF EXISTS log_trip_insert;
DELIMITER $
CREATE TRIGGER log_trip_insert AFTER INSERT ON trip
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('INSERT', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_trip_update;
DELIMITER $
CREATE TRIGGER log_trip_update AFTER UPDATE ON trip
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('UPDATE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_trip_delete;
DELIMITER $
CREATE TRIGGER log_trip_delete AFTER DELETE ON trip
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, times)
    VALUES ('DELETE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_reservation_insert;
DELIMITER $
CREATE TRIGGER log_reservation_insert AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
  DECLARE user VARCHAR(20);
  SET user = USER();
  INSERT INTO log (action, user, time)
  VALUES ('INSERT', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_reservation_update;
DELIMITER $
CREATE TRIGGER log_reservation_update AFTER UPDATE ON reservation
FOR EACH ROW
BEGIN
  DECLARE user VARCHAR(20);
  SET user = USER();
  INSERT INTO log (action, user, time)
  VALUES ('UPDATE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_reservation_delete;
DELIMITER $
CREATE TRIGGER log_reservation_delete AFTER DELETE ON reservation
FOR EACH ROW
BEGIN
  DECLARE user VARCHAR(20);
  SET user = USER();
  INSERT INTO log (action, user, time)
  VALUES ('DELETE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_event_insert;
DELIMITER $
CREATE TRIGGER log_event_insert AFTER INSERT ON event
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('INSERT', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_event_update;
DELIMITER $
CREATE TRIGGER log_event_update AFTER UPDATE ON event
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('UPDATE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_event_delete;
DELIMITER $
CREATE TRIGGER log_event_delete AFTER DELETE ON event
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('DELETE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_travel_to_insert;
DELIMITER $
CREATE TRIGGER log_travel_to_insert AFTER INSERT ON travel_to
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('INSERT', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_travel_to_update;
DELIMITER $
CREATE TRIGGER log_travel_to_update AFTER UPDATE ON travel_to
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('UPDATE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_travel_to_delete;
DELIMITER $
CREATE TRIGGER log_travel_to_delete AFTER DELETE ON travel_to
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('DELETE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_destination_insert;
DELIMITER $
CREATE TRIGGER log_destination_insert AFTER INSERT ON destination
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('INSERT', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_destination_update;
DELIMITER $
CREATE TRIGGER log_destination_update AFTER UPDATE ON destination
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('UPDATE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS log_destination_delete;
DELIMITER $
CREATE TRIGGER log_destination_delete AFTER DELETE ON destination
FOR EACH ROW
BEGIN
    DECLARE user VARCHAR(20);
    SET user = USER();
    INSERT INTO log (action, user, time)
    VALUES ('DELETE', user, NOW());
END$
DELIMITER ;

DROP TRIGGER IF EXISTS prevent_change_on_reserved_trip;
DELIMITER $
CREATE TRIGGER prevent_change_on_reserved_trip 
BEFORE UPDATE ON trip 
FOR EACH ROW 
BEGIN 
IF (NEW.tr_id IN (SELECT res_tr_id FROM reservation)) THEN 
    SET NEW.tr_departure = OLD.tr_departure;
    SET NEW.tr_return = OLD.tr_return;
    SET NEW.tr_cost = OLD.tr_cost;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sorry, this trip has already reservations so you can edit its particulars.';
END IF;
END$
DELIMITER ;

DROP TRIGGER IF EXISTS prevent_salary_reduce;
DELIMITER $
CREATE TRIGGER prevent_salary_reduce 
BEFORE UPDATE ON worker
FOR EACH ROW
BEGIN
IF (NEW.wrk_salary < OLD.wrk_salary) THEN
    SET NEW.wrk_salary = OLD.wrk_salary;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You are not able to reduce salary of an employee.';
END IF;
END$
DELIMITER ;
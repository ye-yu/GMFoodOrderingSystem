CREATE PROCEDURE set_default_tax (IN gtax TINYINT, IN atax TINYINT)
BEGIN
	ALTER TABLE receipt ALTER governmenttax SET DEFAULT gtax;
	ALTER TABLE receipt ALTER additional SET DEFAULT atax;
END//
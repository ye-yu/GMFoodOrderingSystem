CREATE PROCEDURE generate_id(IN tablename VARCHAR(8), OUT id CHAR(10), OUT isunique BOOLEAN)
BEGIN
    SELECT TRUE INTO isunique;
    SELECT CONCAT(
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(UNIX_TIMESTAMP(CURRENT_TIMESTAMP()))*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),
        substring('ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789', rand(@seed)*62+1, 1)
        ) INTO id;
    IF (tablename = 'customer' AND (SELECT customerid FROM `foodorder`.`customer` WHERE customerid = id) IS NOT NULL) THEN
        SELECT FALSE INTO isunique;
    ELSE
        IF (tablename = 'ordering' AND (SELECT orderid FROM `foodorder`.`ordering` WHERE orderid = id) IS NOT NULL) THEN
            SELECT FALSE INTO isunique;			
        ELSE
            IF (tablename = 'food' AND (SELECT foodid FROM `foodorder`.`food` WHERE foodid = id) IS NOT NULL) THEN
                SELECT FALSE INTO isunique;							
            END IF;
        END IF;
    END IF;
END//

/*
method to call procedures 

CALL generateID('food', @id, @isunique)//
SELECT @id, @isunique//
DROP PROCEDURE generateID//
*/
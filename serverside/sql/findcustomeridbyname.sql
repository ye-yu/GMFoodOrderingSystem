CREATE FUNCTION find_cust_id(name VARCHAR(100), phone_no VARCHAR(15)) RETURNS CHAR(10)
BEGIN
    DECLARE id CHAR(10);
    SELECT customerid INTO id FROM `foodorder`.`customer` WHERE customername = name and customerphoneno = phone_no;
    IF id IS NOT NULL THEN
        RETURN id;
    ELSE
        CALL generate_id('customer', @gid, @isunique);
        SELECT @gid INTO id;
        RETURN id;
    END IF;
END//

/*
DROP FUNCTION find_cust_id
*/
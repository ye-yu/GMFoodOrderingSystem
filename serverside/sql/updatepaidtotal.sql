CREATE OR REPLACE PROCEDURE record_order_as_paid(IN oid CHAR(10))
BEGIN
    INSERT INTO receipt
VALUES(
    oid,
    NULL,
    oid,
    DEFAULT,
    DEFAULT,
    DEFAULT
);
UPDATE
    receipt
SET
    paidTotal =(
    SELECT
        ordertotal
    FROM
        ordering
    WHERE
        orderid = oid
) *(
    100 + governmenttax + additional
) / 100
WHERE
    orderid = oid;
END //

/*CREATE OR REPLACE TRIGGER update_paid AFTER INSERT
ON
    receipt FOR EACH ROW
BEGIN
END //
*/
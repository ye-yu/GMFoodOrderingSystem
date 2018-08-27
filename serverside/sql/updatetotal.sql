CREATE OR REPLACE TRIGGER update_ordering_I AFTER INSERT
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = NEW.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = NEW.orderid;
END //
CREATE OR REPLACE TRIGGER update_ordering_U AFTER UPDATE
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = NEW.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = NEW.orderid;
END //

CREATE OR REPLACE TRIGGER update_ordering_D AFTER DELETE
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = OLD.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = OLD.orderid;
END //
/*

CREATE OR REPLACE TRIGGER update_ordering_I AFTER INSERT
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = NEW.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = NEW.orderid;
	IF (NEW.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = NEW.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = NEW.orderid;
	END IF;
	
END //
CREATE OR REPLACE TRIGGER update_ordering_U AFTER UPDATE
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = NEW.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = NEW.orderid;
	IF (NEW.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = NEW.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = NEW.orderid;
	END IF;

END //

CREATE OR REPLACE TRIGGER update_ordering_D AFTER DELETE
ON
    orderlist FOR EACH ROW
BEGIN
    UPDATE
        ordering
    SET
        ordertotal =(
        SELECT
            SUM(
                food.foodprice * orderlist.orderQuantity
            )
        FROM
            food,
            orderlist
        WHERE
            orderlist.orderid = OLD.orderid AND food.foodid = orderlist.foodid
    )WHERE ordering.orderid = OLD.orderid;
	IF (OLD.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = OLD.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = OLD.orderid;
	END IF;
END // */
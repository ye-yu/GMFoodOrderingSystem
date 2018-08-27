CREATE TRIGGER update_order_ready_I AFTER INSERT
ON
    orderlist FOR EACH ROW
FOLLOWS update_order_total_I
BEGIN
	IF (NEW.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = NEW.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = NEW.orderid;
	END IF;
END //
CREATE TRIGGER update_order_ready_U AFTER UPDATE
ON
    orderlist FOR EACH ROW
FOLLOWS update_order_total_U
BEGIN
	IF (NEW.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = NEW.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = NEW.orderid;
	END IF;
END //

CREATE TRIGGER update_order_ready_D AFTER DELETE
ON
    orderlist FOR EACH ROW
FOLLOWS update_order_total_D
BEGIN
	IF (NEW.orderid not in (select orderid from orderlist where orderStatus in ('Accepted', 'Preparing'))) THEN
		UPDATE ordering SET orderReadyStatus = TRUE where ordering.orderid = NEW.orderid;
	ELSE
		UPDATE ordering SET orderReadyStatus = FALSE where ordering.orderid = NEW.orderid;
	END IF;
END //

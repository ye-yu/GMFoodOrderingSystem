-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2018 at 09:47 AM
-- Server version: 10.1.34-MariaDB
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `foodorder`
--
CREATE DATABASE IF NOT EXISTS `foodorder` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `foodorder`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_feedback` (IN `cna` VARCHAR(100), IN `tno` INT, IN `rate` TINYINT, IN `rev` VARCHAR(500))  BEGIN
DECLARE oid CHAR(10);
SELECT  @cid := find_cust_id(cna, '') LIMIT 1;
SELECT find_order_id_from_table(@cid, tno) INTO oid;
INSERT INTO feedback VALUES(@cid, oid, rev, CURRENT_TIMESTAMP(), rate);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_id` (IN `tablename` VARCHAR(8), OUT `id` CHAR(10), OUT `isunique` BOOLEAN)  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `record_order_as_paid` (IN `oid` CHAR(10))  BEGIN
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
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `add_food` (`n` VARCHAR(100), `p` DECIMAL(7,2), `t` VARCHAR(50), `d` VARCHAR(500), `l` VARCHAR(100)) RETURNS TINYINT(1) BEGIN
    DECLARE
        id CHAR(10);
    CALL
        generate_id('food', @i, @u);
    SELECT
        @i
    INTO id;
INSERT INTO food
VALUES(id, n, p, t, d, l, DEFAULT); RETURN TRUE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `add_order` (`oid` CHAR(10), `fid` CHAR(10), `qty` INT) RETURNS TINYINT(1) BEGIN
    DECLARE
    	rcount INT;
    SELECT COUNT(*) INTO rcount FROM orderlist;
    INSERT INTO orderlist
    VALUES(rcount + 1, oid, fid, qty, DEFAULT); 
    RETURN TRUE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `find_cust_id` (`name` VARCHAR(100), `phone_no` VARCHAR(15)) RETURNS CHAR(10) CHARSET latin1 BEGIN
    DECLARE id CHAR(10);
    SELECT customerid INTO id FROM `foodorder`.`customer` WHERE customername = name and customerphoneno = phone_no;
    IF id IS NOT NULL THEN
        RETURN id;
    ELSE
        CALL generate_id('customer', @gid, @isunique);
        SELECT @gid INTO id;
		IF @isunique THEN
			RETURN id;
		END IF;
		RETURN '0';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `find_order_id_from_table` (`cid` CHAR(10), `tno` INT) RETURNS CHAR(10) CHARSET latin1 BEGIN
DECLARE oid CHAR(10);
SELECT `orderid` INTO oid FROM ordering where orderid not in (select orderid from receipt) and customerid = cid;
IF oid IS NULL THEN
	CALL generate_id('ordering', @oid, @uni);
    INSERT INTO ordering values(@oid, CURRENT_TIMESTAMP(),  default, cid, tno, default);
    SELECT @oid INTO oid;
END IF;
RETURN oid;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insert_customer` (`cid` CHAR(10), `cname` VARCHAR(100), `cphoneno` VARCHAR(15)) RETURNS TINYINT(1) BEGIN
    DECLARE
        ncid CHAR(10);
    SELECT
        customerid
    INTO ncid
    FROM
        customer
    WHERE
        customerid = cid; 
    IF ncid IS NOT NULL THEN
        UPDATE
            customer
        SET
            customername = cname,
            customerphoneno = cphoneno
        WHERE
            customerid = cid;
    ELSE
    	INSERT INTO customer VALUES(cid, cname, cphoneno);
    END IF; 
    RETURN TRUE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `reserve_table` (`n` INT) RETURNS INT(11) BEGIN
	IF (select @no := tableno from diningtable where seatQuantity >= n and tableStatus = 'Ready' order by seatQuantity asc LIMIT 1) IS NULL THEN
    	RETURN null;
    ELSE
    	update diningtable set tableStatus = CONCAT('Req ', CAST(n AS CHAR)) where tableno = @no;
    	RETURN @no;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerid` char(10) NOT NULL DEFAULT '0',
  `customername` varchar(100) DEFAULT NULL,
  `customerphoneno` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerid`, `customername`, `customerphoneno`) VALUES
('8atqsCyo66', '3 2', ''),
('eZfy9qfrll', '1 1', ''),
('f3l8Xn67ee', 'hello', ''),
('F4VjS1Q5cc', '4 1', ''),
('H93dgQ7nff', '3 1', ''),
('ie1V0MWpNN', '1 2', ''),
('jAZx74JMjj', 'Johnny Johhny', '0147843176'),
('ocf6V8JdWW', '4 2', ''),
('pbKVBa4Zvv', '2 1', ''),
('SqKZYuhF66', '2 2', ''),
('UOt3hNujxx', '3 3', ''),
('XFFdnvpXCC', 'green', ''),
('ylJ3Oafy11', '1 3', ''),
('ZJM9pEO3', 'raflie', '01412365456');

-- --------------------------------------------------------

--
-- Table structure for table `diningtable`
--

CREATE TABLE `diningtable` (
  `tableno` smallint(5) UNSIGNED NOT NULL,
  `tableStatus` varchar(8) NOT NULL DEFAULT 'Ready',
  `tabletype` varchar(50) DEFAULT NULL,
  `seatQuantity` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `diningtable`
--

INSERT INTO `diningtable` (`tableno`, `tableStatus`, `tabletype`, `seatQuantity`) VALUES
(1, 'Ready', 'Quadruple', 4),
(2, 'Req 2', 'Couple', 2),
(3, 'Ready', 'Family', 12),
(4, 'Ready', 'Family', 12),
(5, 'Ready', 'Quadruple', 4);

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `customerid` char(10) NOT NULL DEFAULT '0',
  `orderid` char(10) NOT NULL DEFAULT '0',
  `feedbackContent` varchar(500) DEFAULT NULL,
  `feedbackDateTime` datetime DEFAULT NULL,
  `feedbackRate` tinyint(3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`customerid`, `orderid`, `feedbackContent`, `feedbackDateTime`, `feedbackRate`) VALUES
('eZfy9qfrll', 'HzS5zWaa', 'just nice', '2018-09-16 09:10:00', 3),
('ie1V0MWpNN', 'j1dOoHzvWW', 'five star', '2018-09-16 09:10:07', 5),
('eZfy9qfrll', 'NPaj6s9Rrr', '', '2018-09-17 00:47:10', 5),
('ie1V0MWpNN', 'oeyGVlvvss', '', '2018-09-16 17:48:36', 0),
('eZfy9qfrll', 'P3kMG5yqSS', '', '2018-09-16 17:48:34', 0),
('ie1V0MWpNN', 'umYcLQk7dd', '', '2018-09-17 00:47:14', 4),
('ylJ3Oafy11', 'XoRp0fwVpp', '', '2018-09-16 17:48:38', 0);

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `foodid` char(10) NOT NULL DEFAULT '0',
  `foodname` varchar(100) DEFAULT NULL,
  `foodprice` decimal(7,2) DEFAULT NULL,
  `foodtype` varchar(50) DEFAULT NULL,
  `fooddescription` varchar(500) DEFAULT NULL,
  `foodimagelink` varchar(100) DEFAULT NULL,
  `showfood` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`foodid`, `foodname`, `foodprice`, `foodtype`, `fooddescription`, `foodimagelink`, `showfood`) VALUES
('9lgY5HT20Z', 'Obvious Paradise', '14.80', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537709844', 1),
('9pP94lO179', 'Tea Petal', '2.00', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537709882', 1),
('a12a20aa12', 'Milo', '1.20', 'Local Beverages', 'Milo is chocolate and malt powder that is mixed with hot water and milk or milk to produce a beverage', '1537706868', 1),
('A88ScbPTwf', 'Dark Chocolate Pound Cake', '17.50', 'Dessert', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537709924', 1),
('AO6qXkFawl', 'Savage Surge', '16.20', 'Milkshake', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537709989', 1),
('e9KPZOdSff', 'Blue Wish', '5.50', 'Local Beverages', 'This is a blue wish.', '1537710028', 1),
('eTXaxCGvnn', 'dunno', '3.20', 'Western Foods', 'bitch', NULL, 0),
('feaQfX05BZ', 'Fire-Roasted Mushroom & Garlic Sandwich', '8.20', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537710197', 1),
('GJ8X8LIH0w', 'Oven-Baked Cocoa & Mushroom Oysters', '19.10', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537751320', 1),
('gMXCaEBzhB', 'Vanilla Hound', '15.00', 'Dessert', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537753636', 1),
('GQXOocGNKR', 'Barbecued Mustard & Garlic Herring', '17.70', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537753730', 1),
('IItlQwa2bx', 'Dark Chocolate and Pistachio Pound Cake', '4.70', 'Dessert', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537753785', 1),
('j493lA7y1P', 'Stewed Light Ale Pizza', '12.10', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537754579', 1),
('J4iGUh8gwy', 'Chocolate Milkshakes', '9.40', 'Milkshake', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', '1537754673', 1),
('j89h78fgfy', 'Nescafe Milk', '2.50', 'Western Drinks', 'Nescafe milk is very delicious.', '1537754738', 1),
('LSUrqiOatt', 'Strawberry and Banana Pancake', '8.20', 'Western Foods', '5 layers of pancakes with honey, strawberry, and banana.', '1537706294', 0),
('n9Jw03Un16', 'Ginger Breeze', '6.90', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('NBPKc8MoMp', 'Pear Paralyzer', '14.00', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('oee1R3pOtt', 'Strawberry Waffle', '7.50', 'Dessert', 'Delicious Waffles with Fresh Strawberries.', '1537775178', 1),
('OpVxb5ZUXL', 'Tomato Crusher', '13.80', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('oQ4U6wX788', 'Milo Ais Dinosaur', '7.50', 'Local Beverages', 'Milo Ais Dinosaur yang dibancuh beserta dengan taburan serbuk Milo diatas bancuh. Tetap menjadi pilihan orang tempatan.', '1537673035', 1),
('pXhzIF9Nit', 'Dark Chocolate and Peanut Pud', '3.80', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('REhSCqLspl', 'Baked Thyme & Parsley Bear', '2.30', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('ticgWd3e2u', 'Fresh Duke', '13.90', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('TJeb0xP2gH', 'Engine-Cooked Honey Turkey', '1.00', 'Western Foods', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('u8uhhgd3ed', 'Fried Chicken Set', '7.50', 'Local Food', 'Very crispy fried chicken.', '1537750690', 1),
('VVtT5xnitA', 'Icy Talon', '1.30', 'Western Drinks', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', NULL, 0),
('wzeIeWp4hh', 'Strawberry and Banana Pancake', '8.20', 'Western Foods', '5 layers of pancakes with honey, strawberry, and banana.', '1537705869', 1),
('y7t6tty6rf', 'nasi lemak', '1.20', 'Western Foods', 'nasi lemak is very cheap', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ordering`
--

CREATE TABLE `ordering` (
  `orderid` char(10) NOT NULL DEFAULT '0',
  `orderdate` datetime NOT NULL,
  `orderReadyStatus` tinyint(1) NOT NULL DEFAULT '0',
  `customerid` char(10) NOT NULL DEFAULT '0',
  `tableno` smallint(5) UNSIGNED DEFAULT NULL,
  `ordertotal` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ordering`
--

INSERT INTO `ordering` (`orderid`, `orderdate`, `orderReadyStatus`, `customerid`, `tableno`, `ordertotal`) VALUES
('2gdw80Br00', '2018-09-17 07:10:22', 1, 'jAZx74JMjj', NULL, '107.20'),
('2rKrCkzIii', '2018-09-16 22:27:40', 1, 'pbKVBa4Zvv', 2, '44.40'),
('4ll01LV1yy', '2018-09-16 21:38:00', 1, 'ie1V0MWpNN', 1, '1.20'),
('5bczJwV3bb', '2018-09-17 06:58:23', 1, 'jAZx74JMjj', NULL, '107.20'),
('8L4jRjY77', '2018-09-17 16:42:21', 1, 'jAZx74JMjj', NULL, '18.80'),
('8XemlSrDaa', '2018-09-16 21:37:29', 1, 'eZfy9qfrll', 1, '3.80'),
('eOuzr4j9BB', '2018-09-16 19:10:13', 1, 'eZfy9qfrll', 1, '65.00'),
('EpIJbFDINN', '2018-09-17 16:44:03', 1, 'ie1V0MWpNN', 1, '4.00'),
('gERzPS7K33', '2018-09-16 22:29:52', 1, 'eZfy9qfrll', 1, '17.50'),
('GUJ9mjGd55', '2018-09-17 17:36:03', 0, 'pbKVBa4Zvv', 2, '17.50'),
('hljWUEUWMM', '2018-09-17 17:29:08', 0, 'jAZx74JMjj', NULL, '4.00'),
('HzS5zWaa', '2018-09-16 09:08:24', 1, 'eZfy9qfrll', 1, '17.50'),
('j1dOoHzvWW', '2018-09-16 09:08:34', 1, 'ie1V0MWpNN', 1, '14.80'),
('jjklkjlkjl', '2018-09-16 00:00:00', 1, 'ZJM9pEO3', NULL, '36.40'),
('M79EEuAw33', '2018-09-16 18:43:54', 1, 'eZfy9qfrll', 1, '4.70'),
('matfpown88', '2018-09-17 06:51:45', 1, 'jAZx74JMjj', NULL, '21.30'),
('NPaj6s9Rrr', '2018-09-17 00:45:53', 1, 'eZfy9qfrll', 1, '37.50'),
('oeyGVlvvss', '2018-09-16 17:47:17', 1, 'ie1V0MWpNN', 1, '6.90'),
('OjEHm23Occ', '2018-09-17 16:43:05', 1, 'eZfy9qfrll', 1, '121.90'),
('P3kMG5yqSS', '2018-09-16 17:47:08', 1, 'eZfy9qfrll', 1, '19.50'),
('qjkNeouSII', '2018-09-16 22:27:50', 1, 'SqKZYuhF66', 2, '2.30'),
('rdhHgQj8NN', '2018-09-17 07:13:28', 1, 'jAZx74JMjj', NULL, '17.50'),
('umYcLQk7dd', '2018-09-17 00:46:02', 1, 'ie1V0MWpNN', 1, '12.10'),
('vSLqE4dQKK', '2018-09-16 19:10:26', 1, 'ie1V0MWpNN', 1, '16.80'),
('VY1W3uXbDD', '2018-09-17 00:34:10', 1, 'jAZx74JMjj', NULL, '58.60'),
('XoRp0fwVpp', '2018-09-16 17:47:32', 1, 'ylJ3Oafy11', 1, '18.00');

-- --------------------------------------------------------

--
-- Table structure for table `orderlist`
--

CREATE TABLE `orderlist` (
  `entryno` int(11) NOT NULL,
  `orderid` char(10) NOT NULL DEFAULT '0',
  `foodid` char(10) NOT NULL DEFAULT '0',
  `orderQuantity` smallint(5) UNSIGNED NOT NULL,
  `orderStatus` varchar(9) NOT NULL DEFAULT 'Accepted'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orderlist`
--

INSERT INTO `orderlist` (`entryno`, `orderid`, `foodid`, `orderQuantity`, `orderStatus`) VALUES
(43, '2gdw80Br00', '9lgY5HT20Z', 1, 'Prepared'),
(44, '2gdw80Br00', '9pP94lO179', 1, 'Prepared'),
(45, '2gdw80Br00', 'AO6qXkFawl', 1, 'Prepared'),
(46, '2gdw80Br00', 'gMXCaEBzhB', 1, 'Prepared'),
(47, '2gdw80Br00', 'J4iGUh8gwy', 1, 'Prepared'),
(48, '2gdw80Br00', 'j89h78fgfy', 1, 'Prepared'),
(49, '2gdw80Br00', 'n9Jw03Un16', 1, 'Prepared'),
(50, '2gdw80Br00', 'NBPKc8MoMp', 1, 'Prepared'),
(51, '2gdw80Br00', 'OpVxb5ZUXL', 1, 'Prepared'),
(52, '2gdw80Br00', 'ticgWd3e2u', 1, 'Prepared'),
(15, '2rKrCkzIii', '9lgY5HT20Z', 3, 'Prepared'),
(14, '4ll01LV1yy', 'j89h78fgfy', 1, 'Prepared'),
(33, '5bczJwV3bb', '9lgY5HT20Z', 1, 'Prepared'),
(34, '5bczJwV3bb', '9pP94lO179', 1, 'Prepared'),
(35, '5bczJwV3bb', 'AO6qXkFawl', 1, 'Prepared'),
(36, '5bczJwV3bb', 'gMXCaEBzhB', 1, 'Prepared'),
(37, '5bczJwV3bb', 'J4iGUh8gwy', 1, 'Prepared'),
(38, '5bczJwV3bb', 'j89h78fgfy', 1, 'Prepared'),
(39, '5bczJwV3bb', 'n9Jw03Un16', 1, 'Prepared'),
(40, '5bczJwV3bb', 'NBPKc8MoMp', 1, 'Prepared'),
(41, '5bczJwV3bb', 'OpVxb5ZUXL', 1, 'Prepared'),
(42, '5bczJwV3bb', 'ticgWd3e2u', 1, 'Prepared'),
(54, '8L4jRjY77', '9lgY5HT20Z', 1, 'Prepared'),
(55, '8L4jRjY77', '9pP94lO179', 2, 'Prepared'),
(13, '8XemlSrDaa', 'pXhzIF9Nit', 1, 'Prepared'),
(9, 'eOuzr4j9BB', '9lgY5HT20Z', 2, 'Prepared'),
(10, 'eOuzr4j9BB', 'GQXOocGNKR', 2, 'Prepared'),
(60, 'EpIJbFDINN', '9pP94lO179', 1, 'Prepared'),
(61, 'EpIJbFDINN', '9pP94lO179', 1, 'Prepared'),
(17, 'gERzPS7K33', 'A88ScbPTwf', 1, 'Prepared'),
(63, 'GUJ9mjGd55', 'A88ScbPTwf', 1, 'Accepted'),
(62, 'hljWUEUWMM', '9pP94lO179', 2, 'Accepted'),
(1, 'HzS5zWaa', 'A88ScbPTwf', 1, 'Prepared'),
(2, 'j1dOoHzvWW', '9lgY5HT20Z', 1, 'Prepared'),
(0, 'jjklkjlkjl', 'eTXaxCGvnn', 2, 'Prepared'),
(19, 'jjklkjlkjl', 'gMXCaEBzhB', 2, 'Prepared'),
(8, 'M79EEuAw33', 'IItlQwa2bx', 1, 'Prepared'),
(32, 'matfpown88', 'feaQfX05BZ', 1, 'Prepared'),
(31, 'matfpown88', 'j493lA7y1P', 1, 'Prepared'),
(30, 'matfpown88', 'TJeb0xP2gH', 1, 'Prepared'),
(26, 'NPaj6s9Rrr', 'A88ScbPTwf', 1, 'Prepared'),
(28, 'NPaj6s9Rrr', 'AO6qXkFawl', 1, 'Prepared'),
(27, 'NPaj6s9Rrr', 'pXhzIF9Nit', 1, 'Prepared'),
(5, 'oeyGVlvvss', 'n9Jw03Un16', 1, 'Prepared'),
(56, 'OjEHm23Occ', 'A88ScbPTwf', 5, 'Prepared'),
(58, 'OjEHm23Occ', 'AO6qXkFawl', 1, 'Prepared'),
(57, 'OjEHm23Occ', 'eTXaxCGvnn', 1, 'Prepared'),
(59, 'OjEHm23Occ', 'gMXCaEBzhB', 1, 'Prepared'),
(3, 'P3kMG5yqSS', '9lgY5HT20Z', 1, 'Prepared'),
(4, 'P3kMG5yqSS', 'IItlQwa2bx', 1, 'Prepared'),
(16, 'qjkNeouSII', 'REhSCqLspl', 1, 'Prepared'),
(53, 'rdhHgQj8NN', 'A88ScbPTwf', 1, 'Prepared'),
(29, 'umYcLQk7dd', 'j493lA7y1P', 1, 'Prepared'),
(12, 'vSLqE4dQKK', 'IItlQwa2bx', 1, 'Prepared'),
(11, 'vSLqE4dQKK', 'j493lA7y1P', 1, 'Prepared'),
(20, 'VY1W3uXbDD', '9lgY5HT20Z', 1, 'Prepared'),
(21, 'VY1W3uXbDD', '9pP94lO179', 1, 'Prepared'),
(22, 'VY1W3uXbDD', 'a12a20aa12', 1, 'Prepared'),
(23, 'VY1W3uXbDD', 'AO6qXkFawl', 1, 'Prepared'),
(24, 'VY1W3uXbDD', 'gMXCaEBzhB', 1, 'Prepared'),
(25, 'VY1W3uXbDD', 'J4iGUh8gwy', 1, 'Prepared'),
(7, 'XoRp0fwVpp', '9pP94lO179', 2, 'Prepared'),
(6, 'XoRp0fwVpp', 'NBPKc8MoMp', 1, 'Prepared');

--
-- Triggers `orderlist`
--
DELIMITER $$
CREATE TRIGGER `update_ordering_D` AFTER DELETE ON `orderlist` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_ordering_I` AFTER INSERT ON `orderlist` FOR EACH ROW BEGIN
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
	
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_ordering_U` AFTER UPDATE ON `orderlist` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `receiptid` char(10) NOT NULL DEFAULT '0',
  `creditcardno` bigint(16) DEFAULT '0',
  `orderid` char(10) NOT NULL DEFAULT '0',
  `governmenttax` tinyint(4) DEFAULT '0',
  `additional` tinyint(4) DEFAULT '10',
  `paidTotal` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`receiptid`, `creditcardno`, `orderid`, `governmenttax`, `additional`, `paidTotal`) VALUES
('2gdw80Br00', 0, '2gdw80Br00', 0, 10, '117.92'),
('2rKrCkzIii', 0, '2rKrCkzIii', 0, 10, '48.84'),
('4ll01LV1yy', 0, '4ll01LV1yy', 0, 10, '1.32'),
('5bczJwV3bb', 12345678901234, '5bczJwV3bb', 0, 10, '117.92'),
('8L4jRjY77', 0, '8L4jRjY77', 0, 10, '20.68'),
('8XemlSrDaa', 12345678901234, '8XemlSrDaa', 0, 10, '4.18'),
('eOuzr4j9BB', 0, 'eOuzr4j9BB', 0, 10, '71.50'),
('EpIJbFDINN', 12345678901234, 'EpIJbFDINN', 0, 10, '4.40'),
('gERzPS7K33', 0, 'gERzPS7K33', 0, 10, '19.25'),
('HzS5zWaa', 12345678901234, 'HzS5zWaa', 0, 10, '19.25'),
('j1dOoHzvWW', 12345678901234, 'j1dOoHzvWW', 0, 10, '16.28'),
('jjklkjlkjl', 12345678901234, 'jjklkjlkjl', 0, 10, '40.04'),
('M79EEuAw33', 0, 'M79EEuAw33', 0, 10, '5.17'),
('matfpown88', 0, 'matfpown88', 0, 10, '23.43'),
('NPaj6s9Rrr', 12345678901234, 'NPaj6s9Rrr', 0, 10, '41.25'),
('oeyGVlvvss', 0, 'oeyGVlvvss', 0, 10, '7.59'),
('OjEHm23Occ', 12345678901234, 'OjEHm23Occ', 0, 10, '134.09'),
('P3kMG5yqSS', 12345678901234, 'P3kMG5yqSS', 0, 10, '21.45'),
('qjkNeouSII', 0, 'qjkNeouSII', 0, 10, '2.53'),
('rdhHgQj8NN', 0, 'rdhHgQj8NN', 0, 10, '19.25'),
('umYcLQk7dd', 12345678901234, 'umYcLQk7dd', 0, 10, '13.31'),
('vSLqE4dQKK', 0, 'vSLqE4dQKK', 0, 10, '18.48'),
('VY1W3uXbDD', 12345678901234, 'VY1W3uXbDD', 0, 10, '64.46'),
('XoRp0fwVpp', 12345678901234, 'XoRp0fwVpp', 0, 10, '19.80');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `diningtable`
--
ALTER TABLE `diningtable`
  ADD PRIMARY KEY (`tableno`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`orderid`,`customerid`),
  ADD KEY `customerid` (`customerid`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`foodid`);

--
-- Indexes for table `ordering`
--
ALTER TABLE `ordering`
  ADD PRIMARY KEY (`orderid`),
  ADD KEY `customerid` (`customerid`),
  ADD KEY `tableno` (`tableno`);

--
-- Indexes for table `orderlist`
--
ALTER TABLE `orderlist`
  ADD PRIMARY KEY (`orderid`,`foodid`,`entryno`) USING BTREE,
  ADD KEY `foodid` (`foodid`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receiptid`),
  ADD KEY `orderid` (`orderid`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `ordering` (`orderid`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`customerid`) REFERENCES `customer` (`customerid`);

--
-- Constraints for table `ordering`
--
ALTER TABLE `ordering`
  ADD CONSTRAINT `ordering_ibfk_1` FOREIGN KEY (`customerid`) REFERENCES `customer` (`customerid`),
  ADD CONSTRAINT `ordering_ibfk_2` FOREIGN KEY (`tableno`) REFERENCES `diningtable` (`tableno`);

--
-- Constraints for table `orderlist`
--
ALTER TABLE `orderlist`
  ADD CONSTRAINT `orderlist_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `ordering` (`orderid`),
  ADD CONSTRAINT `orderlist_ibfk_2` FOREIGN KEY (`foodid`) REFERENCES `food` (`foodid`);

--
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `ordering` (`orderid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

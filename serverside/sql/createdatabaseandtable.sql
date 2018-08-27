CREATE DATABASE foodorder;
CREATE TABLE `foodorder`.`customer`(
    `customerid` CHAR(10) NOT NULL DEFAULT '0',
    `customername` VARCHAR(100) NULL,
    `customerphoneno` VARCHAR(15) NULL,
    PRIMARY KEY(`customerid`)
) ENGINE = InnoDB; 

CREATE TABLE `foodorder`.`food`(
    `foodid` CHAR(10) NOT NULL DEFAULT '0',
    `foodname` VARCHAR(100) NULL,
    `foodprice` DECIMAL(7, 2) NULL,
    `foodtype` VARCHAR(50) NULL,
    `fooddescription` VARCHAR(500) NULL,
    `foodimagelink` VARCHAR(100) NULL,
    PRIMARY KEY(`foodid`)
) ENGINE = InnoDB; 

CREATE TABLE `foodorder`.`diningtable`(
    `tableno` SMALLINT UNSIGNED NOT NULL,
    `tableStatus` VARCHAR(8) NOT NULL DEFAULT 'Ready',
    `tabletype` VARCHAR(50) NULL,
    `seatQuantity` SMALLINT UNSIGNED NULL,
    PRIMARY KEY(`tableno`)
) ENGINE = InnoDB; 

CREATE TABLE `foodorder`.`ordering`(
    `orderid` CHAR(10) NOT NULL DEFAULT '0',
    `orderdate` DATE NOT NULL,
    `orderpickuptime` TIME NULL,
    `orderReadyStatus` BOOLEAN NOT NULL DEFAULT FALSE,
    `customerid` CHAR(10) NOT NULL DEFAULT '0',
    `tableno` SMALLINT UNSIGNED NULL,
    `ordertotal` DECIMAL(7, 2) NULL DEFAULT 0,
    PRIMARY KEY(`orderid`),
    FOREIGN KEY(`customerid`) REFERENCES customer(`customerid`),
    FOREIGN KEY (`tableno`) REFERENCES diningtable(`tableno`)
) ENGINE = InnoDB;

CREATE TABLE `foodorder`.`orderlist` (
    `orderid` CHAR(10) NOT NULL DEFAULT '0',
    `foodid` CHAR(10) NOT NULL DEFAULT '0',
    `orderQuantity` SMALLINT UNSIGNED NOT NULL,
    `orderStatus` VARCHAR(9) NOT NULL DEFAULT 'Accepted' CHECK (orderStatus IN ('Accepted', 'Preparing', 'Prepared')),
    PRIMARY KEY(`orderid`, `foodid`),
    FOREIGN KEY(`orderid`) REFERENCES ordering(`orderid`),
    FOREIGN KEY(`foodid`) REFERENCES food(`foodid`)
) ENGINE = InnoDB;

CREATE TABLE `foodorder`.`receipt` (
    `receiptid` CHAR(10) NOT NULL DEFAULT '0',
	`creditcardno` INT(16) NULL DEFAULT '0',
    `orderid` CHAR(10) NOT NULL DEFAULT '0',
	`governmenttax` TINYINT NULL,
	`additional` TINYINT NULL,
	`paidTotal` DECIMAL(7, 2),
    PRIMARY KEY(`receiptid`),
    FOREIGN KEY(`orderid`) REFERENCES ordering(`orderid`)
) ENGINE = InnoDB;

CREATE TABLE `foodorder`.`feedback` (
    `customerid` CHAR(10) NOT NULL DEFAULT '0',
    `orderid` CHAR(10) NOT NULL DEFAULT '0',
    `feedbackContent` VARCHAR(500) NULL,
    `feedbackDateTime` DATETIME NULL,
    `feedbackRate` TINYINT UNSIGNED NULL,
    PRIMARY KEY(`orderid`, `customerid`),
    FOREIGN KEY(`orderid`) REFERENCES ordering(`orderid`),
    FOREIGN KEY(`customerid`) REFERENCES customer(`customerid`)	
) ENGINE = InnoDB;

/*
DROP TABLE `feedback`;
DROP TABLE `receipt`;
DROP TABLE `orderlist`;
DROP TABLE `ordering`;
DROP TABLE `food`;
DROP TABLE `customer`;
DROP TABLE `diningtable`;
*/

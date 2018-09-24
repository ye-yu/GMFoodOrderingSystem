-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2018 at 05:46 AM
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
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(11) NOT NULL,
  `dbase` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `user` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `query` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

--
-- Dumping data for table `pma__bookmark`
--

INSERT INTO `pma__bookmark` (`id`, `dbase`, `user`, `label`, `query`) VALUES
(1, 'foodorder', 'root', 'create generate id procedure', 'CREATE PROCEDURE generateID(IN tablename VARCHAR(8), OUT id CHAR(10), OUT isunique BOOLEAN)\r\nBEGIN\r\n    SELECT TRUE INTO isunique;\r\n    SELECT CONCAT(\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(UNIX_TIMESTAMP(CURRENT_TIMESTAMP()))*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed:=round(rand(@seed)*4294967296))*62+1, 1),\r\n        substring(\'ABCDEFGHIJKLMNOPQRSTUVWXYZqwertyuiopasdfghjklzxcvbnm0123456789\', rand(@seed)*62+1, 1)\r\n        ) INTO id;\r\n    IF (tablename = \'customer\' AND (SELECT customerid FROM `foodorder`.`customer` WHERE customerid = id) IS NOT NULL) THEN\r\n        SELECT FALSE INTO isunique;\r\n    ELSE\r\n        IF (tablename = \'ordering\' AND (SELECT orderid FROM `foodorder`.`ordering` WHERE orderid = id) IS NOT NULL) THEN\r\n            SELECT FALSE INTO isunique;			\r\n        ELSE\r\n            IF (tablename = \'food\' AND (SELECT foodid FROM `foodorder`.`food` WHERE foodid = id) IS NOT NULL) THEN\r\n                SELECT FALSE INTO isunique;							\r\n            END IF;\r\n        END IF;\r\n    END IF;\r\nEND//\r\n'),
(2, 'foodorder', 'root', 'create find id function', 'CREATE FUNCTION find_cust_id(name VARCHAR(100), phone_no VARCHAR(15)) RETURNS CHAR(10)\r\nBEGIN\r\n    DECLARE id CHAR(10);\r\n    SELECT customerid INTO id FROM `foodorder`.`customer` WHERE customername = name and customerphoneno;\r\n    IF id IS NOT NULL THEN\r\n        RETURN id;\r\n    ELSE\r\n        CALL generateID(\'customer\', @gid, @isunique);\r\n        SELECT @gid INTO id;\r\n        RETURN id;\r\n    END IF;\r\nEND//\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `col_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `col_type` varchar(64) COLLATE utf8_bin NOT NULL,
  `col_length` text COLLATE utf8_bin,
  `col_collation` varchar(64) COLLATE utf8_bin NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) COLLATE utf8_bin DEFAULT '',
  `col_default` text COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `column_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `transformation` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `transformation_options` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `input_transformation` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `settings_data` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `export_type` varchar(10) COLLATE utf8_bin NOT NULL,
  `template_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `template_data` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

--
-- Dumping data for table `pma__export_templates`
--

INSERT INTO `pma__export_templates` (`id`, `username`, `export_type`, `template_name`, `template_data`) VALUES
(1, 'root', 'table', 'test', '{\"quick_or_custom\":\"quick\",\"what\":\"sql\",\"allrows\":\"1\",\"aliases_new\":\"\",\"output_format\":\"sendit\",\"filename_template\":\"@TABLE@\",\"remember_template\":\"on\",\"charset\":\"utf-8\",\"compression\":\"none\",\"maxsize\":\"\",\"codegen_structure_or_data\":\"data\",\"codegen_format\":\"0\",\"csv_separator\":\",\",\"csv_enclosed\":\"\\\"\",\"csv_escaped\":\"\\\"\",\"csv_terminated\":\"AUTO\",\"csv_null\":\"NULL\",\"csv_structure_or_data\":\"data\",\"excel_null\":\"NULL\",\"excel_columns\":\"something\",\"excel_edition\":\"win\",\"excel_structure_or_data\":\"data\",\"json_structure_or_data\":\"data\",\"json_unicode\":\"something\",\"latex_caption\":\"something\",\"latex_structure_or_data\":\"structure_and_data\",\"latex_structure_caption\":\"Struktur tabel @TABLE@\",\"latex_structure_continued_caption\":\"Struktur tabel @TABLE@ (dilanjutkan)\",\"latex_structure_label\":\"tab:@TABLE@-structure\",\"latex_relation\":\"something\",\"latex_comments\":\"something\",\"latex_mime\":\"something\",\"latex_columns\":\"something\",\"latex_data_caption\":\"Isi tabel @TABLE@\",\"latex_data_continued_caption\":\"Isi tabel @TABLE@ (dilanjutkan)\",\"latex_data_label\":\"tab:@TABLE@-data\",\"latex_null\":\"\\\\textit{NULL}\",\"mediawiki_structure_or_data\":\"data\",\"mediawiki_caption\":\"something\",\"mediawiki_headers\":\"something\",\"htmlword_structure_or_data\":\"structure_and_data\",\"htmlword_null\":\"NULL\",\"ods_null\":\"NULL\",\"ods_structure_or_data\":\"data\",\"odt_structure_or_data\":\"structure_and_data\",\"odt_relation\":\"something\",\"odt_comments\":\"something\",\"odt_mime\":\"something\",\"odt_columns\":\"something\",\"odt_null\":\"NULL\",\"pdf_report_title\":\"\",\"pdf_structure_or_data\":\"data\",\"phparray_structure_or_data\":\"data\",\"sql_include_comments\":\"something\",\"sql_header_comment\":\"\",\"sql_use_transaction\":\"something\",\"sql_compatibility\":\"NONE\",\"sql_structure_or_data\":\"structure_and_data\",\"sql_create_table\":\"something\",\"sql_auto_increment\":\"something\",\"sql_create_view\":\"something\",\"sql_create_trigger\":\"something\",\"sql_backquotes\":\"something\",\"sql_type\":\"INSERT\",\"sql_insert_syntax\":\"both\",\"sql_max_query_size\":\"50000\",\"sql_hex_for_binary\":\"something\",\"sql_utc_time\":\"something\",\"texytext_structure_or_data\":\"structure_and_data\",\"texytext_null\":\"NULL\",\"xml_structure_or_data\":\"data\",\"xml_export_events\":\"something\",\"xml_export_functions\":\"something\",\"xml_export_procedures\":\"something\",\"xml_export_tables\":\"something\",\"xml_export_triggers\":\"something\",\"xml_export_views\":\"something\",\"xml_export_contents\":\"something\",\"yaml_structure_or_data\":\"data\",\"\":null,\"lock_tables\":null,\"csv_removeCRLF\":null,\"csv_columns\":null,\"excel_removeCRLF\":null,\"json_pretty_print\":null,\"htmlword_columns\":null,\"ods_columns\":null,\"sql_dates\":null,\"sql_relation\":null,\"sql_mime\":null,\"sql_disable_fk\":null,\"sql_views_as_tables\":null,\"sql_metadata\":null,\"sql_drop_table\":null,\"sql_if_not_exists\":null,\"sql_procedure_function\":null,\"sql_truncate\":null,\"sql_delayed\":null,\"sql_ignore\":null,\"texytext_columns\":null}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `tables` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `db` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `table` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sqlquery` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `item_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `item_type` varchar(64) COLLATE utf8_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `tables` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `master_table` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `master_field` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `foreign_db` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `foreign_table` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `foreign_field` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `search_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `search_data` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT '0',
  `x` float UNSIGNED NOT NULL DEFAULT '0',
  `y` float UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `display_field` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `prefs` text COLLATE utf8_bin NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

--
-- Dumping data for table `pma__table_uiprefs`
--

INSERT INTO `pma__table_uiprefs` (`username`, `db_name`, `table_name`, `prefs`, `last_update`) VALUES
('admin', 'foodorder', 'food', '{\"sorted_col\":\"`food`.`foodimagelink` ASC\"}', '2018-09-23 12:44:19'),
('root', 'foodorder', 'ordering', '[]', '2018-09-16 14:55:21'),
('root', 'foodorder', 'orderlist', '[]', '2018-09-16 14:55:17');

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text COLLATE utf8_bin NOT NULL,
  `schema_sql` text COLLATE utf8_bin,
  `data_sql` longtext COLLATE utf8_bin,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') COLLATE utf8_bin DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `config_data` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('admin', '2018-09-23 12:38:48', '{\"Console\\/Mode\":\"collapse\",\"lang\":\"en_GB\"}'),
('customer', '2018-08-21 08:44:08', '{\"Console\\/Mode\":\"collapse\"}'),
('root', '2018-09-24 03:46:07', '{\"Console\\/Mode\":\"collapse\",\"lang\":\"en_GB\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) COLLATE utf8_bin NOT NULL,
  `tab` varchar(64) COLLATE utf8_bin NOT NULL,
  `allowed` enum('Y','N') COLLATE utf8_bin NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) COLLATE utf8_bin NOT NULL,
  `usergroup` varchar(64) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;

-- --------------------------------------------------------

--
-- Table structure for table `hello`
--

CREATE TABLE `hello` (
  `g` int(11) NOT NULL,
  `h` int(11) NOT NULL,
  `j` int(11) NOT NULL,
  `k` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

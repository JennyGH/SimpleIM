-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2016-12-28 08:29:25
-- 服务器版本： 10.1.13-MariaDB
-- PHP Version: 5.6.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jennychat`
--

-- --------------------------------------------------------

--
-- 表的结构 `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `username` varchar(45) CHARACTER SET gbk NOT NULL,
  `pswd` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `account`
--

INSERT INTO `account` (`id`, `username`, `pswd`) VALUES
(1, 'jenny1000', '1'),
(1000, 'jenny1000', '134345'),
(1001, 'jenny1001', '134345'),
(1002, 'jenny1002', '134345'),
(1003, 'jenny1003', '134345'),
(1004, 'jenny1004', '134345'),
(1005, 'jenny1005', '134345'),
(1006, 'jenny1006', '134345'),
(1007, 'jenny1007', '134345'),
(1008, 'jenny1008', '134345'),
(1009, 'jenny1009', '134345');

-- --------------------------------------------------------

--
-- 表的结构 `friendlist`
--

CREATE TABLE `friendlist` (
  `id` int(11) NOT NULL,
  `fid` varchar(10) NOT NULL,
  `fname` varchar(45) CHARACTER SET gbk NOT NULL,
  `accountid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `friendlist`
--

INSERT INTO `friendlist` (`id`, `fid`, `fname`, `accountid`) VALUES
(3, '1', 'jenny1', 1000),
(14, '1002', 'jenny1002', 1000),
(15, '1003', 'jenny1003', 1000),
(34, '1005', 'jenny1005', 1),
(35, '1006', 'jenny1006', 1),
(36, '1007', 'jenny1007', 1),
(37, '1008', 'jenny1008', 1),
(39, '1000', 'jenny1000', 1);

-- --------------------------------------------------------

--
-- 表的结构 `message`
--

CREATE TABLE `message` (
  `id` int(11) NOT NULL,
  `message` varchar(200) CHARACTER SET gbk NOT NULL,
  `senderID` int(11) NOT NULL,
  `recvID` int(11) NOT NULL,
  `isFriend` int(1) UNSIGNED ZEROFILL NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `message`
--

INSERT INTO `message` (`id`, `message`, `senderID`, `recvID`, `isFriend`) VALUES
(4, 'qingqiu', 1234, 1, 0),
(5, 'dqdwqd', 1, 1007, 1),
(6, 'dqdqwd', 1, 1007, 1),
(7, 'qwd', 1, 1007, 1),
(8, 'wq', 1, 1007, 1),
(9, 'dqw', 1, 1007, 1),
(10, 'd', 1, 1007, 1),
(11, 'qwd', 1, 1007, 1),
(12, 'dqwdqw', 1, 1008, 1),
(13, '哈哈', 1, 1005, 1),
(14, '你好吗', 1, 1005, 1),
(15, '嗯嗯', 1, 1005, 1),
(16, '哦哦', 1, 1005, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friendlist`
--
ALTER TABLE `friendlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `accountid_idx` (`accountid`);

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `recvID_idx` (`recvID`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `friendlist`
--
ALTER TABLE `friendlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;
--
-- 使用表AUTO_INCREMENT `message`
--
ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- 限制导出的表
--

--
-- 限制表 `friendlist`
--
ALTER TABLE `friendlist`
  ADD CONSTRAINT `accountid` FOREIGN KEY (`accountid`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `recvID` FOREIGN KEY (`recvID`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

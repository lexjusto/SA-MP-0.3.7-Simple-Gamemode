-- phpMyAdmin SQL Dump
-- version 4.0.10.6
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июл 02 2015 г., 23:51
-- Версия сервера: 5.5.41-log
-- Версия PHP: 5.6.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `astawnew`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(32) NOT NULL,
  `regdate` int(11) NOT NULL,
  `regip` varchar(40) NOT NULL,
  `lastdate` int(11) NOT NULL,
  `lastip` varchar(40) NOT NULL,
  `registered` tinyint(1) NOT NULL,
  `invited` varchar(24) NOT NULL,
  `gender` tinyint(1) NOT NULL,
  `logged` tinyint(1) NOT NULL,
  `level` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `skin` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `email`, `password`, `regdate`, `regip`, `lastdate`, `lastip`, `registered`, `invited`, `gender`, `logged`, `level`, `money`, `skin`) VALUES
(1, 'lexjusto', 'test@sa-mp.com', '66312e23e467b62ebc1986a3a6e0b69c', 1433262414, '127.0.0.1', 1433371987, '127.0.0.1', 1, 'lexjusto', 1, 1, 1, 250, 3);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

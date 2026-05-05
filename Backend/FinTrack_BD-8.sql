-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:8889
-- Время создания: Май 05 2026 г., 00:57
-- Версия сервера: 8.0.44
-- Версия PHP: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `FinTrack_BD`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Budget`
--

CREATE TABLE `Budget` (
  `BudgetID` int NOT NULL,
  `UserID` int NOT NULL,
  `SumLimit` decimal(15,2) NOT NULL,
  `PeriodType` varchar(20) NOT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Дамп данных таблицы `Budget`
--

INSERT INTO `Budget` (`BudgetID`, `UserID`, `SumLimit`, `PeriodType`, `CreatedAt`) VALUES
(17, 14, 50000.00, 'month', '2026-04-20 20:18:42'),
(18, 14, 4000.00, 'week', '2026-04-20 20:18:48'),
(19, 15, 50000.00, 'month', '2026-04-20 20:30:53'),
(20, 15, 10000.00, 'week', '2026-04-20 20:30:56'),
(21, 17, 90000.00, 'month', '2026-04-21 10:21:33'),
(22, 17, 5000.00, 'week', '2026-04-21 10:21:42'),
(23, 21, 100000.00, 'month', '2026-04-25 08:55:26'),
(24, 21, 10000.00, 'week', '2026-04-25 08:55:32');

-- --------------------------------------------------------

--
-- Структура таблицы `Categories`
--

CREATE TABLE `Categories` (
  `CategoryID` int NOT NULL,
  `UserID` int DEFAULT NULL,
  `CategoryName` varchar(50) NOT NULL,
  `IsDefault` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Categories`
--

INSERT INTO `Categories` (`CategoryID`, `UserID`, `CategoryName`, `IsDefault`) VALUES
(60, NULL, 'Продукты', 1),
(61, NULL, 'Транспорт', 1),
(62, NULL, 'Жильё', 1),
(63, NULL, 'Коммунальные услуги', 1),
(64, NULL, 'Развлечения', 1),
(65, NULL, 'Здоровье', 1),
(66, NULL, 'Зарплата', 1),
(67, NULL, 'Прочее', 1),
(68, 15, 'Одежда', 0),
(69, 17, 'Шоппинг', 0),
(70, 17, 'Красота', 0),
(71, 18, 'одежда', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `Operations`
--

CREATE TABLE `Operations` (
  `OperationID` int NOT NULL,
  `UserID` int NOT NULL,
  `CategoryID` int NOT NULL,
  `Sum` decimal(15,2) NOT NULL,
  `OperationType` varchar(10) NOT NULL,
  `OperationDate` datetime NOT NULL,
  `Comment` varchar(200) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Дамп данных таблицы `Operations`
--

INSERT INTO `Operations` (`OperationID`, `UserID`, `CategoryID`, `Sum`, `OperationType`, `OperationDate`, `Comment`, `CreatedAt`) VALUES
(24, 14, 66, 50000.00, 'income', '2026-04-20 00:00:00', 'Зарплата', '2026-04-20 20:19:16'),
(25, 14, 60, 4000.00, 'expense', '2026-04-20 00:00:00', 'Продукты', '2026-04-20 20:19:37'),
(26, 14, 61, 500.00, 'expense', '2026-04-20 00:00:00', 'Такси', '2026-04-20 20:28:12'),
(27, 14, 63, 10000.00, 'expense', '2026-04-20 00:00:00', 'Коммуналка', '2026-04-20 20:28:57'),
(28, 14, 64, 20000.00, 'expense', '2026-04-20 00:00:00', 'Ресторан', '2026-04-20 20:29:48'),
(29, 15, 66, 50000.00, 'income', '2026-04-20 00:00:00', 'ЗП', '2026-04-20 20:31:09'),
(30, 15, 67, 10000.00, 'income', '2026-04-20 00:00:00', 'Аванс', '2026-04-20 20:31:21'),
(31, 15, 62, 30000.00, 'expense', '2026-04-20 00:00:00', 'Аренда', '2026-04-20 20:31:34'),
(32, 15, 66, 10000.00, 'income', '2026-04-20 00:00:00', 'ЗП', '2026-04-21 00:21:15'),
(33, 14, 60, 200.00, 'expense', '2026-04-21 00:00:00', 'Кофе', '2026-04-21 00:22:37'),
(34, 15, 61, 300.00, 'expense', '2026-04-01 00:00:00', 'Такси', '2026-04-21 00:24:13'),
(35, 17, 66, 100000.00, 'income', '2026-04-14 00:00:00', 'Зп', '2026-04-21 10:19:25'),
(37, 17, 62, 45000.00, 'expense', '2026-04-21 00:00:00', 'Аренда', '2026-04-21 10:20:50'),
(38, 17, 61, 250.00, 'expense', '2026-04-21 00:00:00', 'Такси', '2026-04-21 10:21:05'),
(39, 17, 60, 1000.00, 'expense', '2026-04-21 00:00:00', 'продукты', '2026-04-21 10:21:20'),
(40, 18, 66, 10000.00, 'income', '2026-04-21 00:00:00', 'аванс', '2026-04-21 10:40:18'),
(41, 18, 67, 500.00, 'expense', '2026-04-21 00:00:00', 'бургир кинг', '2026-04-21 10:40:42'),
(42, 18, 67, 5000.00, 'expense', '2026-04-21 00:00:00', 'долги', '2026-04-21 10:41:01'),
(43, 18, 63, 1400.00, 'expense', '2026-04-21 00:00:00', 'интернет', '2026-04-21 10:41:23'),
(44, 15, 60, 5000.00, 'expense', '2026-04-21 00:00:00', 'Продукты', '2026-04-21 11:31:39'),
(45, 19, 66, 14999.99, 'income', '2026-04-22 00:00:00', 'зп', '2026-04-22 10:24:22'),
(46, 15, 66, 7000.00, 'income', '2026-04-24 00:00:00', 'Фриланс', '2026-04-25 08:48:46'),
(47, 15, 60, 5000.00, 'expense', '2026-04-24 00:00:00', 'Продукты', '2026-04-25 08:49:00'),
(48, 15, 61, 500.00, 'expense', '2026-04-24 00:00:00', 'Такси', '2026-04-25 08:50:24'),
(49, 15, 62, 70000.00, 'income', '2026-04-24 00:00:00', 'Аренда', '2026-04-25 08:50:48'),
(50, 18, 67, 1000.00, 'expense', '2026-04-24 00:00:00', 'Обед', '2026-04-25 08:51:51'),
(51, 20, 66, 70000.00, 'income', '2026-04-25 00:00:00', 'Аванс', '2026-04-25 08:53:33'),
(52, 20, 62, 40000.00, 'expense', '2026-04-25 00:00:00', 'Аренда', '2026-04-25 08:54:05'),
(53, 20, 60, 5000.00, 'income', '2026-04-24 00:00:00', 'Продукты', '2026-04-25 08:54:25'),
(54, 21, 66, 100000.00, 'income', '2026-04-25 00:00:00', 'Зарплата', '2026-04-25 08:55:49'),
(55, 21, 62, 45000.00, 'expense', '2026-04-25 00:00:00', 'Жилье', '2026-04-25 08:56:04'),
(56, 21, 61, 107.00, 'expense', '2026-04-25 00:00:00', 'Такси', '2026-04-25 08:56:25'),
(57, 15, 66, 5000.00, 'income', '2026-04-27 00:00:00', 'Fdfyc', '2026-04-27 13:47:59'),
(58, 15, 62, 5000.00, 'expense', '2026-05-04 00:00:00', 'fjfvfjvfv', '2026-05-04 11:43:28'),
(59, 15, 62, 50000.00, 'expense', '2026-05-04 00:00:00', 'Fiofvojvov', '2026-05-04 11:43:44'),
(60, 15, 66, 50.00, 'expense', '2026-05-04 00:00:00', 'fffhj', '2026-05-04 11:43:54'),
(61, 15, 66, 50000.00, 'income', '2026-05-04 00:00:00', 'Pg', '2026-05-04 11:45:12'),
(62, 15, 66, 50000.00, 'expense', '2026-05-04 00:00:00', 'Зп', '2026-05-04 11:50:28');

-- --------------------------------------------------------

--
-- Структура таблицы `Tips`
--

CREATE TABLE `Tips` (
  `TipID` int NOT NULL,
  `Title` varchar(100) NOT NULL,
  `TipText` varchar(500) NOT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Tips`
--

INSERT INTO `Tips` (`TipID`, `Title`, `TipText`, `CreatedAt`) VALUES
(2, 'Правило 50/30/20', 'Распределяй доход так: 50% на обязательные расходы, 30% на личные желания, 20% откладывай на накопления.', '2026-04-03 20:19:40'),
(3, 'Веди учёт каждый день', 'Записывай расходы сразу после траты — так ты не забудешь мелкие покупки, которые в сумме съедают бюджет.', '2026-04-03 20:19:40'),
(4, 'Подушка безопасности', 'Старайся иметь на счету сумму, равную 3–6 месяцам твоих обязательных расходов на случай непредвиденных ситуаций.', '2026-04-03 20:19:40'),
(5, 'Проверяй подписки', 'Раз в месяц просматривай все активные подписки. Часто мы платим за сервисы, которыми давно не пользуемся.', '2026-04-03 20:19:40'),
(6, 'Планируй крупные покупки', 'Перед большой тратой подожди 48 часов. Если желание купить не пропало — покупка действительно нужна.', '2026-04-03 20:19:40'),
(7, 'Плати сначала себе, а не “что осталось”', 'Суть простая: как только получаешь деньги — сразу откладывай часть (например 10–20%), и только потом живи на остальное.', '2026-04-10 21:28:00');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `UserID` int NOT NULL,
  `Email` varchar(255) NOT NULL DEFAULT '',
  `PasswordHash` varchar(255) NOT NULL DEFAULT '',
  `currency` varchar(3) DEFAULT 'RUB',
  `ThemeMode` varchar(10) NOT NULL DEFAULT 'light',
  `DateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `theme` varchar(10) DEFAULT 'light'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`UserID`, `Email`, `PasswordHash`, `currency`, `ThemeMode`, `DateCreated`, `theme`) VALUES
(14, 'diana@gmail.com', '$2y$10$vsnPlqcNBBJ5cZJ5W5.mM.dNlAxQZaoZHJdVgg97zhULlTRCONwFa', '₽', 'light', '2026-04-20 12:40:19', 'light'),
(15, 'example@gmail.com', '$2y$10$ov7Ghik5OhskUErdMeISM.tp0o8Plyr8S86yvj56BPAu7FSIEfi9C', '₽', 'light', '2026-04-20 20:10:48', 'light'),
(16, 'example2@gmail.com', '$2y$10$8vaYefve4d9VpMeHKqTNs.ivBDIawd4HJxM/dIMCcmai8ix9Mn2Ha', '₽', 'light', '2026-04-20 20:14:36', 'light'),
(17, 'primer@gmail.com', '$2y$10$nLmLfeW6UoYUJWsBCn6XfeoRTtn5XjAcHyH6JSH1VDe3ZbrBXQDdO', '₽', 'light', '2026-04-21 10:18:55', 'light'),
(18, 'tikhonov@gmail.com', '$2y$10$8zqfrjUMegQivGbg.0i8R.JsYlzWA6MzxEpAFxB1igqhVAN6ezFIW', '₽', 'light', '2026-04-21 10:39:43', 'light'),
(19, 'golubko@gmail.com', '$2y$10$f8kZ2dDxLjDyk11N6shK1uOgvEYf3V1k4oIolFxePstkJNYm2aqzS', '₽', 'light', '2026-04-22 10:23:44', 'light'),
(20, 'borisova@gmail.com', '$2y$10$jB8A.aVm0BqxG/iBQz7GROS8I34PiOiz9THy7dYexFEqcE/SUBokq', '₽', 'light', '2026-04-25 08:53:13', 'light'),
(21, 'diana77@gmail.com', '$2y$10$Rsb1vOGHr.l0CuLxOB.byeGvF/euZBChvGeYKw88zH9DHjdDYmorC', '₽', 'light', '2026-04-25 08:55:01', 'light');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Budget`
--
ALTER TABLE `Budget`
  ADD PRIMARY KEY (`BudgetID`),
  ADD KEY `budget_ibfk_1` (`UserID`);

--
-- Индексы таблицы `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`CategoryID`),
  ADD KEY `categories_ibfk_1` (`UserID`);

--
-- Индексы таблицы `Operations`
--
ALTER TABLE `Operations`
  ADD PRIMARY KEY (`OperationID`),
  ADD KEY `operations_ibfk_1` (`UserID`),
  ADD KEY `operations_ibfk_2` (`CategoryID`);

--
-- Индексы таблицы `Tips`
--
ALTER TABLE `Tips`
  ADD PRIMARY KEY (`TipID`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Budget`
--
ALTER TABLE `Budget`
  MODIFY `BudgetID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Categories`
--
ALTER TABLE `Categories`
  MODIFY `CategoryID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT для таблицы `Operations`
--
ALTER TABLE `Operations`
  MODIFY `OperationID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Tips`
--
ALTER TABLE `Tips`
  MODIFY `TipID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `Budget`
--
ALTER TABLE `Budget`
  ADD CONSTRAINT `budget_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Categories`
--
ALTER TABLE `Categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Operations`
--
ALTER TABLE `Operations`
  ADD CONSTRAINT `operations_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `operations_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

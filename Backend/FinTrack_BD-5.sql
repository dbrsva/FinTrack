-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:8889
-- Время создания: Апр 06 2026 г., 13:03
-- Версия сервера: 8.0.44
-- Версия PHP: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";



CREATE TABLE `Budget` (
  `BudgetID` int NOT NULL,
  `UserID` int NOT NULL,
  `SumLimit` decimal(15,2) NOT NULL,
  `PeriodType` varchar(20) NOT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP
) ;


INSERT INTO `Budget` (`BudgetID`, `UserID`, `SumLimit`, `PeriodType`, `CreatedAt`) VALUES
(1, 4, 6000.00, 'month', '2026-04-03 20:16:34'),
(2, 1, 45000.00, 'month', '2026-04-03 20:17:03'),
(3, 3, 5000.00, 'week', '2026-04-03 20:17:32'),
(4, 1, 1500.00, 'day', '2026-04-03 20:18:33');


CREATE TABLE `Categories` (
  `CategoryID` int NOT NULL,
  `UserID` int DEFAULT NULL,
  `CategoryName` varchar(50) NOT NULL,
  `IsDefault` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Categories` (`CategoryID`, `UserID`, `CategoryName`, `IsDefault`) VALUES
(1, NULL, 'Продукты', 1),
(2, NULL, 'Транспорт', 1),
(3, NULL, 'Жильё', 1),
(4, NULL, 'Коммунальные услуги', 1),
(5, NULL, 'Развлечения', 1),
(6, NULL, 'Здоровье', 1),
(7, NULL, 'Зарплата', 1),
(8, NULL, 'Прочее', 1);


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


INSERT INTO `Operations` (`OperationID`, `UserID`, `CategoryID`, `Sum`, `OperationType`, `OperationDate`, `Comment`, `CreatedAt`) VALUES
(1, 1, 1, 3000.00, 'expense', '2026-04-03 00:00:00', 'Продукты на неделю', '2026-04-03 20:13:02'),
(2, 2, 3, 50000.00, 'income', '2026-04-03 11:13:12', 'Аванс', '2026-04-03 20:13:39'),
(4, 2, 6, 400.00, 'expense', '2026-04-03 00:00:00', 'Пополнение карты', '2026-04-03 20:15:45');


CREATE TABLE `Tips` (
  `TipID` int NOT NULL,
  `Title` varchar(100) NOT NULL,
  `TipText` varchar(500) NOT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `Tips` (`TipID`, `Title`, `TipText`, `CreatedAt`) VALUES
(2, 'Правило 50/30/20', 'Распределяй доход так: 50% на обязательные расходы, 30% на личные желания, 20% откладывай на накопления.', '2026-04-03 20:19:40'),
(3, 'Веди учёт каждый день', 'Записывай расходы сразу после траты — так ты не забудешь мелкие покупки, которые в сумме съедают бюджет.', '2026-04-03 20:19:40'),
(4, 'Подушка безопасности', 'Старайся иметь на счету сумму, равную 3–6 месяцам твоих обязательных расходов на случай непредвиденных ситуаций.', '2026-04-03 20:19:40'),
(5, 'Проверяй подписки', 'Раз в месяц просматривай все активные подписки. Часто мы платим за сервисы, которыми давно не пользуемся.', '2026-04-03 20:19:40'),
(6, 'Планируй крупные покупки', 'Перед большой тратой подожди 48 часов. Если желание купить не пропало — покупка действительно нужна.', '2026-04-03 20:19:40');


CREATE TABLE `Users` (
  `UserID` int NOT NULL,
  `Email` varchar(255) NOT NULL DEFAULT '',
  `PasswordHash` varchar(255) NOT NULL DEFAULT '',
  `Currency` varchar(10) NOT NULL,
  `ThemeMode` varchar(10) NOT NULL DEFAULT 'light',
  `DateCreated` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `Users` (`UserID`, `Email`, `PasswordHash`, `Currency`, `ThemeMode`, `DateCreated`) VALUES
(1, '', '', '₽', 'light', '2026-04-03 20:07:45'),
(2, '', '', '₽', 'light', '2026-04-03 20:08:56'),
(3, '', '', '₽', 'light', '2026-04-03 20:09:00'),
(4, '', '', '$', 'light', '2026-04-03 20:09:27'),
(5, '', '', '$', 'light', '2026-04-03 20:09:30');

ALTER TABLE `Budget`
  ADD PRIMARY KEY (`BudgetID`),
  ADD KEY `UserID` (`UserID`);

ALTER TABLE `Categories`
  ADD PRIMARY KEY (`CategoryID`),
  ADD KEY `UserID` (`UserID`);

ALTER TABLE `Operations`
  ADD PRIMARY KEY (`OperationID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `CategoryID` (`CategoryID`);

ALTER TABLE `Tips`
  ADD PRIMARY KEY (`TipID`);

ALTER TABLE `Users`
  ADD PRIMARY KEY (`UserID`);

ALTER TABLE `Budget`
  MODIFY `BudgetID` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Categories`
  MODIFY `CategoryID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

ALTER TABLE `Operations`
  MODIFY `OperationID` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `Tips`
  MODIFY `TipID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

ALTER TABLE `Users`
  MODIFY `UserID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `Budget`
  ADD CONSTRAINT `budget_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE CASCADE;

ALTER TABLE `Categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE CASCADE;

ALTER TABLE `Operations`
  ADD CONSTRAINT `operations_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `operations_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

CREATE DATABASE Restaurant
USE Restaurant

CREATE TABLE Meals
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(255) NOT NULL,
	Price MONEY
)

CREATE TABLE Seats
(
	Id INT PRIMARY KEY IDENTITY,
	Number VARCHAR(255) UNIQUE
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	MealId INT FOREIGN KEY REFERENCES Meals(Id),
	SeatId INT FOREIGN KEY REFERENCES Seats(Id),
	OrderDate DATETIME2 NOT NULL

)

INSERT INTO Meals
VALUES 
('Fettucini Alfredo',14.67),
('Shrimp noddles',7.8),
('Cheesecake',8),
('Calzone',4.34),
('Sushi',28.5),
('Salad',6.23)

INSERT INTO Seats
VALUES 
('127'),
('128'),
('671'),
('911'),
('119'),
('223'),
('401')

SELECT * FROM Meals
SELECT * FROM Seats

INSERT INTO Orders
VALUES
(1,7,'2024-10-20 19:00'),
(1,3,'2024-10-20 19:25'),
(2,7,'2024-01-01 23:11'),
(3,3,'2024-01-12 14:40'),
(3,4,'2024-02-28 17:36'),
(3,2,'2024-08-09 12:45'),
(4,1,'2024-03-28 18:09'),
(5,1,'2024-05-11 18:53'),
(6,6,'2024-08-14 15:37'),
(6,3,'2024-11-13 19:23'),
(6,7,'2024-12-12 15:34')

INSERT INTO Orders
VALUES
(2,4,'2024-02-18 21:07'),
(1,4,'2024-01-18 21:15')

-- Bütün masadatalarını yanında o masaya edilmiş sifariş sayı ilə birlikdə select edən query

SELECT *,(SELECT COUNT(*) FROM Orders as O WHERE O.SeatId = S.Id) AS OrderCountForSeat 
FROM Seats AS S

-- Bütün yeməkləri o yeməyin sifariş sayı ilə select edən query

SELECT *,(SELECT COUNT(*) FROM Orders AS O WHERE O.MealId = M.Id) AS OrderCountForMeal 
FROM Meals AS M

-- Bütün sifariş datalarını yanında yeməyin adı ilə select edən query

SELECT MealId,SeatId,OrderDate,M.Name FROM Orders AS O 
RIGHT JOIN Meals AS M ON M.Id = O.MealId

-- Bütün sirafiş datalarını yanında yeməyin adı və masanın nömrəsi  ilə select edən query

SELECT M.Name,S.Number AS SeatNumber FROM Orders AS O 
LEFT JOIN Meals AS M ON M.Id = O.MealId
RIGHT JOIN Seats AS S ON S.Id = O.SeatId

-- Bütün masa datalarını yanında o masının sifarişlərinin ümumi məbləği ilə select edən query 

SELECT S.Number,SUM(M.Price) AS TotalAmount FROM Orders AS O  
LEFT JOIN Meals AS M ON M.Id = O.MealId
RIGHT JOIN Seats AS S ON S.Id = O.SeatId
GROUP BY S.Number

-- 1-idli masaya verilmis ilk sifarişlə son sifariş arasında neçə saat fərq olduğunu select edən query

SELECT DATEDIFF(Hour,MIN(O.OrderDate), MAX(O.OrderDate)) AS DateDifference 
FROM Orders AS O WHERE O.SeatId = 1

-- ən son 30-dəqədən əvvəl verilmiş sifarişləri select edən query

SELECT * FROM Orders AS O WHERE DATEDIFF(MINUTE,O.OrderDate,GETDATE()) > 30

-- heç sifariş verməmiş masaları select edən query

SELECT * FROM Seats AS S LEFT JOIN Orders AS O ON S.Id = O.SeatId
WHERE O.SeatId IS NULL;

-- son 60 dəqiqədə heç sifariş verməmiş masaları select edən query

SELECT S.Number FROM Seats AS S LEFT JOIN Orders AS O ON S.Id = O.SeatId
WHERE O.SeatId IS NULL OR DATEDIFF(MINUTE, O.OrderDate, GETDATE()) > 60
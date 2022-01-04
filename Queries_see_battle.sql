create database  Seabattle
use Seabattle
go

create table Classes(Cod_cl int primary key,
 Name_cl varchar(30), 
 Type_cl char(2),
 Country varchar(20), 
 Numguns int,
 bore int, 
 displacement int)
 go

 Create table Ship( Cod_ships int primary key,
 name varchar(20),
 cod_cl int foreign key references Classes(Cod_cl) ON DELETE CASCADE, 
 launched int)
 go
 
 create table Battles( cod_battles int primary key, name varchar (20) , datas date)
 go

 create table Outcomes(
 Cod_ships int foreign key references Ship( Cod_ships ) ON DELETE CASCADE, 
cod_batles int foreign key references Battles(cod_battles  ) ON DELETE CASCADE, 
 Result varchar(10))
 go 

INSERT Classes Values(1,'Bismarck', 'bb', 'Germany', 8, 15, 42000)
INSERT Classes Values(2, 'Iowa', 'bb', 'USA', 9, 16, 46000)
INSERT Classes Values(3, 'Kongo', 'bc', 'Japan', 8, 14, 32000)
INSERT Classes Values(4, 'North California', 'bb', 'USA', 9, 16, 37000)
INSERT Classes Values(5, 'Renown', 'bc', 'Gt.Britain', 6, 15, 32000)
INSERT Classes Values(6, 'Revenge', 'bb', 'Gr.Britain', 8, 15, 29000)
INSERT Classes Values(7, 'Tennessee', 'bb', 'USA', 12, 14, 32000)
INSERT Classes Values(8, 'Yamato', 'bb', 'Japan', 9, 18, 65000)

 INSERT Ship VALUES(1,'California',7, 1921)
 INSERT Ship VALUES(2,'Haruna',3, 1915)
 INSERT Ship VALUES(3, 'Hiei',3, 1914)
 INSERT Ship VALUES(4, 'Iowa',2, 1943)
 INSERT Ship VALUES(5,'Kirishima',3, 1915)
 INSERT Ship VALUES(6, 'Kongo',3, 1913)
 INSERT Ship VALUES(7, 'Missouri',2, 1944)
 INSERT Ship VALUES(8, 'Musashi',8, 1942)
 INSERT Ship VALUES(9, 'New Jersey',2, 1943)
 INSERT Ship VALUES(10, 'North Carolina',4, 1941)
 INSERT Ship VALUES(11, 'Ramillies',6, 1917)
 INSERT Ship VALUES(12, 'Renown',5, 1916)
 INSERT Ship VALUES(13, 'Repulse',5, 1916)
 INSERT Ship VALUES(14, 'Resolution',6, 1916)
 INSERT Ship VALUES(15, 'Revenge',6, 1916)
 INSERT Ship VALUES(16, 'Royal Oak',6, 1916)
 INSERT Ship VALUES(17, 'Royal Sovereign',6, 1916)
 INSERT Ship VALUES(18, 'Tennessee',7, 1920)
 INSERT Ship VALUES(19, 'Washington',4, 1941)
 INSERT Ship VALUES(20, 'Wisconsin',2, 1924)
 INSERT Ship VALUES(21, 'Yamato',8, 1941)
 INSERT Ship VALUES(22, 'Bismarck', 1, 1939)

INSERT Battles VALUES(1, 'North Atlantic', '5-24-1941')
INSERT Battles VALUES(2, 'Guadalcanal', '11-15-1942')
INSERT Battles VALUES(3, 'North Cape', '12-26-1943')
INSERT Battles VALUES(4, 'Surigao Strait', '10-25-1944')

INSERT Outcomes VALUES (22, 1, ' Sunk')
INSERT Outcomes VALUES (1, 4, 'Ok')
INSERT Outcomes VALUES(11, 3, 'Ok')
INSERT Outcomes VALUES(8, 4, 'Sunk')
INSERT Outcomes VALUES(12, 1, 'Sunk')
INSERT Outcomes VALUES(16, 1, 'Ok')
INSERT Outcomes VALUES(2, 2, 'Sunk')
INSERT Outcomes VALUES(17, 1, 'Damaged')
INSERT Outcomes VALUES(15, 1, 'Ok')
INSERT Outcomes VALUES(11, 3, 'Sunk')
INSERT Outcomes VALUES(20, 2, 'Damaged')
INSERT Outcomes VALUES(18, 4, 'Ok')
INSERT Outcomes VALUES(19, 2, 'Ok')
INSERT Outcomes VALUES(10, 4, 'Ok')
INSERT Outcomes VALUES(21, 4, 'Sunk')

SELECT name
FROM Battles
WHERE datas < '11-26-43'

SELECT Name_cl
FROM Classes
WHERE displacement <= 38000

SELECT name
FROM Ship
WHERE launched >= 1921

SELECT Name_cl
FROM Classes
WHERE Country = 'USA' and Numguns > 7

SELECT Country
FROM Classes
WHERE Country not in ('Germany', 'USA') and Type_cl = 'bb'

SELECT Name_cl
FROM Classes
WHERE Country = 'USA' or Country = 'Japan' 

SELECT Country, Name_cl, Numguns
FROM Classes
WHERE Type_cl = 'bb'
UNION
SELECT Country, Name_cl, Numguns
FROM Classes
WHERE not Country = 'USA' and Numguns > 9

SELECT Name_cl AS '�������� ������'
FROM Classes
WHERE Country = 'USA'

SELECT Name_cl
FROM Classes
WHERE Numguns BETWEEN 6 AND 10

SELECT Ship.Name
FROM Ship, Outcomes
WHERE Ship.Cod_ships = Outcomes.Cod_ships and Result = 'Sunk' 

SELECT Ship.Name
FROM Ship, Outcomes, Battles
WHERE Ship.Cod_ships = Outcomes.Cod_ships and Battles.cod_battles = Outcomes.cod_batles and  Battles.name = 'North Atlantic'

SELECT Name
FROM Ship
WHERE launched BETWEEN 1925 AND 1945

Select*
FROM Ship
WHERE Ship.name LIKE 'R%'

Select*
FROM Classes
WHERE Classes.Name_cl LIKE '%North%'

Select*
FROM Battles
WHERE datas is null

SELECT DISTINCT Country
FROM Classes INNER JOIN Ship
ON Classes.Cod_cl = Ship.cod_cl
WHERE Ship.launched > 1940


SELECT Battles.name
FROM Battles, Outcomes, Ship
WHERE Battles.cod_battles = Outcomes.cod_batles
AND Outcomes.Cod_ships = Ship.Cod_ships
AND Ship.name like 'California'

SELECT Ship.name
FROM Classes, Ship
WHERE Classes.Cod_cl = Ship.cod_cl
AND Country like 'USA'

SELECT *
FROM Classes FULL OUTER JOIN Ship
ON Classes.Cod_cl = Ship.cod_cl
AND Country like 'USA'

SELECT Ship.name
FROM Classes, Ship
WHERE Classes.Cod_cl = Ship.cod_cl
AND Numguns > 9

SELECT Ship.name
FROM Classes, Ship
WHERE Classes.Cod_cl = Ship.cod_cl
AND Classes.Name_cl like 'Kongo'

SELECT Ship.name
FROM Classes JOIN Ship
ON Classes.Cod_cl = Ship.cod_cl
AND Classes.Name_cl like 'Kongo'

SELECT Ship.name, Outcomes.cod_batles, Outcomes.Result
FROM Ship LEFT OUTER JOIN Outcomes
ON Ship.Cod_ships = Outcomes.Cod_ships


SELECT Ship.name, Classes.Name_cl
FROM Ship RIGHT OUTER JOIN Classes
ON Ship.cod_cl = Classes.Cod_cl

SELECT C1.name
FROM Ship C1, Ship C2
WHERE C1.cod_cl = C2.cod_cl
AND C2.name like 'Resolution'
AND C1.name <> 'Resolution'

CREATE VIEW InfoShipView AS
    SELECT Classes.*, Ship.Cod_ships, Ship.name, Ship.launched
    FROM Classes INNER JOIN Ship
    ON Classes.Cod_cl = Ship.Cod_cl

SELECT * FROM InfoShipView

CREATE VIEW ShipOutcomesView AS
    SELECT InfoShipView.*, Outcomes.cod_batles, Outcomes.Result
    FROM InfoShipView INNER JOIN Outcomes
    ON InfoShipView.Cod_ships = Outcomes.Cod_ships

SELECT * FROM ShipOutcomesView

CREATE VIEW BattleShipView AS
    SELECT ShipOutcomesView.*, Battles.name AS BattleName, Battles.datas
    FROM ShipOutcomesView INNER JOIN Battles
    ON ShipOutcomesView.cod_batles = Battles.cod_battles

SELECT * FROM BattleShipView

--������� ���������� �������� � ������ ������ 
SELECT InfoShipView.Name_cl, COUNT(InfoShipView.Cod_ships) AS Count_Ships
FROM InfoShipView
GROUP BY InfoShipView.Name_cl

--� ��� ������ ��� ������ ������������ ������� sum, ��� ��� ��� ����� ��������, ������� ����� ���� �� ������� � ��� ���� �� �������. � ����� ������ ����� ���� ������ � ������, �� ����-�� ��� ���������� ����-�� ����������. ��� ��� � �� ����� ������ � sum, �� � ���� � ������������, �� �����������.

--������� �������� ����, ������� ����� ����� ���� � 1941 ����

SELECT Battles.name
FROM Battles
WHERE YEAR(datas) = 1941 

--������� ���������� ��������, ������������� � ����� Guadalcanal

SELECT BattleShipView.BattleName, COUNT(BattleShipView.Cod_ships) AS Count_Ships
FROM BattleShipView
WHERE BattleShipView.BattleName LIKE 'Guadalcanal'
GROUP BY BattleShipView.BattleName

--������� ��� ������ ������ ���������� �������� � ������ ������(���� ������). ���� ������ ����� ������� ��� ����������, ����� ������� ��� ������ ������ ���������� ������� � �������� � ���� �������.

SELECT InfoShipView.Country, InfoShipView.Name_cl, COUNT(InfoShipView.Cod_ships) AS Count_Ships
FROM InfoShipView
GROUP BY InfoShipView.Country, InfoShipView.Name_cl

--������� �������� �����, � ������� ��������� ���������� ������� ������ ������

SELECT Classes.Country, COUNT(Classes.Cod_cl) AS Num_classes
FROM Classes
GROUP BY Classes.Country
HAVING COUNT(Classes.Cod_cl) > 1
--�� �������� ����� HAVING ����� ����� ������������ ��� ����� GROUP BY, ��-�� ���� ����� ����������� ��������������� �� �� ���� ����.
--� ��� ���� ������ ���� ������������ � ������������� HAVING ��� ����� GROUP BY. �, �������, ���� ������� ��������: ���������� ��������� �������� � ������, ��� ����������� ����� 5 ��������, �� ����-�� ����������� ����� ������ ����� �����.

--������������� ������ �� ���������� ��������

SELECT InfoShipView.Name_cl, COUNT(InfoShipView.Cod_ships) AS Num_Ships
FROM InfoShipView
GROUP BY InfoShipView.Name_cl
ORDER BY COUNT(InfoShipView.Cod_ships) DESC

--������ �� ���������� ����� ������ � �������
--�������� ���������� � ����� ������, ������� ����� �������� - Anime, ��� - bb, ������ ������������� - USA, ���������� ������ - 7, ������� ��������� - 17 � ������������� - 45 000
INSERT INTO Classes (Cod_cl, Name_cl, Type_cl, Country, Numguns, bore, displacement)
VALUES(9, 'Anime', 'bb', 'USA', 7, 16, 45000)

--������ �� ���������� ����� ������ �� ����������� ������� � �������� ������������ ��������
--�������� ���������� � ����� ����� Dos alarzis, ������� ���� ��������� � ���� ����, ��� � Guadalcanal
INSERT INTO Battles(cod_battles, name, datas)
VALUES ( 5, 'Dos alarzis', (SELECT datas FROM Battles WHERE name LIKE 'Guadalcanal'))


--��������� ���������� ������ ������ Bismarck �� 3. ���� ������ ����� ����� ����, ��� ��� �������� ���� ������������� ������ Bismark, � ���������� ������� ��� ���� �������� ����� ������ ���� ��������� ���������� ������ �� 3
UPDATE Classes
SET Numguns = Numguns + 3
WHERE Classes.Name_cl LIKE 'Bismarck'

--�, �������, ���� ��������� ������ � ��� where, �� ��� ������������� ��������� � ��� ������. ����-�� ���������� �������� �����-�� ������ ����� ��� ���� �������, �� � �������� ������� � ������.
--��������� ������������� �� 3 000 ���� ������� ��������
UPDATE Classes
SET displacement = displacement + 3000

--��� ���� �� ������� ������� ���������� � ��������, ������� ���� ���������. �� ��� ��� ������� ship ��������� � ����� � ������� ���������(� �������� ��������), �� ��� ������� ������� ����� ������.

CREATE VIEW Classes_count AS
    SELECT Classes.Country, Classes.Name_cl, COUNT(Ship.Cod_ships) AS Num_ship
    FROM Classes INNER JOIN Ship
    ON Classes.Cod_cl = Ship.Cod_cl
	GROUP BY Classes.Country, Classes.Name_cl

	SELECT * FROM InfoShipView

	SELECT InfoShipView.name, InfoShipView.Name_cl, InfoShipView.launched
	FROM InfoShipView
	WHERE InfoShipView.Country like 'USA'

	SELECT InfoShipView.name, InfoShipView.Name_cl, InfoShipView.launched
	FROM InfoShipView
	WHERE InfoShipView.Type_cl like 'bb'

	SELECT Name_cl, Num_ship
	FROM Classes_count
	GROUP BY Name_cl, Num_ship
	ORDER BY Num_ship DESC

	go


	SET IMPLICIT_TRANSACTIONS OFF
	select IIF(@@OPTIONS & 2 = 0, 'OFF', 'ON')


	SET IMPLICIT_TRANSACTIONS ON
	select IIF(@@OPTIONS & 2 = 0, 'OFF', 'ON')

	GO  
	
BEGIN DISTRIBUTED TRANSACTION;  

UPDATE Classes SET Numguns += 2 WHERE Name_cl like 'Bismarck'

use SeaBattles_test
UPDATE Classes SET Numguns += 2 WHERE Name_cl like 'Kongo'

COMMIT TRANSACTION;  
GO  

CREATE TABLE aaa (cola int) -- 0-� �������

BEGIN TRAN -- 1-� �������
INSERT INTO aaa VALUES (111)

BEGIN TRAN -- 2-� �������
INSERT INTO aaa VALUES (222)

BEGIN TRAN -- 3-� �������
INSERT INTO aaa VALUES (333)

SELECT * FROM aaa

SELECT '����������� ���������', @@TRANCOUNT ROLLBACK TRAN

SELECT * FROM aaa -- ����� �� 0-� �������

SELECT '����������� ����������', @@TRANCOUNT 

--���� ������ ������� �������� - ��������������. � ��� ����� ����� �������������� ����������, ��� ��� �� ���� ������ ���� �� ���� ����������, �� �� �������� � � �� �������.
--�� � �� �� ������� ��������� �������� ����������, ����� �� ������, ��� � ���� �� ������. �� ��� ����-�� ����� ��������������. ���� ���� ���� ��� �����������, � ����� �� �� ������ �������� ������ 


--���������� �� ��������� ������ Yamato. �� ������ ��������� � ������ � ����� ������
-- ������ ����������
BEGIN TRANSACTION
    UPDATE Classes
        SET Numguns += 1
        WHERE Name_cl like 'Yamato'

    IF (@@error <> 0)
        -- �������� ����������, ���� ���� ������
        ROLLBACK
    
    UPDATE Classes
        SET bore += 2
        WHERE Name_cl like 'Yamato'
    
    IF (@@error <> 0)
        ROLLBACK
-- ���������� ����������
COMMIT

--� ���� bb(���������) ��������� ������������� �� 3000, � � bc (�� ����� ���) ��������� ������������� �� 3000
BEGIN TRANSACTION
    UPDATE Classes
        SET displacement += 3000
        WHERE Type_cl LIKE 'bb'

    IF (@@error <> 0)
        -- �������� ����������, ���� ���� ������
        ROLLBACK
    
   UPDATE Classes
        SET displacement -= 3000
        WHERE Type_cl LIKE 'bc'
    
    IF (@@error <> 0)
        ROLLBACK
-- ���������� ����������
COMMIT

--� �������� ������� ���������� ���� �������� � ������ �������� �������������

CREATE VIEW InfoShipView AS
    SELECT Classes.*, Ship.Cod_ships, Ship.name, Ship.launched
    FROM Classes INNER JOIN Ship
    ON Classes.Cod_cl = Ship.Cod_cl

--��� ��� sql ��� ������ ���������� ����� �������� ������ CREATE. ������� �������� VIEW ����� ������� ������� �����������

GO  
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE ;  
GO  
EXEC sp_configure 'recovery interval', 3 ;  
GO  
RECONFIGURE;  
GO  
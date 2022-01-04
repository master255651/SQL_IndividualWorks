CREATE DATABASE Cafe
use Cafe

CREATE TABLE bliuda(
    cod_bl int NOT NULL,
	name_bl varchar(35),
	cod_tipa int,
	gramaj int,
	price int,
	sostav varchar(100)
)

CREATE TABLE menu(
    datam Date,
	cod_bl int
)

CREATE TABLE tipbl(
    cod_tipa int NOT NULL,
	name_tipa varchar(20)
)

CREATE TABLE zakaz(
    n_sciota int,
	dataz date,
	cod_bl int,
	col_pr int
)

ALTER TABLE bliuda
ADD PRIMARY KEY (cod_bl)

ALTER TABLE tipbl
ADD PRIMARY KEY (cod_tipa)

ALTER TABLE bliuda
ADD FOREIGN KEY (cod_tipa) REFERENCES tipbl(cod_tipa)

ALTER TABLE menu
ADD FOREIGN KEY (cod_bl) REFERENCES bliuda(cod_bl)

ALTER TABLE zakaz
ADD FOREIGN KEY (cod_bl) REFERENCES bliuda(cod_bl)

Insert into tipbl values (10,'Holodnie bliuda')
go
Insert into tipbl values (11,'Salati')
go
Insert into tipbl values (12,'Goreacie bliuda')
go
Insert into tipbl values (13,'Supi')
go
Insert into tipbl values (14,'Gratarnie bliuda')
go
Insert into tipbl values (15,'Bliuda iz ribi')
go
Insert into tipbl values (16,'Bliuda iz goveadini')
go
Insert into tipbl values (17,'Bliuda iz svinini')
go
Insert into tipbl values (18,'Bliuda iz ptiti')
go
Insert into tipbl values (19,'Bliuda iz iaut')
go
Insert into tipbl values (20,'Muchnie bliuda')
go
Insert into tipbl values (21,'Bliuda iz ovoshei')
go
Insert into tipbl values (22,'Garniri')
go
Insert into tipbl values (23,'Sladkie bliuda')
go
Insert into tipbl values (24,'Goreacie napitki')
go
Insert into tipbl values (25,'Kokteili')
go
Insert into tipbl values (26,'Spirtnoe')
go
Insert into tipbl values (27,'Shokolad')
go
Insert into bliuda values (1001,'Kanape s ciornoi ikroi',10,250,25,'---')
go
Insert into bliuda values (1002,'Kanape s krasnoi ikroi',10,400,27,'...')
go
Insert into bliuda values (1003,'Ositrina s limonom',10,250,120,'...')
go
Insert into bliuda values (1004,'Selid s maslinami',10,400,60,'...')
go
Insert into bliuda values (1008,'Assorti iz svezhih ovoshei',11,400,51,'...')
go
Insert into bliuda values (1101,'Ot shef-povara',11,400,25,'...')
go
Insert into bliuda values (1105,'Greceskii',11,300,29,'...')
go
Insert into bliuda values (1107,'Iz svezhih ovoshei',11,300,24,'...')
go
Insert into bliuda values (1201,'Julien iz ptiti',12,200,35,'...')
go
Insert into bliuda values (1202,'Julien iz kurinoi peceni',12,200,35,'...')
go
Insert into bliuda values (1304,'Okroshka',13,200,20,'...')
go
Insert into menu values ('2019-11-16',1001)
go
Insert into menu values ('2020-10-13',1101)
go

Insert into menu values ('2020-11-15',1201)
go
Insert into menu values ('2020-11-15',1202)
go
Insert into menu values ('2020-11-15',1105)
go
Insert into menu values ('2020-11-15',1107)
go


Insert into menu values ('2015-03-18',1008)
go
Insert into menu values ('2010-01-02',1105)
go
Insert into menu values ('2011-05-12',1201)
go
Insert into menu values ('2012-12-25',1202)
go
Insert into menu values ('2011-04-28',1003)
go
Insert into menu values ('2009-01-06',1304)
go
Insert into menu values ('2013-07-18',1002)
go
Insert into menu values ('2010-01-12',1105)
go
Insert into zakaz values ('10010001','2019-11-16',1001,2)
go
Insert into zakaz values ('10123453','2019-12-11',1004,3)
go
Insert into zakaz values ('10352535','2019-11-16',1105,4)
go
Insert into zakaz values ('10040001','2012-12-25',1202,2)
go
Insert into zakaz values ('10011201','2011-04-28',1003,1)
go
Insert into zakaz values ('10352530','2019-11-16',1107,2)
go


--Создаю переменную табличного типа, в которую запишу блюда для завтрешнего дня
--Вы просили создавать меню на завтра из меню, которое было на сегодня + новые блюда
--Я так и сделал, сначала копирую блюда с прошлого меню, а потом добавляю новые

DECLARE @Bliuda_Next_Day Table (Cod_bliuda int NOT NULL, Name_bliuda varchar(30) )

INSERT INTO @Bliuda_Next_Day (Cod_bliuda, Name_bliuda)
SELECT menu.cod_bl, name_bl 
FROM menu INNER JOIN bliuda
ON menu.cod_bl = bliuda.cod_bl
WHERE datam = CONVERT (date, GETDATE())

INSERT INTO @Bliuda_Next_Day (Cod_bliuda, Name_bliuda)
	VALUES 
	(1001,'Kanape s ciornoi ikroi'),
	(1002,'Kanape s krasnoi ikroi'),
	(1003,'Ositrina s limonom'),
	(1105,'Greceskii'),
	(1304,'Okroshka')

--Таблица с блюдами на завтрешее меню готова. Осталось заполнить таблицу меню
--Так как при вставке информации могут быть ошибки, то я делаю через транзакцию. Дабы сохранить целостность и правильность бд

BEGIN TRANSACTION

PRINT 'Создаётся меню на следующий день, ожидайте...'

--Использую конструкцию try catch для обработки исключений 
BEGIN TRY
--Вставялю информацию из моей временной таблицы в таблицу меню на следующий день. Использую функцию GETDATE()+1
INSERT INTO menu(datam, cod_bl)
SELECT CONVERT (date, GETDATE() + 1), Cod_bliuda
FROM @Bliuda_Next_Day
raiserror('Вымышленная ошибка', 16, 1)
--Если всё прошло успешно, то пишу об этом пользователю и делаю commit транзакции
PRINT 'Информация о меню на следующий день была успешно записана...'
COMMIT
END TRY

--Если всё же что-то пошло не так, то переходим в тело catch
BEGIN CATCH
--Пишу, что при выполнении произошла ошибка, а также пишу номер ошибки

PRINT 'Создание меню на следующий день не было завершнено, ошибка: ' + ERROR_MESSAGE()
--Так как данные либо не были внесены, или были внесенны некоректно, то делаю ROLLBACK
ROLLBACK
END CATCH

SELECT * FROM menu
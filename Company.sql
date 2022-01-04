CREATE Database Firma

Use master


Create table Rabotnik ( CodRabotnika int primary key check (CodRabotnika > 0), FIO_Rabotnika varchar(40) default 'No_name', Prof_dopusk_rabotnika varchar(40) default 'No_name', Telefon_rabotnika char(12) default '+373xxxxxxxx' )

Create table Zakazcik ( CodZakazcika int primary key check (CodZakazcika > 0), FIO_Zakazcika varchar(40) default 'No_name', Telefon_zakazcika char(12) default '+373xxxxxxxx', Ulita_Zakazcika varchar(40) default 'No_name', Nm_doma_zakazcik int default 0, Nr_kvartiri_zakazcika int default 0)

Create table  Dogovor ( Cod_Dogovora int primary key check (Cod_Dogovora > 0), CodZakazcika int foreign key references Zakazcik (CodZakazcika) ON DELETE CASCADE, Nomer_Dogovora char(6), Nacalo_remonta date, Konet_remonta date, Price int default 0, Model varchar(20) default 'No_model', Garantiinii_srok int default 0, Tip_remonta varchar(40) default 'No_tip')

Create table Jurnal ( Cod_Dogovora int primary key references Dogovor(Cod_Dogovora) ON DELETE CASCADE check (Cod_Dogovora > 0) , CodRabotnika int foreign key references Rabotnik(CodRabotnika)ON DELETE CASCADE )

Create Index Fio_Rabotnika on Rabotnik( FIO_Rabotnika )

Create Index Prof_dopusk on Rabotnik ( Prof_dopusk_rabotnika )

Create Index Fio_zakazcika on Zakazcik ( FIO_Zakazcika )

Create Index Telefon_zakazcik on Zakazcik ( Telefon_zakazcika )

Create Index Nacalo_remonta on Dogovor ( Nacalo_remonta )

INSERT Rabotnik Values(1, 'Starenco', 'Programmer', '+37369785402')
INSERT Rabotnik Values(2, 'Kojocaru', 'Technician', '+37378584585')

INSERT Zakazcik Values(1, 'Russov', '+37378584585', 'Dragan Maria', 12, 45)
INSERT Zakazcik Values(2, 'Eranosean', '+37379854485', 'Petru Zadnipru', 32, 11)
INSERT Zakazcik Values(3, 'Plamadeala', '+37360254585', 'Sarmisegetuza', 78, 77)
INSERT Zakazcik Values(4, 'Ersov', '+37378451236', 'Grigore Vieru', 12, 72)

INSERT Dogovor Values(1, 1, 'N-3245', '2020-05-02', '2020-05-06', 1200, 'TP-20', 2, 'Windows_programs')
INSERT Dogovor Values(2, 2, 'N-7896','2020-04-25', '2020-05-08', 2500, 'Lwenovo2000', 3, 'Technical_REPAIR')
INSERT Dogovor Values(3, 3, 'N-3455','2020-05-14', '2020-05-18', 788, 'Apple_vs100', 1, 'Technical_REPAIR')
INSERT Dogovor Values(4, 3, 'N-7139','2020-05-17', '', 2500, 'Lwenovo2000', 3, 'Windows_programs')
INSERT Dogovor Values(5, 1, 'N-9317','2020-10-02', '2020-10-05', 200, 'JP-20', 2, 'Windows_programs')
INSERT Dogovor Values(6, 1, 'N-1754','2020-10-22', '2020-10-24', 2500, 'ASUS-P16', 1, 'Technical_REPAIR')
INSERT Dogovor Values(7, 1, 'N-3578','2020-11-10', '', 7820, 'Gigabite-M34', 1, 'Technical_REPAIR')
INSERT Dogovor Values(8, 1, 'N-1111','2020-12-05', '2020-12-10', 1000, 'ASUS-RockSuper', 1, 'Technical_REPAIR')

INSERT Jurnal Values(1, 1)
INSERT Jurnal Values(2, 2)
INSERT Jurnal Values(3, 2)
INSERT Jurnal Values(4, 1)
INSERT Jurnal Values(5, 1)
INSERT Jurnal Values(6, 1)
INSERT Jurnal Values(7, 1)

//������ �������������, ������� ������ �� ���� ������, � ������ ������, ��� ����������� �������� ����� �������������� ����������,
��� � ���� ������� ������ ����������� ���������� �� ������������.

CREATE VIEW Rabotnik_Jurnal AS
SELECT Rabotnik.*, Jurnal.Cod_Dogovora
FROM Rabotnik INNER JOIN Jurnal
ON Rabotnik.CodRabotnika = Jurnal.CodRabotnika


CREATE VIEW Rabotnik_Dogovor AS
SELECT Dogovor.*, Rabotnik_Jurnal.CodRabotnika, Rabotnik_Jurnal.FIO_Rabotnika, Rabotnik_Jurnal.Prof_dopusk_rabotnika, Rabotnik_Jurnal.Telefon_rabotnika
FROM Dogovor INNER JOIN Rabotnik_Jurnal
ON Rabotnik_Jurnal.Cod_Dogovora = Dogovor.Cod_Dogovora


CREATE VIEW Rabotnik_Dogovor_Zakazcik AS
SELECT Rabotnik_Dogovor.*, Zakazcik.FIO_Zakazcika, Zakazcik.Telefon_zakazcika, Zakazcik.Ulita_Zakazcika, Zakazcik.Nm_doma_zakazcik, Zakazcik.Nr_kvartiri_zakazcika
FROM Rabotnik_Dogovor INNER JOIN Zakazcik
ON Rabotnik_Dogovor.CodZakazcika = Zakazcik.CodZakazcika

//������� ��� ��������� � ���������� �������, ������� �� ��������.
SELECT FIO_Rabotnika, COUNT(Cod_Dogovora) AS NumDogovors
FROM Rabotnik_Jurnal 
GROUP BY FIO_Rabotnika

//������� ����� ��� ����������, � ������� ���� ������������ ������
SELECT FIO_Zakazcika
FROM Zakazcik INNER JOIN Dogovor
ON Zakazcik.CodZakazcika = Dogovor.CodZakazcika
WHERE Konet_remonta like '1900-01-01'

//����� ��� ����������, ������� ��������� ������ � ����� Windows_programs, �� ���� ������ ������������ �����������.
SELECT Distinct FIO_Rabotnika
FROM Rabotnik_Jurnal
WHERE  Cod_Dogovora IN
(
	SELECT Cod_Dogovora
	FROM Dogovor
	WHERE LOWER(Tip_remonta) like 'windows_programs'
)

//����� ���������� � ���������� �� ��� ���
SELECT *
FROM Rabotnik
WHERE FIO_Rabotnika like 'Starenco'

//������� ���� ������������� (�����, ������� ����� ������ ����������� �����������)
SELECT FIO_Rabotnika, Telefon_rabotnika 
FROM Rabotnik
WHERE Prof_dopusk_rabotnika like 'Programmer'

//����� ���������� � ��������� �� ��� ��� ��� ��������
SELECT *
FROM Zakazcik
WHERE FIO_Zakazcika like 'Russov'

SELECT *
FROM Zakazcik
WHERE Telefon_zakazcika like '+37378584585'

//����� ���������� � ������, � ������������ � �������� �����
SELECT Rabotnik_Dogovor_Zakazcik.FIO_Rabotnika, Rabotnik_Dogovor_Zakazcik.FIO_Zakazcika, Rabotnik_Dogovor_Zakazcik.Garantiinii_srok, Rabotnik_Dogovor_Zakazcik.Konet_remonta, Rabotnik_Dogovor_Zakazcik.Nacalo_remonta, Rabotnik_Dogovor_Zakazcik.Model, Rabotnik_Dogovor_Zakazcik.Price, Rabotnik_Dogovor_Zakazcik.Prof_dopusk_rabotnika, Rabotnik_Dogovor_Zakazcik.Telefon_rabotnika, Rabotnik_Dogovor_Zakazcik.Telefon_zakazcika, Rabotnik_Dogovor_Zakazcik.Tip_remonta, Rabotnik_Dogovor_Zakazcik.Ulita_Zakazcika
FROM Rabotnik_Dogovor_Zakazcik
WHERE Rabotnik_Dogovor_Zakazcik.Nacalo_remonta like '2020-04-25'

//����� ���������� � ������, ������� ���� ������� ����������� ����������
SELECT Rabotnik_Dogovor_Zakazcik.FIO_Rabotnika, Rabotnik_Dogovor_Zakazcik.FIO_Zakazcika, Rabotnik_Dogovor_Zakazcik.Garantiinii_srok, Rabotnik_Dogovor_Zakazcik.Konet_remonta, Rabotnik_Dogovor_Zakazcik.Nacalo_remonta, Rabotnik_Dogovor_Zakazcik.Model, Rabotnik_Dogovor_Zakazcik.Price, Rabotnik_Dogovor_Zakazcik.Prof_dopusk_rabotnika, Rabotnik_Dogovor_Zakazcik.Telefon_rabotnika, Rabotnik_Dogovor_Zakazcik.Telefon_zakazcika, Rabotnik_Dogovor_Zakazcik.Tip_remonta, Rabotnik_Dogovor_Zakazcik.Ulita_Zakazcika
FROM Rabotnik_Dogovor_Zakazcik
WHERE Rabotnik_Dogovor_Zakazcik.FIO_Zakazcika like 'Russov'

//����� �����, ������� ��������� �������� �� ����������� ����
SELECT FIO_Rabotnika, SUM(Price) AS Sum_price
FROM Rabotnik_Dogovor
WHERE Konet_remonta  BETWEEN '2020-04-20' AND '2020-05-20'
GROUP BY FIO_Rabotnika

--���������, ������� ����� ������������ ���������� �������, ������� �������� ������� �� �����.
--����� ������� � ���� ��������� � ��� ����������, ��� ��� �� ������������ �������� ���������� � ����������� �� ���������� �������, ������� ��� ���������.

GO
CREATE PROCEDURE Count_Zakazi
@FIO_Rabotnika as varchar(30), @First_date as date,  @Second_date as date
AS
SELECT Count(Cod_Dogovora) AS '���������� ������� �� �����'
FROM Rabotnik_Dogovor
WHERE FIO_Rabotnika = @FIO_Rabotnika AND Konet_remonta BETWEEN @First_date AND @Second_date
Go

--��� �������, �������� ��������� ��� ��������� Starenco �� ������� �����.
EXECUTE Count_Zakazi 'Starenco', '2020-10-01', '2020-10-30'

--��� ����� ���������� ���� �� ���������� ������ ���������
GRANT EXECUTE ON Count_Zakazi TO Buhgalter

--���������, ������� ����� �������� ���������� � ��� �� ��������� �������.
--������ � ���� ��������� � ����������� ���������, ������� ����� ������������ � ��������� �� ����������� ������

GO
CREATE PROCEDURE Nezakoncenii_Zakazi
AS
SELECT Cod_Dogovora, FIO_Zakazcika, FIO_Rabotnika, Nacalo_remonta, Tip_remonta, Model
FROM Rabotnik_Dogovor_Zakazcik
WHERE Konet_remonta like '1900-01-01'
--���� 1900-01-01 �������� Default - ��� ������, ��� ����� ��� �� ��� �������.
Go

--�������� ���������
EXECUTE Nezakoncenii_Zakazi

--��� ����� ��������� ���� �� ���������� ������ ���������
GRANT EXECUTE ON Nezakoncenii_Zakazi TO Meneger

--���������, ������� ������� ����� ����� �� ����������� ������. ���� �������� � �������� ����������
GO
CREATE FUNCTION Sum_Price (@First_date date,  @Second_date date)
RETURNS varchar(100)
	BEGIN
		DECLARE @Sum_Price DECIMAL(7, 2)
		SET @Sum_Price =
		(
			SELECT SUM(Price) AS Sum_price
			FROM Rabotnik_Dogovor
			WHERE Konet_remonta BETWEEN @First_date AND @Second_date
		)
		RETURN '�� ������ �� ' + CONVERT(varchar(15), @First_date) + ' �� ' + CONVERT(varchar(15), @Second_date) 
		+ ' ����� ���������� ' + CONVERT(varchar(15), @Sum_Price) + ' ���.'
	END
GO
PRINT [dbo].[Sum_Price] ('2020-05-01', '2020-05-30')


--����� ������� � ���� ��������� � ��� ����������. ������� ����� ������ ���������� ������� � ������� �����. � ����� ������������ � ���������

--��� ����� ��������� ���� �� ���������� ������ ���������
GRANT EXECUTE ON Sum_Price TO Buhgalter


--�������, ������� ����� ������������ ���������� �������, ������� �������� ������� �� �����.
--��� �������� � ���� ����� �������� � �������� ����������.
GO
CREATE FUNCTION Count_Zakaz(@FIO_Rabotnika as varchar(30), @First_date as date,  @Second_date as date)
	RETURNS varchar(100)
	BEGIN
		DECLARE @CountZakazi int
		SET @CountZakazi = (
			SELECT Count(Cod_Dogovora)
			FROM Rabotnik_Dogovor
			WHERE FIO_Rabotnika = @FIO_Rabotnika AND Konet_remonta BETWEEN @First_date AND @Second_date)
		RETURN '�� ������ �� ' + CONVERT(varchar(25), @First_date) + ' �� ' + CONVERT(varchar(25), @Second_date) 
		+ ' �������� ' + @FIO_Rabotnika + ' �������� ' + CONVERT(varchar(25), @CountZakazi) + ' ������.'
	END
GO

--�������� ������ ������� ��� ��������� Starenco �� ������� �����
SELECT [dbo].[Count_Zakaz] ('Starenco', '2020-10-01', '2020-10-30')


--�������, ������� ����� �������� ��������� ����������, � ������� ����� �������� ������ � ������������ �������.
GO
CREATE FUNCTION Zakazi_Rabotnik (@FIO_Rabotnika as varchar(30))
    RETURNS TABLE
		AS RETURN (
			SELECT FIO_Rabotnika, Prof_dopusk_rabotnika, Nomer_Dogovora, Nacalo_remonta, Konet_remonta, Price, Model, Tip_remonta
			FROM Rabotnik_Dogovor
			WHERE UPPER(FIO_Rabotnika) like UPPER(@FIO_Rabotnika)
		)
GO

--��������� ������ �������
SELECT * FROM Zakazi_Rabotnik('Starenco')


--� ������� Zakazcik �������� ���������� �� �������� ����������. ���� � ��� � ���� ��� ��������� ��� ������ ���������� �������, �� �� ���� ��������� � �����. ��, �� ������ ������� ����� �������� ������� (��������� � �����) ���������, � �������� ���� ������� � ������. ������� � ������ ������� �� �������� �� ������� Zakazcik. ��� �������� ���� ���������, ���� �� � ����� �������� �������� ������.
--�������, ������� �� ���� ������� ���������� � ���������, ���� � ����� �������� ���� �������� ������ (��������).
GO
ALTER TRIGGER DeleteZakazcik
	ON Zakazcik 
	AFTER DELETE
AS BEGIN
	
			PRINT '� ����� ��������� ���� �������� ������, �� �� ������ ��� �������!'
			ROLLBACK
	
END
GO

DELETE FROM Zakazcik WHERE CodZakazcika = 4
SELECT * FROM Zakazcik
--�������, ������� �� ��� ����������� ���� ��������� ������� ��������, ����� ���� ��������� ���� > ��� ���� ������ �������.
--��� ��� ����� ��� ����� ���������� ������. �������� ���� ������ �������� 11 �����, � ���������� 5 ����� ���� �� ������ � ����.

GO
CREATE TRIGGER Set_Konet_remonta
	ON Dogovor
	AFTER UPDATE
AS BEGIN
	DECLARE @Konet_remonta date
	DECLARE @Nacalo_remonta date

	SET @Konet_remonta = (
		SELECT Konet_remonta
		FROM inserted
	)

	SET @Nacalo_remonta = (
		SELECT Nacalo_remonta
		FROM inserted
	)

	IF(DATEDIFF(DAY, @Nacalo_remonta, @Konet_remonta) > 0)
	BEGIN
		PRINT '���� ��������� ������� ���� ������� ��������...'
	END

	ELSE BEGIN
		PRINT '���� ��������� ������� �� ����� ���� ������ ���� ������ �������. ���������� �� ����� ��������!'
		ROLLBACK
	END

SELECT * FROM Dogovor

UPDATE Dogovor
SET Konet_remonta = '2020-10-7'
WHERE Cod_Dogovora = 7

--��� ���� ������ �������� ����������, ������� � ��� ����� ���������� ����������� ���������� (���������� � ����������).
--�������� ����� � ��� ���������� ��������� ����� �������(���������). ����� ����� ���� �������, � ���� ��� ����� ��������� ��
-- 100 ����� �������. ������� � ����� ������� �������� ���������, ������� �� �������� ��������� ����� �������.
--� ���� ���� ������� JURNAL, ��� ������ � ���� ������ ����. ����� ������������� ������� ���� ����������. ������� � ������
--��������� �� ��� ������� JURNAL �� INSERT, ����� ����� ���� �� ������� ����, � ������� � �������� ���������� ���������� ��������.

GO
CREATE PROCEDURE Insert_Jurnal(@FIO_Rabotnika varchar(30), @Nomer_Dogovora char(6)) 
AS BEGIN 
	DECLARE @Cod_Dogovora INT 
	SET @Cod_Dogovora = 
	( 
		SELECT Cod_Dogovora 
		FROM Dogovor 
		WHERE Nomer_Dogovora like @Nomer_Dogovora
	) 
	IF @Cod_Dogovora IS NULL 
	BEGIN 
		PRINT '�������� � ����� ������� �� ����������!' 
		RETURN 
	END 

	DECLARE @CodRabotnika INT 
	SET @CodRabotnika = 
	( 
		SELECT CodRabotnika 
		FROM Rabotnik 
		WHERE UPPER(FIO_Rabotnika) = UPPER(@FIO_Rabotnika) 
	) 
	IF @CodRabotnika IS NULL 
	BEGIN 
		PRINT '��������� � ����� ��� �� ����������!' 
		RETURN 
	END 
INSERT Jurnal VALUES(@Cod_Dogovora, @CodRabotnika) 
END 
GO 
SELECT * FROM Rabotnik 
SELECT * FROM Dogovor 
SELECT * FROM Jurnal 

EXEC Insert_Jurnal 'NetuTakogo', 'N-1111'

EXEC sp_addrole 'Rabotnik'
EXEC sp_addrole 'Meneger'
EXEC sp_addrole 'Vladelet_firmi'


GRANT SELECT ON Dogovor TO Rabotnik

GRANT SELECT, UPDATE ON Dogovor TO Meneger
GRANT SELECT, UPDATE ON Jurnal TO Meneger
GRANT SELECT ON Rabotnik TO Meneger
GRANT SELECT ON Zakazcik TO Meneger

GRANT SELECT, UPDATE, DELETE ON Jurnal TO Vladelet_firmi
GRANT SELECT, UPDATE, DELETE ON Dogovor TO Vladelet_firmi
GRANT SELECT, UPDATE, DELETE ON Zakazcik TO Vladelet_firmi
GRANT SELECT, UPDATE, DELETE ON Rabotnik TO Vladelet_firmi

create database Lybrary

use Lybrary

create table Author
(
cod_author int primary key not null,
name_author varchar(25),
surname_author varchar(25),
birthday_author date,
deathday_author date
)

create table Book
(
cod_book int primary key not null,
name_book varchar(50),
cod_author int FOREIGN KEY (cod_author) REFERENCES Author ON DELETE CASCADE,
year_book date,
genre varchar(20)
)

create table Reader
(
cod_reader int primary key not null,
name_reader varchar(30),
surname_reader varchar(30),
birthday_reader date,
adres_reader varchar(50),
--+373 78 85 45 85
telefon_reader char(12),
idnp_reader char(13)
)

create table Gets
(
cod_gets int primary key not null,
cod_book int FOREIGN KEY (cod_book) REFERENCES Book ON DELETE CASCADE,
cod_reader int FOREIGN KEY (cod_reader) REFERENCES Reader ON DELETE CASCADE,
date_gets date,
date_back date
)

INSERT Author VALUES (001, 'Aurel', 'Doinici', '1980-10-01', '')
INSERT Author VALUES (002, 'Dimitri', 'Cantemir', '1976-04-27', '2018-01-14')
INSERT Author VALUES (003, 'Mihai', 'Eminescu', '1879-12-12', '1940-04-30')


INSERT Book VALUES (001, 'Green Piece', 001, '2008-10-10', 'Fantastica')
INSERT Book VALUES (002, 'Number the Stars', 001, '2007-12-14', 'Comedia')
INSERT Book VALUES (003, 'The Chronicles of Narnia', 001, '2004-02-02', 'Fantastica')
INSERT Book VALUES (004, 'Winnie-the-Pooh', 002, '2017-09-24', 'Drama')
INSERT Book VALUES (005, 'Bridge to Terabithia', 001, '1920-12-11', 'Comedia')
INSERT Book VALUES (006, 'Coraline', 003, '1925-08-07', 'Fantastica')
INSERT Book VALUES (007, 'Black Beauty', 003, '2008-10-10', 'Fantastica')

INSERT Reader VALUES (001, 'Iurie', 'Srarenco', '01-07-2002', 'Stefan cel mare', '+37369874525', '2013458574521')
INSERT Reader VALUES (002, 'Gleb', 'Popsoi', '07-12-2002', 'Sarmisegetuza', '+37378541252', '2014784596451')
INSERT Reader VALUES (003, 'Igor', 'Russov', '04-02-2001', 'Vieru', '+37348851245', '2014789652412')

INSERT Gets VALUES (001, 001, 001, '2020-11-10', '2020-11-15')
INSERT Gets VALUES (002, 002, 001, '2020-11-20', '2020-11-23')
INSERT Gets VALUES (003, 002, 002, '2020-10-10', '2020-10-27')
INSERT Gets VALUES (004, 007, 001, '2020-11-22', '')
INSERT Gets VALUES (005, 005, 001, '2020-11-23', '')
INSERT Gets VALUES (006, 004, 001, '2020-11-23', '')

select * from Gets
delete from Gets WHERE cod_gets = 6

GO
CREATE TRIGGER GIVE_BOOK
	ON Gets
	AFTER INSERT
AS
	BEGIN
		DECLARE @NumBook INT
		SET @NumBook =
		(
			SELECT COUNT(*) - 1
			FROM Gets INNER JOIN inserted
			ON Gets.cod_reader = inserted.cod_reader
			WHERE Gets.date_back LIKE '1900-01-01' 
		)
		
		IF(@NumBook > 3)
		BEGIN
			PRINT 'The number of books taken is more than 3, you cannot take a book'
			ROLLBACK
		END

		ELSE
		BEGIN
			PRINT 'The book was taken by the reader'
		END
	END


GO
alter TRIGGER DELETE_READER
	ON Reader 
	INSTEAD OF DELETE
AS
BEGIN
	DECLARE @NumBook INT
		SET @NumBook =
		(
			SELECT COUNT(*)
			FROM Gets INNER JOIN deleted
			ON Gets.cod_reader = deleted.cod_reader
			WHERE Gets.date_back LIKE '1900-01-01' 
		)

	IF(@NumBook > 0)
	BEGIN
		PRINT 'You cannot delete a reader, he has unrendered books'
	END

	ELSE
	BEGIN
		DELETE FROM Reader WHERE cod_reader IN
		(
			SELECT cod_reader
			FROM deleted
		)
		PRINT 'The reader has been successfully deleted'
	END

END


DELETE FROM Reader WHERE cod_reader = 3

GO
CREATE LOGIN loginTest WITH PASSWORD = '12345',
CHECK_EXPIRATION = ON;

GO
GRANT VIEW SERVER STATE TO loginTest;

CREATE USER loginTest FOR LOGIN loginTest;  
GO  

GO
CREATE TRIGGER trigger_ConnectionLimit
    ON ALL SERVER WITH EXECUTE AS 'loginTest'
    FOR LOGON AS
    BEGIN
        IF ORIGINAL_LOGIN()= 'loginTest' AND
            (SELECT COUNT(*) FROM sys.dm_exec_sessions
                WHERE is_user_process = 1 AND
                      original_login_name = 'loginTest') > 1
            ROLLBACK;
    END; 
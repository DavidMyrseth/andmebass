create database autorentMyrseth;
use autorentMyrseth;

CREATE TABLE auto(
autoID int not null Primary key IDENTITY(1,1),
regNumber char(6) UNIQUE,
markID int,
varv varchar(20),
v_aasta int,
kaigukastID int,
km decimal(6,2)
);
SELECT * FROM auto


CREATE TABLE mark(
markID int not null Primary key IDENTITY(1,1),
autoMark varchar(30) UNIQUE
);

INSERT INTO mark(autoMark)
VALUES ('Ziguli');
INSERT INTO mark(autoMark)
VALUES ('Lambordzini');
INSERT INTO mark(autoMark)
VALUES ('BMW');
SELECT * FROM mark;

CREATE TABLE kaigukast(
kaigukastID int not null Primary key IDENTITY(1,1),
kaigukast varchar(30) UNIQUE
);
INSERT INTO kaigukast(kaigukast)
VALUES ('Automaat');
INSERT INTO kaigukast(kaigukast)
VALUES ('Manual');
SELECT * FROM kaigukast;

ALTER TABLE auto
ADD FOREIGN KEY (markID) REFERENCES mark(markID);
ALTER TABLE auto
ADD FOREIGN KEY (kaigukastID) REFERENCES kaigukast(kaigukastID);

CREATE TABLE klient(
klientiID int not null Primary key IDENTITY(1,1),
kliendiNimi varchar(50),
telefon varchar(20),
aadress varchar(50),
soiduKogemus varchar(30)
);

CREATE TABLE amet(
ametiID int not null Primary key IDENTITY(1,1),
markID int,
ametiNimi varchar(50),
FOREIGN KEY (markID) REFERENCES mark(markID)
);

CREATE TABLE tootaja(
tootajaID int not null Primary key IDENTITY(1,1),
tootajanimi varchar(50),
ametiID int,
FOREIGN KEY (ametiID) REFERENCES amet(ametiID)
);

CREATE TABLE rendiLeping(
lepingID int not null Primary key IDENTITY(1,1),
rendiAlgus date,
rendiLopp date,
klientiID int,
regNumber char(6),
rendiKestvus int,
hindKokku decimal(5,2),
tootajaID int,
FOREIGN KEY (klientiID) REFERENCES klient(klientiID),
FOREIGN KEY (regNumber) REFERENCES auto(regNumber),
FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID)
);


INSERT INTO mark(autoMark) VALUES ('Audi');
INSERT INTO mark(autoMark) VALUES ('Honda');

INSERT INTO kaigukast(kaigukast) VALUES ('Manuaal');
INSERT INTO kaigukast(kaigukast) VALUES ('Automaatne');
INSERT INTO kaigukast(kaigukast) VALUES ('Tiptronic');

INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km) 
VALUES 
('XY9876', 1, 'Sinine', 2012, 1, 1300.00),
('ZX5432', 2, 'Roheline', 2016, 2, 2600.85),
('MN1357', 3, 'Hall', 2019, 3, 3100.95),
('QP2468', 4, 'Punane', 2021, 4, 1600.30),
('LK8520', 5, 'Kollane', 2023, 5, 600.40);

INSERT INTO klient (kliendiNimi, telefon, aadress, soiduKogemus) VALUES
('Anna P', '59012345', 'Liivalaia', '4 aastat'),
('Oleg S', '59054321', 'Tartu mnt', '2 aastat'),
('Ivan R', '59067890', 'Pärnu mnt', '8 aastat'),
('Sergey N', '59023456', 'Narva mnt', '6 aastat'),
('Marina D', '59087654', 'Järvevana tee', '1 aasta');

INSERT INTO amet (markID, ametiNimi) VALUES
(1, 'Audi Eesti'),
(2, 'Honda Baltics'),
(3, 'Lada OÜ'),
(1, 'Porsche EST'),
(2, 'Volvo EE');

INSERT INTO tootaja (tootajanimi, ametiID) VALUES
('Nikita V', 1),
('Olga S', 2),
('Maksim T', 3),
('Elena L', 1),
('Viktor P', 2);

INSERT INTO rendiLeping (rendiAlgus, rendiLopp, klientiID, regNumber, rendiKestvus, hindKokku, tootajaID) VALUES
('2024-06-01', '2024-06-07', 1, 'XY9876', 6, 220.00, 1),
('2024-07-10', '2024-07-15', 2, 'ZX5432', 5, 180.00, 2),
('2024-08-05', '2024-08-12', 3, 'MN1357', 7, 270.00, 3),
('2024-09-01', '2024-09-08', 4, 'QP2468', 7, 320.00, 4),
('2024-10-01', '2024-10-10', 5, 'LK8520', 9, 370.00, 5);

select * from auto, mark, kaigukast
where mark.markID=auto.markID and kaigukast.kaigukastID=auto.kaigukastID

select * from auto
INNER JOIN mark ON mark.markID=auto.markID
INNER JOIN kaigukast ON kaigukast.kaigukastID=auto.kaigukastID

SELECT auto.regNumber, mark.autoMark, auto.varv, auto.v_aasta, kaigukast.kaigukast, auto.km FROM auto
JOIN mark ON auto.markID = mark.markID
JOIN kaigukast ON auto.kaigukastID = kaigukast.kaigukastID

SELECT auto.regNumber, kaigukast.kaigukast 
FROM auto 
INNER JOIN kaigukast 
ON auto.kaigukastID = kaigukast.kaigukastID;

SELECT auto.regNumber, mark.autoMark 
FROM auto 
INNER JOIN mark 
ON auto.markID = mark.markID;

SELECT rendiLeping.regNumber, tootaja.tootajanimi 
FROM rendiLeping 
INNER JOIN tootaja 
ON rendiLeping.tootajaID = tootaja.tootajaID;

SELECT COUNT(*) AS auto_arv, SUM(hindKokku) AS summaarne_maksumus 
FROM rendiLeping;

SELECT klient.kliendiNimi, auto.regNumber, auto.varv 
FROM rendiLeping 
INNER JOIN klient ON rendiLeping.klientiID = klient.klientiID
INNER JOIN auto ON rendiLeping.regNumber = auto.regNumber;

-- Käsk ei töötanud, kuna kasutajal pole tabelite kustutamise õigusi.
Create table test1(
number int);

drop table test1;

--1) Toiming 1 andmete lisamiseks Rendilepingi tabelisse:
CREATE PROCEDURE LisaRendileping(
    @p_rendiAlgus DATE,
    @p_rendiLopp DATE,
    @p_klientiID INT,
    @p_regNumber VARCHAR(6),
    @p_rendiKestvus INT,
    @p_hindKokku DECIMAL(5,2),
    @p_tootajaID INT
)
AS
BEGIN
    INSERT INTO rendileping (rendiAlgus, rendiLopp, klientiID, regNumber, rendiKestvus, hindKokku, tootajaID)
    VALUES (@p_rendiAlgus, @p_rendiLopp, @p_klientiID, @p_regNumber, @p_rendiKestvus, @p_hindKokku, @p_tootajaID);
END;

--2) toiming lepingu ID alusel kustutamiseks:
CREATE PROCEDURE KustutaRendileping(
    @p_lepingID INT
)
AS
BEGIN
    DELETE FROM rendileping WHERE lepingID = @p_lepingID;
END;

--3) Toiming 3 rendi lõpukuupäeva (rendiLopp) värskendamiseks lepingu ID järgi.
CREATE PROCEDURE UuendaRendiLopp(
    @p_lepingID INT,
    @p_uusRendiLopp DATE
)
AS
BEGIN
    UPDATE rendileping
    SET rendiLopp = @p_uusRendiLopp
    WHERE lepingID = @p_lepingID;
END;




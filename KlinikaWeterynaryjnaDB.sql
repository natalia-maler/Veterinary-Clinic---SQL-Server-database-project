-- Baza danych zosta³a zaprojektowana dla kliniki weterynaryjnej i s³u¿y do zarz¹dzania informacjami o w³aœcicielach zwierz¹t, pacjentach, 
-- wizytach, zabiegach oraz receptach. System umo¿liwia przechowywanie historii leczenia zwierz¹t, przypisywanie weterynarzy do wizyt oraz 
-- dokumentowanie wykonanych zabiegów i wypisanych leków.

USE master;
GO

--sprawdzenie czy baza istnieje 
IF EXISTS (SELECT *FROM sys.databases WHERE name = 'KlinikaWeterynaryjnaDB')
BEGIN

-- zamkniêcie po³¹czeñ do bazy
ALTER DATABASE KlinikaWeterynaryjnaDB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

-- usuniêcie bazy
DROP DATABASE KlinikaWeterynaryjnaDB;

END;
GO

-- tworzenie nowej bazy
CREATE DATABASE KlinikaWeterynaryjnaDB;
GO

-- wejœcie do bazy
USE KlinikaWeterynaryjnaDB;
GO 

/*Tabela przechowuje dane w³aœcicieli zwierz¹t. Zawiera informacje takie jak imiê, nazwisko, numer telefonu, adres e-mail oraz adres 
zamieszkania w³aœciciela.*/

CREATE TABLE Owners (
owner_id INT IDENTITY(1,1) PRIMARY KEY,
first_name NVARCHAR(30) NOT NULL,
last_name NVARCHAR(30) NOT NULL,
phone NVARCHAR(9) NOT NULL,
email NVARCHAR(30),  
city NVARCHAR(30) NOT NULL,
street NVARCHAR(30) NOT NULL,
postal_code CHAR(6) NOT NULL
);

INSERT INTO Owners (first_name, last_name, phone,email, city,street, postal_code ) VALUES
( 'Jan', 'Kowalski', '123456789', 'jan@gmail.com', 'Kraków', 'ul. D³uga 10', '30-011'),
( 'Anna', 'Nowak', '987654321', 'anna@gmail.com', 'Katowice', 'ul. Znajoma 5', '40-002'),
('Piotr', 'Zieliñski', '222111333',NULL, 'Kraków', 'ul. Szeroka 8', '30-111'), 
( 'Marzena', 'Mazur', '987654311', 'm.mazur12@wp.pl', 'Niepo³omice', 'ul. Polna 15', '35-102'),
( 'Ewelina', 'Wójcik', '123654321', 'ewelina.w@gmail.com', 'Kraków', 'ul. Krawiecka 88', '30-123'),
( 'Tomasz', 'Baran', '432154321',NULL,'Kraków', 'ul. Brzozowa 4', '31-112'),
( 'Robert', 'D¹browski', '121254321', 'r.dabrowski@onet.pl', 'Katowice', 'ul. Sosnowa 11', '40-111'),
( 'Katarzyna', 'Niewiadoma', '795132111', 'kat.niew@gmail.com', 'S³omniki', 'ul. Krakowska 22', '36-321'),
( 'Julia', 'Malarczyk', '771257327', NULL, 'Kraków', 'aleja 29 listopada 32', '31-452'),
( 'Adrian', 'Ma³ysz', '721357428', NULL, 'Zielonki', 'ul. Krakowskie Przedmieœcie 55', '32-078');

SELECT * FROM Owners;

/*Tabela Pets przechowuje informacje o zwierzêtach nale¿¹cych do w³aœcicieli. Zawiera dane takie jak imiê zwierzêcia, gatunek, rasa, 
data urodzenia, waga oraz p³eæ. Kolumna gender mo¿e przyjmowaæ tylko wartoœci: "samiec", "samica" lub "nieznana", 
a domyœlnie ustawiana jest wartoœæ "nieznana".*/

CREATE TABLE Pets (
animal_id INT IDENTITY(1,1) PRIMARY KEY,
name NVARCHAR(30) NOT NULL,
species NVARCHAR(20) NOT NULL,  
breed NVARCHAR(30) NULL,
birth_date DATE NULL,
weight DECIMAL(5,2),
gender NVARCHAR(10)  NOT NULL DEFAULT 'nieznana' CHECK (gender IN ('samiec','samica','nieznana')),
owner_id INT,
FOREIGN KEY (owner_id) REFERENCES Owners(owner_id)
);

INSERT INTO Pets (name, species, breed, birth_date, weight, gender,owner_id) VALUES
('Rex', 'pies', 'labrador', '2020-05-10', 30.5, 'samiec', 1),
('Mruczek', 'kot', 'dachowiec', NULL, 4.2, 'samiec', 2),
('Bella', 'pies', 'buldog', '2023-04-01', 12.0, 'samica', 1),
('Kropka', 'kot', 'perski', '2019-11-05', 3.8, 'samica', 3),
('Kruszynka', 'chomik', NULL,NULL,NULL, 'samica', 4),
('Cynamon', 'kot', 'dachowiec',NULL, 4.0, 'samiec', 5),
('Puszek', 'kot', 'ragdoll', '2024-05-12', 4.7, 'samiec', 6),
('Mamba', 'kot', 'bombajski', '2023-04-20', 4.0, 'samica', 6),
('Maks', 'pies',NULL,NULL, 11.0, 'samiec', 7),
('Kulka', 'chomik',NULL,NULL, 0.38, 'samica', 8),
('Pasztecik', 'chomik',NULL,NULL,0.45,'samiec',8),
('Azor', 'pies','kundel',NULL, 15.32, 'samiec', 9);

-- tu przyk³ad gdy p³eæ nieznana
INSERT INTO Pets (name, species, breed, birth_date, weight,owner_id) VALUES
('Nela', 'pies','maltañczyk','2025-04-10', 3.3,10);


/*Tabela przechowuje informacje o weterynarzach pracuj¹cych w klinice. Zawiera dane takie jak imiê, nazwisko, specjalizacja, numer 
telefonu oraz data zatrudnienia.*/
CREATE TABLE Vets (
    vet_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(30) NOT NULL,
    last_name NVARCHAR(30) NOT NULL,
    specialization NVARCHAR(50) NOT NULL,
    phone NVARCHAR(9) NOT NULL,
    hire_date DATE NOT NULL
);

INSERT INTO Vets (first_name, last_name, specialization, phone, hire_date) VALUES
('Marek', 'Nowak', 'chirurgia', '791227333', '2015-03-01'),
('Ewa', 'Lis', 'dermatologia', '324855166', '2020-06-15'),
('Tomasz', 'Kaczmarek', 'ortopedia', '127883919', '2018-09-10'),
('Anna', 'Wójcik', 'radiologia', '772333444', '2019-01-20'),
('Pawe³', 'Mazur', 'asystent weterynarii', '755688717', '2019-11-05'),
('Janusz', 'Szymañski', 'kardiologia', '744628788', '2018-10-15');

/*
Tabela Visits przechowuje informacje o wizytach pacjentów, takie jak termin wizyty, dane pacjenta oraz lekarza. Ka¿dy rekord reprezentuje jedn¹ --wizytê. Kolumna status okreœla aktualny stan wizyty i mo¿e przyjmowaæ tylko wartoœci: "zaplanowana", "zakoñczona" lub "anulowana". Domyœlnie ka¿da nowa wizyta otrzymuje status "zaplanowana". Dodatkowe ograniczenie sprawdza, czy zakoñczona wizyta ma przypisanego weterynarza.*/
CREATE TABLE Visits (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    animal_id INT NOT NULL,
    vet_id INT NULL,
    visit_date DATETIME NOT NULL,
    reason NVARCHAR(70) NOT NULL,
    notes NVARCHAR(255) NULL,      
    status NVARCHAR(20) DEFAULT 'zaplanowana'
        CHECK (status IN ('zaplanowana','zakoñczona','anulowana')),
    
    FOREIGN KEY (animal_id) REFERENCES Pets(animal_id),
    FOREIGN KEY (vet_id) REFERENCES Vets(vet_id),

	CHECK (
	(status = 'zakoñczona' AND vet_id IS NOT NULL)
	OR
	(status IN ('zaplanowana','anulowana'))
	)
);

INSERT INTO Visits (animal_id, vet_id, visit_date, reason, notes, status) VALUES
(1, 5, '2025-04-10 10:00', 'szczepienie', 'brak uwag', 'zakoñczona'),
(2, 2, '2025-04-11 12:00', 'alergia', 'wysypka na skórze', 'zakoñczona'),
(3, 1, '2025-04-15 09:00', 'kontrola', NULL, 'zakoñczona'),
(4, 3, '2025-04-16 11:00', 'uraz ³apy', 'lekkie kulawienie', 'zakoñczona'),
(5, 1, '2025-05-16 13:00', 'operacja', 'usuniêcie guza', 'zakoñczona'), 
(6, NULL, '2025-05-18 14:00', 'badanie ogólne', NULL, 'anulowana'),
(7, 4, '2025-05-16 11:00', 'diagnostyka', 'badanie krwi oraz badanie ogólne', 'zakoñczona'),
(8, 4, '2025-05-18 14:00', 'badanie ogólne', NULL, 'anulowana'),
(9, 3, '2025-05-16 11:00', 'uraz ³apy','uraz spowodowany niefortunnym skokiem', 'zakoñczona'),
(10,NULL, '2025-05-18 14:00', 'badanie ogólne', NULL, 'zaplanowana'),
(11, 5, '2025-05-20 13:30', 'badanie ogólne', 'brak uwag', 'zaplanowana'),
(12, 5, '2025-05-21 10:00', 'szczepienie', NULL, 'zaplanowana'),
(13,NULL, '2025-05-21 11:30', 'kontrola - opatrzenie rany', 'rana w fazie gojenia', 'zaplanowana'),
(4, 3, '2025-05-22 10:00', 'kontrola - uraz ³apy', 'lekkie kulawienie', 'zaplanowana'),
(9, NULL, '2025-05-22 11:00', 'kontrola - uraz ³apy','uraz spowodowany niefortunnym skokiem', 'zaplanowana'),
(5,1, '2025-05-22 12:00', 'kontrola po operacji chomika',NULL, 'zaplanowana');

/*Tabela Treatments przechowuje informacje o wykonanych zabiegach podczas wizyty. Zawiera nazwê zabiegu, jego opis, notatki lekarza, czas trwania oraz koszt. Ka¿dy zabieg jest powi¹zany z konkretn¹ wizyt¹. */
CREATE TABLE Treatments (
    treatment_id INT IDENTITY(1,1) PRIMARY KEY,
    visit_id INT NOT NULL,
    name NVARCHAR(50) NOT NULL,
    description NVARCHAR(255) NULL, -- opis zabiegu
    notes NVARCHAR(255) NULL, -- notatki lekarza
    duration INT NOT NULL, -- czas w minutach
    cost DECIMAL(7,2) NOT NULL

    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

INSERT INTO Treatments (visit_id, name,description, notes, duration, cost) VALUES
(1, 'szczepienie', 'podanie szczepionki przeciw wœciekliŸnie','Zwierzê by³o spokojne. Podano szczepionkê. Brak reakcji niepo¿¹danych. Zalecana kontrola za rok.',40,50),
(2, 'alergia', 'podanie leków na alergiê', 'Wysypka zniknê³a czêœciowo. Zalecana kontrola po tygodniu. Podano lek przeciwhistaminowy.',30,40),
(3, 'kontrola', 'kontrola stanu zdrowia','Zwierzê w dobrej kondycji. Brak uwag.',60,30),
(4, 'uraz ³apy','wykonanie zdjêcia RTG ³apy','Rana oczyszczona i zabanda¿owana. Pacjent by³ niespokojny, zalecano ograniczenie ruchu przez 3 dni.',90,90),
(5, 'operacja','Przeprowadzono operacje guza u chomika. Pacjent by³ pod narkoz¹. Operacja przebieg³a pomyœlnie. Zalecono odpoczynek i leki przeciwbólowe.',NULL, 120,150),
(7, 'diagnostyka','Standardowe badanie ogólne.',' Informacja o profilaktyce.',60,15),
(9, 'uraz ³apy','Oczyszczenie i zdezynfekowanie rany. Za³o¿enie opatrunku i stabilizacja koñczyny.','Uraz spowodowany niefortunnym skokiem. Rana oczyszczona i zabanda¿owana. Pacjent by³ niespokojny, zalecano ograniczenie ruchu przez 3 dni. Kontrola za tydzieñ.',100,110);

/*Tabela Prescriptions przechowuje informacje o przepisanych lekach po wykonanym zabiegu. Zawiera nazwê leku, dawkowanie, czas trwania leczenia oraz dodatkowe uwagi lekarza. Ka¿da recepta jest powi¹zana z konkretnym zabiegiem. Jeden zabieg mo¿e posiadaæ wiele recept, dlatego w tabeli mo¿e wystêpowaæ wiele rekordów przypisanych do tego samego zabiegu.*/

CREATE TABLE Prescriptions (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    treatment_id INT NOT NULL, 
    medicine_name NVARCHAR(100) NOT NULL,
    dosage NVARCHAR(50) NOT NULL, -- dawkowanie 
    duration_days INT NOT NULL, -- na ile dni lek
    notes NVARCHAR(MAX) NULL, -- uwagi lekarza

    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
);

INSERT INTO Prescriptions (treatment_id, medicine_name, dosage, duration_days, notes) VALUES
-- alergia
(2, 'Dolvit Allergy', '2x dziennie po 1 tabletce', 7, 'Podawaæ po posi³ku.'),

-- uraz ³apy
(4, 'RemediCann', '2x dziennie', 10, 'Maœæ przeciwzapalna. Nanieœæ cienk¹ warstwê na ranê.'),
(4, 'Meloksykam', '1x dziennie', 5, 'Œrodek przeciwbólowy. Podawaæ w razie bólu.'),

-- operacja chomika
(5, 'Antybiotyk VetCure', '2x dziennie po 0.5 ml', 7, 'Podawaæ po jedzeniu. Obserwowaæ stan zwierzêcia.'),
(5, 'Meloksykam', '1x dziennie', 5, 'Podawaæ zgodnie z zaleceniami lekarza.'),

-- diagnostyka
(6, 'Dolfos Vetcal D3', '1x dziennie', 14, 'Witamina D. Podawaæ razem z jedzeniem.'),

-- uraz ³apy (drugi przypadek)
(7, 'Beaphar Wound Maœæ', '2x dziennie', 10, 'Maœæ ³agodz¹c¹ stosowaæ na oczyszczon¹ ranê. Kontrola za tydzieñ.');
GO

-- Procedury
-- a) procedura: koñczy wizytê, przypisuje lekarza, zmienia status, dodaje zabieg do tabeli
CREATE PROCEDURE FinishVisit
(
    @visit_id INT,
    @vet_id INT,
    @treatment_name NVARCHAR(50),
    @description NVARCHAR(255),
    @treatment_notes NVARCHAR(255),
    @duration INT,
    @cost DECIMAL(7,2)
)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        -- sprawdzenie statusu wizyty
        IF NOT EXISTS (SELECT 1 FROM Visits WHERE visit_id = @visit_id AND status = 'zaplanowana')
        BEGIN
            THROW 50001, 'Wizyta nie jest zaplanowana, mo¿e byæ anulowana lub zakoñczona. Brak mo¿liwoœci dodania leczenia.', 1;
        END;

        -- aktualizacja wizyty
        UPDATE Visits
        SET
            vet_id = @vet_id,
            status = 'zakoñczona'
        WHERE visit_id = @visit_id;

        -- dodanie zabiegu
        INSERT INTO Treatments(visit_id, name, description, notes, duration, cost)
        VALUES (@visit_id, @treatment_name, @description, @treatment_notes, @duration, @cost);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION;

        -- przekazanie b³êdu dalej, czyli czytelny komunikat dla u¿ytkownika
        THROW;

    END CATCH
END;
GO

--Sprawdzenia, poprawne
/*
EXECUTE FinishVisit
	@visit_id = 10,
    @vet_id = 4,
    @treatment_name = 'badanie ogólne',
    @description = 'kontrola stanu zdrowia',
    @treatment_notes = NULL,
    @duration = 60,
    @cost = 30;

SELECT * FROM Treatments;
SELECT * FROM Visits;

-- b³êdne
EXECUTE FinishVisit
	@visit_id = 8, -- wizyta anulowana
	@vet_id = 4,
    @treatment_name = 'badanie ogólne',
    @description = 'kontrola stanu zdrowia',
    @treatment_notes = NULL,
    @duration = 60,
    @cost = 30;
 */

-- b. wywo³ania procedury z innej procedury wraz z obs³ug¹ b³êdów - jedna procedura wywo³uje drug¹.
-- cel procedury: koñczymy wizytê, dodajemy zabieg, opcjonalnie dodajemy receptê

-- Procedura podrzêdna 
CREATE PROCEDURE AddPrescription
(
    @treatment_id INT,
    @medicine_name NVARCHAR(100),
    @dosage NVARCHAR(50),
    @duration_days INT,
    @notes NVARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY

        INSERT INTO Prescriptions (treatment_id, medicine_name, dosage, duration_days, notes) VALUES
            (@treatment_id, @medicine_name, @dosage, @duration_days, @notes);

    END TRY
    BEGIN CATCH
        THROW; -- przekazuje b³¹d do procedury nadrzêdnej
    END CATCH
END;
GO

-- Procedura g³ówna
CREATE PROCEDURE FinishVisitWithPrescription
(
   @visit_id INT,
   @vet_id INT,
   @treatment_name NVARCHAR(50),
   @description NVARCHAR(255),
   @treatment_notes NVARCHAR(255),
   @duration INT,
   @cost DECIMAL(7,2),
   @medicine_name NVARCHAR(100) = NULL,
   @dosage NVARCHAR(50) = NULL,
   @duration_days INT = NULL,
   @prescription_notes NVARCHAR(MAX) = NULL
)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @treatment_id INT;

        -- walidacja wizyty 
        IF NOT EXISTS (SELECT 1 FROM Visits WHERE visit_id = @visit_id AND status = 'zaplanowana')
        BEGIN
            THROW 50001, 'Wizyta nie jest zaplanowana.', 1;
        END;

        -- zakoñczenie wizyty
        UPDATE Visits
        SET vet_id = @vet_id,
            status = 'zakoñczona'
        WHERE visit_id = @visit_id;

        -- dodanie zabiegu
        INSERT INTO Treatments (visit_id, name, description, notes, duration, cost) VALUES
            (@visit_id, @treatment_name, @description, @treatment_notes, @duration, @cost);

        SET @treatment_id = SCOPE_IDENTITY();

        --  WYWO£ANIE INNEJ PROCEDURY
        IF @medicine_name IS NOT NULL
        BEGIN
            EXEC AddPrescription
                @treatment_id = @treatment_id,
                @medicine_name = @medicine_name,
                @dosage = @dosage,
                @duration_days = @duration_days,
                @notes = @prescription_notes;
        END;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION;

        -- kluczowe - przekazanie b³êdu dalej
        THROW 50000, 'Operacja nie powiod³a siê, sprawdŸ dane wizyty lub recepty.', 1;

    END CATCH
END;
GO

-- Test bez recepty
/*
EXEC FinishVisitWithPrescription
    @visit_id = 12,
    @vet_id = 5, -- to musi byæ, gdy null tutaj - tylko wtedy gdy ustawiony jest vet_id w tabeli wizyty, status='zaplanowane' --sprawdzic moze
    @treatment_name = 'szczepienie',
    @description = 'podanie szczepionki przeciw wœciekliŸnie',
    @treatment_notes = 'Zwierzê by³o niespokojne.',
    @duration = 40,
    @cost = 50.00;

SELECT * FROM Treatments;
SELECT * FROM Visits;

-- Test z recept¹
EXEC FinishVisitWithPrescription
    @visit_id = 13,
    @vet_id = 3,
    @treatment_name = 'kontrola',
    @description = 'kontrola w celu opatrzenie rany',
    @treatment_notes = 'Rana pacjenta jest w dobrej kondycji. Brak nieprawid³owoœci. Przypisanie maœci.',
    @duration = 30,
    @cost = 70.00,
    @medicine_name = 'RemediCann',
    @dosage = '2x dziennie',
    @duration_days = 7,
    @prescription_notes = 'Maœæ stosowaæ na oczyszczon¹ ranê.';

SELECT * FROM Treatments;
SELECT * FROM Visits;
SELECT *FROM Prescriptions;

--Test b³êdu: z³a wizyta
EXEC FinishVisitWithPrescription
    @visit_id = 1,
    @vet_id = 2,
    @treatment_name = 'Test',
    @description = 'Test',
    @treatment_notes = 'Test',
    @duration = 10,
    @cost = 50;
*/

-- c. bardziej skomplikowanej struktury ni¿ prosty insert
-- Obliczenie: liczby wizyt, przychodu lekarza
CREATE PROCEDURE VetStatistics
(
    @vet_id INT
)
AS
BEGIN

    -- sprawdzenie czy weterynarz ma zakoñczone wizyty
    IF NOT EXISTS (SELECT 1 FROM Visits WHERE vet_id = @vet_id AND status = 'zakoñczona')
    BEGIN
        THROW 50010, 'Brak danych: weterynarz nie istnieje lub nie ma zakoñczonych wizyt.', 1;
    END;

    --  statystyki
    SELECT
        v.vet_id,
        COUNT(v.visit_id) AS total_visits,
        SUM(t.cost) AS total_income,
        AVG(t.cost) AS avg_visit_cost
    FROM Visits v
    JOIN Treatments t ON v.visit_id = t.visit_id
    WHERE v.vet_id = @vet_id AND v.status = 'zakoñczona'
    GROUP BY v.vet_id;

END;
GO

/*
EXEC VetStatistics
 @vet_id =2;
*/

-- Funkcja skalarna
-- Obliczenie wieku zwierzêcia. Na podstawie daty urodzenia i aktualnej daty
CREATE FUNCTION AnimalAge
(
    @birth_date DATE
)
RETURNS INT
AS
BEGIN

    DECLARE @age INT;
    SET @age = DATEDIFF(YEAR, @birth_date, GETDATE());
    RETURN @age;

END;
GO

/*
SELECT name, dbo.AnimalAge(birth_date) AS age
FROM Pets;
*/

-- Funkcja tabelaryczna 
-- Historia wizyt konkretnego zwierzêcia.
CREATE FUNCTION GetAnimalVisits
(
    @animal_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        visit_id,
        visit_date,
        reason,
        status
    FROM Visits
    WHERE animal_id = @animal_id

    UNION ALL

    SELECT
        NULL,
        NULL,
        'BRAK WIZYT',
        NULL
    WHERE NOT EXISTS (
        SELECT 1 FROM Visits WHERE animal_id = @animal_id
    )
);
GO

/*
SELECT * FROM dbo.GetAnimalVisits(4);
SELECT * FROM dbo.GetAnimalVisits(99);
*/

-- WIDOKI
-- Widok: pe³na historia wizyty z zabiegiem
CREATE VIEW Visit_With_Treatment AS
SELECT 
    v.visit_id,
    v.visit_date,
    v.reason,
    t.name AS treatment_name,
    t.cost,
    t.duration
FROM Visits v
JOIN Treatments t ON v.visit_id = t.visit_id
WHERE v.status = 'zakoñczona';
GO

-- SELECT *FROM Visit_With_Treatment;


--Widok - podsumowanie kosztów leczenia. Pokazuje  ile kosztowa³o leczenie ka¿dego zwierzêcia, sumê kosztów zabiegów.
CREATE VIEW AnimalTreatmentCosts AS
SELECT
   p.animal_id,
   p.name AS animal_name,
   SUM(t.cost) AS total_cost,
   COUNT(t.treatment_id) AS treatments_count
FROM Pets p
JOIN Visits v ON p.animal_id = v.animal_id
JOIN Treatments t ON v.visit_id = t.visit_id
GROUP BY p.animal_id, p.name;
GO

/*
SELECT * FROM AnimalTreatmentCosts
ORDER BY total_cost DESC;
*/

-- TRIGGER
-- Trigger: log usuniêcia wizyty, zapisuje jej dane do tabeli logów
CREATE TABLE Visit_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    visit_id INT,
    animal_id INT,
    vet_id INT,
    visit_date DATETIME,
    reason NVARCHAR(70),
    deleted_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Visit_Delete
ON Visits
INSTEAD OF DELETE
AS
BEGIN
	BEGIN TRANSACTION;

	BEGIN TRY

		-- sprawdzenie czy rekord istnieje
		IF NOT EXISTS (SELECT 1 FROM DELETED)
		BEGIN
			THROW 50003,
			'Wizyta nie istnieje.',
			1;
		END;

		-- tylko zaplanowane wizyty
		IF EXISTS (
			SELECT 1
			FROM DELETED
			WHERE status <> 'zaplanowana'
		)
		BEGIN
			THROW 50001,
			'Mo¿na usuwaæ tylko wizyty zaplanowane.',
			1;
		END;

		-- brak powi¹zanych zabiegów
		IF EXISTS (
			SELECT 1
			FROM Treatments t
			JOIN DELETED d
				ON t.visit_id = d.visit_id
		)
		BEGIN
			THROW 50002,
			'Nie mo¿na usun¹æ wizyty posiadaj¹cej zabiegi.',
			1;
		END;

		-- log
		INSERT INTO Visit_Log
			(visit_id, animal_id, vet_id, visit_date, reason)
		SELECT
			d.visit_id,
			d.animal_id,
			d.vet_id,
			d.visit_date,
			d.reason
		FROM DELETED d;

		-- delete
		DELETE FROM Visits
		WHERE visit_id IN (
			SELECT visit_id FROM DELETED
		);

		COMMIT TRANSACTION;

	 END TRY

	 BEGIN CATCH

		ROLLBACK TRANSACTION;

		THROW;

	END CATCH

	PRINT 'Usuniêto wizytê.';

END;
GO

-- tu wizyta zaplanowana
/*
DELETE FROM Visits WHERE visit_id = 1;

SELECT * FROM Visits;
SELECT * FROM Visit_Log;

-- poprawne
DELETE FROM Visits WHERE visit_id = 14;
*/

--Trigger - automatyczne logowanie dodania zabiegu, zapisuje informacjê o tym zdarzeniu w tabeli log
CREATE TABLE Treatment_Log (
   log_id INT IDENTITY(1,1) PRIMARY KEY,
   treatment_id INT,
   visit_id INT,
   name NVARCHAR(50),
   cost DECIMAL(7,2),
   created_at DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Treatment_Insert
ON Treatments
AFTER INSERT
AS
BEGIN

    INSERT INTO Treatment_Log (treatment_id, visit_id, name, cost)
    SELECT 
        i.treatment_id,
        i.visit_id,
        i.name,
        i.cost
    FROM INSERTED i;

END;

--Sprawdzenie:
/*
INSERT INTO Treatments (visit_id, name, description, notes, duration, cost)
VALUES (10, 'badanie ogólne', 'standardowe badanie', 'NULL', 60, 30);

SELECT * FROM Treatment_Log;
SELECT * FROM Treatments;
SELECT * FROM Visits;
*/
-- przyk³ad relacji 'join' - pe³ny widok pacjenta:
SELECT 
    o.first_name + ' ' + o.last_name AS owner,
    a.name AS animal,
    v.visit_date,
    v.reason,
    t.name AS treatment,
    t.cost,
    p.medicine_name
FROM Owners o
JOIN Pets a ON o.owner_id = a.owner_id
JOIN Visits v ON a.animal_id = v.animal_id
JOIN Treatments t ON v.visit_id = t.visit_id
LEFT JOIN Prescriptions p ON t.treatment_id = p.treatment_id;
GO



-- Kursor który bêdzie kopiowaæ dane z tabelaA do tabelaAJson(kolumny: ID, Json).
CREATE TABLE AnimalsJson (
   group_id INT IDENTITY(1,1) PRIMARY KEY,
   species NVARCHAR(20),
   json_data NVARCHAR(MAX)
);
GO

CREATE PROCEDURE ExportAnimals_ToJson_BySpecies
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @species NVARCHAR(20);
   DECLARE @json NVARCHAR(MAX);

   BEGIN TRY
       BEGIN TRANSACTION;

       -- kursor po grupach (gatunkach)
       DECLARE species_cursor CURSOR FOR
       SELECT DISTINCT species
       FROM dbo.Pets;

       OPEN species_cursor;

       FETCH NEXT FROM species_cursor INTO @species;

       WHILE @@FETCH_STATUS = 0
       BEGIN

           -- budowanie JSON dla danej grupy
           SELECT @json =
           (
               SELECT
                   animal_id,
                   name,
                   breed,
                   birth_date,
                   weight,
                   gender
               FROM dbo.Pets
               WHERE species = @species
               FOR JSON PATH
           );

           -- zapis do tabeli JSON
           INSERT INTO dbo.AnimalsJson (species, json_data)
           VALUES (@species, @json);

           FETCH NEXT FROM species_cursor INTO @species;
       END;

       CLOSE species_cursor;
       DEALLOCATE species_cursor;

       COMMIT TRANSACTION;

   END TRY

  BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    CLOSE species_cursor;
    DEALLOCATE species_cursor;

    PRINT 'B³¹d podczas generowania JSON zwierz¹t';

  END CATCH

END;
GO

/*
EXEC ExportAnimals_ToJson_BySpecies;
SELECT * FROM AnimalsJson;
*/
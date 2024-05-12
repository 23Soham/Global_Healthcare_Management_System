CREATE DATABASE GlobalHealthCareSystem


---- Create Table Patient ----

CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    Patient_FirstName VARCHAR(100),
    Patient_MiddleName VARCHAR(100),
    Patient_LastName VARCHAR(100),
    Patient_Phone_Num VARCHAR(15),
	Patient_Date_of_Birth DATE,
    Sex CHAR(1) CHECK (Sex IN ('M', 'F', 'O')),
	Height Float,
	Weight Float,
    Blood_Group VARCHAR(5) CHECK (Blood_Group IN ('A', 'B', 'AB', 'O', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    Address VARCHAR(500),
    Country VARCHAR(100),
    Next_of_Kin_Name VARCHAR(150),
    Emergency_Phone_Number VARCHAR(15),
    Patient_Password VARBINARY(MAX)
);
SELECT * FROM Patient

--- Added new column ---

ALTER TABLE Patient
ADD PatientPass VARCHAR(500)

---- Create Table HealthcareInstitution ----

CREATE TABLE HealthcareInstitution(
	InstitutionID INT PRIMARY KEY,
	Institution_Name VARCHAR(500),
	Location VARCHAR(500)
);
SELECT * FROM HealthcareInstitution;

---- Create Table Doctor ----

CREATE TABLE Doctor(
   DoctorID INT PRIMARY KEY,
   InstitutionID INT,
   Doctor_FirstName VARCHAR(50),
   Doctor_MiddleName VARCHAR(50),
   Doctor_LastName VARCHAR(50),
   Specialization VARCHAR(200),
   OnCallNumber VARCHAR(15),
   FOREIGN KEY (InstitutionID)REFERENCES HealthcareInstitution(InstitutionID),
);

--- Added new column ---

alter table Doctor
add DoctorPass varchar(500);

SELECT * FROM Doctor;

---- Create Table RegulatoryDept ----

CREATE TABLE RegulatoryDept (
   Regulatory_Dept_ID INT PRIMARY KEY,
   Authorizer_Name VARCHAR(200)
); 

--- Added new column ----

alter table RegulatoryDept
add DeptPass varchar(500);

SELECT * FROM RegulatoryDept;

---- Create Table Staff ----

CREATE TABLE Staff(
    InstitutionStaffID INT PRIMARY KEY,
	InstitutionID INT,
	ContactNumber VARCHAR(15),
	ContactEmail VARCHAR(100),
	Department VARCHAR(500),
	Address VARCHAR(500),
	FOREIGN KEY (InstitutionID)REFERENCES HealthcareInstitution(InstitutionID),
);

--- Added new column ---

alter table Staff
add StaffPass varchar(500);

SELECT * FROM Staff

---- Create Table InsuranceCoverage ----

CREATE TABLE InsuranceCoverage(
   Insurance_Registration_ID INT PRIMARY KEY,
   PatientID INT,
   Coverage VARCHAR(100) CHECK(COVERAGE IN('Basic', 'Advance', 'Premium', 'PremiumPlus')),
   Expiration_Date Date,
   FOREIGN KEY (PatientID) REFERENCES Patient(PatientID)
);
SELECT * FROM InsuranceCoverage;

---- Create Table Visit ----

CREATE TABLE Visit(
VisitID INT PRIMARY Key,
DoctorID INT,
PatientID INT,
InstitutionID INT,
Visit_Date DATE,
Visit_Time TIME,
FOREIGN key (DoctorID) REFERENCES Doctor(DoctorID),
FOREIGN key (PatientID) REFERENCES Patient(PatientID),
FOREIGN KEY (InstitutionID)REFERENCES HealthcareInstitution(InstitutionID),
);
SELECT * FROM Visit;

---- Create Table Record ----

CREATE TABLE Record(
   UniqueRecordID INT PRIMARY KEY,
   PatientID INT,
   InstitutionID INT,
   Regulatory_Dept_ID INT,
   Location VARCHAR(200),
   Date DATE,
   ReportType VARCHAR(200) CHECK (ReportType IN('Diagnostic Reports','Prescription')),
   FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
   FOREIGN KEY (InstitutionID) REFERENCES HealthcareInstitution (InstitutionID),
   FOREIGN KEY (Regulatory_Dept_ID) REFERENCES RegulatoryDept(Regulatory_Dept_ID),
);

---- Added new column ----

ALTER TABLE Record
ADD Status varchar(500);

ALTER TABLE Record
ADD CreationTimeStamp DATETIME DEFAULT GETDATE();

select * from Record

ALTER TABLE Record
ADD PDFRecord VARBINARY(MAX);

ALTER TABLE Record
ADD DoctorID INT;

ALTER TABLE Record
ADD CONSTRAINT FK_Record_Doctor
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID);

SELECT * FROM Record;

---- Create Table Treatment ----

CREATE TABLE Treatment(
   TreatmentID INT PRIMARY KEY,
   PatientID INT,
   InstitutionID INT,
   DoctorID INT,
   Cost Float,
   Description VARCHAR(500),
   Date DATE,
   Diagnosed_Illness VARCHAR(500)
    FOREIGN KEY(PatientID) REFERENCES Patient(PatientID),
	FOREIGN KEY (InstitutionID)REFERENCES HealthcareInstitution(InstitutionID),
    FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID),
);
SELECT * FROM Treatment;

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Treatment' AND COLUMN_NAME = 'TreatmentID';
ALTER TABLE Treatment
DROP CONSTRAINT PK__Treatmen__1A57B71165B3C8A7;
ALTER TABLE Treatment
ALTER COLUMN TreatmentID INT NOT NULL;
ALTER TABLE Treatment
ALTER COLUMN PatientID INT NOT NULL;
  
ALTER TABLE Treatment
ADD CONSTRAINT PK_Treatment PRIMARY KEY (TreatmentID, PatientID);

select * from Treatment

---- Create Table DiagnosticReports ----

CREATE TABLE DiagnosticReports(
	UniqueRecordID INT PRIMARY KEY,
	Medical_Department VARCHAR(250),
	FOREIGN KEY (UniqueRecordID) REFERENCES Record(UniqueRecordID),
);
SELECT * from DiagnosticReports;

---- Create Table Prescription ----

CREATE TABLE Prescription(
	UniqueRecordID INT PRIMARY KEY,
	E_Sign_Doctor VARCHAR(300),
	FOREIGN KEY (UniqueRecordID) REFERENCES Record(UniqueRecordID),
);
SELECT * FROM Prescription;

---- Create Table AuditPatient ----

CREATE TABLE AuditPatient(
	AuditID INT PRIMARY KEY IDENTITY(1,1),
	PatientID INT,
	ChangeType VARCHAR(100),
	ChangeDate DATETIME,
);
SELECT * FROM AuditPatient;

---- Create Table DeletedPatient ----

CREATE TABLE DeletedPatient(
	PatientID INT,
    Patient_FirstName VARCHAR(100),
    Patient_MiddleName VARCHAR(100),
    Patient_LastName VARCHAR(100),
    Patient_Phone_Num VARCHAR(15),
	Patient_Date_of_Birth DATE,
    Sex CHAR(1) CHECK (Sex IN ('M', 'F', 'O')),
	Height Float,
	Weight Float,
    Blood_Group VARCHAR(5) CHECK (Blood_Group IN ('A', 'B', 'AB', 'O', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    Address VARCHAR(500),
    Country VARCHAR(100),
    Next_of_Kin_Name VARCHAR(150),
    Emergency_Phone_Number VARCHAR(15),
    Patient_Password VARBINARY(MAX)
);
SELECT * FROM DeletedPatient;

---- Insert details into Patient ----

INSERT INTO Patient (PatientID, Patient_FirstName, Patient_MiddleName, Patient_LastName, Patient_Phone_Num,
    Patient_Date_of_Birth, Sex, Height, Weight, Blood_Group, Address, Country,
    Next_of_Kin_Name, Emergency_Phone_Number, Patient_Password)
VALUES
    (101, 'John', 'A', 'Doe', 857123456789, '1990-05-17', 'M', 1.70, 70, 'A+', '123 Main St', 'India',
    'Jane Doe', 8579876543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass101'))),

    (102, 'Alice', 'B', 'Smith', 857987654321, '1999-11-29', 'F', 1.60, 55, 'B-', '456 Oak St', 'India',
    'Bob Smith', 857876543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass102'))),

    (103, 'Charlie', 'C', 'Brown', 85787654321, '1985-09-03', 'M', 1.75, 80, 'O-', '789 Pine St', 'India',
    'David Brown', 857765432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass103'))),

    (104, 'Eva', 'D', 'Johnson', 85776543210, '2001-11-29', 'F', 1.55, 50, 'B+', '101 Elm St', 'India',
    'Frank Johnson', 857654321098, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass104'))),

    (105, 'Grace', 'E', 'Williams', 857654321098, '1993-03-12', 'F', 1.60, 60, 'AB-', '202 Cedar St', 'India',
    'Henry Williams', 857543210987, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass105'))),

    (106, 'Ian', 'F', 'Miller', 85754321098, '1980-07-08', 'M', 1.80, 85, 'O+', '303 Maple St', 'USA',
    'Julia Miller', 857432109876, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass106'))),

    (107, 'Karen', 'G', 'Davis', 85743210987, '1998-01-25', 'F', 1.65, 70, 'A-', '404 Birch St', 'USA',
    'Larry Davis', 857321098765, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass107'))),

    (108, 'Michael', 'H', 'Wilson', 85732109876, '1976-08-21', 'M', 1.75, 75, 'B-', '505 Pine St', 'USA',
    'Nancy Wilson', 857987654321, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass108'))),

    (109, 'Olivia', 'I', 'Moore', 85798765432, '1989-04-15', 'F', 1.60, 55, 'AB-', '606 Oak St', 'USA',
    'Paul Moore', 857876543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass109'))),

    (110, 'Quentin', 'J', 'Taylor', 85787654321, '1995-10-02', 'O', 1.70, 80, 'O+', '707 Main St', 'USA',
    'Rachel Taylor', 857765432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass110'))),
	
    (111, 'Dmitri', 'A', 'Ivanov', 857123456789, '1980-05-17', 'M', 1.70, 70, 'A+', 'Street 1', 'Russia',
    'Olga Ivanova', 8579876543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass111'))),

    (112, 'Svetlana', 'B', 'Petrov', 857987654321, '1995-11-29', 'F', 1.60, 55, 'B-', 'Avenue 2', 'Russia',
    'Igor Petrov', 857876543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass112')));

    INSERT INTO Patient (PatientID, Patient_FirstName, Patient_MiddleName, Patient_LastName, Patient_Phone_Num,
    Patient_Date_of_Birth, Sex, Height, Weight, Blood_Group, Address, Country,
    Next_of_Kin_Name, Emergency_Phone_Number, Patient_Password, PatientPass)
VALUES
    (113, 'Vishal', 'R', 'Kumar', 8571234567, '1992-08-22', 'M', 1.78, 75, 'B+', '12 Oak Lane', 'India',
    'Priya Kumar', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass113')), 'Passw13'),

    (114, 'Aarav', 'S', 'Patel', 8571234567, '1995-03-10', 'M', 1.68, 68, 'O+', '34 Maple Avenue', 'India',
    'Amit Patel', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass114')), 'Passw14'),

    (115, 'Nina', 'K', 'Gupta', 8579876543, '1987-09-27', 'F', 1.65, 55, 'AB-', '45 Pine Street', 'India',
    'Raj Gupta', 8578765432, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass115')), 'Passw15');


    INSERT INTO Patient (PatientID, Patient_FirstName, Patient_MiddleName, Patient_LastName, Patient_Phone_Num,
    Patient_Date_of_Birth, Sex, Height, Weight, Blood_Group, Address, Country,
    Next_of_Kin_Name, Emergency_Phone_Number, Patient_Password, PatientPass)
VALUES
    (116, 'Sanjay', 'M', 'Singh', 8577654321, '1990-11-15', 'M', 1.75, 80, 'A-', '56 Elm Street', 'India',
    'Anita Singh', 8576543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass116')), 'Passw16'),

    (117, 'Priya', 'S', 'Sharma', 8576543210, '1993-06-20', 'F', 1.60, 55, 'B+', '78 Cedar Avenue', 'India',
    'Rahul Sharma', 8575432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass117')), 'Passw17'),

    (118, 'Rahul', 'K', 'Verma', 8575432109, '1985-02-25', 'M', 1.80, 85, 'O+', '90 Oak Lane', 'India',
    'Sonia Verma', 8574321098, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass118')), 'Passw18'),

    (119, 'Asha', 'R', 'Reddy', 8574321098, '1998-09-10', 'F', 1.65, 60, 'AB-', '123 Pine Street', 'India',
    'Kiran Reddy', 8573210987, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass119')), 'Passw19'),

    (120, 'Nikhil', 'A', 'Agarwal', 8573210987, '1982-04-05', 'M', 1.70, 75, 'B-', '234 Birch Avenue', 'India',
    'Pooja Agarwal', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass120')), 'Passw20'),

    (121, 'Meera', 'P', 'Patil', 8579876543, '1995-01-30', 'F', 1.68, 68, 'O+', '345 Maple Street', 'India',
    'Sunil Patil', 8578765432, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass121')), 'Passw21'),

    (122, 'Vikram', 'S', 'Saxena', 8578765432, '1987-07-15', 'M', 1.75, 70, 'A+', '456 Cedar Avenue', 'India',
    'Deepika Saxena', 8577654321, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass122')), 'Passw22'),

    (123, 'Pooja', 'R', 'Rajput', 8577654321, '2000-12-02', 'F', 1.60, 55, 'B+', '567 Elm Street', 'India',
    'Rajeev Rajput', 8576543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass123')), 'Passw23'),

    (124, 'Anil', 'K', 'Khanna', 8576543210, '1984-08-18', 'M', 1.78, 78, 'AB-', '678 Birch Avenue', 'India',
    'Suman Khanna', 8575432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass124')), 'Passw24'),

    (125, 'Neha', 'B', 'Bhat', 8575432109, '1997-03-25', 'F', 1.65, 60, 'O+', '789 Oak Lane', 'India',
    'Ravi Bhat', 8574321098, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass125')), 'Passw25'),

    (126, 'Raj', 'A', 'Ahmed', 8574321098, '1980-10-10', 'M', 1.70, 75, 'A-', '890 Pine Street', 'India',
    'Ayesha Ahmed', 8573210987, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass126')), 'Passw26');

    INSERT INTO Patient (PatientID, Patient_FirstName, Patient_MiddleName, Patient_LastName, Patient_Phone_Num,
    Patient_Date_of_Birth, Sex, Height, Weight, Blood_Group, Address, Country,
    Next_of_Kin_Name, Emergency_Phone_Number, Patient_Password, PatientPass)
VALUES
    (127, 'Alex', 'J', 'Johnson', 8576543210, '1992-05-22', 'M', 1.75, 80, 'A+', '123 Oak Street', 'USA',
    'Emily Johnson', 8575432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass127')), 'Passw27'),

    (128, 'Sophia', 'M', 'Miller', 8575432109, '1995-12-10', 'F', 1.68, 68, 'O-', '456 Maple Avenue', 'USA',
    'William Miller', 8574321098, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass128')), 'Passw28'),

    (129, 'Aiden', 'R', 'Rodriguez', 8574321098, '1987-08-25', 'M', 1.80, 85, 'B+', '789 Cedar Lane', 'USA',
    'Olivia Rodriguez', 8573210987, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass129')), 'Passw29'),

    (130, 'Mia', 'A', 'Anderson', 8573210987, '1998-02-10', 'F', 1.65, 55, 'AB+', '101 Pine Avenue', 'USA',
    'Daniel Anderson', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass130')), 'Passw30'),

    (131, 'Ethan', 'K', 'Kumar', 8579876543, '1982-09-15', 'M', 1.70, 75, 'B-', '202 Elm Street', 'India',
    'Riya Kumar', 8578765432, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass131')), 'Passw31'),

    (132, 'Zoe', 'A', 'Agarwal', 8578765432, '1995-02-28', 'F', 1.68, 60, 'O+', '303 Oak Avenue', 'India',
    'Aarav Agarwal', 8577654321, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass132')), 'Passw32'),

    (133, 'Owen', 'L', 'Li', 8577654321, '1987-07-05', 'M', 1.75, 70, 'A+', '404 Pine Street', 'China',
    'Sophie Li', 8576543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass133')), 'Passw33'),

    (134, 'Lily', 'Y', 'Yang', 8576543210, '2000-12-02', 'F', 1.60, 55, 'B+', '505 Cedar Lane', 'China',
    'William Yang', 8575432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass134')), 'Passw34'),

    (135, 'Elijah', 'C', 'Chen', 8575432109, '1984-08-18', 'M', 1.78, 78, 'AB-', '606 Maple Avenue', 'China',
    'Sophia Chen', 8574321098, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass135')), 'Passw35'),

    (136, 'Aria', 'L', 'Lee', 8574321098, '1997-03-25', 'F', 1.65, 60, 'O+', '707 Pine Street', 'USA',
    'Matthew Lee', 8573210987, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass136')), 'Passw36'),

    (137, 'Oliver', 'W', 'Wang', 8573210987, '1980-10-10', 'M', 1.70, 75, 'A-', '808 Cedar Avenue', 'China',
    'Emma Wang', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass137')), 'Passw37'),

    (138, 'Amelia', 'D', 'Das', 8579876543, '1992-05-22', 'F', 1.75, 80, 'A+', '909 Oak Lane', 'India',
    'Arjun Das', 8578765432, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass138')), 'Passw38'),

    (139, 'Lucas', 'R', 'Rao', 8578765432, '1995-12-10', 'M', 1.68, 68, 'O-', '101 Pine Avenue', 'India',
    'Sophie Rao', 8577654321, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass139')), 'Passw39'),

    (140, 'Eva', 'J', 'Jin', 8577654321, '1987-08-25', 'F', 1.80, 85, 'B+', '202 Elm Street', 'China',
    'David Jin', 8576543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass140')), 'Passw40');

INSERT INTO Patient (PatientID, Patient_FirstName, Patient_MiddleName, Patient_LastName, Patient_Phone_Num,
    Patient_Date_of_Birth, Sex, Height, Weight, Blood_Group, Address, Country,
    Next_of_Kin_Name, Emergency_Phone_Number, Patient_Password, PatientPass)
VALUES
    (141, 'Ivan', 'N', 'Nikolayev', 8571234567, '1990-04-15', 'M', 1.75, 75, 'A-', '5 Red Square', 'Russia',
    'Maria Nikolayeva', 8579876543, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass141')), 'Passw41'),

    (142, 'Anastasia', 'S', 'Sokolova', 8579876543, '1993-11-29', 'F', 1.68, 65, 'O+', '8 Pushkin Street', 'Russia',
    'Alexei Sokolov', 8578765432, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass142')), 'Passw42'),

    (143, 'Dmitri', 'I', 'Ivanov', 8578765432, '1985-06-03', 'M', 1.80, 80, 'B+', '12 Gorky Lane', 'Russia',
    'Svetlana Ivanova', 8577654321, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass143')), 'Passw43'),

    (144, 'Ekaterina', 'V', 'Volkova', 8577654321, '2001-11-29', 'F', 1.60, 55, 'AB-', '15 Moscow Avenue', 'Russia',
    'Igor Volkov', 8576543210, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass144')), 'Passw44'),

    (145, 'Sergei', 'K', 'Kuznetsov', 8576543210, '1993-03-12', 'M', 1.70, 70, 'A+', '20 Kremlin Lane', 'Russia',
    'Natalia Kuznetsova', 8575432109, EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Pass145')), 'Passw45');

SELECT * FROM Patient;

--- Updated rows ----

update Patient 
set Emergency_Phone_Number = '8575769067'
where PatientID = 101;

UPDATE Patient
SET Patient_Password = EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Passw2'))
where PatientID=102;

UPDATE Patient
SET PatientPass = 'Passw1'
where PatientID=101;
-----

update Patient 
set Emergency_Phone_Number = '9898172546'
where PatientID = 112;

OPEN SYMMETRIC KEY PatientPass_SM
DECRYPTION BY CERTIFICATE PatientPass;

UPDATE Patient
SET Patient_Password = EncryptByKey(Key_GUID('PatientPass_SM'), CONVERT(VARBINARY, 'Passw12'))
where PatientID=112;

UPDATE Patient
SET PatientPass = 'Passw12'
where PatientID=112;

---- Insert details into HealthcareInstitution ----

INSERT INTO HealthcareInstitution (InstitutionID, Institution_Name, Location)
VALUES
(1, 'City General Hospital', '123 Main St'),
(2, 'Suburb Medical Center', '456 Elm St'),
(3, 'Rural Clinic', '789 Oak St'),
(4, 'Metro Health Center', '101 Pine St'),
(5, 'Coastal Medical Clinic', '202 Cedar St'),
(6, 'Hilltop Wellness Center', '303 Maple St'),
(7, 'Valley Family Health', '404 Birch St'),
(8, 'Downtown Urgent Care', '505 Pine St'),
(9, 'Community Health Center', '606 Oak St'),
(10, 'Central Medical Hub', '707 Main St');
 
SELECT * FROM HealthcareInstitution;

---- Insert details into Doctor ----

INSERT INTO Doctor(DoctorID, InstitutionID, Doctor_FirstName, Doctor_MiddleName, Doctor_LastName, Specialization, OnCallNumber)
VALUES
    (201, 1, 'Anna', 'L', 'Kuznetsova', 'Cardiologist', '8571122334'),
    (202, 2, 'Vladimir', 'P', 'Ivanov', 'Orthopedic Surgeon', '8572244668'),
    (203, 3, 'Natalia', 'A', 'Petrova', 'Dermatologist', '8573366991'),
    (204, 4, 'Ivan', 'M', 'Sokolov', 'Neurologist', '8574488225'),
    (205, 5, 'Elena', 'S', 'Popova', 'Pediatrician', '8575611559'),
    (206, 6, 'Sergei', 'N', 'Volkov', 'Ophthalmologist', '8576734892'),
    (207, 7, 'Maria', 'D', 'Kovalenko', 'ENT Specialist', '8577857226'),
    (208, 8, 'Dmitri', 'I', 'Smirnov', 'Gastroenterologist', '8578979560'),
    (209, 9, 'Tatiana', 'V', 'Egorova', 'Endocrinologist', '8579001111'),
    (210, 10, 'Alexei', 'E', 'Sidorov', 'Psychiatrist', '8570123456'),
    (211, 1, 'Irina', 'P', 'Nikitina', 'Cardiologist', '8571122334'),
    (212, 3, 'Pavel', 'S', 'Kozlov', 'Orthopedic Surgeon', '8572244668'),
    (213, 5, 'Oksana', 'V', 'Kuznetsova', 'Dermatologist', '8573366991'),
    (214, 7, 'Yuri', 'A', 'Ivanov', 'Neurologist', '8574488225'),
    (215, 9, 'Yulia', 'M', 'Sokolova', 'Pediatrician', '8575611559'),
    (216, 2, 'Nikolai', 'N', 'Popov', 'Ophthalmologist', '8576734892'),
    (217, 4, 'Ekaterina', 'D', 'Kozlova', 'ENT Specialist', '8577857226'),
    (218, 6, 'Artem', 'I', 'Smirnov', 'Gastroenterologist', '8578979560'),
    (219, 8, 'Larisa', 'V', 'Egorova', 'Endocrinologist', '8579001111'),
    (220, 10, 'Andrei', 'E', 'Sidorov', 'Psychiatrist', '8570123456');

--- Added new column ---

ALTER TABLE Doctor
ADD DoctorPass VARCHAR(50);

--- Updated DoctorPass---

update Doctor
set DoctorPass='Doc1'
where DoctorID=201

update Doctor
set DoctorPass='Doc2'
where DoctorID=202

update Doctor
set DoctorPass='Doc3'
where DoctorID=203;

update Doctor
set DoctorPass='Doc4'
where DoctorID=204;

update Doctor
set DoctorPass='Doc5'
where DoctorID=205;

update Doctor
set DoctorPass='Doc6'
where DoctorID=206;

update Doctor
set DoctorPass='Doc7'
where DoctorID=207;

update Doctor
set DoctorPass='Doc8'
where DoctorID=208;

update Doctor
set DoctorPass='Doc9'
where DoctorID=209;

update Doctor
set DoctorPass='Doc10'
where DoctorID=210;

UPDATE Doctor
SET DoctorPass = 'Doc11'
WHERE DoctorID = 211;

UPDATE Doctor
SET DoctorPass = 'Doc12'
WHERE DoctorID = 212;

UPDATE Doctor
SET DoctorPass = 'Doc13'
WHERE DoctorID = 213;

UPDATE Doctor
SET DoctorPass = 'Doc14'
WHERE DoctorID = 214;

UPDATE Doctor
SET DoctorPass = 'Doc15'
WHERE DoctorID = 215;

UPDATE Doctor
SET DoctorPass = 'Doc16'
WHERE DoctorID = 216;

UPDATE Doctor
SET DoctorPass = 'Doc17'
WHERE DoctorID = 217;

UPDATE Doctor
SET DoctorPass = 'Doc18'
WHERE DoctorID = 218;

UPDATE Doctor
SET DoctorPass = 'Doc19'
WHERE DoctorID = 219;

UPDATE Doctor
SET DoctorPass = 'Doc20'
WHERE DoctorID = 220;

SELECT * from Doctor

---- Insert details into RegulatoryDept ----

INSERT INTO RegulatoryDept (Regulatory_Dept_ID, Authorizer_Name)
VALUES
    (1001, 'Ashley Brown'),
    (1002, 'Jason Nash'),
    (1003, 'Joshua Mathews'),
    (1004, 'Joey Tribbiani'),
	(1005, 'Rachel Green');

---- Added new column ----

ALTER TABLE RegulatoryDept
ADD DeptPass varchar(500);

SELECT * FROM RegulatoryDept;

---- Updated details ----

update RegulatoryDept
set DeptPass='Dept1'
where Regulatory_Dept_ID=1001;
update RegulatoryDept
set DeptPass='Dept2'
where Regulatory_Dept_ID=1002;
update RegulatoryDept
set DeptPass='Dept3'
where Regulatory_Dept_ID=1003;
update RegulatoryDept
set DeptPass='Dept4'
where Regulatory_Dept_ID=1004;
update RegulatoryDept
set DeptPass='Dept5'
where Regulatory_Dept_ID=1005;
update RegulatoryDept
set DeptPass='Dept6'
where Regulatory_Dept_ID=1006;
insert into RegulatoryDept(Regulatory_Dept_ID, Authorizer_Name, DeptPass) 
values(1007, 'John Nathan', 'Dept7')
insert into RegulatoryDept(Regulatory_Dept_ID, Authorizer_Name, DeptPass) 
values(1008, 'Viola Dsouza', 'Dept8')
insert into RegulatoryDept(Regulatory_Dept_ID, Authorizer_Name, DeptPass) 
values(1009, 'John Green', 'Dept9')
insert into RegulatoryDept(Regulatory_Dept_ID, Authorizer_Name, DeptPass) 
values(1010, 'Mark Green', 'Dept10')

select * from RegulatoryDept;

---- Insert details into Staff ----

INSERT INTO Staff (InstitutionStaffID, InstitutionID, ContactNumber, ContactEmail, Department, Address)
VALUES
    (901, 1, '8571111111', 'staff1@gmail.com', 'Administration', '123 Main St'),
    (902, 2, '8572222222', 'staff2@gmail.com', 'Nursing', '456 Oak St'),
    (903, 3, '8573333333', 'staff3@gmail.com', 'Lab', '789 Pine St'),
    (904, 4, '8574444444', 'staff4@gmail.com', 'IT', '101 Elm St'),
    (905, 5, '8575555555', 'staff5@gmail.com', 'Human Resources', '202 Cedar St'),
    (906, 6, '8576666666', 'staff6@gmail.com', 'Lab', '303 Maple St'),
    (907, 7, '8577777777', 'staff7@gmail.com', 'Patient Services', '404 Birch St'),
    (908, 8, '8578888888', 'staff8@gmail.com', 'Medical Records', '505 Pine St'),
    (909, 9, '8579999999', 'staff9@gmail.com', 'Lab', '606 Oak St'),
    (910, 10, '8571010101', 'staff10@gmail.com', 'Security', '707 Main St'),
    (911, 1, '8571111101', 'staff11@gmail.com', 'Administration', '124 Main St'),
    (912, 2, '8572222202', 'staff12@gmail.com', 'Nursing', '457 Oak St'),
    (913, 3, '8573333303', 'staff13@gmail.com', 'Lab', '790 Pine St'),
    (914, 4, '8574444404', 'staff14@gmail.com', 'IT', '102 Elm St'),
    (915, 5, '8575555505', 'staff15@gmail.com', 'Human Resources', '203 Cedar St');

--- Added new Column --- 

Alter TABLE Staff 
ADD StaffPass VARCHAR(50)

--- Updated StaffPass ---

update Staff
set StaffPass='Staff1'
where InstitutionStaffID = 901

update Staff
set StaffPass='Staff2'
where InstitutionStaffID = 902

UPDATE Staff
SET StaffPass = 'Staff3'
WHERE InstitutionStaffID = 903;

UPDATE Staff
SET StaffPass = 'Staff4'
WHERE InstitutionStaffID = 904;

UPDATE Staff
SET StaffPass = 'Staff5'
WHERE InstitutionStaffID = 905;

UPDATE Staff
SET StaffPass = 'Staff6'
WHERE InstitutionStaffID = 906;

UPDATE Staff
SET StaffPass = 'Staff7'
WHERE InstitutionStaffID = 907;

UPDATE Staff
SET StaffPass = 'Staff8'
WHERE InstitutionStaffID = 908;

UPDATE Staff
SET StaffPass = 'Staff9'
WHERE InstitutionStaffID = 909;

UPDATE Staff
SET StaffPass = 'Staff10'
WHERE InstitutionStaffID = 910;

UPDATE Staff
SET StaffPass = 'Staff11'
WHERE InstitutionStaffID = 911;

UPDATE Staff
SET StaffPass = 'Staff12'
WHERE InstitutionStaffID = 912;

UPDATE Staff
SET StaffPass = 'Staff13'
WHERE InstitutionStaffID = 913;

UPDATE Staff
SET StaffPass = 'Staff14'
WHERE InstitutionStaffID = 914;

UPDATE Staff
SET StaffPass = 'Staff15'
WHERE InstitutionStaffID = 915;

SELECT * FROM Staff;

---- Insert details into InsuranceCoverage ----

INSERT INTO InsuranceCoverage (Insurance_Registration_ID, PatientID, Coverage, Expiration_Date)
VALUES
    (301, 101, 'Basic', '2023-12-31'),
    (302, 102, 'Advance', '2023-12-30'),
    (303, 103, 'Basic', '2023-12-29'),
    (304, 104, 'PremiumPlus', '2023-12-28'),
    (305, 105, 'Advance', '2023-12-27'),
    (306, 106, 'Advance', '2023-12-26'),
    (307, 107, 'Premium', '2023-12-25'),
    (308, 108, 'PremiumPlus', '2023-12-24'),
    (309, 109, 'Basic', '2023-12-23'),
    (310, 110, 'Advance', '2023-12-22'),
    (311, 111, 'PremiumPlus', '2023-12-21');

SELECT * FROM InsuranceCoverage;

---- Insert details into Visit ----

INSERT INTO Visit (VisitID, DoctorID, PatientID, InstitutionID, Visit_Date, Visit_Time)
VALUES
    (401, 201, 101, 1, '2022-12-01', '08:00:00'),
    (402, 202, 102, 2, '2022-12-02', '09:15:00'),
    (403, 203, 103, 3, '2022-12-03', '10:30:00'),
    (404, 204, 104, 4, '2022-12-04', '11:45:00'),
    (405, 205, 105, 5, '2022-12-05', '13:00:00'),
    (406, 206, 106, 6, '2022-12-06', '14:15:00'),
    (407, 207, 107, 7, '2022-12-07', '15:30:00'),
    (408, 208, 108, 8, '2022-12-08', '16:45:00'),
    (409, 209, 109, 9, '2022-12-09', '18:00:00'),
    (410, 210, 110, 10, '2022-12-10', '19:15:00'),
    (411, 211, 111, 1, '2022-12-11', '20:30:00'),
    (412, 212, 112, 2, '2022-12-12', '21:45:00'),
    (413, 213, 101, 3, '2022-12-13', '23:00:00'),
    (414, 214, 102, 4, '2022-12-14', '00:15:00'),
    (415, 215, 103, 5, '2022-12-15', '01:30:00');

    INSERT INTO Visit (VisitID, DoctorID, PatientID, InstitutionID, Visit_Date, Visit_Time)
VALUES
    (416, 201, 101, 1, '2022-12-16', '02:30:42'),
    (417, 202, 101, 2, '2022-12-17', '10:36:53'),
    (418, 203, 102, 3, '2022-12-19', '06:53:32'),
    (419, 201, 103, 1, '2023-01-09', '02:30:42'),
    (420, 202, 101, 2, '2023-01-16', '11:32:13'),
    (421, 201, 101, 4, '2023-01-21', '15:30:12'),
    (422, 202, 104, 9, '2023-01-31', '17:32:41'),
    (423, 207, 106, 4, '2023-02-02', '15:30:13'),
    (424, 203, 101, 7, '2023-02-10', '17:30:12'),
    (425, 207, 102, 6, '2023-02-21', '09:30:42');

SELECT * FROM VISIT

---- Insert details into Treatment ----

INSERT INTO Treatment (TreatmentID, PatientID, InstitutionID, DoctorID, Cost, Description, Date, Diagnosed_Illness)
VALUES
   (501, 101, 1, 201, 500.0, 'COVID-19 Diagnostic Check-up', '2023-05-20', 'COVID19'),
   (502, 102, 2, 202, 400.0, 'BP Diagnostic Check-up', '2023-06-21', 'BP'),
   (503, 103, 3, 203, 700.0, 'COVID-19 Diagnostic Check-up', '2023-03-22', 'COVID19'),
   (504, 104, 4, 204, 800.0, 'BP Diagnostic Check-up', '2022-11-23', 'BP'),
   (505, 105, 5, 205, 200.0, 'Diabetes Diagnostic Check-up', '2023-03-24', 'Diabetes'),
   (506, 106, 6, 206, 900.0, 'COVID-19 Diagnostic Check-up', '2023-06-25', 'COVID19'),
   (507, 107, 7, 207, 400.0, 'Diabetes Diagnostic Check-up', '2023-07-26', 'Diabetes'),
   (508, 108, 8, 208, 400.0, 'Diabetes Diagnostic Check-up', '2023-08-27', 'Diabetes'),
   (509, 109, 9, 209, 900.0, 'COVID-19 Diagnostic Check-up', '2022-12-28', 'COVID19'),
   (510, 110, 10, 210, 800.0, 'BP Diagnostic Check-up', '2023-01-29', 'BP'),
   (511, 111, 1, 211, 5000.0, 'Diabetes Diagnostic Check-up', '2023-02-01', 'Diabetes'),
   (512, 112, 3, 213, 200.0, 'Flu Diagnostic Check-up', '2022-12-02', 'Flu'),
   (513, 101, 2, 212, 300.0, 'Flu Diagnostic Check-up', '2022-12-03', 'Flu'),
   (514, 102, 4, 214, 500.0, 'COVID-19 Diagnostic Check-up', '2023-04-04', 'COVID19'),
   (515, 103, 5, 215, 100.0, 'Flu Diagnostic Check-up', '2023-08-05', 'Flu'),
   (516, 104, 6, 216, 350.0, 'BP Diagnostic Check-up', '2023-12-06', 'BP'),
   (517, 105, 7, 217, 450.0, 'COVID-19 Diagnostic Check-up', '2023-12-07', 'COVID19'),
   (518, 106, 8, 218, 150.0, 'Flu Diagnostic Check-up', '2023-12-08', 'Flu'),
   (519, 107, 9, 219, 550.0, 'Diabetes Diagnostic Check-up', '2022-12-09', 'Diabetes'),
   (520, 108, 10, 220, 650.0, 'COVID-19 Diagnostic Check-up', '2022-12-10', 'COVID19');

   INSERT INTO Treatment (TreatmentID, PatientID, InstitutionID, DoctorID, Cost, Description, Date, Diagnosed_Illness)
VALUES
(527, 121, 7, 216, 350.0, 'COVID-19 Diagnostic Check-up', '2023-12-06', 'COVID19'),
   (528, 132, 7, 217, 450.0, 'Flu Diagnostic Check-up', '2023-12-07', 'Flu'),
   (529, 144, 9, 218, 150.0, 'Flu Diagnostic Check-up', '2023-12-08', 'Flu'),
   (530, 125, 9, 210, 550.0, 'BP Diagnostic Check-up', '2022-12-09', 'BP'),
   (531, 112, 10, 208, 650.0, 'Diabetes Diagnostic Check-up', '2022-12-10', 'Diabetes'),
   (532, 123, 7, 216, 350.0, 'COVID-19 Diagnostic Check-up', '2023-12-02', 'COVID19'),
   (533, 133, 1, 217, 450.0, 'Flu Diagnostic Check-up', '2023-12-03', 'Flu'),
   (534, 141, 5, 218, 150.0, 'Flu Diagnostic Check-up', '2023-12-04', 'Flu'),
   (535, 123, 9, 210, 550.0, 'BP Diagnostic Check-up', '2022-12-09', 'BP'),
   (536, 116, 10, 208, 650.0, 'Diabetes Diagnostic Check-up', '2022-12-10', 'Diabetes'),
   (537, 129, 6, 216, 350.0, 'COVID-19 Diagnostic Check-up', '2023-12-08', 'COVID19'),
   (538, 135, 5, 217, 450.0, 'Flu Diagnostic Check-up', '2023-12-09', 'Flu'),
   (539, 122, 8, 218, 150.0, 'Flu Diagnostic Check-up', '2023-12-13', 'Flu'),
   (540, 130, 9, 210, 550.0, 'BP Diagnostic Check-up', '2022-12-16', 'BP'),
   (541, 140, 2, 208, 650.0, 'Diabetes Diagnostic Check-up', '2022-12-19', 'Diabetes');

SELECT * FROM Treatment;

---- Insert details into Record ----

INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType)
VALUES
    (610, 101, 1, 1001, 'Room123', '2023-09-15', 'Diagnostic Reports'),
    (611, 102, 2, 1002, 'Room234', '2023-08-20', 'Prescription'),
    (612, 103, 3, 1003, 'Room345', '2023-07-25', 'Diagnostic Reports'),
    (613, 104, 4, 1001, 'Room456', '2023-06-30', 'Prescription'),
    (614, 105, 5, 1002, 'Room567', '2023-05-05', 'Diagnostic Reports'),
    (615, 106, 6, 1003, 'Room678', '2023-04-10', 'Prescription'),
    (616, 107, 7, 1001, 'Room789', '2023-03-15', 'Diagnostic Reports'),
    (617, 108, 8, 1002, 'Room890', '2023-02-20', 'Prescription'),
    (618, 109, 9, 1003, 'Room901', '2023-01-25', 'Diagnostic Reports'),
    (619, 110, 10, 1001, 'Room101', '2022-12-30', 'Prescription'),
    (620, 111, 1, 1002, 'Room202', '2022-11-05', 'Diagnostic Reports'),
    (621, 112, 2, 1003, 'Room303', '2022-10-10', 'Prescription'),
    (622, 101, 3, 1001, 'Room404', '2022-09-15', 'Diagnostic Reports'),
    (623, 102, 4, 1002, 'Room505', '2022-08-20', 'Prescription'),
    (624, 103, 5, 1003, 'Room606', '2022-07-25', 'Diagnostic Reports'),
    (625, 104, 6, 1001, 'Room707', '2022-06-30', 'Prescription'),
    (626, 105, 7, 1002, 'Room808', '2022-05-05', 'Diagnostic Reports'),
    (627, 106, 8, 1003, 'Room909', '2022-04-10', 'Prescription'),
    (628, 107, 9, 1001, 'Room1010', '2022-03-15', 'Diagnostic Reports'),
    (629, 108, 10, 1002, 'Room1111', '2022-02-20', 'Prescription'),
    (630, 109, 1, 1003, 'Room1212', '2022-01-25', 'Prescription');


INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType, Status)
VALUES
  (636, 106, 6, 1006, 'Room 6', '2023-06-22', 'Prescription', 'Waiting'),
  (637, 107, 7, 1007, 'Room 7', '2023-07-12', 'Diagnostic Reports', 'Approved'),
  (638, 108, 8, 1008, 'Room 8', '2023-08-03', 'Prescription', 'Waiting'),
  (639, 109, 9, 1009, 'Room 9', '2023-09-28', 'Diagnostic Reports', 'Approved'),
  (640, 110, 10, 1010, 'Room 10', '2023-10-09', 'Prescription', 'Waiting'),
  (641, 111, 1, 1001, 'Room 11', '2023-11-14', 'Diagnostic Reports', 'Approved'),
  (642, 112, 2, 1002, 'Room 12', '2023-12-01', 'Prescription', 'Waiting'),
  (643, 113, 3, 1003, 'Room 13', '2023-01-25', 'Diagnostic Reports', 'Approved'),
  (644, 114, 4, 1004, 'Room 14', '2023-02-08', 'Prescription', 'Waiting'),
  (645, 115, 5, 1005, 'Room 15', '2023-03-17', 'Diagnostic Reports', 'Approved'),
  (646, 116, 6, 1006, 'Room 16', '2023-04-30', 'Prescription', 'Waiting'),
  (647, 117, 7, 1007, 'Room 17', '2023-05-09', 'Diagnostic Reports', 'Approved'),
  (648, 118, 8, 1008, 'Room 18', '2023-06-14', 'Prescription', 'Waiting'),
  (649, 119, 9, 1009, 'Room 19', '2023-07-27', 'Diagnostic Reports', 'Approved'),
  (650, 120, 10, 1010, 'Room 20', '2023-08-19', 'Prescription', 'Waiting'),
  (651, 121, 1, 1001, 'Room 21', '2023-09-04', 'Diagnostic Reports', 'Approved'),
  (652, 122, 2, 1002, 'Room 22', '2023-10-11', 'Prescription', 'Waiting'),
  (653, 123, 3, 1003, 'Room 23', '2023-11-23', 'Diagnostic Reports', 'Approved'),
  (654, 124, 4, 1004, 'Room 24', '2023-12-06', 'Prescription', 'Waiting'),
  (655, 125, 5, 1005, 'Room 25', '2023-01-07', 'Diagnostic Reports', 'Approved'),
  (656, 126, 6, 1006, 'Room 26', '2023-02-14', 'Prescription', 'Waiting'),
  (657, 127, 7, 1007, 'Room 27', '2023-03-19', 'Diagnostic Reports', 'Approved'),
  (658, 128, 8, 1008, 'Room 28', '2023-04-02', 'Prescription', 'Waiting'),
  (659, 129, 9, 1009, 'Room 29', '2023-05-28', 'Diagnostic Reports', 'Approved'),
  (660, 130, 10, 1010, 'Room 30', '2023-06-09', 'Prescription', 'Waiting'),
  (661, 131, 1, 1001, 'Room 31', '2023-07-14', 'Diagnostic Reports', 'Approved'),
  (662, 132, 2, 1002, 'Room 32', '2023-08-21', 'Prescription', 'Waiting'),
  (663, 133, 3, 1003, 'Room 33', '2023-09-12', 'Diagnostic Reports', 'Approved'),
  (664, 134, 4, 1004, 'Room 34', '2023-10-05', 'Prescription', 'Waiting'),
  (665, 135, 5, 1005, 'Room 35', '2023-11-18', 'Diagnostic Reports', 'Approved'),
  (666, 136, 6, 1006, 'Room 36', '2023-12-22', 'Prescription', 'Waiting'),
  (667, 137, 7, 1007, 'Room 37', '2023-01-12', 'Diagnostic Reports', 'Approved'),
  (668, 138, 8, 1008, 'Room 38', '2023-02-03', 'Prescription', 'Waiting'),
  (669, 139, 9, 1009, 'Room 39', '2023-03-28', 'Diagnostic Reports', 'Approved'),
  (670, 140, 10, 1010, 'Room 40', '2023-04-09', 'Prescription', 'Waiting');

INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType, Status, CreationTimeStamp)
VALUES
    (671, 102, 2, 1002, 'Room 2', '2023-07-02', 'Prescription', 'Waiting', '2023-07-02 08:15:30.123'),
    (672, 103, 3, 1003, 'Room 3', '2023-07-03', 'Diagnostic Reports', 'Approved', '2023-07-03 14:45:20.567'),
    (673, 104, 4, 1004, 'Room 4', '2023-07-04', 'Prescription', 'Waiting', '2023-07-04 10:20:15.789'),
    (674, 105, 5, 1005, 'Room 5', '2023-07-05', 'Diagnostic Reports', 'Approved', '2023-07-05 09:35:55.234'),
    (675, 106, 6, 1006, 'Room 6', '2023-08-06', 'Prescription', 'Waiting', '2023-08-06 11:40:40.987'),
    (676, 107, 7, 1007, 'Room 7', '2023-08-07', 'Diagnostic Reports', 'Approved', '2023-08-07 15:55:25.321'),
    (677, 108, 8, 1008, 'Room 8', '2023-08-08', 'Prescription', 'Waiting', '2023-08-08 07:10:10.654'),
    (678, 109, 9, 1009, 'Room 9', '2023-08-09', 'Diagnostic Reports', 'Approved', '2023-08-09 13:25:50.987'),
    (679, 110, 10, 1010, 'Room 10', '2023-08-10', 'Prescription', 'Waiting', '2023-08-10 09:30:35.321'),
    (680, 111, 1, 1001, 'Room 11', '2023-09-11', 'Diagnostic Reports', 'Approved', '2023-08-11 14:45:20.654'),
    (681, 112, 2, 1002, 'Room 12', '2023-09-12', 'Prescription', 'Waiting', '2023-08-12 10:00:05.987'),
    (682, 113, 3, 1003, 'Room 13', '2023-09-13', 'Diagnostic Reports', 'Approved', '2023-08-13 16:15:50.321'),
    (683, 114, 4, 1004, 'Room 14', '2023-09-14', 'Prescription', 'Waiting', '2023-08-14 11:30:35.654'),
    (684, 115, 5, 1005, 'Room 15', '2023-09-15', 'Diagnostic Reports', 'Approved', '2023-08-15 07:45:20.987'),
    (685, 116, 6, 1006, 'Room 16', '2023-09-16', 'Prescription', 'Waiting', '2023-09-16 13:00:05.321');

    INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType, Status, CreationTimeStamp)
VALUES
    (686, 101, 1, 1001, 'Room 1', '2023-09-01', 'Diagnostic Reports', 'Approved', '2023-09-01 09:30:45.678'),
    (687, 102, 2, 1002, 'Room 2', '2023-09-02', 'Prescription', 'Waiting', '2023-09-02 08:15:30.123'),
    (688, 103, 3, 1003, 'Room 3', '2023-09-03', 'Diagnostic Reports', 'Approved', '2023-09-03 14:45:20.567'),
    (689, 104, 4, 1004, 'Room 4', '2023-09-04', 'Prescription', 'Waiting', '2023-09-04 10:20:15.789'),
    (690, 105, 5, 1005, 'Room 5', '2023-09-05', 'Diagnostic Reports', 'Approved', '2023-09-05 09:35:55.234'),
    (691, 106, 6, 1006, 'Room 6', '2023-09-06', 'Prescription', 'Waiting', '2023-09-06 11:40:40.987'),
    (692, 107, 7, 1007, 'Room 7', '2023-09-07', 'Diagnostic Reports', 'Approved', '2023-09-07 15:55:25.321'),
    (693, 108, 8, 1008, 'Room 8', '2023-09-08', 'Prescription', 'Waiting', '2023-09-08 07:10:10.654'),
    (694, 109, 9, 1009, 'Room 9', '2023-09-09', 'Diagnostic Reports', 'Approved', '2023-09-09 13:25:50.987'),
    (695, 110, 10, 1010, 'Room 10', '2023-09-10', 'Prescription', 'Waiting', '2023-09-10 09:30:35.321'),
    (696, 111, 1, 1001, 'Room 11', '2023-10-11', 'Diagnostic Reports', 'Approved', '2023-10-11 14:45:20.654'),
    (697, 112, 2, 1002, 'Room 12', '2023-10-12', 'Prescription', 'Waiting', '2023-10-12 10:00:05.987'),
    (698, 113, 3, 1003, 'Room 13', '2023-10-13', 'Diagnostic Reports', 'Approved', '2023-10-13 16:15:50.321'),
    (699, 114, 4, 1004, 'Room 14', '2023-10-14', 'Prescription', 'Waiting', '2023-10-14 11:30:35.654'),
    (700, 115, 5, 1005, 'Room 15', '2023-10-15', 'Diagnostic Reports', 'Approved', '2023-10-15 07:45:20.987');

    INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType, Status, CreationTimeStamp)
VALUES
    (701, 101, 1, 1001, 'Room 1', '2023-10-01', 'Diagnostic Reports', 'Approved', '2023-10-01 08:30:45.678'),
    (702, 102, 2, 1002, 'Room 2', '2023-10-02', 'Prescription', 'Waiting', '2023-10-02 07:15:30.123'),
    (703, 103, 3, 1003, 'Room 3', '2023-10-03', 'Diagnostic Reports', 'Approved', '2023-10-03 13:45:20.567'),
    (704, 104, 4, 1004, 'Room 4', '2023-10-04', 'Prescription', 'Waiting', '2023-10-04 09:20:15.789'),
    (705, 105, 5, 1005, 'Room 5', '2023-10-05', 'Diagnostic Reports', 'Approved', '2023-10-05 08:35:55.234'),
    (706, 106, 6, 1006, 'Room 6', '2023-10-06', 'Prescription', 'Waiting', '2023-10-06 10:40:40.987'),
    (707, 107, 7, 1007, 'Room 7', '2023-10-07', 'Diagnostic Reports', 'Approved', '2023-10-07 14:55:25.321'),
    (708, 108, 8, 1008, 'Room 8', '2023-10-08', 'Prescription', 'Waiting', '2023-10-08 06:10:10.654'),
    (709, 109, 9, 1009, 'Room 9', '2023-10-09', 'Diagnostic Reports', 'Approved', '2023-10-09 12:25:50.987'),
    (710, 110, 10, 1010, 'Room 10', '2023-10-10', 'Prescription', 'Waiting', '2023-10-10 09:30:35.321'),
    (711, 111, 1, 1001, 'Room 11', '2023-11-11', 'Diagnostic Reports', 'Approved', '2023-11-11 14:45:20.654'),
    (712, 112, 2, 1002, 'Room 12', '2023-11-12', 'Prescription', 'Waiting', '2023-11-12 10:00:05.987'),
    (713, 113, 3, 1003, 'Room 13', '2023-11-13', 'Diagnostic Reports', 'Approved', '2023-11-13 16:15:50.321'),
    (714, 114, 4, 1004, 'Room 14', '2023-11-14', 'Prescription', 'Waiting', '2023-11-14 11:30:35.654'),
    (715, 115, 5, 1005, 'Room 15', '2023-11-15', 'Diagnostic Reports', 'Approved', '2023-11-15 07:45:20.987');


    INSERT INTO Record (UniqueRecordID, PatientID, InstitutionID, Regulatory_Dept_ID, Location, Date, ReportType, Status, CreationTimeStamp)
VALUES
    (716, 101, 1, 1001, 'Room 1', '2023-11-01', 'Diagnostic Reports', 'Approved', '2023-11-01 10:30:45.678'),
    (717, 102, 2, 1002, 'Room 2', '2023-11-02', 'Prescription', 'Waiting', '2023-11-02 09:15:30.123'),
    (718, 103, 3, 1003, 'Room 3', '2023-11-03', 'Diagnostic Reports', 'Approved', '2023-11-03 15:45:20.567'),
    (719, 104, 4, 1004, 'Room 4', '2023-11-04', 'Prescription', 'Waiting', '2023-11-04 11:20:15.789'),
    (720, 105, 5, 1005, 'Room 5', '2023-11-05', 'Diagnostic Reports', 'Approved', '2023-11-05 10:35:55.234'),
    (721, 106, 6, 1006, 'Room 6', '2023-11-06', 'Prescription', 'Waiting', '2023-11-06 12:40:40.987'),
    (722, 107, 7, 1007, 'Room 7', '2023-11-07', 'Diagnostic Reports', 'Approved', '2023-11-07 16:55:25.321'),
    (723, 108, 8, 1008, 'Room 8', '2023-11-08', 'Prescription', 'Waiting', '2023-11-08 08:10:10.654'),
    (724, 109, 9, 1009, 'Room 9', '2023-11-09', 'Diagnostic Reports', 'Approved', '2023-11-09 14:25:50.987'),
    (725, 110, 10, 1010, 'Room 10', '2023-11-10', 'Prescription', 'Waiting', '2023-11-10 09:30:35.321'),
    (726, 111, 1, 1001, 'Room 11', '2023-11-11', 'Diagnostic Reports', 'Approved', '2023-11-11 14:45:20.654'),
    (727, 112, 2, 1002, 'Room 12', '2023-11-12', 'Prescription', 'Waiting', '2023-11-12 10:00:05.987');

SELECT * FROM Record

---- Update Records ----

update Record 
set Status='Approved'
where UniqueRecordID=610

update Record 
set Status='Waiting'
where UniqueRecordID=611

update Record 
set Status='Waiting'
where UniqueRecordID=612

update Record 
set Status='Approved'
where UniqueRecordID=613

update Record 
set Status='Waiting'
where UniqueRecordID=614

update Record 
set Status='Approved'
where UniqueRecordID=615

update Record 
set Status='Approved'
where UniqueRecordID=616

update Record 
set Status='Waiting'
where UniqueRecordID=617

update Record 
set Status='Approved'
where UniqueRecordID=618

update Record 
set Status='Waiting'
where UniqueRecordID=619

update Record 
set Status='Approved'
where UniqueRecordID=620

update Record 
set Status='Approved'
where UniqueRecordID=621

update Record 
set Status='Approved'
where UniqueRecordID=622

update Record 
set Status='Waiting'
where UniqueRecordID=623

update Record 
set Status='Waiting'
where UniqueRecordID=624

update Record 
set Status='Approved'
where UniqueRecordID=625

update Record 
set Status='Waiting'
where UniqueRecordID=626

update Record 
set Status='Approved'
where UniqueRecordID=627

update Record 
set Status='Waiting'
where UniqueRecordID=628

update Record 
set Status='Approved'
where UniqueRecordID=629

update Record 
set Status='Waiting'
where UniqueRecordID=630

------------------- Update CreationTimeStamp records ------

ALTER TABLE Record
ADD L

update Record 
set CreationTimeStamp='2022-08-06 17:21:30.294'
where UniqueRecordID=610

update Record 
set CreationTimeStamp='2022-08-17 19:23:48.191'
where UniqueRecordID=611

update Record 
set CreationTimeStamp='2022-09-10 18:21:55.341'
where UniqueRecordID=612

update Record 
set CreationTimeStamp='2022-09-18 18:10:53.123'
where UniqueRecordID=613

update Record 
set CreationTimeStamp='2022-09-25 20:54:55.234'
where UniqueRecordID=614

update Record 
set CreationTimeStamp='2022-10-10 21:41:55.123'
where UniqueRecordID=615

update Record 
set CreationTimeStamp='2022-10-15 20:43:55.123'
where UniqueRecordID=616

update Record 
set CreationTimeStamp='2022-10-17 17:32:55.123'
where UniqueRecordID=617

update Record 
set CreationTimeStamp='2022-10-27 13:35:55.123'
where UniqueRecordID=618

update Record 
set CreationTimeStamp='2022-11-13 18:30:58.123'
where UniqueRecordID=619

update Record 
set CreationTimeStamp='2022-11-16 21:30:58.123'
where UniqueRecordID=620

update Record 
set CreationTimeStamp='2022-11-21 11:30:58.123'
where UniqueRecordID=621

update Record 
set CreationTimeStamp='2022-11-28 17:30:58.123'
where UniqueRecordID=622

update Record 
set CreationTimeStamp='2022-11-30 18:12:58.123'
where UniqueRecordID=623

update Record 
set CreationTimeStamp='2022-12-04 15:34:43.234'
where UniqueRecordID=624

update Record 
set CreationTimeStamp='2022-12-15 17:11:43.213'
where UniqueRecordID=625

update Record 
set CreationTimeStamp='2022-12-17 09:12:12.321'
where UniqueRecordID=626

update Record 
set CreationTimeStamp='2022-12-21 11:43:34.123'
where UniqueRecordID=627

update Record 
set CreationTimeStamp='2022-12-24 16:34:53.567'
where UniqueRecordID=628

update Record 
set CreationTimeStamp='2022-12-25 15:31:41.421'
where UniqueRecordID=629

update Record 
set CreationTimeStamp='2023-01-03 13:12:41.231'
where UniqueRecordID=630

update Record 
set CreationTimeStamp='2023-01-05 15:21:41.231'
where UniqueRecordID=631

update Record 
set CreationTimeStamp='2023-01-08 13:43:12.342'
where UniqueRecordID=632

update Record 
set CreationTimeStamp='2023-01-11 18:54:31.231'
where UniqueRecordID=633

update Record 
set CreationTimeStamp='2023-01-15 21:15:43.312'
where UniqueRecordID=634

update Record 
set CreationTimeStamp='2023-01-17 13:12:41.231'
where UniqueRecordID=635

update Record 
set CreationTimeStamp='2023-01-24 16:42:12.124'
where UniqueRecordID=636

update Record 
set CreationTimeStamp='2023-01-31 19:32:12.124'
where UniqueRecordID=637

update Record 
set CreationTimeStamp='2023-02-08 19:32:12.124'
where UniqueRecordID=638

update Record 
set CreationTimeStamp='2023-02-11 21:13:44.213'
where UniqueRecordID=639

update Record 
set CreationTimeStamp='2023-02-14 22:32:12.124'
where UniqueRecordID=640

update Record 
set CreationTimeStamp='2023-02-16 14:32:12.431'
where UniqueRecordID=641

update Record 
set CreationTimeStamp='2023-02-17 17:14:19.312'
where UniqueRecordID=642

update Record 
set CreationTimeStamp='2023-02-21 19:23:15.341'
where UniqueRecordID=643

update Record 
set CreationTimeStamp='2023-02-24 11:45:42.213'
where UniqueRecordID=644

update Record 
set CreationTimeStamp='2023-02-27 09:32:32.321'
where UniqueRecordID=645

update Record 
set CreationTimeStamp='2023-02-28 22:32:12.124'
where UniqueRecordID=646

update Record 
set CreationTimeStamp='2023-03-15 21:46:12.114'
where UniqueRecordID=647

update Record 
set CreationTimeStamp='2023-03-21 21:46:17.154'
where UniqueRecordID=648

update Record 
set CreationTimeStamp='2023-03-28 13:57:32.215'
where UniqueRecordID=649

update Record 
set CreationTimeStamp='2023-04-15 21:46:12.114'
where UniqueRecordID=650

update Record 
set CreationTimeStamp='2023-04-23 13:24:52.174'
where UniqueRecordID=651

update Record 
set CreationTimeStamp='2023-05-10 22:59:31.133'
where UniqueRecordID=652

update Record 
set CreationTimeStamp='2023-05-14 20:51:41.521'
where UniqueRecordID=653

update Record 
set CreationTimeStamp='2023-05-17 13:21:13.242'
where UniqueRecordID=654

update Record 
set CreationTimeStamp='2023-05-24 18:34:42.231'
where UniqueRecordID=655

update Record 
set CreationTimeStamp='2023-05-26 19:31:14.153'
where UniqueRecordID=656

update Record 
set CreationTimeStamp='2023-05-27 21:41:11.163'
where UniqueRecordID=657

update Record 
set CreationTimeStamp='2023-06-03 22:34:59.171'
where UniqueRecordID=658

update Record 
set CreationTimeStamp='2023-06-08 12:41:43.177'
where UniqueRecordID=659

update Record 
set CreationTimeStamp='2023-06-11 17:31:34.187'
where UniqueRecordID=660

update Record 
set CreationTimeStamp='2023-06-14 10:42:12.177'
where UniqueRecordID=661

update Record 
set CreationTimeStamp='2023-06-16 17:53:21.531'
where UniqueRecordID=662

update Record 
set CreationTimeStamp='2023-06-19 20:57:31.342'
where UniqueRecordID=663

update Record 
set CreationTimeStamp='2023-06-21 21:31:43.123'
where UniqueRecordID=664

update Record 
set CreationTimeStamp='2023-06-24 13:21:54.234'
where UniqueRecordID=665

update Record 
set CreationTimeStamp='2023-06-28 23:41:43.177'
where UniqueRecordID=666

update Record 
set CreationTimeStamp='2023-07-06 21:34:43.137'
where UniqueRecordID=667

update Record 
set CreationTimeStamp='2023-07-11 17:52:14.127'
where UniqueRecordID=668

update Record 
set CreationTimeStamp='2023-07-17 20:34:43.137'
where UniqueRecordID=669

update Record 
set CreationTimeStamp='2023-07-20 14:15:45.174'
where UniqueRecordID=670

select * from Record

---- Insert Details in Prescription ----

INSERT INTO Prescription (UniqueRecordID, E_Sign_Doctor)
SELECT UniqueRecordID, 'Awaiting Doctor Signature'
FROM Record
WHERE ReportType = 'Prescription';

---- Insert Details in Diagnostic Reports ----

INSERT INTO DiagnosticReports (UniqueRecordID)
SELECT UniqueRecordID
FROM Record
WHERE ReportType = 'Diagnostic Reports';
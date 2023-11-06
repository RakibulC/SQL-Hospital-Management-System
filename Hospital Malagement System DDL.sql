DROP DATABASE Hospital_Management_SystemDB
go
CREATE DATABASE Hospital_Management_SystemDB
ON primary
(
	NAME= 'Hospital_Management_SystemDB_Data_1',
	FILENAME= 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Medical_ClinicDB.mdf',
	SIZE=25MB,
	MAXSIZE=100MB,
	FILEGROWTH=5%
)
LOG ON
(
	NAME='Hospital_Management_SystemDB_Log_1',
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Medical_ClinicDB_Log.ldf',
	SIZE=5MB,
	MAXSIZE=50MB,
	FILEGROWTH=1%
)
GO

USE Hospital_Management_SystemDB
GO
					----CREATE TABLE----
					--Table-1- Surgeon:
CREATE TABLE Surgeon (
	surgeon_id INT PRIMARY KEY,
	surgeon_name nvarchar (50) NOT NULL,
	surgeon_designation nvarchar (50) NOT NULL,
	surgeon_email nvarchar (50) unique NOT NULL,
	surgeon_contact INT unique NOT NULL
);

					--Table-2- Department:
CREATE TABLE Department (
	dept_id INT PRIMARY KEY,
	dept_name nvarchar (50) NOT NULL
);


					--Table-3- Patient:
CREATE TABLE Patient (
	patient_id INT PRIMARY KEY,
	patient_name nvarchar (50) NOT NULL,
	patient_diease nvarchar (50) NOT NULL,
	patient_age INT NOT NULL,
	patient_gender nvarchar (6) NOT NULL,
	patient_bloodgroup nvarchar (10) NOT NULL
);


					--Table-4- Room:
CREATE TABLE Room (
	room_number INT PRIMARY KEY,
	room_Name varchar (80) NOT NULL
);

					--Table-5- Bill:
CREATE TABLE Bill (
	bill_id INT PRIMARY KEY,
	bill_amount INT,
	bill_date varchar(50)
);

					--Table-6- Relation:
CREATE TABLE Relation (
	surgeon_id INT FOREIGN KEY REFERENCES Surgeon(surgeon_id),
	DepartmentID INT FOREIGN KEY REFERENCES Department(dept_id),
	PatientID INT FOREIGN KEY REFERENCES Patient(patient_id),
	RoomID INT FOREIGN KEY REFERENCES Room(room_number),
	BillID INT FOREIGN KEY REFERENCES Bill(bill_id)
);


	DROP Table Surgeon;
	DROP Table Department;
	DROP Table Patient;
	DROP Table Room;
	DROP Table Bill;
	DROP Table Relation;

	--Drop view table
	DROP VIEW Vw_HMDetails;

	--Drop Procedure
	DROP PROC spPatientInsert 
	DROP PROC spPatient

	--Drop Function
	DROP Function Fn_PatientDetails
	DROP Function fn_TotalBillCount

	--Drop Trigger
	DROP Trigger tr_Patient_insert
	DROP Trigger Trg_InsteadOfUpdatePatient

				---CREATE INDEX---
			----CREATE CLUSTERED INDEX-----
CREATE CLUSTERED INDEX idx_Surgeon
ON Relation(Surgeon_id);

----Show index in query----
EXECUTE sp_helpindex idx_Surgeon;

----CREATE NON-CLUSTERED INDEX-----
CREATE NONCLUSTERED INDEX DepartmentInfo
ON Relation(DepartmentID);

--Show index in query
EXECUTE sp_helpindex DepartmentInfo;

-----LTER TABLE-----------
---ADD column------
	ALTER TABLE Bill
	ADD TotalBill INT;

--Drop Column
	ALTER TABLE Bill DROP COLUMN TotalBill;

--ALL Column Delete
	TRUNCATE Table Surgeon;
	TRUNCATE Table Department;
	TRUNCATE Table Patient;
	TRUNCATE Table Room;
	TRUNCATE Table Bill;
	TRUNCATE Table Relation;

----------ALTER PROCEDURE-------------
ALTER PROC spPatient
AS
BEGIN
	SELECT patient_id, patient_name, patient_diease, patient_gender, patient_bloodgroup
	FROM Patient
	ORDER BY patient_id
END

----------ALTER FUNCTION------------
ALTER FUNCTION Fn_PatientDetails()

Returns Table
Return 
(
	SELECT Sur.surgeon_id, Sur.surgeon_name,
	COUNT(pt.patient_name) AS PatientCount
	FROM Relation

	JOIN Surgeon Sur ON Relation.surgeon_id = Sur.surgeon_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	Group by Sur.surgeon_id, Sur.surgeon_name
)
SELECT * FROM dbo.Fn_PatientDetails();

ALTER Function fn_TotalBillCount ()
Returns INT
BEGIN
	Declare @BillCount INT;
	SELECT @BillCount = MAX(bill.bill_amount) FROM Bill;
	Return @BillCount;
END;
SELECT dbo.fn_TotalBillCount() TotalBillCount;

-----------------VIEW-------------------
CREATE VIEW Vw_HMDetails As
	SELECT Sur.surgeon_id, Sur.surgeon_name, dpt.dept_name, pt.patient_name, rm.room_Name, bl.bill_amount
	From Relation
	JOIN Surgeon Sur ON Relation.surgeon_id = Sur.surgeon_id
	JOIN Department Dpt ON Relation.DepartmentID = dpt.dept_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	JOIN Room rm ON Relation.RoomID = rm.room_number
	JOIN Bill bl ON Relation.BillID = bl.bill_id

-------------MARGE TABLE----------

CREATE TABLE SurgeonMerge (
	surgeon_id INT PRIMARY KEY NOT NULL ,
	surgeon_name VARCHAR(50),
	surgeon_designation VARCHAR(80),
	surgeon_email VARCHAR(30),
	surgeon_contact INT NOT NULL
);
					----- MERGE
	MERGE INTO dbo.SurgeonMerge AS SMRG
	USING dbo.Surgeon AS Sur
    ON Sur.surgeon_id = SMRG.surgeon_id

	WHEN MATCHED THEN
    UPDATE SET
    SMRG.surgeon_name = Sur.surgeon_name,
	SMRG.surgeon_designation = Sur.surgeon_designation,
	SMRG.surgeon_email = Sur.surgeon_email,
	SMRG.surgeon_contact = Sur.surgeon_contact

    WHEN NOT MATCHED THEN 
    INSERT (surgeon_id, surgeon_name, surgeon_designation, surgeon_email, surgeon_contact)
    VALUES (Sur.surgeon_id, Sur.surgeon_name,Sur.surgeon_designation,Sur.surgeon_email,Sur.surgeon_contact);



		-------CREATE A FUNCTION
		---TABLE Value Function-----
CREATE FUNCTION Fn_PatientDetails()
Returns Table
Return 
(
	SELECT Sur.surgeon_id, Sur.surgeon_name,
	COUNT(pt.patient_name) AS PatientCount
	FROM Relation

	JOIN Surgeon Sur ON Relation.surgeon_id = Sur.surgeon_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	Group by Sur.surgeon_id, Sur.surgeon_name
)

SELECT * FROM dbo.Fn_PatientDetails();

-----------Scalar value function-Count -----------
CREATE Function fn_PatientCount ()
Returns INT
BEGIN
Declare @PatientCount INT;
SELECT @PatientCount = COUNT(*) FROM Patient;
Return @PatientCount;
END;

SELECT dbo.fn_PatientCount() AS PatientCount;

/*----------------------------------------Scalar value function-Sum -------------------------------------*/
CREATE Function fn_TotalBillCount ()
Returns INT
BEGIN
	Declare @BillCount INT;
	SELECT @BillCount = SUM(bill.bill_amount) FROM Bill;
	Return @BillCount;

END;

SELECT dbo.fn_TotalBillCount() TotalBillCount;

/*--------------------------------------Multi Statement Table Valued Function-----------------------------*/

CREATE Function Fn_MultiStatement()
Returns @multiTable Table (patient_id INT, patient_name VARCHAR(50), patient_gender VARCHAR(10), patient_age INT)
AS
BEGIN
	INSERT INTO @multiTable
	SELECT patient_id, patient_name, patient_gender, CAST(patient_age AS nvarchar) FROM Patient
	Return
END

SELECT * FROM Fn_MultiStatement();

						---------TRIGGER
			----------Trigger on Patient Table----------

CREATE TABLE backTblPatient (
	patient_id INT PRIMARY KEY,
	patient_name nvarchar (50) NOT NULL,
	patient_diease nvarchar (50) NOT NULL,
	patient_age INT NOT NULL,
	patient_gender nvarchar (6) NOT NULL,
	patient_bloodgroup nvarchar (10) NOT NULL
);

----------Trigger--------------
CREATE TRIGGER tr_Patient_insert
ON Patient
After Insert, Update
AS
INSERT INTO backTblPatient (
patient_id, patient_name, patient_diease, patient_age, patient_gender, patient_bloodgroup)

SELECT 
i.patient_id, i.patient_name,i.patient_diease,i.patient_age,i.patient_gender,i.patient_bloodgroup
FROM inserted i;

------Insert-----
INSERT INTO Patient (patient_id,patient_name,patient_diease,patient_age,patient_gender,patient_bloodgroup)
VALUES (16,'Jibon','Colds and Flu',28,'Male','A+')

SELECT * FROM Patient;
SELECT * FROM backTblPatient;

DELETE FROM Patient WHERE patient_id = 11;

/*---------------------For Insert/Update/Delete DML Trigger---------------------------*/
CREATE TRIGGER trAllDMLOperationsOnSurgeon 
ON Surgeon
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  PRINT 'YOU CANNOT PERFORM DML OPERATION ON DOCTOR TABLE!'
  ROLLBACK TRANSACTION
END
Insert Into Surgeon 
Values(6, 'fortrigger','OPD','trigger@gmail.com',012222223)

----------Instead of Trigger to Rise an Error---------
CREATE TRIGGER dbo.Trg_InsteadOfUpdatePatient
ON dbo.Relation
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @surgeon_ID int, @DepartmentID int, @PatientID int, @RoomID int, @BillID int;
	SELECT  @surgeon_ID	 = inserted.surgeon_ID,
	        @DepartmentID = inserted.DepartmentID,
	        @PatientID	 = inserted.PatientID,
	 	@RoomID		 = inserted.RoomID,  
		@BillID		 = inserted.BillID
FROM inserted
if UPDATE(surgeon_ID)
BEGIN
       RAISERROR('Surgeon Cannot be Updated.', 16 ,1)
	   ROLLBACK
END
ELSE
BEGIN
	  UPDATE [Relation]
	  SET surgeon_ID = @surgeon_ID
	  WHERE surgeon_ID = @surgeon_ID
	END
END
Update Relation set surgeon_ID = 3 where surgeon_ID = 1


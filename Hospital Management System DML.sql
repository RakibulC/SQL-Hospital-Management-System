USE Hospital_Management_SystemDB

-----INSERT Data insert Surgeon Table:-----

INSERT INTO Surgeon (surgeon_id,surgeon_name,surgeon_designation,surgeon_email,surgeon_contact) 
VALUES
	(1, 'Dr.Shamima Ahmed','Head of Dept. of Medicine','shamima@gmail.com',01723922202),
	(2, 'Dr Shovon','Consultant','shovon@gmail.com',0169200021),
	(3, 'Abdur Rashid','Medicine & Diadetologist','rashid@gmail.com',01921002229),
	(4, 'Dr Mahamuda','OPD','mahamuda@gmail.com',01720333330),
	(5, 'Abul Bashar','Nutrition','bashar@gmail.com',01312444558);
GO

--Data insert Department Table:

INSERT INTO Department(dept_id, dept_name) VALUES
	(1,'Hematology'),
	(2,'Medicine'),
	(3,'Kidney'),
	(4,'Neurology'),
	(5,'Cardiology');
GO

--Data insert Patient Table:

INSERT INTO Patient(patient_id,patient_name,patient_diease,patient_age,patient_gender,patient_bloodgroup) VALUES
	(1,'Shammi','Anemia',23,'Female','B+'),
	(2,'Nitu','Influenza',20,'Female','A+'),
	(3,'Rade','Allergies',10,'Male','0-'),
	(4,'Monisha','Colds and Flu',15,'Female','B+'),
	(5,'Alif','Diarrhea',25,'Male','A-'),
	(6,'Shimu','Colds and Flu',18,'Female','AB+'),
	(7,'Habiba','Anemia',28,'Female','A-'),
	(8,'Jidan','Diarrhea',8,'Male','B+'),
	(9,'Shuvo','Anemia',26,'Male','AB+'),
	(10,'Jelly','Colds and Flu',30,'Female','B+'),
	(11,'Mahmuda','Anemia',21,'Female','AB+'),
	(12,'Anamika','Colds and Flu',20,'Female','0-'),
	(13,'Jahid','Diabetes',22,'Male','B+'),
	(14,'Pollob','Anemia',28,'Male','B+'),
	(15,'Habib','Hepatitis B',26,'Male','0+');
GO

--Data Insert Room Table:
INSERT INTO Room (room_number, room_Name) VALUES
	(101,'Emergency unit'),
	(102,'Consulting'),
	(103,'Surgery'),
	(104,'Outpatient'),
	(105,'E.C.G');
GO

--Data Insert Bill Table:

INSERT INTO Bill (bill_id, bill_amount, bill_date) VALUES
	(201,1400,'2018-02-15'),
	(202,800,'2012-08-04'),
	(203,1500,'2021-05-06'),
	(204,600,'2020-01-15'),
	(205,1200,'2014-10-03'),
	(206,500,'2010-05-12'),
	(207,1100,'2018-02-09'),
	(208,2100,'2013-06-16'),
	(209,3000,'2018-01-01'),
	(210,2100,'2012-06-03'),
	(211,3000,'2010-01-09'),
	(212,2250,'2011-02-12'),
	(213,1500,'2012-05-10'),
	(214,1800,'2020-07-08'),
	(215,2100,'2014-02-10');
GO
		--Data Insert Relation Table:

INSERT INTO Relation (surgeon_id,DepartmentID,PatientID,RoomID,BillID) 
VALUES
	(1,1,1,101,201),
	(2,2,2,102,202),
	(3,3,3,103,203),
	(4,4,4,104,204),
	(5,5,5,105,205),
	(1,1,6,101,206),
	(2,2,7,102,207),
	(3,3,8,103,208),
	(1,1,9,104,209),
	(2,2,10,105,210),
	(4,4,11,101,211),
	(2,5,12,102,212),
	(5,1,13,103,213),
	(2,2,14,104,214),
	(1,1,15,105,215);
GO

/*---------------------------------------------------------------------------------------------------------
											VIEW TABLE
----------------------------------------------------------------------------------------------------------*/

	SELECT * FROM Surgeon;
	SELECT * FROM Department;
	SELECT * FROM Patient;
	SELECT * FROM Room;
	SELECT * FROM Bill;
	SELECT * FROM Relation;
	SELECT * FROM Vw_HMDetails

				---Join Table-----
	SELECT sur.surgeon_id,sur.surgeon_name,dpt.dept_name,
		   pt.patient_name,pt.patient_diease,
		   rm.room_number,rm.room_Name,
		   bl.bill_id,bl.bill_date,bl.bill_amount
	FROM Relation
	JOIN Surgeon sur ON Relation.surgeon_id = sur.surgeon_id
	JOIN Department Dpt ON Relation.DepartmentID = dpt.dept_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	JOIN Room rm ON Relation.RoomID = rm.room_number
	JOIN Bill bl ON Relation.BillID=bl.bill_id

/*-----------------------------------------Joining with Where Clause--------------------------------------------*/
SELECT sur.surgeon_id,sur.surgeon_name,dpt.dept_name,
		   pt.patient_name,pt.patient_diease,
		   rm.room_number,rm.room_Name,
		   bl.bill_id,bl.bill_date,bl.bill_amount
	FROM Relation
	JOIN Surgeon sur ON Relation.surgeon_id = sur.surgeon_id
	JOIN Department Dpt ON Relation.DepartmentID = dpt.dept_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	JOIN Room rm ON Relation.RoomID = rm.room_number
	JOIN Bill bl ON Relation.BillID=bl.bill_id

	WHERE patient_name='Shammi';

/*---------------------------------Joining with Group By & Having Clause---------------------------------*/
SELECT Surgeon.surgeon_id, Surgeon.surgeon_name,
	COUNT(pt.patient_name) AS PatientCount
	FROM Relation
	JOIN Surgeon ON Relation.surgeon_id = Surgeon.surgeon_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	Group by Surgeon.surgeon_id, Surgeon.surgeon_name
	Having Surgeon.surgeon_name = 'Dr Shovon';	

			----------------Joining with Order By--------------------------
SELECT Sur.surgeon_id, Sur.surgeon_name,
	COUNT(pt.patient_name) AS PatientCount
	FROM Relation
	JOIN Surgeon Sur ON Relation.surgeon_id = Sur.surgeon_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	Group by Sur.surgeon_id, Sur.surgeon_name
	Order by Sur.surgeon_name;


							----SUBQUERY 
							---SUBQUERY-01

	SELECT Sur.surgeon_id, Sur.surgeon_name, dpt.dept_name, pt.patient_name, rm.room_Name, bl.bill_amount, bl.bill_date
	From Relation
	JOIN Surgeon Sur ON Relation.surgeon_id = Sur.surgeon_id
	JOIN Department Dpt ON Relation.DepartmentID = dpt.dept_id
	JOIN Patient pt ON Relation.PatientID = pt.patient_id
	JOIN Room rm ON Relation.RoomID = rm.room_number
	JOIN Bill bl ON Relation.BillID=bl.bill_id
	WHERE Sur.surgeon_name IN
		(SELECT surgeon_name FROM Surgeon
	WHERE surgeon_name ='Dr.Shamima Ahmed');

						--SUBQUERY-02
	Select Sur.surgeon_name, Count (surgeon_name) As PatientCount
	From Surgeon Sur JOIN Relation Re
	On Sur.surgeon_id=Re.surgeon_id
	Where surgeon_name IN (Select surgeon_name from Surgeon)
	Group by Sur.surgeon_name;

								----CASE FUNCTION
SELECT Sur.surgeon_id, Sur.surgeon_name, dpt.dept_name, pt.patient_name, bl.bill_amount, 
CASE
WHEN bill_amount >= 3000 THEN 'Highest Bill' 
WHEN bill_amount > 1000 AND bill_amount < 3000  THEN 'Medium Bill'
ELSE 'Lowest Bill'
END AS Status
FROM Relation rel
JOIN Surgeon Sur ON  rel.surgeon_id =Sur.surgeon_id
JOIN Department dpt ON  rel.DepartmentID = dpt.dept_id
JOIN Patient pt ON rel.PatientID = pt.patient_id
JOIN Bill bl ON rel.BillID = bl.bill_id

						-----CTE------
	WITH CTE_Patient (PatientID,PatientName,PatientAge,PatientGender,PatientBloodgroup,PatientDiease) 
	AS 
	(
	SELECT 	pt.patient_id, pt.patient_name, pt.patient_age, pt.patient_gender, pt.patient_bloodgroup, pt.patient_diease
	FROM Patient pt
	)
	SELECT PatientID, PatientName,PatientAge, PatientGender, PatientBloodgroup, PatientDiease
	FROM CTE_Patient
	WHERE PatientName = 'Shammi';

------							STORE PROCEDURE
/*---------------------------------Store Procedure With parameters----------------------------------------*/
CREATE PROC spPatient
AS
BEGIN
	SELECT patient_id, patient_name, patient_diease, patient_gender FROM Patient;
END

EXEC spPatient;

CREATE PROC spPatientInsert
@patient_name nvarchar(50),
@patient_diease varchar(50),
@patient_age varchar(70),
@patient_bloodgroup nvarchar(100)
As
Insert Into Patient (patient_name,patient_diease,patient_age,patient_bloodgroup)
Values(@patient_name,@patient_diease,@patient_age,@patient_bloodgroup);

Exec spPatientInsert 'Shammi','Colds and Flu','19','A+';
Exec spPatientInsert 'Nitu','Influenza','20','A-';
Exec spPatientInsert 'Rade','Diarrhea','25','B+';
Exec spPatientInsert 'Monisha','Anemia','8','0+';
Exec spPatientInsert 'Alif','Allergies','22','A+';

--Procedure On Update
CREATE PROC spPatientUpdate
@patient_name nvarchar(50),
@patient_diease varchar(50)
AS
 Update Patient SET patient_name = @patient_name
 WHERE patient_diease = @patient_diease;

EXEC spPatientUpdate 'Nitu','Anemia'

Select * From Patient

-------Procedure On Delete------
CREATE PROC spPatientDelete
@patient_name nvarchar(50)
AS
BEGIN
	DELETE FROM Patient WHERE patient_name = @patient_name
END

/*--------------------------------Store Procedure Without parameters--------------------------------------*/
  CREATE PROC spwithoutParameters
  AS
  BEGIN
	SELECT * FROM Surgeon WHERE Surgeon_email = 'shamima@gmail.com';
  END

  EXEC spwithoutParameters;		
		
-------Store Procedure with Output parameters--------
			--Create Procedure
CREATE Proc spPatientCountByGender
  @Gender Varchar(15),
  @PatientCount INT OUTPUT
  AS
  BEGIN
	  SELECT @PatientCount = COUNT(patient_id)
	  FROM Patient
	  WHERE patient_gender = @Gender
  END
  -----Execute
Declare @TotalPatient INT 
Exec spPatientCountByGender 'Female', @TotalPatient OUTPUT
SELECT @TotalPatient AS FemalePatient

---------------	  		  ROLL UP
SELECT
bill_id, SUM(bill.bill_amount) FROM Bill

GROUP BY ROLLUP(bill_id);


-------					  RANK
 SELECT surgeon_id,
		surgeon_name,
		surgeon_designation,
		surgeon_contact,
		surgeon_email, 
 RANK() OVER(order by surgeon_designation DESC ) as RankDoctor
 FROM   surgeon ;
 SELECT * FROM surgeon

			---------CAST & CONVERT----------

SELECT bill_id, bill_amount,bill_date, CAST(bill_date AS datetime) AS ConvertedDate
FROM bill

SELECT bill_id, bill_amount,bill_date, CONVERT(datetime,bill_date) AS ConvertedDate
FROM bill




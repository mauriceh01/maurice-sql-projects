-- This system is designed to streamline the management of school operations including students, 
-- parents, teachers, classrooms, courses, attendance, and exams. It features robust relational structures 
-- for tracking student enrollment, assigning teachers to classes, recording attendance, managing exams and 
-- results, and generating report cards with automatic grade calculation. Normalized tables and data integrity 
-- constraints ensure reliability, while extensibility allows for future additions like semesters, fees, and 
-- scheduling.
-- SchoolManagementDB.sql
-- Maurice Hazan  06/13/2025
-- -------------------------------------------------------------------------------------------------------------


CREATE DATABASE SchoolManagementDB;

USE SchoolManagementDB;

-- ===================================================
-- ============== Parents Table ======================
-- ===================================================

CREATE TABLE Parents (
  ParentID 		  INT PRIMARY KEY AUTO_INCREMENT,
  FirstName		  VARCHAR(50),
  LastName  		VARCHAR(50),
  PhoneNumber   CHAR(10),
  Email         VARCHAR(100) UNIQUE
);

-- ===================================================
-- ============== Grades Table =======================
-- ===================================================

CREATE TABLE Grades (
  GradeID          	INT PRIMARY KEY AUTO_INCREMENT,
  GradeName        	VARCHAR(10)
);

-- ===================================================
-- ============== TeacherType Table ==================
-- ===================================================

CREATE TABLE TeacherType (
  TeacherTypeID     	INT PRIMARY KEY AUTO_INCREMENT,
  TypeName          	VARCHAR(20) -- e.g. full-time, part-time
);

-- ===================================================
-- ============== Departments Table ==================
-- ===================================================

CREATE TABLE Departments  (
  DepartmentID       	INT PRIMARY KEY AUTO_INCREMENT,
  DepartmentName    	VARCHAR(10)
);

-- ===================================================
-- ============== Gender Table =======================
-- ===================================================

CREATE TABLE Gender (
  GenderID          	 INT PRIMARY KEY AUTO_INCREMENT,
  GenderName        	 VARCHAR(20) UNIQUE
);

-- ===================================================
-- ============== Teachers Table =====================
-- ===================================================

CREATE TABLE Teachers ( 
  TeacherID         	INT PRIMARY KEY AUTO_INCREMENT,
  DepartmentID      	INT NOT NULL,
  TeacherTypeID     	INT NOT NULL,
  GenderID          	INT,
  TeacherFirstName  	VARCHAR(50),
  TeacherLastName   	VARCHAR(50),
  TeacherDOB        	DATE,
  TeacherAddress    	VARCHAR(100),
  TeacherPhone      	CHAR(10),
  TeacherEmail	    	VARCHAR(100) UNIQUE,
  FOREIGN KEY (TeacherTypeID) REFERENCES TeacherType(TeacherTypeID),
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (GenderID) REFERENCES Gender(GenderID)
);

-- ===================================================
-- ============== Classrooms Table ===================
-- ===================================================

CREATE TABLE Classrooms (
  ClassroomID       INT PRIMARY KEY AUTO_INCREMENT,
  GradeID           INT NOT NULL,
  TeacherID         INT NOT NULL,
  ClassroomName     VARCHAR(20),
  FOREIGN KEY (GradeID) REFERENCES Grades(GradeID),
  FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- ===================================================
-- ============== Students Table =====================
-- ===================================================    
    
CREATE TABLE Students (
  StudentID         INT PRIMARY KEY AUTO_INCREMENT,
  ParentID          INT NOT NULL,
  ClassroomID       INT NOT NULL,
  GenderID          INT,
  StudentFirstName  VARCHAR(50) NOT NULL,
  StudentLastName   VARCHAR(50) NOT NULL,
  StudentDOB        DATE,
  StudentAddress    VARCHAR(100),
  StudentPhone      CHAR(10),
  StudentEmail      VARCHAR(100) UNIQUE,
  FOREIGN KEY (ParentID) REFERENCES Parents(ParentID),
  FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID),
  FOREIGN KEY (GenderID) REFERENCES Gender(GenderID)
);

-- ===================================================
-- ============== Courses Table ======================
-- ===================================================

CREATE TABLE Courses (
   CourseID         INT PRIMARY KEY AUTO_INCREMENT,
  TeacherID         INT NOT NULL,
  DepartmentID      INT NOT NULL,
  CourseName        VARCHAR(50) NOT NULL,
  CourseDesc        VARCHAR(100),
  FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID),
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- ===================================================
-- ============== Attendance Table ===================
-- ===================================================    
    
CREATE TABLE Attendance (
  AttendanceID       INT PRIMARY KEY AUTO_INCREMENT,
  StudentID          INT NOT NULL,
  ClassroomID        INT NOT NULL,
  CurrentDate        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID)
);
    
-- ===================================================
-- ============== ExamType Table =====================
-- ===================================================    
    
CREATE TABLE ExamType (
  ExamTypeID        INT PRIMARY KEY AUTO_INCREMENT,
  ExamName          VARCHAR(45),
  ExamDesc          VARCHAR(100)
);
 
-- ===================================================
-- ============== Exams Table ========================
-- =================================================== 
 
CREATE TABLE Exams  (
  ExamID            INT PRIMARY KEY AUTO_INCREMENT,
  ExamTypeID        INT NOT NULL,
  ExamName          VARCHAR(50),
  StartDate         DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ExamTypeID) REFERENCES ExamType(ExamTypeID)
);
 
-- ===================================================
-- ============== ExamResult Table ==================
-- ===================================================
 
CREATE TABLE ExamResult (
  ExamResultID      INT PRIMARY KEY AUTO_INCREMENT,
  ExamID            INT NOT NULL,
  StudentID	    INT NOT NULL,
  CourseID	    INT NOT NULL,
  ExamScore	    DECIMAL(5,2),
  FOREIGN KEY  (ExamID)    REFERENCES Exams(ExamID),
  FOREIGN KEY  (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY  (CourseID)  REFERENCES Courses(CourseID),
  CONSTRAINT chk_exam_score_range CHECK (ExamScore BETWEEN 0 AND 100)
);
 
-- ===================================================
-- ============== CourseEnrollment Table =============
-- ===================================================
 
CREATE TABLE CourseEnrollment (
  EnrollmentID      INT PRIMARY KEY AUTO_INCREMENT,
  StudentID         INT NOT NULL,
  CourseID          INT NOT NULL,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);    
 
-- ===================================================
-- ============== ReportCard Table ===================
-- ===================================================
 
CREATE TABLE ReportCard (
  ReportCardID      INT PRIMARY KEY AUTO_INCREMENT,
  StudentID         INT NOT NULL,
  CourseID          INT NOT NULL,
  AverageScore      DECIMAL(5,2) NOT NULL,
  Grade             CHAR(1),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
    
-- ===================================================
-- ====================  END  ========================
-- ===================================================    

-- Lookup data inserts

INSERT INTO Gender (GenderName) VALUES ('Male'), ('Female'), ('Non-Binary'), ('Other'), ('Prefer not to say');

INSERT INTO Grades (GradeName) VALUES ('1st'), ('2nd'), ('3rd'), ('4th'), ('5th');

INSERT INTO TeacherType (TypeName) VALUES ('Full-Time');

INSERT INTO Departments (DepartmentName) VALUES ('Math');

-- Sample data inserts

INSERT INTO Parents (FirstName, LastName, PhoneNumber, Email) VALUES
('John', 'Doe', '4085551234', 'john.doe@example.com'),
('Maria', 'Gonzalez', '3235556789', 'maria.gonzalez@example.com'),
('David', 'Kim', '5105554321', 'david.kim@example.com'),
('Amina', 'Ali', '2135559876', 'amina.ali@example.com'),
('Emily', 'Chen', '4155552468', 'emily.chen@example.com');

INSERT INTO Teachers (DepartmentID, TeacherTypeID, TeacherFirstName, TeacherLastName, TeacherDOB, GenderID, TeacherAddress, TeacherPhone, TeacherEmail)
VALUES
(1, 1, 'Sarah', 'Johnson', '1985-06-20', 2, '123 Elm St', '4085551111', 's.johnson@example.com'),
(1, 1, 'James', 'Lee', '1979-04-15', 1, '12 Maple St', '4085552001', 'james.lee@example.com'),
(1, 1, 'Angela', 'Martinez', '1982-07-20', 2, '34 Oak Rd', '4085552002', 'angela.martinez@example.com'),
(1, 1, 'Jordan', 'Smith', '1990-11-05', 3, '78 Pine Ave', '4085552003', 'jordan.smith@example.com'),
(1, 1, 'David', 'Nguyen', '1986-01-25', 1, '90 Cedar Blvd', '4085552004', 'david.nguyen@example.com'),
(1, 1, 'Emily', 'White', '1988-03-12', 2, '56 Birch Ln', '4085552005', 'emily.white@example.com');

INSERT INTO Classrooms (GradeID, TeacherID, ClassroomName) VALUES
(1, 2, 'Room 101'),
(2, 3, 'Room 102'),
(3, 4, 'Room 103'),
(4, 5, 'Room 104'),
(5, 6, 'Room 105');

INSERT INTO Students (
    ParentID, ClassroomID, StudentFirstName, StudentLastName,
    StudentDOB, GenderID, StudentAddress, StudentPhone, StudentEmail
) VALUES
(1, 1,  'Liam',     'Hughes',   '2014-05-12', 1, '101 Elm St',   '4085553001', 'liam.hughes@example.com'),
(1, 2,  'Emma',     'Vargas',   '2013-08-22', 2, '102 Elm St',   '4085553002', 'emma.vargas@example.com'),
(1, 3,  'Noah',     'Bennett',  '2015-01-17', 1, '103 Elm St',   '4085553003', 'noah.bennett@example.com');

INSERT INTO Courses (TeacherID, DepartmentID, CourseName, CourseDesc)
VALUES
(2, 1, 'Math 101', 'Intro to Math'),
(3, 1, 'Science 101', 'Intro to Science');

INSERT INTO CourseEnrollment (StudentID, CourseID)
VALUES
(1, 1),
(2, 1),
(3, 2);

INSERT INTO ExamType (ExamName, ExamDesc)
VALUES ('Midterm', 'Midterm assessment'), ('Final', 'Final exam');

INSERT INTO Exams (ExamTypeID, ExamName, StartDate)
VALUES 
(1, 'Math Midterm', '2025-06-17 09:00:00'),
(2, 'Math Final',   '2025-06-21 10:00:00'),
(1, 'Science Midterm', '2025-06-18 11:00:00'),
(2, 'Science Final',   '2025-06-22 10:30:00');

INSERT INTO ExamResult (ExamID, StudentID, CourseID, ExamScore)
VALUES
(1, 1, 1, 88.5),
(2, 1, 1, 91.0),
(1, 2, 1, 76.0),
(2, 2, 1, 82.5),
(1, 3, 2, 95.0),
(2, 3, 2, 97.0);

INSERT INTO Attendance (StudentID, ClassroomID, CurrentDate)
VALUES
(1, 1, '2025-06-09'), (2, 2, '2025-06-09'), (3, 3, '2025-06-09'),
(1, 1, '2025-06-10'), (2, 2, '2025-06-10'), (3, 3, '2025-06-10');

-- Report card setup

INSERT INTO ReportCard (StudentID, CourseID, AverageScore)
SELECT 
    StudentID,
    CourseID,
    ROUND(AVG(ExamScore), 2) AS AverageScore
FROM ExamResult
GROUP BY StudentID, CourseID;

UPDATE ReportCard
SET Grade = CASE
    WHEN AverageScore >= 90 THEN 'A'
    WHEN AverageScore >= 80 THEN 'B'
    WHEN AverageScore >= 70 THEN 'C'
    WHEN AverageScore >= 60 THEN 'D'
    ELSE 'F'
END
WHERE ReportCardID > 0;

CREATE VIEW ReportCardView AS
SELECT 
    rc.ReportCardID,
    rc.StudentID,
    rc.CourseID,
    rc.AverageScore,
    CASE
        WHEN rc.AverageScore >= 90 THEN 'A'
        WHEN rc.AverageScore >= 80 THEN 'B'
        WHEN rc.AverageScore >= 70 THEN 'C'
        WHEN rc.AverageScore >= 60 THEN 'D'
        ELSE 'F'
    END AS Grade
FROM ReportCard rc;

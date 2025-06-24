-- This system is designed to streamline the management of school operations including students, 
-- parents, teachers, classrooms, courses, attendance, and exams. It features robust relational structures 
-- for tracking student enrollment, assigning teachers to classes, recording attendance, managing exams and 
-- results, and generating report cards with automatic grade calculation. Normalized tables and data integrity 
-- constraints ensure reliability, while extensibility allows for future additions like semesters, fees, and 
-- scheduling.
-- Maurice Hazan  06/13/2025
-- --------------------------------------------------------------------------------------------------------------------


CREATE DATABASE SchoolManagementDB;

USE SchoolManagementDB;

CREATE TABLE Parents (
	ParentID 		   INT PRIMARY KEY AUTO_INCREMENT,
    FirstName		   VARCHAR(50),
    LastName  		   VARCHAR(50),
    PhoneNumber        CHAR(10),
    Email              VARCHAR(100) UNIQUE
);

CREATE TABLE Grades (
	GradeID            INT PRIMARY KEY AUTO_INCREMENT,
    GradeName          VARCHAR(10)
);

CREATE TABLE TeacherType (
	TeacherTypeID      INT PRIMARY KEY AUTO_INCREMENT,
    TypeName           VARCHAR(20) -- e.g. full-time, part-time
);


CREATE TABLE Departments  (
	DepartmentID      INT PRIMARY KEY AUTO_INCREMENT,
	DepartmentName    VARCHAR(10)
);

CREATE TABLE Teachers (
	TeacherID         INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentID      INT NOT NULL,
    TeacherTypeID     INT NOT NULL,
    TeacherFirstName  VARCHAR(50),
    TeacherLastName   VARCHAR(50),
    TeacherDOB        DATE,
    TeacherGender     VARCHAR(10),
    TeacherAddress    VARCHAR(100),
    TeacherPhone      CHAR(10),
    TeacherEmail	  VARCHAR(100) UNIQUE,
    FOREIGN KEY (TeacherTypeID) REFERENCES TeacherType(TeacherTypeID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


CREATE TABLE Classrooms (
	ClassroomID       INT PRIMARY KEY AUTO_INCREMENT,
    GradeID           INT NOT NULL,
    TeacherID         INT NOT NULL,
    ClassroomName     VARCHAR(20),
    FOREIGN KEY (GradeID) REFERENCES Grades(GradeID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);
    
    
CREATE TABLE Students (
    StudentID         INT PRIMARY KEY AUTO_INCREMENT,
    ParentID          INT NOT NULL,
    ClassroomID       INT NOT NULL,
    StudentFirstName  VARCHAR(50) NOT NULL,
    StudentLastName   VARCHAR(50) NOT NULL,
	StudentDOB        DATE,
    StudentGender     VARCHAR(10),
    StudentAddress    VARCHAR(100),
    StudentPhone      CHAR(10),
    StudentEmail      VARCHAR(100) UNIQUE,
	FOREIGN KEY (ParentID) REFERENCES Parents(ParentID),
    FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID)
);

CREATE TABLE Courses (
	CourseID          INT PRIMARY KEY AUTO_INCREMENT,
    TeacherID         INT NOT NULL,
    DepartmentID      INT NOT NULL,
    CourseName        VARCHAR(50) NOT NULL,
    CourseDesc        VARCHAR(100),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
    
CREATE TABLE Attendance (
	AttendanceID       INT PRIMARY KEY AUTO_INCREMENT,
    StudentID          INT NOT NULL,
    ClassroomID        INT NOT NULL,
    CurrentDate        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID)
);
    
CREATE TABLE ExamType (
     ExamTypeID        INT PRIMARY KEY AUTO_INCREMENT,
     ExamName          VARCHAR(45),
     ExamDesc          VARCHAR(100)
);
 
CREATE TABLE Exams  (
	 ExamID            INT PRIMARY KEY AUTO_INCREMENT,
     ExamTypeID        INT NOT NULL,
     ExamName          VARCHAR(50),
     StartDate         DATETIME DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (ExamTypeID) REFERENCES ExamType(ExamTypeID)
);
    
CREATE TABLE ExamResult (
      ExamResultID      INT PRIMARY KEY AUTO_INCREMENT,
      ExamID			INT NOT NULL,
      StudentID			INT NOT NULL,
      CourseID			INT NOT NULL,
      ExamScore			DECIMAL(5,2),
      FOREIGN KEY  (ExamID)    REFERENCES Exams(ExamID),
      FOREIGN KEY  (StudentID) REFERENCES Students(StudentID),
      FOREIGN KEY  (CourseID)  REFERENCES Courses(CourseID)
);
    
CREATE TABLE CourseEnrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);    
    
ALTER TABLE ExamResult
ADD CONSTRAINT chk_exam_score_range
CHECK (ExamScore BETWEEN 0 AND 100);

CREATE TABLE Gender (
    GenderID    INT PRIMARY KEY AUTO_INCREMENT,
    GenderName  VARCHAR(20) UNIQUE
);

INSERT INTO Gender (GenderName) VALUES ('Male'), ('Female'), ('Non-Binary'), ('Other'), ('Prefer not to say');
	
ALTER TABLE Teachers
DROP COLUMN TeacherGender;    

ALTER TABLE Teachers
ADD GenderID INT,
ADD FOREIGN KEY (GenderID) REFERENCES Gender(GenderID);

ALTER TABLE Students
DROP COLUMN StudentGender;

ALTER TABLE Students
ADD GenderID INT,
ADD FOREIGN KEY (GenderID) REFERENCES Gender(GenderID);


INSERT INTO Parents (FirstName, LastName, PhoneNumber, Email) VALUES
('John', 'Doe', '4085551234', 'john.doe@example.com'),
('Maria', 'Gonzalez', '3235556789', 'maria.gonzalez@example.com'),
('David', 'Kim', '5105554321', 'david.kim@example.com'),
('Amina', 'Ali', '2135559876', 'amina.ali@example.com'),
('Emily', 'Chen', '4155552468', 'emily.chen@example.com');

INSERT INTO Grades (GradeName) VALUES ('1st');
INSERT INTO Departments (DepartmentName) VALUES ('Math');
INSERT INTO TeacherType (TypeName) VALUES ('Full-Time');

INSERT INTO Teachers (DepartmentID, TeacherTypeID, TeacherFirstName, TeacherLastName, TeacherDOB, TeacherAddress, TeacherPhone, TeacherEmail)
VALUES (1, 1, 'Sarah', 'Johnson', '1985-06-20', '123 Elm St', '4085551111', 's.johnson@example.com');

SELECT 
    t.TeacherID,
    t.TeacherFirstName,
    t.TeacherLastName,
    g.GenderName
FROM 
    Teachers t
JOIN 
    Gender g ON t.GenderID = g.GenderID;
    
INSERT INTO Teachers (DepartmentID, TeacherTypeID, TeacherFirstName, TeacherLastName, TeacherDOB, GenderID, TeacherAddress, TeacherPhone, TeacherEmail) VALUES
(1, 1, 'James', 'Lee', '1979-04-15', 1, '12 Maple St', '4085552001', 'james.lee@example.com'),
(1, 1, 'Angela', 'Martinez', '1982-07-20', 2, '34 Oak Rd', '4085552002', 'angela.martinez@example.com'),
(1, 1, 'Jordan', 'Smith', '1990-11-05', 3, '78 Pine Ave', '4085552003', 'jordan.smith@example.com'),
(1, 1, 'David', 'Nguyen', '1986-01-25', 1, '90 Cedar Blvd', '4085552004', 'david.nguyen@example.com'),
(1, 1, 'Emily', 'White', '1988-03-12', 2, '56 Birch Ln', '4085552005', 'emily.white@example.com'),
(1, 1, 'Avery', 'Brown', '1993-06-19', 3, '12 Redwood Dr', '4085552006', 'avery.brown@example.com'),
(1, 1, 'Carlos', 'Diaz', '1980-09-23', 1, '88 Spruce Ct', '4085552007', 'carlos.diaz@example.com'),
(1, 1, 'Sophia', 'Wang', '1985-08-30', 2, '101 Sequoia St', '4085552008', 'sophia.wang@example.com'),
(1, 1, 'Liam', 'Patel', '1991-10-10', 1, '55 Laurel Rd', '4085552009', 'liam.patel@example.com'),
(1, 1, 'Grace', 'Olsen', '1975-02-14', 2, '99 Hickory Ln', '4085552010', 'grace.olsen@example.com'),
(1, 1, 'Isaac', 'Ramirez', '1983-05-18', 1, '44 Willow Ct', '4085552011', 'isaac.ramirez@example.com'),
(1, 1, 'Nina', 'Khan', '1992-12-01', 2, '77 Magnolia Ave', '4085552012', 'nina.khan@example.com'),
(1, 1, 'Elliot', 'Choi', '1987-03-29', 3, '11 Cypress Blvd', '4085552013', 'elliot.choi@example.com'),
(1, 1, 'Rachel', 'Johnson', '1990-04-02', 2, '65 Elm Dr', '4085552014', 'rachel.johnson@example.com'),
(1, 1, 'Noah', 'Anderson', '1981-07-27', 1, '22 Fir St', '4085552015', 'noah.anderson@example.com'),
(1, 1, 'Olivia', 'Thomas', '1984-11-16', 2, '18 Palm Rd', '4085552016', 'olivia.thomas@example.com'),
(1, 1, 'Riley', 'Scott', '1993-09-09', 3, '84 Cottonwood Ln', '4085552017', 'riley.scott@example.com'),
(1, 1, 'Benjamin', 'Clark', '1989-02-07', 1, '39 Ash Ct', '4085552018', 'benjamin.clark@example.com'),
(1, 1, 'Chloe', 'Lewis', '1986-06-03', 2, '73 Larch Way', '4085552019', 'chloe.lewis@example.com'),
(1, 1, 'Aiden', 'Reed', '1991-01-30', 1, '19 Poplar Blvd', '4085552020', 'aiden.reed@example.com');

INSERT INTO Grades (GradeName)
VALUES ('1st'), ('2nd'), ('3rd'), ('4th'), ('5th');

INSERT INTO Classrooms (GradeID, TeacherID, ClassroomName) VALUES
(1, 2, 'Room 101'),
(2, 3, 'Room 102'),
(3, 4, 'Room 103'),
(4, 5, 'Room 104'),
(5, 6, 'Room 105'),
(1, 7, 'Room 106'),
(2, 8, 'Room 107'),
(3, 9, 'Room 108'),
(4, 10, 'Room 109'),
(5, 11, 'Room 110'),
(1, 12, 'Room 111'),
(2, 13, 'Room 112'),
(3, 14, 'Room 113'),
(4, 15, 'Room 114'),
(5, 16, 'Room 115'),
(1, 17, 'Room 116'),
(2, 18, 'Room 117'),
(3, 19, 'Room 118'),
(4, 20, 'Room 119'),
(5, 21, 'Room 120');

INSERT INTO Students (
    ParentID, ClassroomID, StudentFirstName, StudentLastName,
    StudentDOB, GenderID, StudentAddress, StudentPhone, StudentEmail
) VALUES
(1, 1,  'Liam',     'Hughes',   '2014-05-12', 1, '101 Elm St',   '4085553001', 'liam.hughes@example.com'),
(1, 2,  'Emma',     'Vargas',   '2013-08-22', 2, '102 Elm St',   '4085553002', 'emma.vargas@example.com'),
(1, 3,  'Noah',     'Bennett',  '2015-01-17', 1, '103 Elm St',   '4085553003', 'noah.bennett@example.com'),
(1, 4,  'Ava',      'Nguyen',   '2014-09-25', 2, '104 Elm St',   '4085553004', 'ava.nguyen@example.com'),
(1, 5,  'Lucas',    'Garcia',   '2013-03-11', 1, '105 Elm St',   '4085553005', 'lucas.garcia@example.com'),
(1, 6,  'Mia',      'Wright',   '2014-07-06', 2, '106 Elm St',   '4085553006', 'mia.wright@example.com'),
(1, 7,  'Ethan',    'Reyes',    '2015-02-14', 1, '107 Elm St',   '4085553007', 'ethan.reyes@example.com'),
(1, 8,  'Isabella', 'Young',    '2013-12-30', 2, '108 Elm St',   '4085553008', 'isabella.young@example.com'),
(1, 9,  'Mason',    'Perez',    '2014-06-08', 1, '109 Elm St',   '4085553009', 'mason.perez@example.com'),
(1, 10, 'Amelia',   'Kim',      '2013-10-19', 2, '110 Elm St',   '4085553010', 'amelia.kim@example.com'),
(1, 11, 'Logan',    'Morgan',   '2014-11-28', 1, '111 Elm St',   '4085553011', 'logan.morgan@example.com'),
(1, 12, 'Charlotte','Foster',   '2015-04-01', 2, '112 Elm St',   '4085553012', 'charlotte.foster@example.com'),
(1, 13, 'Aiden',    'Simmons',  '2013-01-09', 1, '113 Elm St',   '4085553013', 'aiden.simmons@example.com'),
(1, 14, 'Harper',   'Evans',    '2014-02-23', 2, '114 Elm St',   '4085553014', 'harper.evans@example.com'),
(1, 15, 'Jackson',  'James',    '2015-08-14', 1, '115 Elm St',   '4085553015', 'jackson.james@example.com'),
(1, 16, 'Ella',     'Ward',     '2013-06-03', 2, '116 Elm St',   '4085553016', 'ella.ward@example.com'),
(1, 17, 'Sebastian','Ross',     '2014-03-12', 1, '117 Elm St',   '4085553017', 'sebastian.ross@example.com'),
(1, 18, 'Luna',     'Cruz',     '2013-05-18', 2, '118 Elm St',   '4085553018', 'luna.cruz@example.com'),
(1, 19, 'Henry',    'Parker',   '2015-07-29', 1, '119 Elm St',   '4085553019', 'henry.parker@example.com'),
(1, 20, 'Sofia',    'Collins',  '2014-12-07', 2, '120 Elm St',   '4085553020', 'sofia.collins@example.com');

INSERT INTO ExamType (ExamName, ExamDesc)
VALUES ('Midterm', 'Midterm assessment'), ('Final', 'Final exam');

	INSERT INTO Exams (ExamTypeID, ExamName)
	VALUES
	(1, 'Math Midterm'), 
	(2, 'Math Final'),
	(1, 'Science Midterm'),
	(2, 'Science Final');
    
    INSERT INTO Courses (TeacherID, DepartmentID, CourseName, CourseDesc)
VALUES (2, 1, 'Math 101', 'Intro to Math');
    
INSERT INTO ExamResult (ExamID, StudentID, CourseID, ExamScore)
VALUES
(1, 1, 1, 88.5),
(2, 1, 1, 91.0),
(1, 2, 1, 76.0),
(2, 2, 1, 82.5),
(1, 3, 1, 95.0),
(2, 3, 1, 97.0),
(1, 4, 1, 67.0),
(2, 4, 1, 71.5),
(1, 5, 1, 80.0),
(2, 5, 1, 85.0);    

INSERT INTO Attendance (StudentID, ClassroomID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);

INSERT INTO Courses (TeacherID, DepartmentID, CourseName, CourseDesc)
VALUES 
(2, 1, 'Math 101', 'Intro to Math'),
(3, 1, 'Science 101', 'Intro to Science');



INSERT INTO CourseEnrollment (StudentID, CourseID)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 1),
(7, 2),
(8, 1),
(9, 2),
(10, 2);

INSERT INTO Attendance (StudentID, ClassroomID, CurrentDate)
VALUES
-- Monday
(1, 1, '2025-06-09'), (2, 2, '2025-06-09'), (3, 3, '2025-06-09'), (4, 4, '2025-06-09'), (5, 5, '2025-06-09'),
-- Tuesday
(1, 1, '2025-06-10'), (2, 2, '2025-06-10'), (3, 3, '2025-06-10'), (4, 4, '2025-06-10'), (5, 5, '2025-06-10'),
-- Wednesday
(1, 1, '2025-06-11'), (2, 2, '2025-06-11'), (3, 3, '2025-06-11'), (4, 4, '2025-06-11'), (5, 5, '2025-06-11'),
-- Thursday
(1, 1, '2025-06-12'), (2, 2, '2025-06-12'), (3, 3, '2025-06-12'), (4, 4, '2025-06-12'), (5, 5, '2025-06-12'),
-- Friday
(1, 1, '2025-06-13'), (2, 2, '2025-06-13'), (3, 3, '2025-06-13'), (4, 4, '2025-06-13'), (5, 5, '2025-06-13');

INSERT INTO Exams (ExamTypeID, ExamName, StartDate)
VALUES 
(1, 'Math Midterm', '2025-06-17 09:00:00'),
(2, 'Math Final',   '2025-06-21 10:00:00'),
(1, 'Science Midterm', '2025-06-18 11:00:00'),
(2, 'Science Final',   '2025-06-22 10:30:00');

SELECT 
    s.StudentID,
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName,
    c.CourseName,
    ROUND(AVG(er.ExamScore), 2) AS AverageScore
FROM
    ExamResult er
JOIN Students s ON er.StudentID = s.StudentID
JOIN Courses c ON er.CourseID = c.CourseID
GROUP BY s.StudentID, c.CourseID
ORDER BY s.StudentID;

SELECT 
    s.StudentID,
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName,
    COUNT(a.AttendanceID) AS DaysPresent,
    5 AS TotalSchoolDays,
    ROUND(COUNT(a.AttendanceID) / 5 * 100, 2) AS AttendancePercent
FROM Students s
LEFT JOIN Attendance a ON s.StudentID = a.StudentID
WHERE a.CurrentDate BETWEEN '2025-06-09' AND '2025-06-13'
GROUP BY s.StudentID;attendance

CREATE TABLE ReportCard (
    ReportCardID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    AverageScore DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO ReportCard (StudentID, CourseID, AverageScore)
SELECT 
    StudentID,
    CourseID,
    ROUND(AVG(ExamScore), 2) AS AverageScore
FROM ExamResult
GROUP BY StudentID, CourseID;

SELECT 
    rc.ReportCardID,
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName,
    c.CourseName,
    rc.AverageScore,
    rc.Grade
FROM ReportCard rc
JOIN Students s ON rc.StudentID = s.StudentID
JOIN Courses c ON rc.CourseID = c.CourseID
ORDER BY s.StudentID;

ALTER TABLE ReportCard
ADD COLUMN Grade CHAR(1);

UPDATE ReportCard
SET Grade = CASE
    WHEN AverageScore >= 90 THEN 'A'
    WHEN AverageScore >= 80 THEN 'B'
    WHEN AverageScore >= 70 THEN 'C'
    WHEN AverageScore >= 60 THEN 'D'
    ELSE 'F'
END
WHERE ReportCardID > 0;

SET SQL_SAFE_UPDATES = 0;

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

SELECT * FROM ReportCardView;


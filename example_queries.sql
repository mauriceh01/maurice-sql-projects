-- example_queries.sql
-- Example queries to demonstrate use of SchoolManagementDB schema

-- List all teachers with their gender
SELECT 
    t.TeacherID,
    t.TeacherFirstName,
    t.TeacherLastName,
    g.GenderName
FROM 
    Teachers t
JOIN 
    Gender g ON t.GenderID = g.GenderID;

-- Student average exam scores per course
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

-- Attendance report for a specific week
SELECT 
    s.StudentID,
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName,
    COUNT(a.AttendanceID) AS DaysPresent,
    5 AS TotalSchoolDays,
    ROUND(COUNT(a.AttendanceID) / 5 * 100, 2) AS AttendancePercent
FROM Students s
LEFT JOIN Attendance a ON s.StudentID = a.StudentID
WHERE a.CurrentDate BETWEEN '2025-06-09' AND '2025-06-13'
GROUP BY s.StudentID;

-- Report card summary from the view
SELECT * FROM ReportCardView;

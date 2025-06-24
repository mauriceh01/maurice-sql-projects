# 🏫 SchoolManagementDB

This project is a full-scale, comprehensive SQL-based system designed to streamline the management of school operations. 
This system models and tracks real-world relationships between students, parents, teachers, classrooms, departments, courses, attendance, exams, and reporting — all within a normalized, relational structure.

## 📘 Overview

**SchoolManagementDB** features robust data architecture and integrity to handle:

- ✅ Student enrollment and personal information
- ✅ Parent and guardian contacts  
- ✅ Classroom and teacher assignments  
- ✅ Course offerings and scheduling  
- ✅ Attendance tracking per student/class/date  
- ✅ Exam creation and grade input  
- ✅ Automated report card generation with GPA/grade calculation
- ✅ Data integrity via foreign keys and normalization
  

This system is scalable and extensible, built to reflect best practices in database design—including normalization, referential integrity, and future extensibility—it is ideal for both academic demonstrations and real-world prototyping.

## 📂 Core Features

- **Relational schema** with foreign keys and constraints
- **Many-to-many** relationships handled through bridge tables (e.g. student-course enrollments)
- **Attendance module** for per-day, per-class tracking
- **Exam results module** with grading logic
- **Scalable** for adding future features like:
  - Semester management
  - Tuition/fees
  - Timetabling and scheduling
  - Online portals for teachers/students
  - Optimized for reporting, analytics, and automation

## 🛠️ Technologies Used

- SQL (compatible with SQL Server / MySQL / PostgreSQL / SQLite)
- Designed for use with MS Access, Azure Data Studio, or any modern SQL interface

## 🧩 Tables Included

| Table Name       | Description |
|------------------|-------------|
| `Students`       | Stores student records including personal details and gender |
| `Parents`        | Tracks parents/guardians linked to students |
| `Teachers`       | Contains teacher details, linked to departments and types |
| `TeacherType`    | Defines teacher roles (e.g. full-time, adjunct, substitute) |
| `Gender`         | Lookup table for standardized gender values |
| `Departments`    | Defines school departments (e.g. Math, Science) |
| `Courses`        | Course catalog linked to departments and teachers |
| `Classrooms`     | Physical or virtual locations for course delivery |
| `Enrollments`    | Many-to-many bridge between students and courses |
| `Attendance`     | Logs student presence/absence per date per course |
| `Exams`          | Scheduled assessments for courses |
| `ExamType`       | Lookup table for types of exams (e.g. midterm, final) |
| `ExamResults`    | Stores student scores for each exam |
| `Grades`         | Lookup table mapping percentage ranges to letter grades |
| `ReportCard`     | Summarized academic performance per student/course/term |

## 🚀 Getting Started

1. Clone or download the `.sql` script from this repo.
2. Run it in your SQL environment to create the database and tables.
3. Populate it with sample data or connect it to your frontend.

## 🧠 Author

Maurice Hazan — *SQL Developer with a strong focus on data integrity, normalized design, and education systems.*

---

### 📌 License

This project is provided under the MIT License.

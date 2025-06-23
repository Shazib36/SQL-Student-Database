-- Database: student_management_system

-- 1. Create the Students Table
CREATE DATABASE `Student Management System`;
USE `Student Management System`;
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create the Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0 AND credits <= 10)
);

-- 3. Create the Enrollments Table (Junction Table for Many-to-Many)
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE (student_id, course_id) -- Ensures a student can't enroll in the same course twice
);

-- 4. Insert Sample Data into Students Table
INSERT INTO Students (first_name, last_name, date_of_birth, email) VALUES
('Alice', 'Smith', '2002-03-15', 'alice.smith@example.com'),
('Bob', 'Johnson', '2001-07-22', 'bob.j@example.com'),
('Charlie', 'Brown', '2003-01-01', 'charlie.b@example.com'),
('Diana', 'Prince', '2000-11-30', 'diana.p@example.com');

-- 5. Insert Sample Data into Courses Table
INSERT INTO Courses (course_code, course_name, description, credits) VALUES
('CS101', 'Introduction to Computer Science', 'Fundamental concepts of computing.', 3),
('MA201', 'Calculus I', 'Basic concepts of differential and integral calculus.', 4),
('PH101', 'Introduction to Philosophy', 'Overview of major philosophical ideas.', 3),
('HI305', 'World History II', 'From the Renaissance to the modern era.', 3);

-- 6. Insert Sample Data into Enrollments Table
-- Alice enrolls in CS101 and MA201
INSERT INTO Enrollments (student_id, course_id) VALUES
((SELECT student_id FROM Students WHERE email = 'alice.smith@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'CS101')),
((SELECT student_id FROM Students WHERE email = 'alice.smith@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'MA201'));

-- Bob enrolls in MA201 and PH101
INSERT INTO Enrollments (student_id, course_id) VALUES
((SELECT student_id FROM Students WHERE email = 'bob.j@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'MA201')),
((SELECT student_id FROM Students WHERE email = 'bob.j@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'PH101'));

-- Charlie enrolls in CS101
INSERT INTO Enrollments (student_id, course_id) VALUES
((SELECT student_id FROM Students WHERE email = 'charlie.b@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'CS101'));

-- Diana enrolls in HI305
INSERT INTO Enrollments (student_id, course_id) VALUES
((SELECT student_id FROM Students WHERE email = 'diana.p@example.com'), (SELECT course_id FROM Courses WHERE course_code = 'HI305'));

-- Get all students and their enrolled courses
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    c.course_code,
    e.enrollment_date
FROM
    Students s
JOIN
    Enrollments e ON s.student_id = e.student_id
JOIN
    Courses c ON e.course_id = c.course_id
ORDER BY
    s.last_name, s.first_name, c.course_name;

-- Get all courses and the number of students enrolled in each
SELECT
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS num_enrolled_students
FROM
    Courses c
LEFT JOIN
    Enrollments e ON c.course_id = e.course_id
GROUP BY
    c.course_id, c.course_name, c.course_code
ORDER BY
    num_enrolled_students DESC, c.course_name;

-- Find students who are not enrolled in any course
SELECT
    s.first_name,
    s.last_name
FROM
    Students s
LEFT JOIN
    Enrollments e ON s.student_id = e.student_id
WHERE
    e.enrollment_id IS NULL;
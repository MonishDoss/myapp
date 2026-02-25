-- ============================================================
--  schema.sql  –  run this ONCE before starting the app
--  mysql -u root -p < schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

CREATE TABLE IF NOT EXISTS students (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    course     VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- seed data (optional)
INSERT INTO students (name, email, course) VALUES
    ('Alice Johnson',  'alice@example.com',  'Computer Science'),
    ('Bob Smith',      'bob@example.com',    'Information Technology'),
    ('Carol Williams', 'carol@example.com',  'Software Engineering');

CREATE DATABASE TenderManagementSystem;
USE TenderManagementSystem;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Client', 'Company', 'Admin') NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
CREATE TABLE CompanyDetails (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    certification_url VARCHAR(255),
    blacklisted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES Users(user_id)
  );
CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    budget DECIMAL(12, 2),
    bid_type ENUM('Real-Time', 'Proposal-Based'),
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    posted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES Users(user_id)
  );
CREATE TABLE Bids (
    bid_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    company_id INT NOT NULL,
    amount DECIMAL(12, 2),
    bid_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Submitted', 'Accepted', 'Rejected') DEFAULT 'Submitted',
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (company_id) REFERENCES Users(user_id)
  );
CREATE TABLE Proposals (
    proposal_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    company_id INT NOT NULL,
    proposal_text TEXT,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Submitted', 'Accepted', 'Rejected') DEFAULT 'Submitted',
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (company_id) REFERENCES Users(user_id)
  );
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    client_id INT NOT NULL,
    company_id INT NOT NULL,
    amount DECIMAL(12, 2),
    method ENUM('Bank Transfer', 'Cheque'),
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    paid_on TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (client_id) REFERENCES Users(user_id),
    FOREIGN KEY (company_id) REFERENCES Users(user_id)
  );
CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    rated_by INT NOT NULL,
    rated_user INT NOT NULL,
    role ENUM('Client', 'Company'),
    rating_value INT CHECK (rating_value BETWEEN 1 AND 5),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (rated_by) REFERENCES Users(user_id),
    FOREIGN KEY (rated_user) REFERENCES Users(user_id)
  );
CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT,
    seen BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
  );
CREATE TABLE Meetings (
    meeting_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    company_id INT NOT NULL,
    scheduled_on DATETIME,
    meeting_link VARCHAR(255),
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (company_id) REFERENCES Users(user_id)
  );
CREATE TABLE AdminLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    action_type VARCHAR(100),
    description TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Users(user_id)
  );
INSERT INTO Users (name, email, password, role, verified) VALUES
('Ali Raza', 'ali@example.com', 'hashed_pass1', 'Client', TRUE),
('TechCorp Ltd.', 'techcorp@example.com', 'hashed_pass2', 'Company', TRUE),
('BuildX Solutions', 'buildx@example.com', 'hashed_pass3', 'Company', TRUE),
('Admin Huma', 'admin@example.com', 'hashed_pass4', 'Admin', TRUE);
INSERT INTO CompanyDetails (company_id, company_name, certification_url, blacklisted) VALUES
(2, 'TechCorp Ltd.', 'http://certs.example.com/techcorp', FALSE),
(3, 'BuildX Solutions', 'http://certs.example.com/buildx', FALSE);
INSERT INTO Projects (client_id, title, description, category, budget, bid_type, status) VALUES
(1, 'Website Development', 'Create a responsive and SEO-friendly company website', 'Web Design', 80000, 'Proposal-Based', 'Approved'),
(1, 'Mobile App Prototype', 'Develop a cross-platform MVP', 'Mobile Development', 100000, 'Real-Time', 'Pending');
INSERT INTO Bids (project_id, company_id, amount, bid_time, status) VALUES
(2, 2, 95000, NOW(), 'Submitted'),
(2, 3, 90000, NOW(), 'Submitted');
INSERT INTO Proposals (project_id, company_id, proposal_text, submission_date, status) VALUES
(1, 2, 'We propose to use ReactJS and NodeJS with a 4-week timeline.', NOW(), 'Submitted'),
(1, 3, 'BuildX will deliver the project using Laravel and Vue.js stack.', NOW(), 'Submitted');
INSERT INTO Payments (project_id, client_id, company_id, amount, method, status, paid_on) VALUES
(1, 1, 3, 78000, 'Bank Transfer', 'Completed', NOW());
INSERT INTO Ratings (project_id, rated_by, rated_user, role, rating_value, feedback, created_at) VALUES
(1, 1, 3, 'Company', 5, 'BuildX completed the project on time and met all expectations.', NOW()),
(1, 3, 1, 'Client', 4, 'Client provided clear instructions and prompt feedback.', NOW());
INSERT INTO Notifications (user_id, message, seen, created_at) VALUES
(2, 'You have been invited to a new bidding session.', FALSE, NOW()),
(1, 'Your project \"Mobile App Prototype\" has received new bids.', FALSE, NOW());
INSERT INTO Meetings (project_id, company_id, scheduled_on, meeting_link, status) VALUES
(2, 2, '2025-06-10 10:00:00', 'https://meet.example.com/session123', 'Scheduled'),
(2, 3, '2025-06-10 11:00:00', 'https://meet.example.com/session456', 'Scheduled');
INSERT INTO AdminLogs (admin_id, action_type, description, logged_at) VALUES
(4, 'Project Approval', 'Approved project ID 1 by client Ali Raza.', NOW()),
(4, 'Bid Review', 'Reviewed bids for project ID 2.', NOW());

-- Sample SQL file for testing SQL linting and formatting

-- Create database
CREATE DATABASE IF NOT EXISTS sample_app
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sample_app;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL
);

-- Posts table
CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    published_at TIMESTAMP NULL,
    view_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    parent_comment_id INT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- Tags table
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    color VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Post tags junction table
CREATE TABLE post_tags (
    post_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);

-- Insert with potential issues
INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES
('john_doe', 'john@example.com', 'hashed_password_1', 'John', 'Doe'),
('jane_smith', 'jane@example.com', 'hashed_password_2', 'Jane', 'Smith'),
('bob_wilson', 'bob@example.com', 'hashed_password_3', 'Bob', 'Wilson'),
-- Missing semicolon above, duplicate username below
('john_doe', 'john_duplicate@example.com', 'hashed_password_4', 'John', 'Duplicate');

-- Stored procedure with issues
DELIMITER //
CREATE PROCEDURE GetUserPosts(IN user_id INT)
BEGIN
    SELECT
        p.id,
        p.title,
        p.content,
        p.status,
        p.created_at,
        p.view_count,
        COUNT(c.id) as comment_count
    FROM posts p
    LEFT JOIN comments c ON p.id = c.post_id AND c.is_deleted = FALSE
    WHERE p.user_id = user_id
    GROUP BY p.id
    ORDER BY p.created_at DESC;
    -- Missing error handling
END //
DELIMITER ;

-- Trigger with issues
DELIMITER //
CREATE TRIGGER increment_view_count
    AFTER INSERT ON post_views
    FOR EACH ROW
BEGIN
    UPDATE posts
    SET view_count = view_count + 1
    WHERE id = NEW.post_id;
    -- No error handling if post doesn't exist
END //
DELIMITER ;

-- View with potential issues
CREATE VIEW problematic_view AS
SELECT
    p.*,
    u.username,
    u.first_name,
    u.last_name,
    COUNT(c.id) as comment_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id AND c.is_deleted = FALSE
WHERE p.status = 'published'
    -- Missing GROUP BY for aggregated column
GROUP BY p.id;

-- Function with issues
DELIMITER //
CREATE FUNCTION bad_function(param1 INT, param2 VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    -- No input validation
    DECLARE result INT;
    SET result = param1 + LENGTH(param2);
    -- No error handling
    RETURN result;
END //
DELIMITER ;

-- Complex query with potential issues
SELECT
    u.username,
    COUNT(p.id) as post_count,
    AVG(p.view_count) as avg_views,
    MAX(p.created_at) as last_post_date,
    (SELECT COUNT(*) FROM comments WHERE user_id = u.id AND is_deleted = FALSE) as total_comments
FROM users u
LEFT JOIN posts p ON u.id = p.user_id AND p.status = 'published'
WHERE u.is_active = TRUE
    AND u.created_at >= '2023-01-01'
GROUP BY u.id, u.username
HAVING post_count > 0
ORDER BY post_count DESC, avg_views DESC
LIMIT 10;

-- Query with syntax error (missing closing parenthesis)
SELECT * FROM users WHERE (id > 10 AND status = 'active' OR email LIKE '%@example.com';

-- Query with inconsistent naming conventions
SELECT
    user_name,
    userEmail,
    user_age,
    created_at,
    isActive
FROM users
WHERE user_age > 18;

-- Query with potential performance issues
SELECT * FROM large_table WHERE column LIKE '%pattern%';

-- Query with ambiguous column names
SELECT id, name, status FROM users u
JOIN posts p ON u.id = p.user_id
WHERE status = 'published';

-- Query using deprecated syntax
SELECT * FROM users GROUP BY username;

-- Query with implicit conversion issues
SELECT * FROM posts WHERE created_at = '2023-01-01';

-- Query with NULL handling issues
SELECT * FROM users WHERE email = NULL;

-- Query with ORDER BY issues
SELECT DISTINCT name FROM users ORDER BY id;

-- Query with subquery performance issues
SELECT * FROM users WHERE id IN (SELECT user_id FROM posts WHERE created_at > DATE_SUB(NOW(), INTERVAL 30 DAY));

-- Query with subquery and JOIN
SELECT
    p.title,
    p.content,
    u.username as author,
    GROUP_CONCAT(t.name SEPARATOR ', ') as tags,
    COUNT(DISTINCT c.id) as comment_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN post_tags pt ON p.id = pt.post_id
LEFT JOIN tags t ON pt.tag_id = t.id
LEFT JOIN comments c ON p.id = c.post_id AND c.is_deleted = FALSE
WHERE p.status = 'published'
    AND p.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY p.id, p.title, p.content, u.username
ORDER BY p.created_at DESC;

-- Update with potential issues
UPDATE users SET
    last_login = NOW(),
    is_active = CASE
        WHEN last_login < DATE_SUB(NOW(), INTERVAL 90 DAY) THEN FALSE
        ELSE TRUE
    END
WHERE id IN (
    SELECT DISTINCT user_id
    FROM posts
    WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
);

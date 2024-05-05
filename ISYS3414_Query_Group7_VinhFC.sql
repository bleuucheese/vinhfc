-- Authentication function
FUNCTION user_aut    (
    
 p_username IN VARCHAR2, --User_Name
 p_password IN VARCHAR2 -- Password    
)
 RETURN BOOLEAN
AS
 lc_pwd_exit VARCHAR2 (1);
BEGIN
 -- Validate whether the user exits or not
 SELECT 'Y'
 INTO lc_pwd_exit
 FROM Lib_User
 WHERE upper(username) = UPPER (p_username) AND pwd = p_password
;
RETURN TRUE;
EXCEPTION
 WHEN NO_DATA_FOUND
 THEN
 RETURN FALSE;
END user_aut;

-- Authorization 
DECLARE 
    result VARCHAR2(10);
BEGIN
    SELECT USER_TYPE INTO result FROM Lib_User WHERE UPPER(USERNAME)=V('APP USER');
    IF NVL (result, 'x') = 'Admin' THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;

DECLARE 
    result VARCHAR2(10);
BEGIN
    SELECT USER_TYPE INTO result FROM Lib_User WHERE UPPER(USERNAME)=V('APP USER');
    IF NVL (result, 'x') = 'Librarian' THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;

DECLARE 
    result VARCHAR2(10);
BEGIN
    SELECT user_type INTO result FROM Lib_User WHERE UPPER(USERNAME) = UPPER(V('APP_USER'));
    
    IF NVL(result, 'x') IN ('Student', 'Staff') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- Dynamic Fine ID Trigger
CREATE SEQUENCE fine_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_fine
BEFORE INSERT ON Fine
FOR EACH ROW
BEGIN
    :NEW.fine_id := 'FINE' || TO_CHAR(fine_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Book ID Trigger
CREATE SEQUENCE book_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_book
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
    :NEW.book_id := 'B' || TO_CHAR(book_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Room ID Trigger
CREATE SEQUENCE room_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_room
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    :NEW.room_id := 'R' || TO_CHAR(room_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Borrow ID Trigger
CREATE SEQUENCE borrow_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_borrow
BEFORE INSERT ON Member_HardCopy
FOR EACH ROW
BEGIN
    :NEW.borrow_id := 'BRW' || TO_CHAR(borrow_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Room Booking ID Trigger
CREATE SEQUENCE booking_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_member_room_booking
BEFORE INSERT ON Member_Room
FOR EACH ROW
BEGIN
    :NEW.booking_id := 'BKG' || TO_CHAR(booking_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Request ID Trigger
CREATE SEQUENCE request_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_requests
BEFORE INSERT ON Requests
FOR EACH ROW
BEGIN
    :NEW.request_id := 'REQ' || TO_CHAR(request_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Review ID Trigger
CREATE SEQUENCE review_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_review
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    :NEW.review_id := 'REV' || TO_CHAR(review_seq.NEXTVAL, 'FM000');
END;

-- Dynamic User ID Trigger
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER trg_before_insert_user
BEFORE INSERT ON Lib_User
FOR EACH ROW
BEGIN
    :NEW.user_id := 'U' || TO_CHAR(user_seq.NEXTVAL, 'FM000');
END;

-- Dynamic Fine ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_fine
BEFORE INSERT ON Fine
FOR EACH ROW
BEGIN
    SELECT CONCAT('FINE', LPAD(IFNULL(MAX(CAST(SUBSTRING(fine_id, 5) AS UNSIGNED)), 0) + 1, 3, '0')) INTO @next_fine_id
    FROM Fine;
    SET NEW.fine_id = @next_fine_id;
END$$
DELIMITER ;

-- Dynamic Book ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_book
BEFORE INSERT ON Book
FOR EACH ROW
BEGIN
    SELECT CONCAT('B', LPAD(IFNULL(MAX(CAST(SUBSTRING(book_id, 2) AS UNSIGNED)), 0) + 1, 3, '0')) INTO @next_book_id
    FROM Book;
    SET NEW.book_id = @next_book_id;
END$$
DELIMITER ;


-- Dynamic Room ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_room
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    SELECT CONCAT('R', LPAD(IFNULL(MAX(CAST(SUBSTRING(room_id, 2) AS UNSIGNED)), 0) + 1, 3, '0')) INTO @next_room_id
    FROM Room;
    SET NEW.room_id = @next_room_id;
END$$
DELIMITER ;

-- Dynamic Borrow ID trigger
DELIMITER $$
CREATE TRIGGER trg_set_borrow_id
BEFORE INSERT ON Member_HardCopy
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    -- Find the maximum numeric part of existing IDs assuming they all start with 'BRW'
    SELECT IFNULL(MAX(CAST(SUBSTRING(borrow_id, 4) AS UNSIGNED)), 0) INTO max_id FROM Member_HardCopy;
    -- Set the new borrow_id with the prefix and padded number
    SET NEW.borrow_id = CONCAT('BRW', LPAD(max_id + 1, 3, '0'));
END$$
DELIMITER ;


-- Dynamic Room Booking ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_member_room_booking
BEFORE INSERT ON Member_Room
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    DECLARE prefix CHAR(3) DEFAULT 'BKG';
    DECLARE new_id CHAR(15);

    -- Extract the numeric part from the maximum booking_id and increment it
    SELECT MAX(CAST(SUBSTRING(booking_id, 4) AS UNSIGNED)) INTO max_id FROM Member_Room;
    SET max_id = IFNULL(max_id, 0) + 1;

    -- Construct the new booking_id
    SET new_id = CONCAT(prefix, LPAD(max_id, 3, '0'));

    -- Set the new booking_id
    SET NEW.booking_id = new_id;
END$$
DELIMITER ;

-- Dynamic Request ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_requests
BEFORE INSERT ON Requests
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    -- Extract the numeric part from the maximum request_id and increment it
    SELECT IFNULL(MAX(CAST(SUBSTRING(request_id, 4) AS UNSIGNED)), 0) INTO max_id FROM Requests;
    -- Set the new request_id with incremented value
    SET NEW.request_id = CONCAT('REQ', LPAD(max_id + 1, 3, '0'));
END$$
DELIMITER ;

-- Dynamic Review ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_review
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    DECLARE max_id INT;
    -- Extract the numeric part from the maximum review_id and increment it
    SELECT IFNULL(MAX(CAST(SUBSTRING(review_id, 4) AS UNSIGNED)), 0) INTO max_id FROM Review;
    -- Set the new review_id with incremented value
    SET NEW.review_id = CONCAT('REV', LPAD(max_id + 1, 3, '0'));
END$$
DELIMITER ;

-- Dynamic User ID trigger
DELIMITER $$
CREATE TRIGGER trg_before_insert_lib_user
BEFORE INSERT ON Lib_User
FOR EACH ROW
BEGIN
    DECLARE max_num INT DEFAULT 0;
    DECLARE new_id CHAR(10);

    -- Extract the maximum numeric value from the user_id field
    SELECT MAX(CAST(SUBSTRING(user_id, 2) AS UNSIGNED)) INTO max_num FROM Lib_User;

    -- Increment the numeric value for the new user_id
    SET max_num = IFNULL(max_num, 0) + 1;

    -- Construct the new user_id with 'U' prefix and zero-padded number
    SET new_id = CONCAT('U', LPAD(max_num, 3, '0'));

    -- Set the new user_id for the row being inserted
    SET NEW.user_id = new_id;
END$$
DELIMITER ;

-- Borrowing process
DELIMITER $$
CREATE TRIGGER trg_borrow_book
BEFORE INSERT ON Member_HardCopy
FOR EACH ROW
BEGIN
    -- Set the due_date to be 2 months after the issue_date directly in the NEW row
    SET NEW.due_date = DATE_ADD(NEW.issue_date, INTERVAL 2 MONTH);

    -- No need to update the Member_HardCopy table directly, as we are setting the NEW values
    -- Update the status of the hard copy to 'Unavailable' in Hard_Copies table
    UPDATE Hard_Copies
    SET status = 'Unavailable'
    WHERE book_id = NEW.book AND copy_id = NEW.bcopy;

    -- Increment the total_book_borrowed for the user in the Lib_Member table
    UPDATE Lib_Member
    SET total_book_borrowed = total_book_borrowed + 1
    WHERE user_id = NEW.member;
END$$
DELIMITER ;

-- Returning process
DELIMITER $$
CREATE TRIGGER trg_before_update_member_hardcopy
BEFORE UPDATE ON Member_HardCopy
FOR EACH ROW
BEGIN
    -- Set return_date to current date when updating checkout_condition
    IF NEW.checkout_condition IN ('New', 'Damaged') THEN
        SET NEW.return_date = CURRENT_DATE();
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_after_update_member_hardcopy
AFTER UPDATE ON Member_HardCopy
FOR EACH ROW
BEGIN
    -- Update the status of the hard copy to 'Available' after the checkout_condition is updated
    IF NEW.checkout_condition IS NOT NULL THEN
        UPDATE Hard_Copies
        SET status = 'Available'
        WHERE book_id = NEW.book AND copy_id = NEW.bcopy;

        -- Decrement total_book_borrowed for the user
        UPDATE Lib_Member
        SET total_book_borrowed = total_book_borrowed - 1
        WHERE user_id = NEW.member;
    END IF;

    -- Insert a fine if the checkin_condition is not the same as checkout_condition
    IF NEW.checkout_condition IN ('New', 'Damaged') AND NEW.checkin_condition <> NEW.checkout_condition THEN
        INSERT INTO Fine (amount, reason, status, incurred_date, due_date, payer, book_id, copy_id)
        VALUES (50, 'Damaged book', 'Unpaid', NEW.issue_date, NEW.due_date, NEW.member, NEW.book, NEW.bcopy);
    END IF;
END$$
DELIMITER ;

-- Paying fine process
DELIMITER $$
CREATE TRIGGER trg_fine_paid
AFTER UPDATE ON Fine
FOR EACH ROW
BEGIN
    -- Check if the fine status has been updated to 'Paid'
    IF OLD.status <> 'Paid' AND NEW.status = 'Paid' THEN
        -- Update the total_fine_paid in the Lib_Member table
        UPDATE Lib_Member
        SET total_fine_paid = total_fine_paid + NEW.amount
        WHERE user_id = NEW.payer;

    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_fine_paid2
BEFORE UPDATE ON Fine
FOR EACH ROW
BEGIN
    -- Check if the fine status is being updated to 'Paid'
    IF OLD.status <> 'Paid' AND NEW.status = 'Paid' THEN
        -- Set the paid_date to the current date
        SET NEW.paid_date = CURRENT_DATE();

        -- Since we are in a BEFORE trigger, the following update will be executed
        -- AFTER the current transaction commits, avoiding the problem of updating
        -- the same table in an AFTER trigger
    END IF;
END$$
DELIMITER ;


-- Room booking process
SET GLOBAL event_scheduler = ON;

DELIMITER $$
CREATE TRIGGER trg_after_insert_member_room
AFTER INSERT ON Member_Room
FOR EACH ROW
BEGIN
    -- Set the room status to 'Unavailable'
    UPDATE Room
    SET status = 'Unavailable'
    WHERE room_id = NEW.room_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_before_insert_member_room
BEFORE INSERT ON Member_Room
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;
    -- Check for overlapping bookings
    SELECT COUNT(*) INTO overlap_count
    FROM Member_Room
    WHERE member_id = NEW.member_id
    AND room_id = NEW.room_id
    AND (
        (NEW.start_date BETWEEN start_date AND end_date) OR
        (NEW.end_date BETWEEN start_date AND end_date) OR
        (start_date BETWEEN NEW.start_date AND NEW.end_date) OR
        (end_date BETWEEN NEW.start_date AND NEW.end_date)
    );

    -- If there's an overlap, prevent insertion
    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot book more than one room within the same timeslot.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE EVENT ev_update_room_status
ON SCHEDULE EVERY 1 MINUTE
DO
    BEGIN
        -- Update the room status based on whether there's an ongoing booking that overlaps the current timestamp
        UPDATE Room
        LEFT JOIN Member_Room ON Room.room_id = Member_Room.room_id
            AND CURRENT_TIMESTAMP BETWEEN Member_Room.start_date AND Member_Room.end_date
        SET Room.status = IF(Member_Room.room_id IS NULL, 'Available', 'Unavailable');
    END$$
DELIMITER ;

-- Giving review process
DELIMITER $$
CREATE TRIGGER trg_after_insert_review
AFTER INSERT ON Review
FOR EACH ROW
BEGIN
    UPDATE Book
    SET ratings = (SELECT AVG(rating) FROM Review WHERE book = NEW.book)
    WHERE book_id = NEW.book;
END$$
DELIMITER ;

-- Add a new hard copy process
DELIMITER $$
CREATE TRIGGER trg_after_insert_hardcopy
AFTER INSERT ON Hard_Copies
FOR EACH ROW
BEGIN
    UPDATE Book
    SET num_of_copies = num_of_copies + 1
    WHERE book_id = NEW.book_id;
END$$
DELIMITER ;

-- Ensure each member can only borrow limit number of books at a time
DELIMITER $$
CREATE TRIGGER trg_check_borrow_limit
BEFORE INSERT ON Member_HardCopy
FOR EACH ROW
BEGIN
    -- Variables to store user details
    DECLARE v_user_type VARCHAR(10);
    DECLARE v_total_borrowed INT;

    -- Retrieve the user type and current total books borrowed
    SELECT user_type, total_book_borrowed INTO v_user_type, v_total_borrowed
    FROM Lib_Member lm, Lib_User lu
    WHERE lm.user_id = lu.user_id and lu.user_id = NEW.member;

    -- Check the conditions based on user type
    IF v_user_type = 'student' AND v_total_borrowed >= 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Students cannot borrow more than 5 books.';
    ELSEIF v_user_type = 'staff' AND v_total_borrowed >= 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Staff cannot borrow more than 10 books.';
    END IF;
END$$
DELIMITER ;

-- ADMIN QUERIES ------------------
-- View All Majors 
SELECT * FROM Major;

-- View All Admins
SELECT * FROM Lib_User where user_type = 'Admin';

-- View All Librarians 
SELECT * FROM Lib_User where user_type = 'Librarian';

-- View All Students
SELECT lu.*, lm.program_code, m.school, m.name,lm.total_book_borrowed, lm.total_fine_paid
FROM Lib_User lu, Lib_Member lm, Major m
WHERE lu.user_id = lm.user_id AND m.major_id = lm.program_code AND user_type = 'Student';

-- View Student by School

-- View Student by Major
SELECT lu.*, m.*
FROM Lib_User lu, Lib_Member lm, Major m
where lu.user_id = lm.user_id AND lm.program_code = m.major_id AND (m.name LIKE '%Science%' OR m.major_id LIKE 'BP3%')
order by lu.user_id;

SELECT major_id, school, m.name, lu.*, lm.role, lm.program_code, lm.total_book_borrowed, lm.total_fine_paid
FROM Major m 
INNER JOIN
	(Lib_User lu INNER JOIN Lib_Member lm
    ON lu.user_id = lm.user_id)
ON m.major_id = lm.program_code
WHERE m.school IN ('SSET');

-- View all authors for a book
SELECT b.book_id, b.title, b.description, b.num_of_copies, concat(a.f_name, " ", a.l_name) as author_name
from book b inner join
(book_author ba inner join author a on ba.author_id = a.author_id) 
on b.book_id = ba.book_id
ORDER BY b.book_id;
    
WITH BookInfo AS (
    SELECT 
        b.book_id, 
        b.title, 
        b.description, 
        b.num_of_copies,
        GROUP_CONCAT(CONCAT(a.f_name, ' ', a.l_name) SEPARATOR ', ') AS author_names
    FROM 
        book b 
    INNER JOIN 
        book_author ba ON b.book_id = ba.book_id
    INNER JOIN 
        author a ON ba.author_id = a.author_id
    GROUP BY 
        b.book_id, b.title, b.description, b.num_of_copies
)

-- View Books by School level
SELECT DISTINCT bi.*, m.school 
FROM BookInfo bi, Major m, Book_Major bm
WHERE m.major_id = bm.major_id AND bi.book_id =  bm.book_id AND m.school = 'SSET'
ORDER BY bi.book_id;

-- View Books by Major level
SELECT DISTINCT bi.*, m.major_id, m.name
FROM BookInfo bi, Major m, Book_Major bm
WHERE m.major_id = bm.major_id AND bi.book_id =  bm.book_id AND m.major_id = 'BP162'
ORDER BY bi.book_id;

-- View Books by Categories
SELECT bi.*, c.name
FROM BookInfo bi
INNER JOIN
book_category bc ON bi.book_id = bc.book_id
INNER JOIN 
category c ON c.category_id = bc.category_id
WHERE c.name IN ('Arts', 'Computer Science');

-- Check Overdue/Lost Books
SELECT borrow_id, member, lu.f_name, lu.l_name, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition
FROM Member_HardCopy mh, Lib_User lu
WHERE mh.member = lu.user_id AND due_date < CURRENT_DATE AND return_date IS NULL;

-- Check Damaged Books
SELECT borrow_id, member, lu.f_name, lu.l_name, book, bcopy, b.title, issue_date, due_date, return_date, checkin_condition, checkout_condition
FROM Member_HardCopy mh, Lib_User lu, Book b
WHERE mh.member = lu.user_id AND b.book_id = mh.book AND return_date IS NOT NULL and checkin_condition <> checkout_condition;

-- Check Unpaid Fines
SELECT lu.f_name, lu.l_name, lu.user_type ,f.* 
FROM Fine f, Lib_User lu
WHERE f.payer = lu.user_id AND paid_date IS NULL;

-- describe vinht.major;
-- describe vinht.author;

select * from lib_librarian;

-- Count numbers of students in each major
select major_id, count(lm.user_id) as 'Num of Students'
from major m left join lib_member lm
on  m.major_id = lm.program_code
group by major_id
order by count(lm.user_id) DESC;

-- Top books borrowed
select book, count(borrow_id)
from member_hardcopy mh
group by book;

SELECT 
    b.title,
    b.book_id,
    COUNT(DISTINCT hc.copy_id) AS total_copies_borrowed,
    AVG(r.rating) AS average_rating
FROM 
    Book b
LEFT JOIN 
    Hard_Copies hc ON b.book_id = hc.book_id
LEFT JOIN 
    Review r ON b.book_id = r.book
GROUP BY 
    b.title, b.book_id
ORDER BY 
    total_copies_borrowed DESC, average_rating DESC;


-- Get the currently available librarians 
-- MySQL syntax
SELECT *
FROM Lib_Librarian
WHERE start_working_hour <= EXTRACT(HOUR FROM CURRENT_TIME)
AND end_working_hour >= EXTRACT(HOUR FROM CURRENT_TIME);
-- Oracle syntax
SELECT *
FROM Lib_Librarian
WHERE start_working_hour <= TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24'))
AND end_working_hour >= TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24'));

-- Testing zone for the borrowing process
SELECT * FROM member_hardcopy;
SELECT * FROM book where book_id = 'B030';
SELECT * FROM lib_member where user_id = 'U007';
SELECT * FROM hard_copies where copy_id = 'B030C1';
SELECT * FROM book where book_id = 'B022';
SELECT * FROM lib_member where user_id = 'U002';
SELECT * FROM hard_copies where copy_id = 'B022C1';
SELECT * FROM fine;
SELECT * FROM hard_copies where status = 'Available';
INSERT INTO member_hardcopy(member, book, bcopy, checkin_condition) value
('U007','B030','B030C1','New');

INSERT INTO member_hardcopy(member, book, bcopy, checkin_condition) value
('U002','B022','B022C1','New');

INSERT INTO member_hardcopy(member, book, bcopy, checkin_condition) value
('U009','B024','B024C1','New');

UPDATE Member_HardCopy
SET checkout_condition = 'New'
WHERE member = 'U007' and bcopy = 'B030C1' and return_date is null;

UPDATE Member_HardCopy
SET checkout_condition = 'Damaged'
WHERE member = 'U002' and bcopy = 'B022C1' and return_date is null;

-- Testing zone for paying fines
select * from fine where status = 'unpaid';
UPDATE Fine
SET status = 'Paid'
WHERE fine_id = 'FINE006';

-- Testing zone for room booking 
select * from member_room;
select * from room;

INSERT INTO Member_Room(member_id, room_id, start_date, end_date) value
('U003', 'R003', '2024-05-03 13:00:00', '2024-05-03 14:30:00');
INSERT INTO Member_Room(member_id, room_id, start_date, end_date) value
('U004', 'R004', '2024-05-03 18:40:00', '2024-05-03 18:42:00');


-- Testing zone when inserting a new review of a book
INSERT INTO Review(rating, comments, reviewer, book) value
(5, 'Sehr gut', 'U010', 'B023');


-- Testing zone when inserting a new hard copy
INSERT INTO Hard_Copies(book_id,copy_id,status,edition,year_published, location) value
('B030','B030C2','Available','Ninth',2022,'LOC007');

select * from book;
select * from review;

CREATE VIEW BookInfo AS
SELECT 
    b.book_id, 
    b.title, 
    b.description, 
    b.num_of_copies,
    GROUP_CONCAT(DISTINCT CONCAT(a.f_name, ' ', a.l_name) SEPARATOR ', ') AS author_names,
    GROUP_CONCAT(DISTINCT c.name SEPARATOR ', ') AS category_names,
    e.isbn,
    e.format,
    e.url,
    GROUP_CONCAT(DISTINCT co.name SEPARATOR ', ') AS course_names,
    GROUP_CONCAT(DISTINCT m.school SEPARATOR ', ') AS schools,
    GROUP_CONCAT(DISTINCT m.name SEPARATOR ', ') AS major_names
FROM 
    Book b
LEFT JOIN 
    Book_Author ba ON b.book_id = ba.book_id
LEFT JOIN 
    Author a ON ba.author_id = a.author_id
LEFT JOIN 
    Book_Category bc ON b.book_id = bc.book_id
LEFT JOIN 
    Category c ON bc.category_id = c.category_id
LEFT JOIN 
    Ebooks e ON b.book_id = e.book_id
LEFT JOIN 
    Book_Course bcou ON b.book_id = bcou.book_id
LEFT JOIN 
    Course co ON bcou.course_id = co.course_id
LEFT JOIN 
    Book_Major bm ON b.book_id = bm.book_id
LEFT JOIN 
    Major m ON bm.major_id = m.major_id
GROUP BY 
    b.book_id, b.title, b.description, b.num_of_copies, e.isbn, e.format, e.url;
    
    SELECT * FROM bookinfo;

-- Queries for reports: admin dashboard and librarian dashboard
SELECT 
  issue_date,
  COUNT(book) AS books_borrowed_today,
  SUM(COUNT(book)) OVER (ORDER BY issue_date) AS running_total
FROM Member_HardCopy
GROUP BY issue_date
ORDER BY issue_date;

SELECT 
  book,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY (return_date - issue_date)) AS p90_borrow_duration
FROM Member_HardCopy
GROUP BY book;

SELECT 
  c.name AS category_name,
  SUM(f.amount) AS total_fines_collected
FROM Fine f
JOIN Hard_Copies hc ON f.book_id = hc.book_id AND f.copy_id = hc.copy_id
JOIN Book b ON hc.book_id = b.book_id
JOIN Book_Category bc ON b.book_id = bc.book_id
JOIN Category c ON bc.category_id = c.category_id
GROUP BY c.name;

SELECT 
  b.book_id,
  b.title,
  COUNT(*) AS times_borrowed
FROM Member_HardCopy mh
JOIN Book b ON mh.book = b.book_id
LEFT JOIN Book_Major bm ON b.book_id = bm.book_id
WHERE bm.major_id IS NULL
GROUP BY b.book_id, b.title;

SELECT 
  c.name AS category_name,
  SUM(return_date - issue_date) AS total_days_borrowed
FROM Member_HardCopy mh
JOIN Book b ON mh.book = b.book_id
JOIN Book_Category bc ON b.book_id = bc.book_id
JOIN Category c ON bc.category_id = c.category_id
GROUP BY c.name;

SELECT lu.user_type, COUNT(*) AS overdue_count
FROM Fine f
JOIN Member_HardCopy mh ON f.book_id = mh.book AND f.copy_id = mh.bcopy
JOIN Lib_User lu ON mh.member = lu.user_id
WHERE f.reason = 'Late return'
GROUP BY lu.user_type;

-- Top borrowed books
SELECT 
    b.title,
    b.book_id,
    COUNT(DISTINCT mh.borrow_id) AS total_copies_borrowed,
    AVG(r.rating) AS average_rating
FROM 
    Book b
LEFT JOIN 
    Hard_Copies hc ON b.book_id = hc.book_id
LEFT JOIN 
    Review r ON b.book_id = r.book
LEFT JOIN
    Member_HardCopy mh ON mh.bcopy = hc.copy_id
GROUP BY 
    b.title, b.book_id
ORDER BY 
    total_copies_borrowed DESC, average_rating DESC;

-- Num of books per cat across schools
SELECT 
    m.school,
    c.name AS category,
    COUNT(*) AS number_of_books
FROM 
    Book_Category bc
JOIN 
    Category c ON bc.category_id = c.category_id
JOIN 
    Book_Major bm ON bc.book_id = bm.book_id
JOIN 
    Major m ON bm.major_id = m.major_id
GROUP BY 
    m.school, c.name
ORDER BY 
    m.school, number_of_books DESC;

--This is for Oracle syntax

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Member_HardCopy';
  EXECUTE IMMEDIATE 'DROP TABLE Member_Room';
  EXECUTE IMMEDIATE 'DROP TABLE Member_Ebooks';
  EXECUTE IMMEDIATE 'DROP TABLE Member_Course';
  EXECUTE IMMEDIATE 'DROP TABLE Requests';
  EXECUTE IMMEDIATE 'DROP TABLE Fine';
  EXECUTE IMMEDIATE 'DROP TABLE Review';
  EXECUTE IMMEDIATE 'DROP TABLE Hard_Copies';
  EXECUTE IMMEDIATE 'DROP TABLE Ebooks';
  EXECUTE IMMEDIATE 'DROP TABLE Book_Author';
  EXECUTE IMMEDIATE 'DROP TABLE Book_Course';
  EXECUTE IMMEDIATE 'DROP TABLE Book_Category';
  EXECUTE IMMEDIATE 'DROP TABLE Book_Major';
  EXECUTE IMMEDIATE 'DROP TABLE Room';
  EXECUTE IMMEDIATE 'DROP TABLE Book';
  EXECUTE IMMEDIATE 'DROP TABLE Item';
  EXECUTE IMMEDIATE 'DROP TABLE Lib_Librarian';
  EXECUTE IMMEDIATE 'DROP TABLE Lib_Admin';
  EXECUTE IMMEDIATE 'DROP TABLE Lib_Member';
  EXECUTE IMMEDIATE 'DROP TABLE Lib_User';
  EXECUTE IMMEDIATE 'DROP TABLE Author';
  EXECUTE IMMEDIATE 'DROP TABLE Location';
  EXECUTE IMMEDIATE 'DROP TABLE Course';
  EXECUTE IMMEDIATE 'DROP TABLE Category';
  EXECUTE IMMEDIATE 'DROP TABLE Major';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error encountered: ' || SQLCODE || ' - ' || SQLERRM);
END;


CREATE TABLE Major (
    major_id VARCHAR(15) PRIMARY KEY,
    school VARCHAR(50) CHECK (school IN ('SSET', 'TBS', 'SCD', 'SEUP')),
    name VARCHAR(100)
);

CREATE TABLE Course (
    course_id VARCHAR(15) PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Category (
    category_id VARCHAR(15) PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Location (
    location_id VARCHAR(15) PRIMARY KEY,
    campus VARCHAR(50),
    floor INT,
    shelf_no VARCHAR(50),
    line_no INT
);

CREATE TABLE Lib_User (
    user_id VARCHAR(15) PRIMARY KEY,
    username VARCHAR(100) CONSTRAINT username_unique UNIQUE NOT NULL,
    f_name VARCHAR2(100),
    l_name VARCHAR2(100),
    email VARCHAR(100) CONSTRAINT email_unique UNIQUE NOT NULL,
    pwd VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_type VARCHAR(50) CHECK (user_type IN ('Student', 'Staff', 'Librarian', 'Admin'))
);

CREATE TABLE Lib_Member (
    user_id VARCHAR(15) PRIMARY KEY,
    total_book_borrowed INT DEFAULT 0,
    total_fine_paid DECIMAL(10,2) DEFAULT 0.00,
    program_code VARCHAR(15),
    FOREIGN KEY (user_id) REFERENCES Lib_User(user_id),
    FOREIGN KEY (program_code) REFERENCES Major(major_id)
);

CREATE TABLE Lib_Admin (
    user_id VARCHAR(15) PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Lib_User(user_id)
);

CREATE TABLE Lib_Librarian (
    user_id VARCHAR(15) PRIMARY KEY,
    start_working_hour INT CHECK (start_working_hour BETWEEN 0 AND 23),
    end_working_hour INT CHECK (end_working_hour BETWEEN 0 AND 23),
    FOREIGN KEY (user_id) REFERENCES Lib_User(user_id)
);

CREATE TABLE Item (
    item_id VARCHAR(15) PRIMARY KEY
);

CREATE TABLE Room (
    room_id VARCHAR(15) PRIMARY KEY,
    building_no INT,
    room_no VARCHAR(50),
    capacity INT,
    status VARCHAR(50),
    FOREIGN KEY (room_id) REFERENCES Item(item_id)
);

CREATE TABLE Book (
    book_id VARCHAR(15) PRIMARY KEY,
    title VARCHAR(255),
    num_of_copies INT,
    description CLOB,
    ratings FLOAT,
    language VARCHAR(50),
    FOREIGN KEY (book_id) REFERENCES Item(item_id)
);

CREATE TABLE Ebooks (
    book_id VARCHAR(15) PRIMARY KEY,
    isbn VARCHAR(50),
    format VARCHAR(50) CHECK (format IN ('PDF', 'EPub')),
    url VARCHAR(255),
    file_size_mb FLOAT,
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Hard_Copies (
    book_id VARCHAR(15),
    copy_id VARCHAR(15),
    status VARCHAR(50) CHECK (status IN ('Available', 'Unavailable')),
    edition VARCHAR(50),
    year_published INT,
    location VARCHAR(15),
    PRIMARY KEY (book_id, copy_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (location) REFERENCES Location(location_id)
);

CREATE TABLE Author (
    author_id VARCHAR(15) PRIMARY KEY,
    f_name VARCHAR2(100),
    l_name VARCHAR2(100)
);

CREATE TABLE Review (
    review_id VARCHAR(15) PRIMARY KEY,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments CLOB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewer VARCHAR(15),
    book VARCHAR(15),
    FOREIGN KEY (reviewer) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (book) REFERENCES Book(book_id)
);

CREATE TABLE Fine (
    fine_id VARCHAR(15) PRIMARY KEY,
    amount DECIMAL(10,2),
    reason VARCHAR(255),
    status VARCHAR(50),
    incurred_date DATE,
    due_date DATE,
    paid_date DATE,
    payer VARCHAR(15),
    book_id VARCHAR(15),
    copy_id VARCHAR(15),
    FOREIGN KEY (payer) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (book_id, copy_id) REFERENCES Hard_Copies(book_id, copy_id)
);

CREATE TABLE Requests (
    request_id VARCHAR(15) PRIMARY KEY,
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    message CLOB,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Ongoing', 'Resolved')),
    sender VARCHAR(15),
    receiver VARCHAR(15),
    FOREIGN KEY (sender) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (receiver) REFERENCES Lib_Librarian(user_id)
);

CREATE TABLE Member_Course (
    member_id VARCHAR(15),
    course_code VARCHAR(15),
    PRIMARY KEY (member_id, course_code),
    FOREIGN KEY (member_id) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (course_code) REFERENCES Course(course_id)
);

CREATE TABLE Member_Ebooks (
    member_id VARCHAR(15),
    ebook_id VARCHAR(15),
    PRIMARY KEY (member_id, ebook_id),
    FOREIGN KEY (member_id) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (ebook_id) REFERENCES Ebooks(book_id)
);

CREATE TABLE Member_Room (
    booking_id VARCHAR(15) PRIMARY KEY,
    member_id VARCHAR(15),
    room_id VARCHAR(15),
    reservation_date DATE DEFAULT SYSDATE,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    CHECK ((end_date - start_date) <= INTERVAL '2' HOUR)  -- Ensures booking duration does not exceed 2 hours
);

CREATE TABLE Member_HardCopy (
    borrow_id VARCHAR(15) PRIMARY KEY,
    member VARCHAR(15),
    book VARCHAR(15),
    bcopy VARCHAR(15),
    issue_date DATE DEFAULT SYSDATE,
    due_date DATE,
    return_date DATE,
    checkin_condition VARCHAR(255) CHECK (checkin_condition IN ('New', 'Damaged')),  -- Only allows 'New' or 'Damaged'
    checkout_condition VARCHAR(255) CHECK (checkout_condition IN ('New', 'Damaged')),  -- Only allows 'New' or 'Damaged'
    FOREIGN KEY (member) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (book, bcopy) REFERENCES Hard_Copies(book_id, copy_id)
);


CREATE TABLE Book_Author (
    book_id VARCHAR(15),
    author_id VARCHAR(15),
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);

CREATE TABLE Book_Course (
    book_id VARCHAR(15),
    course_id VARCHAR(15),
    PRIMARY KEY (book_id, course_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Book_Category (
    book_id VARCHAR(15),
    category_id VARCHAR(15),
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Book_Major (
    book_id VARCHAR(15),
    major_id VARCHAR(15),
    PRIMARY KEY (book_id, major_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (major_id) REFERENCES Major(major_id)
);

-- Populate Major table
INSERT ALL
  INTO Major (major_id, school, name) VALUES ('BP343', 'TBS', 'Business')
  INTO Major (major_id, school, name) VALUES ('BP214', 'SCD', 'Game Design')
  INTO Major (major_id, school, name) VALUES ('BP312', 'TBS', 'Tourism and Hospitality Management')
  INTO Major (major_id, school, name) VALUES ('BP222', 'SCD', 'Professional Communication')
  INTO Major (major_id, school, name) VALUES ('BP070', 'SSET', 'Applied Science (Aviation)')
  INTO Major (major_id, school, name) VALUES ('BH123', 'SSET', 'Robotics and Mechatronics Engineering')
  INTO Major (major_id, school, name) VALUES ('BP351', 'TBS', 'Accounting')
  INTO Major (major_id, school, name) VALUES ('BP309', 'SCD', 'Digital Media')
  INTO Major (major_id, school, name) VALUES ('BP325', 'SCD', 'Digital Film and Video')
  INTO Major (major_id, school, name) VALUES ('BP327', 'SCD', 'Fashion (Enterprise)')
  INTO Major (major_id, school, name) VALUES ('BP162', 'SSET', 'Information Technology')
  INTO Major (major_id, school, name) VALUES ('BH073', 'SSET', 'Electronic and Computer Systems Engineering')
  INTO Major (major_id, school, name) VALUES ('BP318', 'TBS', 'Digital Marketing')
  INTO Major (major_id, school, name) VALUES ('BP316', 'SCD', 'Design Studies')
  INTO Major (major_id, school, name) VALUES ('BP317', 'SEUP', 'Languages')
  INTO Major (major_id, school, name) VALUES ('BP154', 'SSET', 'Psychology')
  INTO Major (major_id, school, name) VALUES ('BH120', 'SSET', 'Software Engineering')
  INTO Major (major_id, school, name) VALUES ('BP199', 'SSET', 'Food Technology and Nutrition')
SELECT * FROM dual;

-- Populate Course table
INSERT ALL
  INTO Course (course_id, name) VALUES ('MKTG1205', 'Marketing Principles')
  INTO Course (course_id, name) VALUES ('MKTG1419', 'Social Media and Mobile Marketing')
  INTO Course (course_id, name) VALUES ('MKTG1420', 'Digital Business Development')
  INTO Course (course_id, name) VALUES ('MKTG1422', 'Digital Marketing Communication')
  INTO Course (course_id, name) VALUES ('OMGT2085', 'Intro to Logistics & Supply Chain Mgt')
  INTO Course (course_id, name) VALUES ('OMGT2197', 'Procurement Mgmt and Global Sourcing')
  INTO Course (course_id, name) VALUES ('ISYS2109', 'Business Information Systems')
  INTO Course (course_id, name) VALUES ('MKTG1421', 'Consumer Psychology and Behaviour')
  INTO Course (course_id, name) VALUES ('COSC2429', 'Introduction To Programming')
  INTO Course (course_id, name) VALUES ('COSC2430', 'Web Programming')
  INTO Course (course_id, name) VALUES ('COSC2440', 'Software Architecture: Design & Implementation')
  INTO Course (course_id, name) VALUES ('COSC2652', 'User-centred Design')
  INTO Course (course_id, name) VALUES ('ISYS3414', 'Practical Database Concepts')
  INTO Course (course_id, name) VALUES ('COMM2596', 'Digital Narrative Theory and Practice')
  INTO Course (course_id, name) VALUES ('COMM2752', 'Digital Media Specialisation 2')
  INTO Course (course_id, name) VALUES ('COSC2532', 'Advanced Electronic Imaging')
  INTO Course (course_id, name) VALUES ('VART3626', 'Photography 101')
  INTO Course (course_id, name) VALUES ('VART3670', 'Creative Photography')
  INTO Course (course_id, name) VALUES ('ECON1318', 'Economics for Tourism and Hospitality')
  INTO Course (course_id, name) VALUES ('ACCT2105', 'Accounting in Organisations & Society')
  INTO Course (course_id, name) VALUES ('ACCT2158', 'Financial Accounting and Analysis')
  INTO Course (course_id, name) VALUES ('ACCT2160', 'Cost Analysis and Organisational Decisions')
  INTO Course (course_id, name) VALUES ('BAFI3182', 'Financial Markets')
  INTO Course (course_id, name) VALUES ('BAFI3184', 'Business Finance')
  INTO Course (course_id, name) VALUES ('ECON1192', 'Macroeconomics 1')
  INTO Course (course_id, name) VALUES ('ECON1193', 'Business Statistics 1')
  INTO Course (course_id, name) VALUES ('ECON1194', 'Prices and Markets')
  INTO Course (course_id, name) VALUES ('LAW2447', 'Commercial Law')
  INTO Course (course_id, name) VALUES ('ACCT2197', 'Performance Analysis and Simulations')
  INTO Course (course_id, name) VALUES ('EEET2482', 'Software Engineering Design')
  INTO Course (course_id, name) VALUES ('EEET2599', 'Electrical Engineering 1')
  INTO Course (course_id, name) VALUES ('EEET2600', 'Electronics')
  INTO Course (course_id, name) VALUES ('EEET2601', 'Engineering Computing 1')
  INTO Course (course_id, name) VALUES ('EEET2603', 'Introduction to Electrical and Electronic Engineering')
  INTO Course (course_id, name) VALUES ('MATH2394', 'Engineering Mathematics')
  INTO Course (course_id, name) VALUES ('OENG1181', 'Introduction to Professional Engineering Practice')
  INTO Course (course_id, name) VALUES ('BAFI3239', 'Pattern Cutting for Production')
  INTO Course (course_id, name) VALUES ('BUSM1784', 'Supply Chain Management')
  INTO Course (course_id, name) VALUES ('MANU2492', 'Digital Applications for Fashion Enterprise 1')
  INTO Course (course_id, name) VALUES ('MKTG1447', 'Introduction to Fashion Marketing')
  INTO Course (course_id, name) VALUES ('VART3663', 'Computing for Fashion Design and Product Development')
  INTO Course (course_id, name) VALUES ('VART3662', 'Introduction to Fashion Design')
  INTO Course (course_id, name) VALUES ('LANG1306', 'Japanese 1')
  INTO Course (course_id, name) VALUES ('LANG1307', 'Japanese 2')
  INTO Course (course_id, name) VALUES ('LANG1321', 'Introduction to Language')
  INTO Course (course_id, name) VALUES ('LANG1303', 'Ethics & Professional Issues in Translating & Interpreting')
  INTO Course (course_id, name) VALUES ('LANG1308', 'Japanese 3')
  INTO Course (course_id, name) VALUES ('LANG1310', 'Japanese 5')
  INTO Course (course_id, name) VALUES ('LANG1318', 'Language and Society')
  INTO Course (course_id, name) VALUES ('SOCU2252', 'Intercultural Communication')
  INTO Course (course_id, name) VALUES ('SOCU2290', 'Working and Managing in Global Careers')
  INTO Course (course_id, name) VALUES ('BUSM3299', 'The Entrepreneurial Process')
  INTO Course (course_id, name) VALUES ('BUSM3310', 'Human Resource Management')
  INTO Course (course_id, name) VALUES ('BUSM3311', 'International Business')
  INTO Course (course_id, name) VALUES ('BUSM4092', 'Applied Entrepreneurship')
  INTO Course (course_id, name) VALUES ('BUSM4186', 'Global Entrepreneurship')
  INTO Course (course_id, name) VALUES ('BUSM4566', 'Tourism Planning & Resource Management')
  INTO Course (course_id, name) VALUES ('BUSM4769', 'Employment Relations')
  INTO Course (course_id, name) VALUES ('BUSM2301', 'Organisational Analysis')
  INTO Course (course_id, name) VALUES ('BUSM2412', 'Marketing for Managers')
  INTO Course (course_id, name) VALUES ('BUSM2479', 'Digital Entrepreneurship')
  INTO Course (course_id, name) VALUES ('BUSM3244', 'Business and Economic Analysis')
  INTO Course (course_id, name) VALUES ('BUSM3250', 'People and Organisations')
  INTO Course (course_id, name) VALUES ('BUSM4037', 'Contemporary Issues in International Management')
  INTO Course (course_id, name) VALUES ('BUSM4185', 'Introduction to Management')
  INTO Course (course_id, name) VALUES ('BUSM4188', 'Leadership and Decision Making')
  INTO Course (course_id, name) VALUES ('BUSM4488', 'Managing Across Cultures')
  INTO Course (course_id, name) VALUES ('BUSM4561', 'Work in Global Society')
  INTO Course (course_id, name) VALUES ('BUSM4568', 'Room Division Management')
  INTO Course (course_id, name) VALUES ('BUSM4573', 'Business Communications and Professional Practice')
  INTO Course (course_id, name) VALUES ('BUSM4621', 'Postgraduate Business Internship')
  INTO Course (course_id, name) VALUES ('FOHO1024', 'International Food & Beverage Management')
  INTO Course (course_id, name) VALUES ('INTE2562', 'Digital Innovation')
  INTO Course (course_id, name) VALUES ('OMGT2272', 'International Logistics')
  INTO Course (course_id, name) VALUES ('BUSM4553', 'Creativity, Innovation and Design')
  INTO Course (course_id, name) VALUES ('BUSM4557', 'Contemporary Management: Issues and Challenges')
  INTO Course (course_id, name) VALUES ('BUSM4489', 'Sustainable International Business Futures')
  INTO Course (course_id, name) VALUES ('COMM2377', 'Modern Asia')
  INTO Course (course_id, name) VALUES ('COMM2383', 'New Media, New Asia')
  INTO Course (course_id, name) VALUES ('COMM2489', 'Asian Cinemas')
  INTO Course (course_id, name) VALUES ('GRAP2659', 'Art Direction')
  INTO Course (course_id, name) VALUES ('LANG1265', 'Vietnamese for Professional Communication')
  INTO Course (course_id, name) VALUES ('COMM2497', 'Exploring Asian Popular Culture')
  INTO Course (course_id, name) VALUES ('GRAP2413', 'Advertising Media')
SELECT * FROM dual;

-- Populate Category table
INSERT ALL
INTO Category (category_id, name) VALUES ('CAT001', 'Mathematics')
INTO Category (category_id, name) VALUES ('CAT002', 'Physics')
INTO Category (category_id, name) VALUES ('CAT003', 'Chemistry')
INTO Category (category_id, name) VALUES ('CAT004', 'Biology')
INTO Category (category_id, name) VALUES ('CAT005', 'Engineering')
INTO Category (category_id, name) VALUES ('CAT006', 'Computer Science')
INTO Category (category_id, name) VALUES ('CAT007', 'Economics')
INTO Category (category_id, name) VALUES ('CAT008', 'Psychology')
INTO Category (category_id, name) VALUES ('CAT009', 'Literature')
INTO Category (category_id, name) VALUES ('CAT010', 'History')
INTO Category (category_id, name) VALUES ('CAT011', 'Philosophy')
INTO Category (category_id, name) VALUES ('CAT012', 'Political Science')
INTO Category (category_id, name) VALUES ('CAT013', 'Languages')
INTO Category (category_id, name) VALUES ('CAT014', 'Arts')
INTO Category (category_id, name) VALUES ('CAT015', 'Education')
INTO Category (category_id, name) VALUES ('CAT016', 'Business')
INTO Category (category_id, name) VALUES ('CAT017', 'Law')
INTO Category (category_id, name) VALUES ('CAT018', 'Medicine')
INTO Category (category_id, name) VALUES ('CAT019', 'Environmental Science')
INTO Category (category_id, name) VALUES ('CAT020', 'Sociology')
INTO Category (category_id, name) VALUES ('CAT021', 'Social Issues')
INTO Category (category_id, name) VALUES ('CAT022', 'Self-Help')
INTO Category (category_id, name) VALUES ('CAT023', 'Comics')
INTO Category (category_id, name) VALUES ('CAT024', 'Graphic Novels')
INTO Category (category_id, name) VALUES ('CAT025', 'Biographies')
INTO Category (category_id, name) VALUES ('CAT026', 'Memoirs')
INTO Category (category_id, name) VALUES ('CAT027', 'Science Fiction')
INTO Category (category_id, name) VALUES ('CAT028', 'Fantasy')
INTO Category (category_id, name) VALUES ('CAT029', 'Mystery')
INTO Category (category_id, name) VALUES ('CAT030', 'Thriller')
INTO Category (category_id, name) VALUES ('CAT031', 'Romance')
INTO Category (category_id, name) VALUES ('CAT032', 'Adventure')
INTO Category (category_id, name) VALUES ('CAT033', 'Cooking')
INTO Category (category_id, name) VALUES ('CAT034', 'Health and Fitness')
INTO Category (category_id, name) VALUES ('CAT035', 'Travel')
INTO Category (category_id, name) VALUES ('CAT036', 'Crafts and Hobbies')
INTO Category (category_id, name) VALUES ('CAT037', 'Personal Finance')
INTO Category (category_id, name) VALUES ('CAT038', 'Religious and Spiritual')
INTO Category (category_id, name) VALUES ('CAT039', 'Poetry')
SELECT * FROM dual;

-- Populate Location table
INSERT ALL
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC001', 'Melbourne', 1, 'C1', 1)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC002', 'Beanland', 2, 'A1', 2)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC003', 'Hanoi', 1, 'A2', 3)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC004', 'Beanland', 1, 'A2', 6)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC005', 'Hanoi', 3, 'B1', 1)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC006', 'Melbourne', 2, 'G1', 9)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC007', 'Beanland', 2, 'B2', 11)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC008', 'Hanoi', 2, 'B2', 2)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC009', 'Beanland', 4, 'E1', 1)
INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES ('LOC010', 'Beanland', 1, 'C1', 2)
SELECT * FROM dual;

-- Populate Lib_User table
INSERT ALL
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U001', 'anh.lam', 'Anh', 'Lam', 'ltranh@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U002', 'bao.ho', 'Bao', 'Ho', 'hongpbao@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U003', 'johnathan.crellin', 'Johnathan', 'Crellin', 'johncrel@gmail.com', '123', 'Staff')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U004', 'duc.pham', 'Duc', 'Pham', 'phamvietduc@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U005', 'evelyn.vo', 'Evelyn', 'Vo', 'voeva@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U006', 'joshua.hansen', 'Joshua', 'Hansen', 'xthejosh@gmail.com', '123', 'Staff')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U007', 'giang.dinh', 'Giang', 'Dinh', 'dinhqgiang@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U008', 'khai.luong', 'Khai', 'Luong', 'luongminhkhai@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U009', 'vy.kieu', 'Vy', 'Kieu', 'kieukhanhvy@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U010', 'iris.nguyen', 'Iris', 'Nguyen', 'ngmaihuong@gmail.com', '123', 'Student')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U011', 'andrew.tran', 'Andrew', 'Tran', 'litvandrius@gmail.com', '123', 'Librarian')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U012', 'chi.dang', 'Chi', 'Dang', 'tungchi@gmail.com', '123', 'Librarian')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U013', 'thu.le', 'Thu', 'Le', 'lehathu@gmail.com', '123', 'Librarian')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U014', 'ha.trinh', 'Ha', 'Trinh', 'fuhgetmenut@gmail.com', 'pdc', 'Admin')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U015', 'bach.nguyen', 'Bach', 'Nguyen', 'bachesng@gmail.com', 'team7', 'Admin')
INTO Lib_User (user_id, username, f_name, l_name, email, pwd, user_type) VALUES ('U016', 'vinh.truong', 'Vinh', 'Truong', 'trngxuanvinh@gmail.com', 'HD', 'Admin')
SELECT * FROM dual;

-- Populate Lib_Member table
INSERT ALL
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U001', 0, 0.00, 'BP343')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U002', 0, 0.00, 'BP214')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U003', 0, 25.00, NULL)
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U004', 0, 25.00, 'BP312')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U005', 0, 0.00, 'BP222')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U006', 0, 0.00, NULL)
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U007', 0, 0.00, 'BP070')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U008', 0, 0.00, 'BH123')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U009', 1, 0.00, 'BP351')
INTO Lib_Member (user_id, total_book_borrowed, total_fine_paid, program_code) VALUES ('U010', 0, 0.00, 'BP309')
SELECT * FROM dual;

-- Populate Lib_Admin table
INSERT ALL
INTO Lib_Admin (user_id) VALUES ('U014')
INTO Lib_Admin (user_id) VALUES ('U015')
INTO Lib_Admin (user_id) VALUES ('U016')
SELECT * FROM dual;

-- Populate Lib_Librarian table
INSERT ALL
INTO Lib_Librarian (user_id, start_working_hour, end_working_hour) VALUES ('U011', 7, 15)
INTO Lib_Librarian (user_id, start_working_hour, end_working_hour) VALUES ('U012', 15, 22)
INTO Lib_Librarian (user_id, start_working_hour, end_working_hour) VALUES ('U013', 9, 17)
SELECT * FROM dual;

-- Populate Item table
INSERT ALL
INTO Item (item_id) VALUES ('B001')
INTO Item (item_id) VALUES ('B002')
INTO Item (item_id) VALUES ('B003')
INTO Item (item_id) VALUES ('B004')
INTO Item (item_id) VALUES ('B005')
INTO Item (item_id) VALUES ('B006')
INTO Item (item_id) VALUES ('B007')
INTO Item (item_id) VALUES ('B008')
INTO Item (item_id) VALUES ('B009')
INTO Item (item_id) VALUES ('B010')
INTO Item (item_id) VALUES ('B011')
INTO Item (item_id) VALUES ('B012')
INTO Item (item_id) VALUES ('B013')
INTO Item (item_id) VALUES ('B014')
INTO Item (item_id) VALUES ('B015')
INTO Item (item_id) VALUES ('B016')
INTO Item (item_id) VALUES ('B017')
INTO Item (item_id) VALUES ('B018')
INTO Item (item_id) VALUES ('B019')
INTO Item (item_id) VALUES ('B020')
INTO Item (item_id) VALUES ('B021')
INTO Item (item_id) VALUES ('B022')
INTO Item (item_id) VALUES ('B023')
INTO Item (item_id) VALUES ('B024')
INTO Item (item_id) VALUES ('B025')
INTO Item (item_id) VALUES ('B026')
INTO Item (item_id) VALUES ('B027')
INTO Item (item_id) VALUES ('B028')
INTO Item (item_id) VALUES ('B029')
INTO Item (item_id) VALUES ('B030')
INTO Item (item_id) VALUES ('R001')
INTO Item (item_id) VALUES ('R002')
INTO Item (item_id) VALUES ('R003')
INTO Item (item_id) VALUES ('R004')
INTO Item (item_id) VALUES ('R005')
INTO Item (item_id) VALUES ('R006')
INTO Item (item_id) VALUES ('R007')
INTO Item (item_id) VALUES ('R008')
INTO Item (item_id) VALUES ('R009')
INTO Item (item_id) VALUES ('R010')
SELECT * FROM dual;

-- Populate Room table
INSERT ALL
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R001', 1, '101', 5, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R002', 1, '102', 5, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R003', 1, '103', 3, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R004', 1, '104', 3, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R005', 1, '105', 10, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R006', 2, '201', 20, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R007', 2, '202', 10, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R008', 2, '203', 10, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R009', 2, '204', 5, 'Available')
INTO Room (room_id, building_no, room_no, capacity, status) VALUES ('R010', 2, '205', 5, 'Unavailable')
SELECT * FROM dual;

-- Populate Book table
INSERT ALL
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B001', 'Business Dynamics', 5, 'Insights into evolving market trends.', 4.0, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B002', 'Principles of Game Design', 3, 'Foundations of game development and design.', 4.33, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B003', 'Modern Tourism Management', 4, 'Managing tourism businesses in the global economy.', 3.67, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B004', 'Effective Communication', 3, 'Strategies for professional communication.', 4.0, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B005', 'Aviation Studies', 6, 'Comprehensive exploration of the aviation industry.', 4.67, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B006', 'Robotics Fundamentals', 1, 'Introduction to robotics and its applications.', 3.67, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B007', 'Corporate Accounting', 1, 'Accounting principles for corporate environments.', 4.67, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B008', 'Digital Media Evolution', 1, 'The rise of digital media and its impact on culture.', 4.0, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B009', 'Film and Video Production', 1, 'Techniques and tools for aspiring filmmakers.', 4.0, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B010', 'Fashion Design Theory', 1, 'Critical theories and practices in fashion design.', 3.67, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B011', 'IT for Professionals', 1, 'Using technology effectively in professional settings.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B012', 'Electronics Engineering', 1, 'Foundations of electronic and computer systems.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B013', 'Digital Marketing Insights', 1, 'Strategies for successful digital marketing.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B014', 'Foundations of Design', 1, 'Principles of design across different mediums.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B015', 'Linguistics and You', 1, 'Exploring the impact of language on society.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B016', 'Psychological Perspectives', 1, 'A look at modern psychology theories.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B017', 'Software Engineering Today', 1, 'The latest trends in software engineering.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B018', 'Nutrition and You', 1, 'Understanding food technology and nutrition.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B019', 'Advanced Business Strategies', 1, 'In-depth strategies for growing businesses.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B020', 'Next-Gen Game Development', 1, 'Future trends in video game development.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B021', 'Global Tourism Economics', 1, 'Economic perspectives on global tourism.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B022', 'Advanced Robotics', 1, 'Emerging technologies in robotics.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B023', 'Accounting Ethics', 1, 'Ethical considerations in modern accounting.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B024', 'Media and Society', 1, 'Examining the role of media in modern societies.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B025', 'Video Editing Techniques', 1, 'Mastering post-production in film and video.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B026', 'Contemporary Fashion Trends', 1, 'Exploring current trends in the fashion industry.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B027', 'Information Security', 1, 'Principles of securing digital information.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B028', 'Circuit Design', 1, 'Essentials of electronic circuit design.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B029', 'Social Media Marketing', 1, 'Leveraging social media for business success.', NULL, 'English')
INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES ('B030', 'Therapeutic Diets', 1, 'Diet planning for various health conditions.', NULL, 'English')
SELECT * FROM dual;

-- Populate Ebooks table
INSERT ALL
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B001', '978-0-00-000001-2', 'PDF', 'https://example.com/ebooks/business_dynamics.pdf', 2.5)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B002', '978-0-00-000002-9', 'EPub', 'https://example.com/ebooks/game_design.epub', 1.5)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B003', '978-0-00-000003-6', 'PDF', 'https://example.com/ebooks/tourism_management.pdf', 3.0)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B004', '978-0-00-000004-3', 'EPub', 'https://example.com/ebooks/effective_communication.epub', 1.2)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B005', '978-0-00-000005-0', 'PDF', 'https://example.com/ebooks/aviation_studies.pdf', 4.0)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B006', '978-0-00-000006-7', 'EPub', 'https://example.com/ebooks/robotics_fundamentals.epub', 2.8)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B007', '978-0-00-000007-4', 'PDF', 'https://example.com/ebooks/corporate_accounting.pdf', 2.3)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B008', '978-0-00-000008-1', 'EPub', 'https://example.com/ebooks/digital_media.epub', 2.0)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B009', '978-0-00-000009-8', 'PDF', 'https://example.com/ebooks/film_video_production.pdf', 5.0)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B010', '978-0-00-000010-4', 'EPub', 'https://example.com/ebooks/fashion_design.epub', 1.8)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B011', '978-0-00-000011-1', 'PDF', 'https://example.com/ebooks/it_professionals.pdf', 3.5)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B012', '978-0-00-000012-8', 'EPub', 'https://example.com/ebooks/electronics_engineering.epub', 2.2)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B013', '978-0-00-000013-5', 'PDF', 'https://example.com/ebooks/digital_marketing.pdf', 2.6)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B014', '978-0-00-000014-2', 'EPub', 'https://example.com/ebooks/design_foundations.epub', 1.9)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B015', '978-0-00-000015-9', 'PDF', 'https://example.com/ebooks/linguistics.pdf', 3.1)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B016', '978-0-00-000016-6', 'EPub', 'https://example.com/ebooks/psychology_perspectives.epub', 2.7)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B017', '978-0-00-000017-3', 'PDF', 'https://example.com/ebooks/software_engineering.pdf', 3.8)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B018', '978-0-00-000018-0', 'EPub', 'https://example.com/ebooks/nutrition_you.epub', 2.4)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B019', '978-0-00-000019-7', 'PDF', 'https://example.com/ebooks/business_strategies.pdf', 2.1)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B020', '978-0-00-000020-3', 'EPub', 'https://example.com/ebooks/game_development_nextgen.epub', 3.2)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B021', '978-0-00-000021-0', 'PDF', 'https://example.com/ebooks/tourism_economics.pdf', 2.9)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B022', '978-0-00-000022-7', 'EPub', 'https://example.com/ebooks/advanced_robotics.epub', 1.6)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B023', '978-0-00-000023-4', 'PDF', 'https://example.com/ebooks/accounting_ethics.pdf', 2.5)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B024', '978-0-00-000024-1', 'EPub', 'https://example.com/ebooks/media_society.epub', 2.0)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B025', '978-0-00-000025-8', 'PDF', 'https://example.com/ebooks/video_editing.pdf', 4.5)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B026', '978-0-00-000026-5', 'EPub', 'https://example.com/ebooks/fashion_trends.epub', 1.7)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B027', '978-0-00-000027-2', 'PDF', 'https://example.com/ebooks/information_security.pdf', 3.3)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B028', '978-0-00-000028-9', 'EPub', 'https://example.com/ebooks/circuit_design.epub', 2.1)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B029', '978-0-00-000029-6', 'PDF', 'https://example.com/ebooks/social_media_marketing.pdf', 2.8)
INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES ('B030', '978-0-00-000030-2', 'EPub', 'https://example.com/ebooks/therapeutic_diets.epub', 1.4)
SELECT * FROM dual;

-- Populate Physical_Book table
INSERT ALL
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B001', 'B001C1', 'Available', 'Seventh', 2009, 'LOC001')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B001', 'B001C2', 'Available', 'Eighth', 2011, 'LOC001')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B001', 'B001C3', 'Available', 'First', 2002, 'LOC001')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B001', 'B001C4', 'Available', 'Thirteenth', 2023, 'LOC001')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B001', 'B001C5', 'Available', 'First', 2014, 'LOC001')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B002', 'B002C1', 'Available', 'First', 2016, 'LOC002')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B002', 'B002C2', 'Available', 'First', 2012, 'LOC002')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B002', 'B002C3', 'Available', 'Sixth', 2018, 'LOC002')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B003', 'B003C1', 'Available', 'First', 1999, 'LOC003')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B003', 'B003C2', 'Available', 'First', 2005, 'LOC003')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B003', 'B003C3', 'Available', 'Ninth', 2004, 'LOC003')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B003', 'B003C4', 'Available', 'First', 2023, 'LOC003')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B004', 'B004C1', 'Unavailable', 'First', 2021, 'LOC004')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B004', 'B004C2', 'Available', 'First', 2021, 'LOC004')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B004', 'B004C3', 'Available', 'First', 2021, 'LOC004')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C1', 'Available', 'First', 2023, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C2', 'Available', 'First', 2023, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C3', 'Available', 'First', 2023, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C4', 'Available', 'First', 2023, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C5', 'Available', 'First', 2023, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B005', 'B005C6', 'Available', 'Second', 2024, 'LOC005')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B006', 'B006C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B007', 'B007C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B008', 'B008C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B009', 'B009C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B010', 'B010C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B011', 'B011C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B012', 'B012C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B013', 'B013C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B014', 'B014C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B015', 'B015C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B016', 'B016C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B017', 'B017C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B018', 'B018C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B019', 'B019C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B020', 'B020C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B021', 'B021C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B022', 'B022C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B023', 'B023C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B024', 'B024C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B025', 'B025C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B026', 'B026C1', 'Available', 'Second', 2023, 'LOC007')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B027', 'B027C1', 'Available', 'Third', 2023, 'LOC008')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B028', 'B028C1', 'Available', 'Fourth', 2023, 'LOC009')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B029', 'B029C1', 'Available', 'Fifth', 2023, 'LOC010')
INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES ('B030', 'B030C1', 'Available', 'Second', 2023, 'LOC007')
SELECT * FROM dual;

-- Populate Author table
INSERT ALL
INTO Author (author_id, f_name, l_name) VALUES ('AUTH001', 'John', 'Smith')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH002', 'Alice', 'Johnson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH003', 'Robert', 'Lee')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH004', 'Michael', 'Brown')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH005', 'Laura', 'Wilson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH006', 'Sarah', 'Miller')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH007', 'James', 'Davis')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH008', 'Mary', 'Taylor')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH009', 'William', 'Anderson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH010', 'Linda', 'Thomas')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH011', 'Richard', 'Jackson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH012', 'Jessica', 'White')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH013', 'David', 'Harris')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH014', 'Emily', 'Martin')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH015', 'Jennifer', 'Thompson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH016', 'Charles', 'Garcia')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH017', 'Angela', 'Martinez')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH018', 'Patricia', 'Robinson')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH019', 'Joseph', 'Clark')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH020', 'Christopher', 'Rodriguez')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH021', 'Karen', 'Lewis')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH022', 'Daniel', 'Walker')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH023', 'Nancy', 'Allen')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH024', 'Barbara', 'Young')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH025', 'Paul', 'King')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH026', 'Donna', 'Scott')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH027', 'Steven', 'Green')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH028', 'Susan', 'Adams')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH029', 'Edward', 'Baker')
INTO Author (author_id, f_name, l_name) VALUES ('AUTH030', 'Margaret', 'Gonzalez')
SELECT * FROM dual;


-- Populate Review table
INSERT ALL
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV001', 5, 'Absolutely insightful with practical tips on navigating market trends.', 'U001', 'B001')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV002', 3, 'Good book but some chapters are too theoretical.', 'U002', 'B001')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV003', 4, 'Great read for anyone interested in business strategy.', 'U003', 'B001')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV004', 5, 'Excellent introduction to game design fundamentals.', 'U004', 'B002')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV005', 4, 'Very helpful for beginners in game development.', 'U005', 'B002')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV006', 4, 'Covers the basics well but lacks advanced topics.', 'U006', 'B002')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV007', 4, 'Comprehensive and up-to-date with modern practices.', 'U007', 'B003')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV008', 2, 'Somewhat outdated in certain aspects of tourism management.', 'U008', 'B003')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV009', 5, 'A must-read for hospitality and tourism management students.', 'U009', 'B003')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV010', 5, 'Incredibly useful for improving communication skills.', 'U010', 'B004')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV011', 3, 'Decent coverage of topics, but some parts were too basic.', 'U001', 'B004')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV012', 4, 'Engaging content and practical advice.', 'U002', 'B004')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV013', 5, 'Outstanding depth and detail on aviation topics.', 'U003', 'B005')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV014', 5, 'The technical insights are remarkable.', 'U004', 'B005')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV015', 4, 'Comprehensive but a little overwhelming for newbies.', 'U005', 'B005')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV016', 4, 'Solid introduction to robotics.', 'U006', 'B006')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV017', 4, 'Good hands-on examples and case studies.', 'U007', 'B006')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV018', 3, 'Needs more advanced topics to be truly comprehensive.', 'U008', 'B006')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV019', 5, 'Essential reading for anyone in finance.', 'U009', 'B007')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV020', 5, 'Detailed and informative with excellent examples.', 'U010', 'B007')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV021', 4, 'Great for understanding corporate accounting principles.', 'U001', 'B007')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV022', 4, 'Very insightful into the changes in digital media.', 'U002', 'B008')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV023', 3, 'Covers the basics well, but lacks depth in new media trends.', 'U003', 'B008')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV024', 5, 'A must-have resource for digital media students.', 'U004', 'B008')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV025', 5, 'Exceptionally detailed guide to film production.', 'U005', 'B009')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV026', 4, 'Great practical advice, though aimed more at beginners.', 'U006', 'B009')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV027', 3, 'Good overview but I expected more advanced techniques.', 'U007', 'B009')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV028', 4, 'Innovative approaches to fashion design.', 'U008', 'B010')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV029', 2, 'Somewhat disappointing with a lack of technical detail.', 'U009', 'B010')
INTO Review (review_id, rating, comments, reviewer, book) VALUES ('REV030', 5, 'Inspiring and thought-provoking!', 'U010', 'B010')
SELECT * FROM dual;


-- Populate Fine
INSERT ALL
INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, book_id, copy_id) VALUES ('FINE001', 50.00, 'Late return', 'Unpaid', DATE '2023-11-11', DATE '2024-1-11', NULL, 'U010', 'B005', 'B005C4')
INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, book_id, copy_id) VALUES ('FINE002', 25.00, 'Damaged book', 'Paid', DATE '2023-10-12', DATE '2023-12-10', DATE '2023-11-14', 'U003', 'B004', 'B004C1')
INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, book_id, copy_id) VALUES ('FINE003', 25.00, 'Damaged book', 'Paid', DATE '2023-08-20', DATE '2023-09-05', DATE '2023-09-04', 'U004', 'B005', 'B005C2')
INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, book_id, copy_id) VALUES ('FINE004', 25.00, 'Damaged book', 'Unpaid', DATE '2023-08-20', DATE '2023-09-05', NULL, 'U007', 'B003', 'B003C3')
INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, book_id, copy_id) VALUES ('FINE005', 100.00, 'Lost item', 'Unpaid', DATE '2023-09-01', DATE '2023-09-15', NULL, 'U009', 'B004', 'B004C1')
SELECT * FROM dual;

-- Populate Requests (created_at)
INSERT ALL
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ001', 'Book Reservation', 'Request to reserve "Business Dynamics" for upcoming coursework.', 'Pending', 'U001', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ002', 'Renewal', 'Request to renew "Principles of Game Design" for another month.', 'Ongoing', 'U002', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ003', 'Book Purchase', 'Suggest purchasing more resources on modern tourism management.', 'Resolved', 'U003', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ004', 'Renewal', 'Need an extension on "Effective Communication".', 'Pending', 'U004', 'U013')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ005', 'Resource Inquiry', 'Is "Aviation Studies" available for borrowing this week?', 'Resolved', 'U005', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ006', 'Technical Support', 'Need help accessing online journals on robotics fundamentals.', 'Ongoing', 'U006', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ007', 'Late Return', 'Requesting forgiveness for late return due to personal reasons.', 'Pending', 'U007', 'U013')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ008', 'Reservation', 'Reserve the meeting room for study group discussion next Wednesday.', 'Pending', 'U008', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ009', 'Book Suggestion', 'Can the library consider acquiring books on digital marketing insights?', 'Resolved', 'U009', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ010', 'Renewal', 'Request to renew "Foundations of Design" for another term.', 'Ongoing', 'U010', 'U013')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ011', 'Book Reservation', 'Request to reserve "Psychological Perspectives" for class.', 'Pending', 'U001', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ012', 'Resource Inquiry', 'Is there a newer edition of "Software Engineering Today" available?', 'Pending', 'U002', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ013', 'Help Request', 'Need guidance on using the librarys database to find specific research papers.', 'Resolved', 'U003', 'U013')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ014', 'Renewal', 'I would like to renew "Advanced Business Strategies".', 'Ongoing', 'U004', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ015', 'Technical Support', 'Having trouble logging into the digital library.', 'Pending', 'U005', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ016', 'Room Booking', 'Would like to book a study room for final year project work.', 'Resolved', 'U006', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ017', 'Book Reservation', 'Request to reserve "Information Security" for next semester.', 'Pending', 'U007', 'U012')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ018', 'Renewal', 'Requesting extension for "Circuit Design" due to project delay.', 'Ongoing', 'U008', 'U011')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ019', 'Resource Inquiry', 'Are there any additional materials on social media marketing?', 'Pending', 'U009', 'U013')
INTO Requests (request_id, type, message, status, sender, receiver) VALUES ('REQ020', 'Renewal', 'Need to extend "Therapeutic Diets" borrowing period for ongoing research.', 'Resolved', 'U010', 'U012')
SELECT * FROM dual;


-- Populate Member_Course
INSERT ALL
INTO Member_Course (member_id, course_code) VALUES ('U001', 'MKTG1205')
INTO Member_Course (member_id, course_code) VALUES ('U001', 'MKTG1419')
INTO Member_Course (member_id, course_code) VALUES ('U002', 'MKTG1420')
INTO Member_Course (member_id, course_code) VALUES ('U002', 'MKTG1422')
INTO Member_Course (member_id, course_code) VALUES ('U003', 'OMGT2085')
INTO Member_Course (member_id, course_code) VALUES ('U003', 'OMGT2197')
INTO Member_Course (member_id, course_code) VALUES ('U004', 'ISYS2109')
INTO Member_Course (member_id, course_code) VALUES ('U004', 'MKTG1421')
INTO Member_Course (member_id, course_code) VALUES ('U005', 'COSC2429')
INTO Member_Course (member_id, course_code) VALUES ('U005', 'COSC2430')
INTO Member_Course (member_id, course_code) VALUES ('U006', 'COSC2440')
INTO Member_Course (member_id, course_code) VALUES ('U006', 'COSC2652')
INTO Member_Course (member_id, course_code) VALUES ('U007', 'ISYS3414')
INTO Member_Course (member_id, course_code) VALUES ('U007', 'COMM2596')
INTO Member_Course (member_id, course_code) VALUES ('U008', 'COMM2752')
INTO Member_Course (member_id, course_code) VALUES ('U008', 'COSC2532')
INTO Member_Course (member_id, course_code) VALUES ('U009', 'VART3626')
INTO Member_Course (member_id, course_code) VALUES ('U009', 'VART3670')
INTO Member_Course (member_id, course_code) VALUES ('U010', 'ECON1318')
INTO Member_Course (member_id, course_code) VALUES ('U010', 'ACCT2105')
INTO Member_Course (member_id, course_code) VALUES ('U001', 'ACCT2158')
INTO Member_Course (member_id, course_code) VALUES ('U002', 'ACCT2160')
INTO Member_Course (member_id, course_code) VALUES ('U003', 'BAFI3182')
INTO Member_Course (member_id, course_code) VALUES ('U004', 'BAFI3184')
INTO Member_Course (member_id, course_code) VALUES ('U005', 'ECON1192')
INTO Member_Course (member_id, course_code) VALUES ('U006', 'ECON1193')
INTO Member_Course (member_id, course_code) VALUES ('U007', 'ECON1194')
INTO Member_Course (member_id, course_code) VALUES ('U008', 'LAW2447')
INTO Member_Course (member_id, course_code) VALUES ('U009', 'ACCT2197')
INTO Member_Course (member_id, course_code) VALUES ('U010', 'EEET2482')
INTO Member_Course (member_id, course_code) VALUES ('U001', 'EEET2599')
INTO Member_Course (member_id, course_code) VALUES ('U002', 'EEET2600')
INTO Member_Course (member_id, course_code) VALUES ('U003', 'EEET2601')
INTO Member_Course (member_id, course_code) VALUES ('U004', 'EEET2603')
INTO Member_Course (member_id, course_code) VALUES ('U004', 'EEET2599')
INTO Member_Course (member_id, course_code) VALUES ('U005', 'MATH2394')
INTO Member_Course (member_id, course_code) VALUES ('U006', 'OENG1181')
INTO Member_Course (member_id, course_code) VALUES ('U007', 'BAFI3239')
INTO Member_Course (member_id, course_code) VALUES ('U008', 'BUSM1784')
INTO Member_Course (member_id, course_code) VALUES ('U009', 'MANU2492')
INTO Member_Course (member_id, course_code) VALUES ('U010', 'MKTG1447')
SELECT * FROM dual;


-- Populate Member_Ebooks
INSERT ALL
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U001', 'B001')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U001', 'B019')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U002', 'B002')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U002', 'B020')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U003', 'B003')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U003', 'B021')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U004', 'B004')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U004', 'B013')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U005', 'B005')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U005', 'B025')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U006', 'B006')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U006', 'B022')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U007', 'B007')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U007', 'B017')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U008', 'B008')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U008', 'B024')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U009', 'B009')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U009', 'B029')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U010', 'B010')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U010', 'B026')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U001', 'B014')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U002', 'B015')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U003', 'B016')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U004', 'B018')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U005', 'B027')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U006', 'B012')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U007', 'B011')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U008', 'B023')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U009', 'B030')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U010', 'B028')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U001', 'B017')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U002', 'B024')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U003', 'B005')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U004', 'B022')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U005', 'B021')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U006', 'B020')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U007', 'B018')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U008', 'B009')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U009', 'B004')
INTO Member_Ebooks (member_id, ebook_id) VALUES ('U010', 'B003')
SELECT * FROM dual;

-- Populate Member_Hard_Copies table
INSERT ALL
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW001', 'U001', 'B001', 'B001C1', TO_DATE('2023-10-01', 'YYYY-MM-DD'), TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_DATE('2023-10-08', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW002', 'U001', 'B005', 'B005C1', TO_DATE('2023-10-02', 'YYYY-MM-DD'), TO_DATE('2023-10-16', 'YYYY-MM-DD'), TO_DATE('2023-10-09', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW003', 'U002', 'B002', 'B002C1', TO_DATE('2023-10-03', 'YYYY-MM-DD'), TO_DATE('2023-10-17', 'YYYY-MM-DD'), TO_DATE('2023-10-10', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW004', 'U002', 'B003', 'B003C1', TO_DATE('2023-10-04', 'YYYY-MM-DD'), TO_DATE('2023-10-18', 'YYYY-MM-DD'), TO_DATE('2023-10-11', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW005', 'U003', 'B004', 'B004C1', TO_DATE('2023-10-05', 'YYYY-MM-DD'), TO_DATE('2023-10-19', 'YYYY-MM-DD'), TO_DATE('2023-10-12', 'YYYY-MM-DD'), 'New', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW006', 'U003', 'B001', 'B001C2', TO_DATE('2023-10-06', 'YYYY-MM-DD'), TO_DATE('2023-10-20', 'YYYY-MM-DD'), TO_DATE('2023-10-13', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW007', 'U004', 'B002', 'B002C2', TO_DATE('2023-10-07', 'YYYY-MM-DD'), TO_DATE('2023-10-21', 'YYYY-MM-DD'), TO_DATE('2023-10-14', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW008', 'U004', 'B005', 'B005C2', TO_DATE('2023-10-08', 'YYYY-MM-DD'), TO_DATE('2023-10-22', 'YYYY-MM-DD'), TO_DATE('2023-10-15', 'YYYY-MM-DD'), 'New', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW009', 'U005', 'B003', 'B003C2', TO_DATE('2023-10-09', 'YYYY-MM-DD'), TO_DATE('2023-10-23', 'YYYY-MM-DD'), TO_DATE('2023-10-16', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW010', 'U005', 'B004', 'B004C2', TO_DATE('2023-10-10', 'YYYY-MM-DD'), TO_DATE('2023-10-24', 'YYYY-MM-DD'), TO_DATE('2023-10-17', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW011', 'U006', 'B001', 'B001C3', TO_DATE('2023-10-11', 'YYYY-MM-DD'), TO_DATE('2023-10-25', 'YYYY-MM-DD'), TO_DATE('2023-10-18', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW012', 'U006', 'B002', 'B002C3', TO_DATE('2023-10-12', 'YYYY-MM-DD'), TO_DATE('2023-10-26', 'YYYY-MM-DD'), TO_DATE('2023-10-19', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW013', 'U007', 'B003', 'B003C3', TO_DATE('2023-10-13', 'YYYY-MM-DD'), TO_DATE('2023-10-27', 'YYYY-MM-DD'), TO_DATE('2023-10-20', 'YYYY-MM-DD'), 'New', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW014', 'U007', 'B004', 'B004C3', TO_DATE('2023-10-14', 'YYYY-MM-DD'), TO_DATE('2023-10-28', 'YYYY-MM-DD'), TO_DATE('2023-10-21', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW015', 'U008', 'B005', 'B005C3', TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_DATE('2023-10-29', 'YYYY-MM-DD'), TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW016', 'U008', 'B001', 'B001C4', TO_DATE('2023-10-16', 'YYYY-MM-DD'), TO_DATE('2023-10-30', 'YYYY-MM-DD'), TO_DATE('2023-10-23', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW017', 'U009', 'B002', 'B002C1', TO_DATE('2023-10-17', 'YYYY-MM-DD'), TO_DATE('2023-10-31', 'YYYY-MM-DD'), TO_DATE('2023-10-24', 'YYYY-MM-DD'), 'Damaged', 'Damaged')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW018', 'U009', 'B003', 'B003C4', TO_DATE('2023-10-18', 'YYYY-MM-DD'), TO_DATE('2023-11-01', 'YYYY-MM-DD'), TO_DATE('2023-10-25', 'YYYY-MM-DD'), 'New', 'New')
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW019', 'U009', 'B004', 'B004C1', TO_DATE('2023-10-19', 'YYYY-MM-DD'), TO_DATE('2023-11-02', 'YYYY-MM-DD'), NULL, 'Damaged', NULL)
INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, due_date, return_date, checkin_condition, checkout_condition) VALUES ('BRW020', 'U010', 'B005', 'B005C4', TO_DATE('2023-10-20', 'YYYY-MM-DD'), TO_DATE('2023-11-03', 'YYYY-MM-DD'), TO_DATE('2023-10-27', 'YYYY-MM-DD'), 'New', 'New')
SELECT * FROM dual;


-- Populate Member_Room table
INSERT ALL
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG001', 'U001', 'R001', TO_DATE('2023-10-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG002', 'U001', 'R005', TO_DATE('2023-10-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG003', 'U002', 'R002', TO_DATE('2023-10-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG004', 'U002', 'R004', TO_DATE('2023-10-03', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-03 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-03 16:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG005', 'U003', 'R005', TO_DATE('2023-10-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-04 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG006', 'U003', 'R008', TO_DATE('2023-10-05', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-05 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG007', 'U004', 'R005', TO_DATE('2023-10-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG008', 'U004', 'R010', TO_DATE('2023-10-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-07 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG009', 'U005', 'R009', TO_DATE('2023-10-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-08 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-08 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG010', 'U005', 'R010', TO_DATE('2023-10-09', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-09 14:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG011', 'U006', 'R001', TO_DATE('2023-10-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-10 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG012', 'U007', 'R004', TO_DATE('2023-10-11', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-11 16:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG013', 'U007', 'R008', TO_DATE('2023-10-12', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG014', 'U008', 'R002', TO_DATE('2023-10-13', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-13 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-13 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG015', 'U008', 'R005', TO_DATE('2023-10-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-14 14:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG016', 'U009', 'R006', TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-15 17:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG017', 'U010', 'R009', TO_DATE('2023-10-16', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-16 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-16 11:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG018', 'U010', 'R010', TO_DATE('2023-10-17', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-17 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG019', 'U006', 'R009', TO_DATE('2023-10-18', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-18 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-10-18 16:00:00', 'YYYY-MM-DD HH24:MI:SS'))
INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES ('BKG020', 'U009', 'R010', TO_DATE('2024-04-27', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-19 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'))
SELECT * FROM dual;


-- Populate Book_Author table
INSERT ALL
    INTO Book_Author (book_id, author_id) VALUES ('B001', 'AUTH001')
    INTO Book_Author (book_id, author_id) VALUES ('B002', 'AUTH002')
    INTO Book_Author (book_id, author_id) VALUES ('B003', 'AUTH003')
    INTO Book_Author (book_id, author_id) VALUES ('B004', 'AUTH004')
    INTO Book_Author (book_id, author_id) VALUES ('B005', 'AUTH005')
    INTO Book_Author (book_id, author_id) VALUES ('B006', 'AUTH006')
    INTO Book_Author (book_id, author_id) VALUES ('B007', 'AUTH007')
    INTO Book_Author (book_id, author_id) VALUES ('B008', 'AUTH008')
    INTO Book_Author (book_id, author_id) VALUES ('B009', 'AUTH009')
    INTO Book_Author (book_id, author_id) VALUES ('B010', 'AUTH010')
    INTO Book_Author (book_id, author_id) VALUES ('B011', 'AUTH011')
    INTO Book_Author (book_id, author_id) VALUES ('B012', 'AUTH012')
    INTO Book_Author (book_id, author_id) VALUES ('B013', 'AUTH013')
    INTO Book_Author (book_id, author_id) VALUES ('B014', 'AUTH014')
    INTO Book_Author (book_id, author_id) VALUES ('B015', 'AUTH015')
    INTO Book_Author (book_id, author_id) VALUES ('B016', 'AUTH016')
    INTO Book_Author (book_id, author_id) VALUES ('B017', 'AUTH017')
    INTO Book_Author (book_id, author_id) VALUES ('B018', 'AUTH018')
    INTO Book_Author (book_id, author_id) VALUES ('B019', 'AUTH019')
    INTO Book_Author (book_id, author_id) VALUES ('B020', 'AUTH020')
    INTO Book_Author (book_id, author_id) VALUES ('B021', 'AUTH001')
    INTO Book_Author (book_id, author_id) VALUES ('B022', 'AUTH001')
    INTO Book_Author (book_id, author_id) VALUES ('B023', 'AUTH002')
    INTO Book_Author (book_id, author_id) VALUES ('B024', 'AUTH005')
    INTO Book_Author (book_id, author_id) VALUES ('B025', 'AUTH020')
    INTO Book_Author (book_id, author_id) VALUES ('B026', 'AUTH019')
    INTO Book_Author (book_id, author_id) VALUES ('B027', 'AUTH007')
    INTO Book_Author (book_id, author_id) VALUES ('B028', 'AUTH008')
    INTO Book_Author (book_id, author_id) VALUES ('B029', 'AUTH020')
    INTO Book_Author (book_id, author_id) VALUES ('B030', 'AUTH017')
    INTO Book_Author (book_id, author_id) VALUES ('B027', 'AUTH011')
    INTO Book_Author (book_id, author_id) VALUES ('B005', 'AUTH013')
SELECT * FROM DUAL;

-- Populate Book_Course table
INSERT ALL
    INTO Book_Course (book_id, course_id) VALUES ('B001', 'BUSM4185')
    INTO Book_Course (book_id, course_id) VALUES ('B002', 'COSC2429')
    INTO Book_Course (book_id, course_id) VALUES ('B003', 'OMGT2085')
    INTO Book_Course (book_id, course_id) VALUES ('B004', 'COMM2596')
    INTO Book_Course (book_id, course_id) VALUES ('B005', 'COSC2440')
    INTO Book_Course (book_id, course_id) VALUES ('B006', 'COSC2440')
    INTO Book_Course (book_id, course_id) VALUES ('B007', 'ACCT2105')
    INTO Book_Course (book_id, course_id) VALUES ('B008', 'COMM2752')
    INTO Book_Course (book_id, course_id) VALUES ('B009', 'VART3626')
    INTO Book_Course (book_id, course_id) VALUES ('B010', 'MKTG1447')
    INTO Book_Course (book_id, course_id) VALUES ('B011', 'ISYS2109')
    INTO Book_Course (book_id, course_id) VALUES ('B012', 'EEET2600')
    INTO Book_Course (book_id, course_id) VALUES ('B013', 'MKTG1420')
    INTO Book_Course (book_id, course_id) VALUES ('B014', 'COSC2532')
    INTO Book_Course (book_id, course_id) VALUES ('B015', 'LANG1318')
    INTO Book_Course (book_id, course_id) VALUES ('B016', 'MKTG1421')
    INTO Book_Course (book_id, course_id) VALUES ('B017', 'EEET2482')
    INTO Book_Course (book_id, course_id) VALUES ('B018', 'FOHO1024')
    INTO Book_Course (book_id, course_id) VALUES ('B019', 'MKTG1205')
    INTO Book_Course (book_id, course_id) VALUES ('B020', 'COSC2430')
    INTO Book_Course (book_id, course_id) VALUES ('B022', 'EEET2599')
    INTO Book_Course (book_id, course_id) VALUES ('B027', 'COSC2429')
    INTO Book_Course (book_id, course_id) VALUES ('B027', 'ISYS3414')
    INTO Book_Course (book_id, course_id) VALUES ('B027', 'COSC2440')
    INTO Book_Course (book_id, course_id) VALUES ('B028', 'EEET2601')
    INTO Book_Course (book_id, course_id) VALUES ('B028', 'EEET2599')
    INTO Book_Course (book_id, course_id) VALUES ('B030', 'FOHO1024')
SELECT * FROM DUAL;

-- Populate Book_Category table
INSERT ALL
    INTO Book_Category (book_id, category_id) VALUES ('B001', 'CAT016')
    INTO Book_Category (book_id, category_id) VALUES ('B002', 'CAT006')
    INTO Book_Category (book_id, category_id) VALUES ('B003', 'CAT007')
    INTO Book_Category (book_id, category_id) VALUES ('B004', 'CAT013')
    INTO Book_Category (book_id, category_id) VALUES ('B005', 'CAT005')
    INTO Book_Category (book_id, category_id) VALUES ('B006', 'CAT006')
    INTO Book_Category (book_id, category_id) VALUES ('B007', 'CAT016')
    INTO Book_Category (book_id, category_id) VALUES ('B008', 'CAT014')
    INTO Book_Category (book_id, category_id) VALUES ('B009', 'CAT014')
    INTO Book_Category (book_id, category_id) VALUES ('B010', 'CAT014')
    INTO Book_Category (book_id, category_id) VALUES ('B011', 'CAT006')
    INTO Book_Category (book_id, category_id) VALUES ('B012', 'CAT005')
    INTO Book_Category (book_id, category_id) VALUES ('B013', 'CAT016')
    INTO Book_Category (book_id, category_id) VALUES ('B014', 'CAT014')
    INTO Book_Category (book_id, category_id) VALUES ('B015', 'CAT013')
    INTO Book_Category (book_id, category_id) VALUES ('B016', 'CAT008')
    INTO Book_Category (book_id, category_id) VALUES ('B017', 'CAT005')
    INTO Book_Category (book_id, category_id) VALUES ('B018', 'CAT018')
    INTO Book_Category (book_id, category_id) VALUES ('B019', 'CAT016')
    INTO Book_Category (book_id, category_id) VALUES ('B020', 'CAT006')
SELECT * FROM DUAL;

-- Populate Book_Major table
INSERT ALL
    INTO Book_Major (book_id, major_id) VALUES ('B001', 'BP343')
    INTO Book_Major (book_id, major_id) VALUES ('B002', 'BP214')
    INTO Book_Major (book_id, major_id) VALUES ('B003', 'BP312')
    INTO Book_Major (book_id, major_id) VALUES ('B004', 'BP222')
    INTO Book_Major (book_id, major_id) VALUES ('B005', 'BP070')
    INTO Book_Major (book_id, major_id) VALUES ('B006', 'BH123')
    INTO Book_Major (book_id, major_id) VALUES ('B007', 'BP351')
    INTO Book_Major (book_id, major_id) VALUES ('B008', 'BP309')
    INTO Book_Major (book_id, major_id) VALUES ('B009', 'BP325')
    INTO Book_Major (book_id, major_id) VALUES ('B010', 'BP327')
    INTO Book_Major (book_id, major_id) VALUES ('B011', 'BP162')
    INTO Book_Major (book_id, major_id) VALUES ('B012', 'BH073')
    INTO Book_Major (book_id, major_id) VALUES ('B013', 'BP318')
    INTO Book_Major (book_id, major_id) VALUES ('B014', 'BP316')
    INTO Book_Major (book_id, major_id) VALUES ('B015', 'BP317')
    INTO Book_Major (book_id, major_id) VALUES ('B016', 'BP154')
    INTO Book_Major (book_id, major_id) VALUES ('B017', 'BH120')
    INTO Book_Major (book_id, major_id) VALUES ('B018', 'BP199')
    INTO Book_Major (book_id, major_id) VALUES ('B019', 'BP343')
    INTO Book_Major (book_id, major_id) VALUES ('B020', 'BP214')
    INTO Book_Major (book_id, major_id) VALUES ('B021', 'BP312')
    INTO Book_Major (book_id, major_id) VALUES ('B022', 'BH123')
    INTO Book_Major (book_id, major_id) VALUES ('B023', 'BP070')
    INTO Book_Major (book_id, major_id) VALUES ('B024', 'BH123')
    INTO Book_Major (book_id, major_id) VALUES ('B025', 'BP351')
    INTO Book_Major (book_id, major_id) VALUES ('B026', 'BP309')
    INTO Book_Major (book_id, major_id) VALUES ('B027', 'BP162')
    INTO Book_Major (book_id, major_id) VALUES ('B028', 'BH073')
    INTO Book_Major (book_id, major_id) VALUES ('B029', 'BP318')
    INTO Book_Major (book_id, major_id) VALUES ('B030', 'BP199')
    INTO Book_Major (book_id, major_id) VALUES ('B028', 'BH123')
    INTO Book_Major (book_id, major_id) VALUES ('B027', 'BH120')
SELECT * FROM DUAL;








--This is for Oracle syntax

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
    f_name VARCHAR2(100),
    l_name VARCHAR2(100),
    email VARCHAR(100) CONSTRAINT email_unique UNIQUE NOT NULL,
    pwd VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Lib_Member (
    user_id VARCHAR(15) PRIMARY KEY,
    role VARCHAR(50) CHECK (role IN ('Student', 'Staff')),
    total_book_borrowed INT DEFAULT 0,
    total_fine_paid DECIMAL(10,2) DEFAULT 0.00,
    program_code VARCHAR(15),
    FOREIGN KEY (user_id) REFERENCES Lib_User(user_id),
    FOREIGN KEY (program_code) REFERENCES Major(major_id),
    CHECK (
        (role = 'Student' AND total_book_borrowed <= 10) OR
        (role = 'Staff' AND total_book_borrowed <= 20)
    )
);

CREATE TABLE Lib_Admin (
    user_id VARCHAR(15) PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Lib_User(user_id)
);

CREATE TABLE Lib_Librarian (
    user_id VARCHAR(15) PRIMARY KEY,
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
    reservation_date DATE,
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
    issue_date DATE,
    return_date DATE,
    due_date DATE,
    checkin_condition VARCHAR(255) CHECK (checkin_condition IN ('New', 'Damaged')),  -- Only allows 'New' or 'Damaged'
    checkout_condition VARCHAR(255) CHECK (checkout_condition IN ('New', 'Damaged')),  -- Only allows 'New' or 'Damaged'
    borrower VARCHAR(15),
    FOREIGN KEY (member) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (book, bcopy) REFERENCES Hard_Copies(book_id, copy_id),
    FOREIGN KEY (borrower) REFERENCES Lib_Member(user_id)
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


-- Test data
SELECT * from Course;
SELECT * FROM Major;

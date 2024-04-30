use vinht;
DROP TABLE IF EXISTS Member_HardCopy;
DROP TABLE IF EXISTS Member_Room;
DROP TABLE IF EXISTS Member_Ebooks;
DROP TABLE IF EXISTS Member_Course;
DROP TABLE IF EXISTS Requests;
DROP TABLE IF EXISTS Fine;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Hard_Copies;
DROP TABLE IF EXISTS Ebooks;
DROP TABLE IF EXISTS Book_Author;
DROP TABLE IF EXISTS Book_Course;
DROP TABLE IF EXISTS Book_Category;
DROP TABLE IF EXISTS Book_Major;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Lib_Librarian;
DROP TABLE IF EXISTS Lib_Admin;
DROP TABLE IF EXISTS Lib_Member;
DROP TABLE IF EXISTS Lib_User;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Major;


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
    username VARCHAR(50) UNIQUE NOT NULL,
    f_name NVARCHAR(100),
    l_name NVARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    pwd VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_type VARCHAR(50) CHECK (user_type IN ('Admin', 'Librarian', 'Member', 'Staff'))
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
    description TEXT,
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
    f_name NVARCHAR(100),
    l_name NVARCHAR(100)
);

CREATE TABLE Review (
    review_id VARCHAR(15) PRIMARY KEY,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
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
    message TEXT,
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
    reservation_date DATE DEFAULT CURRENT_DATE,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Lib_Member(user_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    CHECK (TIMESTAMPDIFF(HOUR, start_date, end_date) <= 2)  -- Ensures booking duration does not exceed 2 hours
);


CREATE TABLE Member_HardCopy (
    borrow_id VARCHAR(15) PRIMARY KEY,
    member VARCHAR(15),
    book VARCHAR(15),
    bcopy VARCHAR(15),
    issue_date DATE DEFAULT CURRENT_DATE,
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
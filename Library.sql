-- Insert Lib_User
INSERT INTO Lib_User (user_id, f_name, l_name, email, password, created_at) VALUES
('U001', 'Anh', 'Lam', 'lamtramanh@gmail.com', 'practical'),
('U002', 'Bao', 'Ho', 'honguyenbao@gmail.com', 'database'),
('U003', 'Uyen', 'Ngo', 'nnphuonguyen@gmail.com', 'concepts'),
('U004', 'Duc', 'Pham', 'phamvietduc@gmail.com', 'pdc'),
('U005', 'Evelyn', 'Vo', 'voeva@gmail.com', 'sql'),
('U006', 'Joshua', 'Hansen', 'xthejosh@gmail.com', 'oracle'),
('U007', 'Giang', 'Dinh', 'dinhquynhgiang@gmail.com', 'apex'),
('U008', 'Hai', 'Luong', 'luongminhhai@gmail.com', 'library'),
('U009', 'Vy', 'Kieu', 'kieukhanhvy@gmail.com', 'system'),
('U010', 'Iris', 'Nguyen', 'ngmaihuong@gmail.com', 'erd'),
('L001', 'Andrew', 'Baltutis', 'litvandrius@gmail.com', 'relationalschema'),
('L002', 'Nguyen', 'Bao', 'nguyenbao@gmail.com', 'entity'),
('L003', 'Tran', 'Chi', 'tranchi@gmail.com', 'relationship'),
('A001', 'Ha', 'Trinh', 'hatrinh@gmail.com', 'schema'),
('A002', 'Bach', 'Nguyen', 'voeva@gmail.com', 'hierachy'),
('A003', 'Vinh', 'Feng', 'buifeng@gmail.com', 'HD');



-- Insert Lib_Member
INSERT INTO Lib_Member (user_id, role, total_book_borrowed, total_fine_paid, program_code) VALUES
('U001', 'Student', 5, 0.00, 'BP343'),
('U002', 'Student', 3, 0.00, 'BP214'),
('U003', 'Lecturer', 0, 0.00, NULL),
('U004', 'Student', 2, 0.00, 'BP312'),
('U005', 'Student', 4, 0.00, 'BP222'),
('U006', 'Lecturer', 0, 0.00, NULL),
('U007', 'Student', 6, 0.00, 'BP070'),
('U008', 'Student', 2, 0.00, 'BH123'),
('U009', 'Student', 5, 0.00, 'BP351'),
('U010', 'Student', 1, 0.00, 'BP309');

-- Insert Lib_Admin
INSERT INTO Lib_Admin (user_id) VALUES
('A001'),
('A002'),
('A003');


-- Populate Lib_Librarian
INSERT INTO Lib_Librarian (user_id) VALUES
('L001'),
('L002'),
('L003');


-- Populate Major
INSERT INTO Major (major_id, school, name) VALUES
('BP343', 'TBS', 'Business'),
('BP214', 'SCD', 'Game Design'),
('BP312', 'TBS', 'Tourism and Hospitality Management'),
('BP222', 'SCD', 'Professional Communication'),
('BP070', 'SSET', 'Applied Science (Aviation)'),
('BH123', 'SSET', 'Robotics and Mechatronics Engineering'),
('BP351', 'TBS', 'Accounting'),
('BP309', 'SCD', 'Digital Media'),
('BP325', 'SCD', 'Digital Film and Video'),
('BP327', 'SCD', 'Fashion (Enterprise)'),
('BP162', 'SSET', 'Information Technology'),
('BH073', 'SSET', 'Electronic and Computer Systems Engineering'),
('BP318', 'TBS', 'Digital Marketing'),
('BP316', 'SCD', 'Design Studies'),
('BP317', 'SEUP', 'Languages'),
('BP154', 'SSET', 'Psychology'),
('BH120', 'SSET', 'Software Engineering'),
('BP199', 'SSET', 'Food Technology and Nutrition');


-- Populate Course
INSERT INTO Course (course_id, name) VALUES
('MKTG1205', 'Marketing Principles'),
('MKTG1419', 'Social Media and Mobile Marketing'),
('MKTG1420', 'Digital Business Development'),
('MKTG1422', 'Digital Marketing Communication'),
('OMGT2085', 'Intro to Logistics & Supply Chain Mgt'),
('OMGT2197', 'Procurement Mgmt and Global Sourcing'),
('ISYS2109', 'Business Information Systems'),
('MKTG1421', 'Consumer Psychology and Behaviour'),
('COSC2429', 'Introduction To Programming'),
('COSC2430', 'Web Programming'),
('COSC2440', 'Software Architecture: Design & Implementation'),
('COSC2652', 'User-centred Design'),
('ISYS3414', 'Practical Database Concepts'),
('COMM2596', 'Digital Narrative Theory and Practice'),
('COMM2752', 'Digital Media Specialisation 2'),
('COSC2532', 'Advanced Electronic Imaging'),
('VART3626', 'Photography 101'),
('VART3670', 'Creative Photography'),
('ECON1318', 'Economics for Tourism and Hospitality'),
('ACCT2105', 'Accounting in Organisations & Society'),
('ACCT2158', 'Financial Accounting and Analysis'),
('ACCT2160', 'Cost Analysis and Organisational Decisions'),
('BAFI3182', 'Financial Markets'),
('BAFI3184', 'Business Finance'),
('ECON1192', 'Macroeconomics 1'),
('ECON1193', 'Business Statistics 1'),
('ECON1194', 'Prices and Markets'),
('LAW2447', 'Commercial Law'),
('ACCT2197', 'Performance Analysis and Simulations'),
('EEET2482', 'Software Engineering Design'),
('EEET2599', 'Electrical Engineering 1'),
('EEET2600', 'Electronics'),
('EEET2601', 'Engineering Computing 1'),
('EEET2603', 'Introduction to Electrical and Electronic Engineering'),
('MATH2394', 'Engineering Mathematics'),
('OENG1181', 'Introduction to Professional Engineering Practice'),
('BAFI3239', 'Pattern Cutting for Production'),
('BUSM1784', 'Supply Chain Management'),
('MANU2492', 'Digital Applications for Fashion Enterprise 1'),
('MKTG1447', 'Introduction to Fashion Marketing'),
('VART3663', 'Computing for Fashion Design and Product Development'),
('VART3662', 'Introduction to Fashion Design'),
('LANG1306', 'Japanese 1'),
('LANG1307', 'Japanese 2'),
('LANG1321', 'Introduction to Language'),
('LANG1303', 'Ethics & Professional Issues in Translating & Interpreting'),
('LANG1308', 'Japanese 3'),
('LANG1310', 'Japanese 5'),
('LANG1318', 'Language and Society'),
('SOCU2252', 'Intercultural Communication'),
('SOCU2290', 'Working and Managing in Global Careers'),
('BUSM3299', 'The Entrepreneurial Process'),
('BUSM3310', 'Human Resource Management'),
('BUSM3311', 'International Business'),
('BUSM4092', 'Applied Entrepreneurship'),
('BUSM4186', 'Global Entrepreneurship'),
('BUSM4566', 'Tourism Planning & Resource Management'),
('BUSM4769', 'Employment Relations'),
('BUSM2301', 'Organisational Analysis'),
('BUSM2412', 'Marketing for Managers'),
('BUSM2479', 'Digital Entrepreneurship'),
('BUSM3244', 'Business and Economic Analysis'),
('BUSM3250', 'People and Organisations'),
('BUSM4037', 'Contemporary Issues in International Management'),
('BUSM4185', 'Introduction to Management'),
('BUSM4188', 'Leadership and Decision Making'),
('BUSM4488', 'Managing Across Cultures'),
('BUSM4561', 'Work in Global Society'),
('BUSM4568', 'Room Division Management'),
('BUSM4573', 'Business Communications and Professional Practice'),
('BUSM4621', 'Postgraduate Business Internship'),
('FOHO1024', 'International Food & Beverage Management'),
('INTE2562', 'Digital Innovation'),
('OMGT2272', 'International Logistics'),
('BUSM4553', 'Creativity, Innovation and Design'),
('BUSM4557', 'Contemporary Management: Issues and Challenges'),
('BUSM4489', 'Sustainable International Business Futures'),
('COMM2377', 'Modern Asia'),
('COMM2383', 'New Media, New Asia'),
('COMM2489', 'Asian Cinemas'),
('GRAP2659', 'Art Direction'),
('LANG1265', 'Vietnamese for Professional Communication'),
('COMM2497', 'Exploring Asian Popular Culture'),
('GRAP2413', 'Advertising Media'); 


-- Insert Category
INSERT INTO Category (category_id, name) VALUES
('CAT001', 'Mathematics'),
('CAT002', 'Physics'),
('CAT003', 'Chemistry'),
('CAT004', 'Biology'),
('CAT005', 'Engineering'),
('CAT006', 'Computer Science'),
('CAT007', 'Economics'),
('CAT008', 'Psychology'),
('CAT009', 'Literature'),
('CAT010', 'History'),
('CAT011', 'Philosophy'),
('CAT012', 'Political Science'),
('CAT013', 'Languages'),
('CAT014', 'Arts'),
('CAT015', 'Education'),
('CAT016', 'Business'),
('CAT017', 'Law'),
('CAT018', 'Medicine'),
('CAT019', 'Environmental Science'),
('CAT020', 'Sociology'),
('CAT001', 'Mathematics'),
('CAT002', 'Physics'),
('CAT003', 'Chemistry'),
('CAT004', 'Biology'),
('CAT005', 'Engineering'),
('CAT006', 'Computer Science'),
('CAT007', 'Economics'),
('CAT008', 'Psychology'),
('CAT009', 'Literature'),
('CAT010', 'History'),
('CAT011', 'Philosophy'),
('CAT012', 'Political Science'),
('CAT013', 'Languages'),
('CAT014', 'Arts'),
('CAT015', 'Education'),
('CAT016', 'Business'),
('CAT017', 'Law'),
('CAT018', 'Medicine'),
('CAT019', 'Environmental Science'),
('CAT020', 'Sociology');


-- Insert Location
INSERT INTO Location (location_id, campus, floor, shelf_no, line_no) VALUES
('LOC001', 'Melbourne', 1, 'C1', 1),
('LOC002', 'Beanland', 2, 'A1', 2),
('LOC003', 'Hanoi', 1, 'A2', 3),
('LOC004', 'Beanland', 1, 'A2', 6),
('LOC005', 'Hanoi', 3, 'B1', 1),
('LOC006', 'Melbourne', 2, 'G1', 9),
('LOC007', 'Beanland', 2, 'B2', 11),
('LOC008', 'Hanoi', 2, 'B2', 2),
('LOC009', 'Beanland', 4, 'E1', 1),
('LOC010', 'Beanland', 1, 'C1', 2);


-- Populate Item 
INSERT INTO Item (item_id, manager) VALUES
('B001'),
('B002'),
('B003'),
('B004'),
('B005'),
('B006'),
('B007'),
('B008'),
('B009'),
('B010'),
('B011'),
('B012'),
('B013'),
('B014'),
('B015'),
('B016'),
('B017'),
('B018'),
('B019'),
('B020'),
('R001'),
('R002'),
('R003'),
('R004'),
('R005'),
('R006'),
('R007'),
('R008'),
('R009'),
('R010');


-- Populate Room 
INSERT INTO Room (room_id, building_no, room_no, capacity, status) VALUES
('R001', 1, '101', 5, 'Available'),
('R002', 1, '102', 5, 'Available'),
('R003', 1, '103', 3, 'Unavailable'),
('R004', 1, '104', 3, 'Available'),
('R005', 1, '105', 10, 'Available'),
('R006', 2, '201', 20, 'Available'),
('R007', 2, '202', 10, 'Unavailable'),
('R008', 2, '203', 10, 'Available'),
('R009', 2, '204', 5, 'Available'),
('R010', 2, '205', 5, 'Available');


-- Populate Books
INSERT INTO Book (book_id, title, num_of_copies, description, ratings, language) VALUES
('B001', 'Business Dynamics', 5, 'Insights into evolving market trends.', 4.1, 'English'),
('B002', 'Principles of Game Design', 3, 'Foundations of game development and design.', 4.5, 'English'),
('B003', 'Modern Tourism Management', 4, 'Managing tourism businesses in the global economy.', 4.0, 'English'),
('B004', 'Effective Communication', 3, 'Strategies for professional communication.', 4.2, 'English'),
('B005', 'Aviation Studies', 6, 'Comprehensive exploration of the aviation industry.', 4.7, 'English'),
('B006', 'Robotics Fundamentals', 7, 'Introduction to robotics and its applications.', 4.3, 'English'),
('B007', 'Corporate Accounting', 4, 'Accounting principles for corporate environments.', 4.4, 'English'),
('B008', 'Digital Media Evolution', 5, 'The rise of digital media and its impact on culture.', 4.1, 'English'),
('B009', 'Film and Video Production', 2, 'Techniques and tools for aspiring filmmakers.', 4.8, 'English'),
('B010', 'Fashion Design Theory', 3, 'Critical theories and practices in fashion design.', 4.2, 'English'),
('B011', 'IT for Professionals', 8, 'Using technology effectively in professional settings.', 4.9, 'English'),
('B012', 'Electronics Engineering', 5, 'Foundations of electronic and computer systems.', 4.3, 'English'),
('B013', 'Digital Marketing Insights', 3, 'Strategies for successful digital marketing.', 4.6, 'English'),
('B014', 'Foundations of Design', 4, 'Principles of design across different mediums.', 4.1, 'English'),
('B015', 'Linguistics and You', 6, 'Exploring the impact of language on society.', 4.5, 'English'),
('B016', 'Psychological Perspectives', 5, 'A look at modern psychology theories.', 4.8, 'English'),
('B017', 'Software Engineering Today', 7, 'The latest trends in software engineering.', 4.9, 'English'),
('B018', 'Nutrition and You', 4, 'Understanding food technology and nutrition.', 4.7, 'English'),
('B019', 'Advanced Business Strategies', 3, 'In-depth strategies for growing businesses.', 4.5, 'English'),
('B020', 'Next-Gen Game Development', 4, 'Future trends in video game development.', 4.6, 'English'),
('B021', 'Global Tourism Economics', 5, 'Economic perspectives on global tourism.', 4.3, 'English'),
('B022', 'Advanced Robotics', 2, 'Emerging technologies in robotics.', 4.8, 'English'),
('B023', 'Accounting Ethics', 3, 'Ethical considerations in modern accounting.', 4.7, 'English'),
('B024', 'Media and Society', 6, 'Examining the role of media in modern societies.', 4.2, 'English'),
('B025', 'Video Editing Techniques', 5, 'Mastering post-production in film and video.', 4.9, 'English'),
('B026', 'Contemporary Fashion Trends', 3, 'Exploring current trends in the fashion industry.', 4.1, 'English'),
('B027', 'Information Security', 4, 'Principles of securing digital information.', 4.5, 'English'),
('B028', 'Circuit Design', 2, 'Essentials of electronic circuit design.', 4.6, 'English'),
('B029', 'Social Media Marketing', 5, 'Leveraging social media for business success.', 4.8, 'English'),
('B030', 'Therapeutic Diets', 3, 'Diet planning for various health conditions.', 4.7, 'English');


-- Insert Ebooks
INSERT INTO Ebooks (book_id, isbn, format, url, file_size_mb) VALUES
('B001', '978-0-00-000001-2', 'PDF', 'https://example.com/ebooks/business_dynamics.pdf', 2.5),
('B002', '978-0-00-000002-9', 'EPub', 'https://example.com/ebooks/game_design.epub', 1.5),
('B003', '978-0-00-000003-6', 'PDF', 'https://example.com/ebooks/tourism_management.pdf', 3.0),
('B004', '978-0-00-000004-3', 'EPub', 'https://example.com/ebooks/effective_communication.epub', 1.2),
('B005', '978-0-00-000005-0', 'PDF', 'https://example.com/ebooks/aviation_studies.pdf', 4.0),
('B006', '978-0-00-000006-7', 'EPub', 'https://example.com/ebooks/robotics_fundamentals.epub', 2.8),
('B007', '978-0-00-000007-4', 'PDF', 'https://example.com/ebooks/corporate_accounting.pdf', 2.3),
('B008', '978-0-00-000008-1', 'EPub', 'https://example.com/ebooks/digital_media.epub', 2.0),
('B009', '978-0-00-000009-8', 'PDF', 'https://example.com/ebooks/film_video_production.pdf', 5.0),
('B010', '978-0-00-000010-4', 'EPub', 'https://example.com/ebooks/fashion_design.epub', 1.8),
('B011', '978-0-00-000011-1', 'PDF', 'https://example.com/ebooks/it_professionals.pdf', 3.5),
('B012', '978-0-00-000012-8', 'EPub', 'https://example.com/ebooks/electronics_engineering.epub', 2.2),
('B013', '978-0-00-000013-5', 'PDF', 'https://example.com/ebooks/digital_marketing.pdf', 2.6),
('B014', '978-0-00-000014-2', 'EPub', 'https://example.com/ebooks/design_foundations.epub', 1.9),
('B015', '978-0-00-000015-9', 'PDF', 'https://example.com/ebooks/linguistics.pdf', 3.1),
('B016', '978-0-00-000016-6', 'EPub', 'https://example.com/ebooks/psychology_perspectives.epub', 2.7),
('B017', '978-0-00-000017-3', 'PDF', 'https://example.com/ebooks/software_engineering.pdf', 3.8),
('B018', '978-0-00-000018-0', 'EPub', 'https://example.com/ebooks/nutrition_you.epub', 2.4),
('B019', '978-0-00-000019-7', 'PDF', 'https://example.com/ebooks/business_strategies.pdf', 2.1),
('B020', '978-0-00-000020-3', 'EPub', 'https://example.com/ebooks/game_development_nextgen.epub', 3.2),
('B021', '978-0-00-000021-0', 'PDF', 'https://example.com/ebooks/tourism_economics.pdf', 2.9),
('B022', '978-0-00-000022-7', 'EPub', 'https://example.com/ebooks/advanced_robotics.epub', 1.6),
('B023', '978-0-00-000023-4', 'PDF', 'https://example.com/ebooks/accounting_ethics.pdf', 2.5),
('B024', '978-0-00-000024-1', 'EPub', 'https://example.com/ebooks/media_society.epub', 2.0),
('B025', '978-0-00-000025-8', 'PDF', 'https://example.com/ebooks/video_editing.pdf', 4.5),
('B026', '978-0-00-000026-5', 'EPub', 'https://example.com/ebooks/fashion_trends.epub', 1.7),
('B027', '978-0-00-000027-2', 'PDF', 'https://example.com/ebooks/information_security.pdf', 3.3),
('B028', '978-0-00-000028-9', 'EPub', 'https://example.com/ebooks/circuit_design.epub', 2.1),
('B029', '978-0-00-000029-6', 'PDF', 'https://example.com/ebooks/social_media_marketing.pdf', 2.8),
('B030', '978-0-00-000030-2', 'EPub', 'https://example.com/ebooks/therapeutic_diets.epub', 1.4);


-- Insert Hard_Copies
INSERT INTO Hard_Copies (book_id, copy_id, status, edition, year_published, location) VALUES
('B001', 'B001C1', 'Unavailable', 'First', 2023, 'LOC001'),
('B001', 'B001C2', 'Available', 'First', 2023, 'LOC001'),
('B001', 'B001C3', 'Available', 'First', 2023, 'LOC001'),
('B001', 'B001C4', 'Unavailable', 'First', 2023, 'LOC001'),
('B001', 'B001C5', 'Available', 'First', 2023, 'LOC001'),
('B002', 'B002C1', 'Available', 'First', 2023, 'LOC002'),
('B002', 'B002C2', 'Available', 'First', 2023, 'LOC002'),
('B002', 'B002C3', 'Unavailable', 'First', 2023, 'LOC002'),
('B003', 'B003C1', 'Unavailable', 'First', 2023, 'LOC003'),
('B003', 'B003C2', 'Available', 'First', 2023, 'LOC003'),
('B003', 'B003C3', 'Available', 'First', 2023, 'LOC003'),
('B003', 'B003C4', 'Available', 'First', 2023, 'LOC003'),
('B004', 'B004C1', 'Available', 'First', 2023, 'LOC004'),
('B004', 'B004C2', 'Unavailable', 'First', 2023, 'LOC004'),
('B004', 'B004C3', 'Unavailable', 'First', 2023, 'LOC004'),
('B005', 'B005C1', 'Available', 'First', 2023, 'LOC005'),
('B005', 'B005C2', 'Available', 'First', 2023, 'LOC005'),
('B005', 'B005C3', 'Available', 'First', 2023, 'LOC005'),
('B005', 'B005C4', 'Unavailable', 'First', 2023, 'LOC005'),
('B005', 'B005C5', 'Available', 'First', 2023, 'LOC005'),
('B005', 'B005C6', 'Available', 'First', 2023, 'LOC005');



-- Insert Populate Author
INSERT INTO Author (author_id, f_name, l_name) VALUES
('AUTH001', 'John', 'Smith'),
('AUTH002', 'Alice', 'Johnson'),
('AUTH003', 'Robert', 'Lee'),
('AUTH004', 'Michael', 'Brown'),
('AUTH005', 'Laura', 'Wilson'),
('AUTH006', 'Sarah', 'Miller'),
('AUTH007', 'James', 'Davis'),
('AUTH008', 'Mary', 'Taylor'),
('AUTH009', 'William', 'Anderson'),
('AUTH010', 'Linda', 'Thomas'),
('AUTH011', 'Richard', 'Jackson'),
('AUTH012', 'Jessica', 'White'),
('AUTH013', 'David', 'Harris'),
('AUTH014', 'Emily', 'Martin'),
('AUTH015', 'Jennifer', 'Thompson'),
('AUTH016', 'Charles', 'Garcia'),
('AUTH017', 'Angela', 'Martinez'),
('AUTH018', 'Patricia', 'Robinson'),
('AUTH019', 'Joseph', 'Clark'),
('AUTH020', 'Christopher', 'Rodriguez'),
('AUTH021', 'Karen', 'Lewis'),
('AUTH022', 'Daniel', 'Walker'),
('AUTH023', 'Nancy', 'Allen'),
('AUTH024', 'Barbara', 'Young'),
('AUTH025', 'Paul', 'King'),
('AUTH026', 'Donna', 'Scott'),
('AUTH027', 'Steven', 'Green'),
('AUTH028', 'Susan', 'Adams'),
('AUTH029', 'Edward', 'Baker'),
('AUTH030', 'Margaret', 'Gonzalez');


-- Insert Review
INSERT INTO Review (review_id, rating, comment, reviewer, book) VALUES
('REV001', 5, 'Absolutely insightful with practical tips on navigating market trends.', 'U001', 'B001'),
('REV002', 3, 'Good book but some chapters are too theoretical.', 'U002', 'B001'),
('REV003', 4, 'Great read for anyone interested in business strategy.', 'U003', 'B001'),
('REV004', 5, 'Excellent introduction to game design fundamentals.', 'U004', 'B002'),
('REV005', 4, 'Very helpful for beginners in game development.', 'U005', 'B002'),
('REV006', 4, 'Covers the basics well but lacks advanced topics.', 'U006', 'B002'),
('REV007', 4, 'Comprehensive and up-to-date with modern practices.', 'U007', 'B003'),
('REV008', 2, 'Somewhat outdated in certain aspects of tourism management.', 'U008', 'B003'),
('REV009', 5, 'A must-read for hospitality and tourism management students.', 'U009', 'B003'),
('REV010', 5, 'Incredibly useful for improving communication skills.', 'U010', 'B004'),
('REV011', 3, 'Decent coverage of topics, but some parts were too basic.', 'U001', 'B004'),
('REV012', 4, 'Engaging content and practical advice.', 'U002', 'B004'),
('REV013', 5, 'Outstanding depth and detail on aviation topics.', 'U003', 'B005'),
('REV014', 5, 'The technical insights are remarkable.', 'U004', 'B005'),
('REV015', 4, 'Comprehensive but a little overwhelming for newbies.', 'U005', 'B005'),
('REV016', 4, 'Solid introduction to robotics.', 'U006', 'B006'),
('REV017', 4, 'Good hands-on examples and case studies.', 'U007', 'B006'),
('REV018', 3, 'Needs more advanced topics to be truly comprehensive.', 'U008', 'B006'),
('REV019', 5, 'Essential reading for anyone in finance.', 'U009', 'B007'),
('REV020', 5, 'Detailed and informative with excellent examples.', 'U010', 'B007'),
('REV021', 4, 'Great for understanding corporate accounting principles.', 'U001', 'B007'),
('REV022', 4, 'Very insightful into the changes in digital media.', 'U002', 'B008'),
('REV023', 3, 'Covers the basics well, but lacks depth in new media trends.', 'U003', 'B008'),
('REV024', 5, 'A must-have resource for digital media students.', 'U004', 'B008'),
('REV025', 5, 'Exceptionally detailed guide to film production.', 'U005', 'B009'),
('REV026', 4, 'Great practical advice, though aimed more at beginners.', 'U006', 'B009'),
('REV027', 3, 'Good overview but I expected more advanced techniques.', 'U007', 'B009'),
('REV028', 4, 'Innovative approaches to fashion design.', 'U008', 'B010'),
('REV029', 2, 'Somewhat disappointing with a lack of technical detail.', 'U009', 'B010'),
('REV030', 5, 'Inspiring and thought-provoking!', 'U010', 'B010');



-------- Populate Fine
INSERT INTO Fine (fine_id, amount, reason, status, incurred_date, due_date, paid_date, payer, item_id) VALUES
('FINE001', 50.00, 'Late return', 'Unpaid', DATE '2023-10-01', DATE '2023-10-15', NULL, 'MEM001', 'ITEM001'),
('FINE002', 25.00, 'Damaged book', 'Paid', DATE '2023-09-01', DATE '2023-09-15', DATE '2023-09-14', 'MEM002', 'ITEM002'),
('FINE003', 15.00, 'Late return', 'Paid', DATE '2023-08-20', DATE '2023-09-05', DATE '2023-09-04', 'MEM003', 'ITEM003'),
('FINE010', 100.00, 'Lost item', 'Unpaid', DATE '2023-09-01', DATE '2023-09-15', NULL, 'MEM010', 'ITEM010');


-------- Populate Requests (created_at) 
INSERT INTO Requests (request_id, type, created_at, message, status, sender, receiver) VALUES
('REQ001', 'Book Reservation', 'Request to reserve "Business Dynamics" for upcoming coursework.', 'Pending', 'U001', 'L001'),
('REQ002', 'Renewal', 'Request to renew "Principles of Game Design" for another month.', 'Ongoing', 'U002', 'L001'),
('REQ003', 'Book Purchase', 'Suggest purchasing more resources on modern tourism management.', 'Resolved', 'U003', 'L002'),
('REQ004', 'Renewal', 'Need an extension on "Effective Communication".', 'Pending', 'U004', 'L003'),
('REQ005', 'Resource Inquiry', 'Is "Aviation Studies" available for borrowing this week?', 'Resolved', 'U005', 'L002'),
('REQ006', 'Technical Support', 'Need help accessing online journals on robotics fundamentals.', 'Ongoing', 'U006', 'L001'),
('REQ007', 'Late Return', 'Requesting forgiveness for late return due to personal reasons.', 'Pending', 'U007', 'L003'),
('REQ008', 'Reservation', 'Reserve the meeting room for study group discussion next Wednesday.', 'Pending', 'U008', 'L002'),
('REQ009', 'Book Suggestion', 'Can the library consider acquiring books on digital marketing insights?', 'Resolved', 'U009', 'L001'),
('REQ010', 'Renewal', 'Request to renew "Foundations of Design" for another term.', 'Ongoing', 'U010', 'L003'),
('REQ011', 'Book Reservation', 'Request to reserve "Psychological Perspectives" for class.', 'Pending', 'U001', 'L002'),
('REQ012', 'Resource Inquiry', 'Is there a newer edition of "Software Engineering Today" available?', 'Pending', 'U002', 'L001'),
('REQ013', 'Help Request', 'Need guidance on using the librarys database to find specific research papers.', 'Resolved', 'U003', 'L003'),
('REQ014', 'Renewal', 'I would like to renew "Advanced Business Strategies".', 'Ongoing', 'U004', 'L002'),
('REQ015', 'Technical Support', 'Having trouble logging into the digital library.', 'Pending', 'U005', 'L001'),
('REQ016', 'Room Booking', 'Would like to book a study room for final year project work.', 'Resolved', 'U006', 'L003'),
('REQ017', 'Book Reservation', 'Request to reserve "Information Security" for next semester.', 'Pending', 'U007', 'L002'),
('REQ018', 'Renewal', 'Requesting extension for "Circuit Design" due to project delay.', 'Ongoing', 'U008', 'L001'),
('REQ019', 'Resource Inquiry', 'Are there any additional materials on social media marketing?', 'Pending', 'U009', 'L003'),
('REQ020', 'Renewal', 'Need to extend "Therapeutic Diets" borrowing period for ongoing research.', 'Resolved', 'U010', 'L002');


-- Populate Member_Course
INSERT INTO Member_Course (member_id, course_code) VALUES
('U001', 'MKTG1205'),
('U001', 'MKTG1419'),
('U002', 'MKTG1420'),
('U002', 'MKTG1422'),
('U003', 'OMGT2085'),
('U003', 'OMGT2197'),
('U004', 'ISYS2109'),
('U004', 'MKTG1421'),
('U005', 'COSC2429'),
('U005', 'COSC2430'),
('U006', 'COSC2440'),
('U006', 'COSC2652'),
('U007', 'ISYS3414'),
('U007', 'COMM2596'),
('U008', 'COMM2752'),
('U008', 'COSC2532'),
('U009', 'VART3626'),
('U009', 'VART3670'),
('U010', 'ECON1318'),
('U010', 'ACCT2105'),
('U001', 'ACCT2158'),
('U002', 'ACCT2160'),
('U003', 'BAFI3182'),
('U004', 'BAFI3184'),
('U005', 'ECON1192'),
('U006', 'ECON1193'),
('U007', 'ECON1194'),
('U008', 'LAW2447'),
('U009', 'ACCT2197'),
('U010', 'EEET2482'),
('U001', 'EEET2599'),
('U002', 'EEET2600'),
('U003', 'EEET2601'),
('U004', 'EEET2603'),
('U005', 'MATH2394'),
('U006', 'OENG1181'),
('U007', 'BAFI3239'),
('U008', 'BUSM1784'),
('U009', 'MANU2492'),
('U010', 'MKTG1447');


-- Populate Member_Ebooks
INSERT INTO Member_Ebooks (member_id, ebook_id) VALUES
('U001', 'B001'),
('U001', 'B019'),
('U002', 'B002'),
('U002', 'B020'),
('U003', 'B003'),
('U003', 'B021'),
('U004', 'B004'),
('U004', 'B013'),
('U005', 'B005'),
('U005', 'B025'),
('U006', 'B006'),
('U006', 'B022'),
('U007', 'B007'),
('U007', 'B017'),
('U008', 'B008'),
('U008', 'B024'),
('U009', 'B009'),
('U009', 'B029'),
('U010', 'B010'),
('U010', 'B026'),
('U001', 'B014'),
('U002', 'B015'),
('U003', 'B016'),
('U004', 'B018'),
('U005', 'B027'),
('U006', 'B012'),
('U007', 'B011'),
('U008', 'B023'),
('U009', 'B030'),
('U010', 'B028'),
('U001', 'B017'),
('U002', 'B024'),
('U003', 'B005'),
('U004', 'B022'),
('U005', 'B021'),
('U006', 'B020'),
('U007', 'B018'),
('U008', 'B009'),
('U009', 'B004'),
('U010', 'B003');


-- Populate Member_Room
INSERT INTO Member_Room (booking_id, member_id, room_id, reservation_date, start_date, end_date) VALUES
('BKG001', 'U001', 'R001', DATE '2023-10-01', TIMESTAMP '2023-10-01 09:00:00', TIMESTAMP '2023-10-01 11:00:00'),
('BKG002', 'U001', 'R005', DATE '2023-10-02', TIMESTAMP '2023-10-02 10:00:00', TIMESTAMP '2023-10-02 12:00:00'),
('BKG003', 'U002', 'R002', DATE '2023-10-01', TIMESTAMP '2023-10-01 08:00:00', TIMESTAMP '2023-10-01 10:00:00'),
('BKG004', 'U002', 'R004', DATE '2023-10-03', TIMESTAMP '2023-10-03 14:00:00', TIMESTAMP '2023-10-03 16:00:00'),
('BKG005', 'U003', 'R005', DATE '2023-10-04', TIMESTAMP '2023-10-04 13:00:00', TIMESTAMP '2023-10-04 15:00:00'),
('BKG006', 'U003', 'R008', DATE '2023-10-05', TIMESTAMP '2023-10-05 09:00:00', TIMESTAMP '2023-10-05 11:00:00'),
('BKG007', 'U004', 'R005', DATE '2023-10-06', TIMESTAMP '2023-10-06 10:00:00', TIMESTAMP '2023-10-06 12:00:00'),
('BKG008', 'U004', 'R010', DATE '2023-10-07', TIMESTAMP '2023-10-07 13:00:00', TIMESTAMP '2023-10-07 15:00:00'),
('BKG009', 'U005', 'R009', DATE '2023-10-08', TIMESTAMP '2023-10-08 09:00:00', TIMESTAMP '2023-10-08 11:00:00'),
('BKG010', 'U005', 'R010', DATE '2023-10-09', TIMESTAMP '2023-10-09 12:00:00', TIMESTAMP '2023-10-09 14:00:00'),
('BKG011', 'U006', 'R001', DATE '2023-10-10', TIMESTAMP '2023-10-10 09:00:00', TIMESTAMP '2023-10-10 11:00:00'),
('BKG012', 'U007', 'R004', DATE '2023-10-11', TIMESTAMP '2023-10-11 14:00:00', TIMESTAMP '2023-10-11 16:00:00'),
('BKG013', 'U007', 'R008', DATE '2023-10-12', TIMESTAMP '2023-10-12 10:00:00', TIMESTAMP '2023-10-12 12:00:00'),
('BKG014', 'U008', 'R002', DATE '2023-10-13', TIMESTAMP '2023-10-13 09:00:00', TIMESTAMP '2023-10-13 11:00:00'),
('BKG015', 'U008', 'R005', DATE '2023-10-14', TIMESTAMP '2023-10-14 12:00:00', TIMESTAMP '2023-10-14 14:00:00'),
('BKG016', 'U009', 'R006', DATE '2023-10-15', TIMESTAMP '2023-10-15 15:00:00', TIMESTAMP '2023-10-15 17:00:00'),
('BKG017', 'U010', 'R009', DATE '2023-10-16', TIMESTAMP '2023-10-16 09:00:00', TIMESTAMP '2023-10-16 11:00:00'),
('BKG018', 'U010', 'R010', DATE '2023-10-17', TIMESTAMP '2023-10-17 10:00:00', TIMESTAMP '2023-10-17 12:00:00'),
('BKG019', 'U006', 'R009', DATE '2023-10-18', TIMESTAMP '2023-10-18 14:00:00', TIMESTAMP '2023-10-18 16:00:00'),
('BKG020', 'U009', 'R010', DATE '2023-10-19', TIMESTAMP '2023-10-19 10:00:00', TIMESTAMP '2023-10-19 12:00:00');


-- Populate Member_HardCopy table 
INSERT INTO Member_HardCopy (borrow_id, member, book, bcopy, issue_date, return_date, due_date, checkin_condition, checkout_condition, borrower) VALUES
('BRW001', 'U001', 'B001', 'B001C1', DATE '2023-10-01', DATE '2023-10-15', DATE '2023-10-08', 'New', 'New', 'U001'),
('BRW002', 'U001', 'B005', 'B005C1', DATE '2023-10-02', DATE '2023-10-16', DATE '2023-10-09', 'New', 'New', 'U001'),
('BRW003', 'U002', 'B002', 'B002C1', DATE '2023-10-03', DATE '2023-10-17', DATE '2023-10-10', 'Damaged', 'Damaged', 'U002'),
('BRW004', 'U002', 'B003', 'B003C1', DATE '2023-10-04', DATE '2023-10-18', DATE '2023-10-11', 'Damaged', 'Damaged', 'U002'),
('BRW005', 'U003', 'B004', 'B004C1', DATE '2023-10-05', DATE '2023-10-19', DATE '2023-10-12', 'New', 'Damaged', 'U003'),
('BRW006', 'U003', 'B001', 'B001C2', DATE '2023-10-06', DATE '2023-10-20', DATE '2023-10-13', 'Damaged', 'Damaged', 'U003'),
('BRW007', 'U004', 'B002', 'B002C2', DATE '2023-10-07', DATE '2023-10-21', DATE '2023-10-14', 'New', 'New', 'U004'),
('BRW008', 'U004', 'B005', 'B005C2', DATE '2023-10-08', DATE '2023-10-22', DATE '2023-10-15', 'New', 'Damaged', 'U004'),
('BRW009', 'U005', 'B003', 'B003C2', DATE '2023-10-09', DATE '2023-10-23', DATE '2023-10-16', 'New', 'New', 'U005'),
('BRW010', 'U005', 'B004', 'B004C2', DATE '2023-10-10', DATE '2023-10-24', DATE '2023-10-17', 'Damaged', 'Damaged', 'U005'),
('BRW011', 'U006', 'B001', 'B001C3', DATE '2023-10-11', DATE '2023-10-25', DATE '2023-10-18', 'New', 'New', 'U006'),
('BRW012', 'U006', 'B002', 'B002C3', DATE '2023-10-12', DATE '2023-10-26', DATE '2023-10-19', 'New', 'New', 'U006'),
('BRW013', 'U007', 'B003', 'B003C3', DATE '2023-10-13', DATE '2023-10-27', DATE '2023-10-20', 'New', 'Damaged', 'U007'),
('BRW014', 'U007', 'B004', 'B004C3', DATE '2023-10-14', DATE '2023-10-28', DATE '2023-10-21', 'Damaged', 'Damaged', 'U007'),
('BRW015', 'U008', 'B005', 'B005C3', DATE '2023-10-15', DATE '2023-10-29', DATE '2023-10-22', 'New', 'New', 'U008'),
('BRW016', 'U008', 'B001', 'B001C4', DATE '2023-10-16', DATE '2023-10-30', DATE '2023-10-23', 'New', 'New', 'U008'),
('BRW017', 'U009', 'B002', 'B002C1', DATE '2023-10-17', DATE '2023-10-31', DATE '2023-10-24', 'Damaged', 'Damaged', 'U009'),
('BRW018', 'U009', 'B003', 'B003C4', DATE '2023-10-18', DATE '2023-11-01', DATE '2023-10-25', 'New', 'New', 'U009'),
('BRW019', 'U010', 'B004', 'B004C1', DATE '2023-10-19', DATE '2023-11-02', DATE '2023-10-26', 'Damaged', 'Damaged', 'U010'),
('BRW020', 'U010', 'B005', 'B005C4', DATE '2023-10-20', DATE '2023-11-03', DATE '2023-10-27', 'New', 'New', 'U010');

-- Populate Book_Author
INSERT INTO Book_Author (book_id, author_id) VALUES
('B001', 'AUTH001'), ('B002', 'AUTH002'), ('B003', 'AUTH003'), ('B004', 'AUTH004'),
('B005', 'AUTH005'), ('B006', 'AUTH006'), ('B007', 'AUTH007'), ('B008', 'AUTH008'),
('B009', 'AUTH009'), ('B010', 'AUTH010'), ('B011', 'AUTH011'), ('B012', 'AUTH012'),
('B013', 'AUTH013'), ('B014', 'AUTH014'), ('B015', 'AUTH015'), ('B016', 'AUTH016'),
('B017', 'AUTH017'), ('B018', 'AUTH018'), ('B019', 'AUTH019'), ('B020', 'AUTH020');


-- Populate Book_Course
INSERT INTO Book_Course (book_id, course_id) VALUES
('B001', 'BUSM4185'), ('B002', 'COSC2429'), ('B003', 'OMGT2085'), ('B004', 'COMM2596'),
('B005', 'BP070'), ('B006', 'COSC2440'), ('B007', 'ACCT2105'), ('B008', 'COMM2752'),
('B009', 'VART3626'), ('B010', 'MKTG1447'), ('B011', 'ISYS2109'), ('B012', 'EEET2600'),
('B013', 'MKTG1420'), ('B014', 'COSC2532'), ('B015', 'LANG1318'), ('B016', 'PSYC101'),
('B017', 'EEET2482'), ('B018', 'FOHO1024'), ('B019', 'MKTG1205'), ('B020', 'COSC2430');


-- Populate Book_Category
INSERT INTO Book_Category (book_id, category_id) VALUES
('B001', 'CAT016'), ('B002', 'CAT006'), ('B003', 'CAT007'), ('B004', 'CAT013'),
('B005', 'CAT005'), ('B006', 'CAT006'), ('B007', 'CAT016'), ('B008', 'CAT014'),
('B009', 'CAT014'), ('B010', 'CAT014'), ('B011', 'CAT006'), ('B012', 'CAT005'),
('B013', 'CAT016'), ('B014', 'CAT014'), ('B015', 'CAT013'), ('B016', 'CAT008'),
('B017', 'CAT005'), ('B018', 'CAT018'), ('B019', 'CAT016'), ('B020', 'CAT006');


-- Populate Book_Category
INSERT INTO Book_Major (book_id, major_id) VALUES
('B001', 'BP343'), ('B002', 'BP214'), ('B003', 'BP312'), ('B004', 'BP222'),
('B005', 'BP070'), ('B006', 'BH123'), ('B007', 'BP351'), ('B008', 'BP309'),
('B009', 'BP325'), ('B010', 'BP327'), ('B011', 'BP162'), ('B012', 'BH073'),
('B013', 'BP318'), ('B014', 'BP316'), ('B015', 'BP317'), ('B016', 'BP154'),
('B017', 'BH120'), ('B018', 'BP199'), ('B019', 'BP343'), ('B020', 'BP214');






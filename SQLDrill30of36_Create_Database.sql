USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE Name = 'LibraryManagementSystem')
	ALTER DATABASE LibraryManagementSystem SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	GO
	DROP DATABASE LibraryManagementSystem
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE Name = 'LibraryManagementSystem')
	CREATE DATABASE LibraryManagementSystem
GO

USE LibraryManagementSystem
GO

CREATE TABLE BOOK
(
	[BookID] INT NOT NULL,
	[Title] NVARCHAR(255),
	[PublisherName] NVARCHAR(255)

	CONSTRAINT PK_BOOK PRIMARY KEY CLUSTERED ([BookID])
)

CREATE TABLE BOOK_AUTHORS
(
	[BookID] INT NOT NULL,
	[AuthorName] NVARCHAR(255)

	CONSTRAINT PK_BOOK_AUTHORS PRIMARY KEY CLUSTERED ([BookID], [AuthorName])
	CONSTRAINT FK_BOOK_AUTHORS_BOOK FOREIGN KEY ([BookID]) REFERENCES BOOK ([BookID])
)

CREATE TABLE PUBLISHER
(
	[Name] NVARCHAR(255),
	[Address] NVARCHAR(255),
	[Phone] NVARCHAR(255)

	CONSTRAINT PK_PUBLISHER PRIMARY KEY CLUSTERED ([Name])
)

ALTER TABLE BOOK
	ADD CONSTRAINT FK_BOOK_PUBLISHER
	FOREIGN KEY ([PublisherName])
	REFERENCES PUBLISHER ([Name])

CREATE TABLE BOOK_COPIES
(
	[BookID] INT NOT NULL,
	[BranchID] INT NOT NULL,
	[No_Of_Copies] INT NOT NULL
	
	CONSTRAINT PK_BOOK_COPIES PRIMARY KEY CLUSTERED ([BookID], [BranchID])
	CONSTRAINT FK_BOOK_COPIES_BOOK FOREIGN KEY ([BookID]) REFERENCES BOOK ([BookID])
)

CREATE TABLE LIBRARY_BRANCH
(
	[BranchID] INT NOT NULL,
	[BranchName] NVARCHAR(255),
	[Address] NVARCHAR(255)

	CONSTRAINT PK_LIBRARY_BRACH PRIMARY KEY CLUSTERED ([BranchID])
)

ALTER TABLE BOOK_COPIES
	ADD CONSTRAINT FK_BOOK_COPIES_LIBRARY_BRANCH
	FOREIGN KEY ([BranchID])
	REFERENCES LIBRARY_BRANCH ([BranchID])

CREATE TABLE BORROWER
(
	[CardNo] INT NOT NULL,
	[Name] NVARCHAR(255),
	[Address] NVARCHAR(255),
	[Phone] NVARCHAR(22)

	CONSTRAINT PK_BORROWER PRIMARY KEY CLUSTERED ([CardNo])
)

CREATE TABLE BOOK_LOANS
(
	[BookID] INT NOT NULL,
	[BranchID] INT NOT NULL,
	[CardNo] INT NOT NULL,
	[DateOut] DATE NOT NULL DEFAULT GETDATE(),
	[DueDate] DATE NOT NULL DEFAULT DATEADD(day, 10, GETDATE()),

	CONSTRAINT PK_BOOK_LOANS PRIMARY KEY CLUSTERED ([BookID], [BranchID], [CardNo]),
	CONSTRAINT FK_BOOK_LOANS_LIBRARY_BRANCH FOREIGN KEY ([BranchID]) REFERENCES LIBRARY_BRANCH ([BranchID]),
	CONSTRAINT FK_BOOK_LOANS_BORROWER FOREIGN KEY ([CardNo]) REFERENCES BORROWER ([CardNo]),
	CONSTRAINT FK_BOOK_LOANS_BOOK FOREIGN KEY ([BookID]) REFERENCES BOOK ([BookID])
)

INSERT INTO PUBLISHER ([Name], [Address], [Phone])
VALUES ('CreateSpace Independent Publishing Platform', '4900 LaCross Road, North Charleston, SC 29406', '843-789-5000')
	,('Mike Murach & Associates', '4340 N Knoll Ave, Fresno, CA 93722', '559-440-9071')
	,('Microsoft Press', 'One Microsoft Way, Redmond, WA 98052', '800-716-5818')
	,('Wrox', '111 River Street, Hoboken, NJ 07030-5774', '201-748-6000')
	,('McGraw-Hill Education', 'P.O. Box 182605, Columbus, OH 43218', '800-338-3987')
	,('Sams Publishing', '9850 East 30th Street, Indianapolis, IN 46229', '800-428-7267')
	,('Manning Publications', '1233 Heartwood Drive, Cherry Hill, NJ  08003', '203-626-1510')
	,('Wiley', '10475 Crosspoint Blvd., Indianapolis, IN 46256', '877-762-2974')
	,('O''Reilly Media', '2 Ave de Lafayette, Boston, MA 02111', '617-354-5800')
	,('No Starch Press', '245 8th St., San Francisco, CA 94103', '800-420-7240')
	,('Packt Publishing', '2nd Floor Livery Place, 35 Livery Street, Colmore Business District, Birmingham B3 2PB, United Kingdom', '+44 (0) 121-265-6484')
	,('Simon & Schuster, Inc.', '1230 Avenue of the Americas, 17th Floor, New York NY 100208510', '212-698-7094');

INSERT INTO BOOK ([BookID], [Title],[PublisherName])
VALUES (1, 'The Lost Tribe', 'CreateSpace Independent Publishing Platform')
	,(2, 'Murach''s SQL Server 2012 for Developers (Training & Reference) 1st Edition', 'Mike Murach & Associates')
	,(3, 'SQL: The Ultimate Beginner’s Guide!', 'CreateSpace Independent Publishing Platform')
	,(4, 'Introducing Microsoft SQL Server 2016: Mission-Critical Applications, Deeper Insights, Hyperscale Cloud, Preview 2', 'Microsoft Press')
	,(5, 'Microsoft SQL Server 2012 T-SQL Fundamentals (Developer Reference) 1st Edition', 'Microsoft Press')
	,(6, 'T-SQL Fundamentals (3rd Edition) 3rd Edition', 'Microsoft Press')
	,(7, 'Professional Microsoft SQL Server 2014 Administration 1st Edition', 'Wrox')
	,(8, 'Microsoft SQL Server 2014 Query Tuning & Optimization 1st Edition', 'McGraw-Hill Education')
	,(9, 'Microsoft SQL Server 2014 Unleashed 1st Edition', 'Sams Publishing')
	,(10, 'C# in Depth, 3rd Edition 3rd Edition', 'Manning Publications')
	,(11, 'JavaScript and JQuery: Interactive Front-End Web Development 1st Edition', 'Wiley')
	,(12, 'JavaScript: The Definitive Guide: Activate Your Web Pages (Definitive Guides)', 'O''Reilly Media')
	,(13, 'Web Design with HTML, CSS, JavaScript and jQuery Set 1st Edition', 'Wiley')
	,(14, 'Secrets of the JavaScript Ninja 2nd Edition', 'Manning Publications')
	,(15, 'The Principles of Object-Oriented JavaScript 1st Edition', 'No Starch Press')
	,(16, 'Javascript: Beginners Guide on Javascript Programming', 'CreateSpace Independent Publishing Platform')
	,(17, 'Thinking in JavaScript', 'Packt Publishing')
	,(18, 'You Don''t Know JS: Up & Going 1st Edition', 'O''Reilly Media')
	,(19, 'Node.JS Web Development - Third Edition', 'Packt Publishing')
	,(20, 'Node.js Design Patterns', 'Packt Publishing')
	,(21, '11/22/63: A Novel', 'Simon & Schuster, Inc.');

INSERT INTO dbo.BOOK_AUTHORS ( BookID, AuthorName )
VALUES  ( 1, 'Matthew Caldwell')
	,(2, 'Bryan Syverson')
	,(2, 'Joel Murach')
	,(3, 'Andrew Johansen')
	,(4, 'Stacia Varga')
	,(4, 'Denny Cherry')
	,(4, 'Joseph D''Antoni')
	,(5, 'Itzik Ben-Gan')
	,(6, 'Itzik Ben-Gan')
	,(7, 'Adam Jorgensen')
	,(7, 'Bradley Ball')
	,(7, 'Steven Wort')
	,(7, 'Ross LoForte')
	,(7, 'Brian Knight')
	,(8, 'Benjamin Nevarez')
	,(9, 'Ray Rankins')
	,(9, 'Paul Bertucci')
	,(9, 'Chris Gallelli')
	,(9, 'Alex T. Silverstein')
	,(10, 'Jon Skeet')
	,(11, 'Jon Duckett')
	,(12, 'David Flanagan')
	,(13, 'Jon Duckett')
	,(14, 'John Resig')
	,(14, 'Bear Bibeault')
	,(14, 'Josip Maras')
	,(15, 'Nicholas C. Zakas')
	,(16, 'Nick Goddard')
	,(17, 'Aravind Shenoy')
	,(18, 'Kyle Simpson')
	,(19, 'David Herron')
	,(20, 'Mario Casciaro')
	,(21, 'Stephen King');

INSERT INTO dbo.LIBRARY_BRANCH ( BranchID, BranchName, Address )
VALUES  (1, 'Sharpstown', '7660 Clarewood, Houston, Texas 77036')
	,(2, 'Central', '500 McKinney St., Houston, Texas 77002')
	,(3, 'Carnegie', '1050 Quitman, Houston, Texas 77009')
	,(4, 'Clayton', '5300 Caroline, Houston, Texas 77004');

INSERT INTO dbo.BOOK_COPIES ( BookID, BranchID, No_Of_Copies )
VALUES 
	(1, 1, 3), (2, 1, 4), (3, 1, 2), (4, 1, 5), (5, 1, 2), (6, 1, 3), (7, 1, 2), (8, 1, 3), (9, 1, 2), (10, 1, 7), (11, 1, 2), (12, 1, 3), (13, 1, 2), (14, 1, 3), (15, 1, 4), (16, 1, 2), (17, 1, 2), (18, 1, 3), (19, 1, 3), (20, 1, 3), (21, 1, 5),
	(1, 2, 2), (2, 2, 2), (3, 2, 3), (4, 2, 4), (5, 2, 4), (6, 2, 4), (7, 2, 2), (8, 2, 2), (9, 2, 3), (10, 2, 8), (11, 2, 2), (12, 2, 3), (13, 2, 3), (14, 2, 3), (15, 2, 4), (16, 2, 5), (17, 2, 3), (18, 2, 2), (19, 2, 3), (20, 2, 2), (21, 2, 3),
	(1, 3, 4), (2, 3, 3), (3, 3, 5), (4, 3, 3), (5, 3, 3), (6, 3, 2), (7, 3, 3), (8, 3, 2), (9, 3, 2), (10, 3, 4), (11, 3, 2), (12, 3, 3), (13, 3, 4), (14, 3, 3), (15, 3, 4), (16, 3, 3), (17, 3, 3), (18, 3, 4), (19, 3, 2), (20, 3, 4), (21, 3, 4),
	(1, 4, 3), (2, 4, 2), (3, 4, 2), (4, 4, 2), (5, 4, 4), (6, 4, 2), (7, 4, 3), (8, 4, 2), (9, 4, 3), (10, 4, 3), (11, 4, 2), (12, 4, 3), (13, 4, 3), (14, 4, 3), (15, 4, 4), (16, 4, 4), (17, 4, 2), (18, 4, 5), (19, 4, 4), (20, 4, 4), (21, 4, 6);

INSERT INTO dbo.BORROWER ( CardNo, Name, Address, Phone )
VALUES  (1, 'Erik Gross', '123 Smart Way Ave., Portland, Oregon, 97204', '503-123-4567')
	,(2, 'Jack Stanley', '124 Smart Way Ave., Portland, Oregon, 97204', '503-124-4678')
	,(3, 'Brett Caudle', '125 Smart Way Ave., Portland, Oregon, 97204', '503-125-4679')
	,(4, 'Emily Hayes', '126 Smart Way Ave., Portland, Oregon, 97204', '503-126-4680')
	,(5, 'Kendra Iraheta', '127 Smart Way Ave., Portland, Oregon, 97204', '503-127-4681')
	,(6, 'Nancy Ku', '128 Smart Way Ave., Portland, Oregon, 97204', '503-128-4682')
	,(7, 'Danny Condon', '129 Smart Way Ave., Portland, Oregon, 97204', '503-128-4683')
	,(8, 'Michael Allen', '130 Smart Way Ave., Portland, Oregon, 97204', '503-129-4684');

INSERT INTO dbo.BOOK_LOANS ( BookID , BranchID , CardNo)
VALUES  
	(1, 1, 1), (2, 1, 1), (3, 1, 1), (4, 1, 1), (5, 1, 1), (6, 1, 1), (7, 1, 1), (8, 1, 1), (9, 1, 1), (10, 1, 1),
	(11, 1, 2), (12, 1, 2), (13, 1, 2), (14, 1, 2), (15, 1, 2), (16, 1, 2), (17, 1, 2), (18, 1, 2), (19, 1, 2), (20, 1, 2),
	(1, 2, 3), (2, 2, 3), (3, 2, 3), (4, 2, 3), (5, 2, 3), (6, 2, 3), (7, 2, 3), (8, 2, 3), (9, 2, 3), (10, 2, 3),
	(11, 2,  4), (12, 2,  4), (13, 2,  4), (14, 2,  4), (15, 2,  4), (16, 2,  4), (17, 2,  4), (18, 2,  4), (19, 2,  4), (20, 2,  4),
	(1, 3, 5), (2, 3, 5), (3, 3, 5), (4, 3, 5), (5, 3, 5), (6, 3, 5), (7, 3, 5), (8, 3, 5), (9, 3, 5), (10, 3, 5);

UPDATE dbo.BOOK_LOANS
SET DueDate = GETDATE()
WHERE BookID = 1 AND BranchID = 1 AND CardNo = 1;

USE [LibraryManagementSystem]
GO

/*
This creates the procedure which is called uspChooseQuery that allows the user to choose the query they would like to run via the
@Choose_Query parameter. The user will set the @Choose_Query parameter to a integer between 1 and 7 to select the query that would
like to run. The default integer for @Choose_Query is set to 1.
*/

IF OBJECT_ID('uspChooseQuery') IS NOT NULL
	DROP PROCEDURE uspChooseQuery
GO

CREATE PROCEDURE uspChooseQuery (@Choose_Query INT = 1)
AS

IF (@Choose_Query = 1)
/*1. How many copies of the book titled The Lost Tribe are owned by the library branch whose name
is"Sharpstown"?*/
SELECT LB.BranchName, B.Title, BC.No_Of_Copies
FROM dbo.BOOK_COPIES AS BC JOIN dbo.LIBRARY_BRANCH AS LB
ON BC.BranchID = LB.BranchID
JOIN dbo.BOOK AS B
ON BC.BookID = B.BookID
WHERE B.Title = 'The Lost Tribe' AND LB.BranchName = 'Sharpstown';

ELSE IF (@Choose_Query = 2)
/*2. How many copies of the book titled The Lost Tribe are owned by each library branch?*/
SELECT B.Title, LB.BranchName, BC.No_Of_Copies
FROM dbo.BOOK AS B JOIN dbo.BOOK_COPIES AS BC
ON B.BookID = BC.BookID
JOIN dbo.LIBRARY_BRANCH AS LB
ON BC.BranchID = LB.BranchID
WHERE B.Title = 'The Lost Tribe';

ELSE IF (@Choose_Query = 3)
/*3. Retrieve the names of all borrowers who do not have any books checked out.*/
SELECT BO.Name, COUNT(BL.CardNo) AS 'Number of Books Checked Out'
FROM dbo.BOOK_LOANS AS BL RIGHT JOIN dbo.BORROWER AS BO
ON BL.CardNo = BO.CardNo
WHERE BL.BookID IS NULL
GROUP BY BO.Name;

ELSE IF (@Choose_Query = 4)
/*4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today,
retrieve the book title, the borrower's name, and the borrower's address.*/
SELECT B.Title, BO.Name, BO.Address
FROM dbo.BOOK_LOANS AS BL JOIN dbo.BORROWER AS BO
ON BL.CardNo = BO.CardNo
JOIN dbo.BOOK AS B
ON BL.BookID = B.BookID
JOIN dbo.LIBRARY_BRANCH AS LB
ON BL.BranchID = LB.BranchID
WHERE BL.DueDate = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) AND LB.BranchName = 'Sharpstown';

ELSE IF (@Choose_Query = 5)
/*5. For each library branch, retrieve the branch name and the total number of books loaned out from
that branch.*/
SELECT LB.BranchName AS 'Branch Name', COUNT(BL.BranchID) AS 'Number of Books Loaned Out'
FROM dbo.BOOK_LOANS AS BL RIGHT JOIN dbo.LIBRARY_BRANCH AS LB
ON BL.BranchID = LB.BranchID
GROUP BY LB.BranchName, LB.BranchID
ORDER BY LB.BranchID;

ELSE IF (@Choose_Query = 6)
/*6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more
than five books checked out.*/
SELECT BO.Name, BO.Address, COUNT(BL.CardNo) AS 'Books Checked Out'
FROM dbo.BOOK_LOANS AS BL JOIN dbo.BORROWER AS BO
ON BL.CardNo = BO.CardNo
GROUP BY BO.Name, BO.Address, BO.CardNo
HAVING COUNT(BL.CardNo) > 5
ORDER BY BO.CardNo;

ELSE IF (@Choose_Query = 7)
/*7. For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central"*/
SELECT B.Title AS 'Book Title', BA.AuthorName AS 'Book Author', LB.BranchName AS 'Library Branch Name', BC.No_Of_Copies AS 'Number of Copies Owned by Library Branch'
FROM BOOK AS B JOIN dbo.BOOK_COPIES AS BC
ON B.BookID = BC.BookID
JOIN dbo.LIBRARY_BRANCH AS LB
ON BC.BranchID = LB.BranchID
JOIN dbo.BOOK_AUTHORS AS BA
ON B.BookID = BA.BookID
WHERE BA.AuthorName = 'Stephen King' AND lb.BranchName = 'Central';

ELSE
PRINT 'You need to set @Choose_Query to an integer between 1 and 7 in order to choose one of the seven possible SELECT query
statements. If you select an integer outside of that range you will get this message. The default integer for @Choose_Query
is set to 1.'

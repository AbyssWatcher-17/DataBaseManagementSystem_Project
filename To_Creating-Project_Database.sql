 --Design 1-1(1-0) realtionship in sql server https://www.mssqltips.com/sqlservertip/2380/sql-server-database-design-with-a-one-to-one-relationship/ 
  CREATE TABLE [Supervisior] (
  [Supervisior_ID] int IDENTITY(1,1)  NOT NULL , --starts from 1,continue
  [Person_ID] int NOT NULL,  --/
  PRIMARY KEY ([Supervisior_ID],[Person_ID])
  --FOREIGN KEY ([Person_ID]) REFERENCES [Person]([Person_ID])--/
);

CREATE TABLE [Person] (
  [Person_ID] int IDENTITY(1001,1) NOT NULL, --starts from 1001,continue
  [Name] varchar(25) NOT NULL,
  [Surname] varchar(25) NOT NULL,
  [Supervisior_ID] int NULL DEFAULT NULL  ,  
  PRIMARY KEY ([Person_ID]), 
  FOREIGN KEY ([Supervisior_ID],[Person_ID]) REFERENCES [Supervisior]([Supervisior_ID],[Person_ID])
);

/*
DROP TABLE[Supervisior]
DROP TABLE [Person]
*/

ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Supervisior] FOREIGN KEY([Person_ID])
REFERENCES [dbo].[Supervisior] ([Person_ID])
GO

ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Supervisior]
GO





CREATE TABLE [Subject Topics] (
  [SubjectName] varchar(35) -- UNIQUE --Can be Used UNIQUE
  PRIMARY KEY ([SubjectName])
);
/*
DROP TABLE [Subject Topics]
*/
CREATE TABLE [University] (
  [UniversityName] varchar(25) NOT NULL,
   PRIMARY KEY ([UniversityName])
 );

DROP TABLE [University]

CREATE TABLE [Institute] (
  [InstituteName] varchar(25) NOT NULL,
 [UniversityName] varchar(25) NOT NULL,
  PRIMARY KEY ([InstituteName],[UniversityName]), 
  FOREIGN KEY ([UniversityName]) REFERENCES [University]([UniversityName]),  
);
/*
DROP TABLE [Institute]
*/
CREATE TABLE [Thesis] (
  [Thesis_no] int IDENTITY(101,1) NOT NULL, --starts from 101,continue
  [Title] varchar(35) NOT NULL,
  [Abstract] nvarchar(20) NOT NULL,
  [Author] int NOT NULL ,--FOREIGN KEY REFERENCES [Person]([Person_ID]),
  [Year] int Check([Year]>=1960) NOT NULL,
  [Type] varchar(25) Check([Type]='Bachelor' or [Type]='Master' or [Type]='Doctorate') NOT NULL,
  [InstituteName] varchar(25) NOT NULL,
  [UniversityName] varchar(25) NOT NULL , 
  [Number_of_pages] int Check([Number_of_pages]>=5) NOT NULL, -- min 5
  [Language_of_the_thesis_text] varchar(12) 
  Check([Language_of_the_thesis_text]='English' 
         or [Language_of_the_thesis_text]='German' 
		 or [Language_of_the_thesis_text]='French' 
		 or [Language_of_the_thesis_text]='Turkish')
  NOT NULL,
  [Submission_date] DATE NOT NULL,
  [Supervisior_ID] int NOT NULL,
  [Supervisior_Person_ID] int NOT NULL,
  [Co_Supervisior_ID] int NULL DEFAULT NULL,
  [Co_Supervisior_Person_ID] int  NULL DEFAULT NULL,
  [SubjectName] varchar(35) NOT NULL,
  [Keyword] varchar(12)  NULL DEFAULT NULL,
  PRIMARY KEY ([Thesis_no]),
  FOREIGN KEY ([Author]) REFERENCES [Person]([Person_ID]),
  --FOREIGN KEY ([UniversityName]) REFERENCES [University]([UniversityName]),
  --FOREIGN KEY ([InstituteName]) REFERENCES [Institute]([InstituteName]),
  FOREIGN KEY ([Supervisior_ID],[Supervisior_Person_ID]) REFERENCES [Supervisior]([Supervisior_ID],[Person_ID]),
  FOREIGN KEY ([Co_Supervisior_ID],[CO_Supervisior_Person_ID]) REFERENCES [Supervisior]([Supervisior_ID],[Person_ID]),
  FOREIGN KEY ([SubjectName]) REFERENCES  [Subject Topics]([SubjectName]),
  );
  ALTER TABLE [dbo].[Thesis]  WITH CHECK ADD  CONSTRAINT [FK_Thesis_University] FOREIGN KEY([UniversityName])
REFERENCES [dbo].[University] ([UniversityName])
GO

ALTER TABLE [dbo].[Thesis] CHECK CONSTRAINT [FK_Thesis_University]
GO
/**/

 ALTER TABLE [dbo].[Thesis]  WITH CHECK ADD  CONSTRAINT [FK_Thesis_Institute] FOREIGN KEY([InstituteName],[UniversityName])
REFERENCES [dbo].[Institute] ([InstituteName],[UniversityName])
GO

ALTER TABLE [dbo].[Thesis] CHECK CONSTRAINT [FK_Thesis_Institute]
GO
/*
 DROP TABLE [Thesis]
*/
  /** INSERTING DATA **/

  INSERT INTO [Person]([Name],[Surname]) VALUES('Yavuz','Gökmen');--Not supervisior
  INSERT INTO [Person]([Name],[Surname]) VALUES('Mehmet','Ezine');--Not supervisior

  INSERT INTO [Person] ([Name],[Surname],[Supervisior_ID])VALUES('Yusuf','Akdeniz',1);--supervisior
  --DELETE [Person] Where Person_ID=1049
  INSERT INTO [Person] VALUES('Kaan','Bıçakçı',1);--supervisior
  INSERT INTO [Person] VALUES('Melis','Kaya',1);--supervisior
  INSERT INTO [Person] VALUES('Eylül','Atmaca',1);--supervisior


  INSERT INTO [University] VALUES('Maltepe University');
INSERT INTO [University] VALUES('Th Köln University');
INSERT INTO [University] VALUES('Marmara University');
INSERT INTO [University] VALUES('Okan University');
INSERT INTO [University] VALUES('Karabük University');



 INSERT INTO [Institute] VALUES('Medicine Faculty','Maltepe University')
INSERT INTO [Institute] VALUES('Medicine Faculty','Th Köln University')
INSERT INTO [Institute] VALUES('Medicine Faculty','Marmara University')
INSERT INTO [Institute] VALUES('Medicine Faculty','Okan University')
INSERT INTO [Institute] VALUES('Medicine Faculty','Karabük University')
 
 INSERT INTO [Institute] VALUES('Engineering Faculty','Maltepe University')
 INSERT INTO [Institute] VALUES('Engineering Faculty','Th Köln University')

 INSERT INTO [Institute] VALUES('Communication Faculty','Karabük University')

 INSERT INTO [Institute] VALUES('Business Faculty','Okan University')
 INSERT INTO [Institute] VALUES('Business Faculty','Marmara University')

 INSERT INTO [Institute] VALUES('Architecture Faculty','Maltepe University')
INSERT INTO [Institute] VALUES('Architecture Faculty','Th Köln University')
INSERT INTO [Institute] VALUES('Architecture Faculty','Marmara University')
INSERT INTO [Institute] VALUES('Architecture Faculty','Okan University')
INSERT INTO [Institute] VALUES('Architecture Faculty','Karabük University')
 

 INSERT INTO [Subject Topics] VALUES('Distributed Systems');
INSERT INTO [Subject Topics] VALUES('Data Analitics');
INSERT INTO [Subject Topics] VALUES('Machine&Deep Learning');
INSERT INTO [Subject Topics] VALUES('Web Programming');
INSERT INTO [Subject Topics] VALUES('Cyber Security');
INSERT INTO [Subject Topics] VALUES('Surgery');
INSERT INTO [Subject Topics] VALUES('Anaesthesia'); 
INSERT INTO [Subject Topics] VALUES('Finance'); 
INSERT INTO [Subject Topics] VALUES('Stock Market Exchange');  
INSERT INTO [Subject Topics] VALUES('Human psychology'); 
INSERT INTO [Subject Topics] VALUES('Superheroes for Cinema'); 
INSERT INTO [Subject Topics] VALUES('Hause Design'); 
SELECT * FROM [Subject Topics]



INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName],[Keyword])
VALUES('Image Processing','?',1001,2021
,'Bachelor','Engineering Faculty','Maltepe University',8,'English','2021-03-18',1,1004,2,1005,'Machine&Deep Learning','AI')--Image Processing with Tensorflow

INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName])
 VALUES('Göz Cerrahisi','?',1002,2020
,'Doctorate','Medicine Faculty','Maltepe University',15,'Turkish','2020-05-18',2,1005,'Surgery')

INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName])
VALUES('Anesthesia period','?',1004,2019
,'Master','Medicine Faculty','Marmara University',17,'English','2019-03-18',3,1006,'Anaesthesia')

--DELETE FROM [Thesis] WHERE Author=1004 AND Title='Anesthesia period'
/*
INSERT INTO [Thesis] VALUES('Recovery period','?',1004,2019
,'Master','Medicine Faculty','Marmara University',17,'English','2019-03-18',3,1009,NULL,NULL,'Recovery',NULL) --Gives Error.Conflict Supervisior_ID - Supervisior_Person_ID
*/

INSERT INTO [Thesis] ([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName],[Keyword])
VALUES('Spider man-Movies in Cinema','?',1007,2014
,'Bachelor','Communication Faculty','Karabük University',21,'English','2014-03-18',3,1006,'Superheroes for Cinema','Marvel')

INSERT INTO [Thesis] ([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[Co_Supervisior_ID],[Co_Supervisior_Person_ID],[SubjectName])
VALUES('Crypto Currency','?',1005,2013
,'Bachelor','Business Faculty','Okan University',9,'English','2013-03-18',1,1004,4,1007,'Finance')


SELECT * FROM [Thesis]
SELECT * FROM [Supervisior]
SELECT * FROM [Person] 
SELECT * FROM [Institute]
SELECT * FROM [University]
SELECT * FROM [Subject Topics]



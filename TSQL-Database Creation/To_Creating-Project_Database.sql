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

--DROP TABLE [University]

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




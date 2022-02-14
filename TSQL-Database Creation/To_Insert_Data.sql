/** INSERTING DATA **/

  INSERT INTO [Person]([Name],[Surname]) VALUES('Yavuz','Gökmen');--Not supervisior
  INSERT INTO [Person]([Name],[Surname]) VALUES('Mehmet','Ezine');--Not supervisior

  INSERT INTO [Person] ([Name],[Surname],[Supervisior_ID])VALUES('Yusuf','Akdeniz',1);--supervisior
  --DELETE [Person] Where Person_ID=1049
  INSERT INTO [Person] VALUES('Kaan','B?çakç?',1);--supervisior
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
--SELECT * FROM [Subject Topics]



INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[Co_Supervisior_ID],[Co_Supervisior_Person_ID],[SubjectName],[Keyword])
VALUES('Image Processing','?',1001,2021
,'Bachelor','Engineering Faculty','Maltepe University',8,'English','2021-03-18',1,1003,2,1004,'Machine&Deep Learning','AI')--Image Processing with Tensorflow

INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName])
 VALUES('Göz Cerrahisi','?',1002,2020
,'Doctorate','Medicine Faculty','Maltepe University',15,'Turkish','2020-05-18',2,1004,'Surgery')

INSERT INTO [Thesis]([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName])
VALUES('Anesthesia period','?',1004,2019
,'Master','Medicine Faculty','Marmara University',17,'English','2019-03-18',3,1005,'Anaesthesia')

--DELETE FROM [Thesis] WHERE Author=1004 AND Title='Anesthesia period'
/*
INSERT INTO [Thesis] VALUES('Recovery period','?',1004,2019
,'Master','Medicine Faculty','Marmara University',17,'English','2019-03-18',3,1009,NULL,NULL,'Recovery',NULL) --Gives Error.Conflict Supervisior_ID - Supervisior_Person_ID
*/

INSERT INTO [Thesis] ([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[SubjectName],[Keyword])
VALUES('Spider man-Movies in Cinema','?',1006,2014
,'Bachelor','Communication Faculty','Karabük University',21,'English','2014-03-18',3,1005,'Superheroes for Cinema','Marvel')

INSERT INTO [Thesis] ([Title],[Abstract],[Author],[Year],[Type],[InstituteName],[UniversityName],[Number_of_pages],
[Language_of_the_thesis_text],[Submission_date],[Supervisior_ID],[Supervisior_Person_ID],[Co_Supervisior_ID],[Co_Supervisior_Person_ID],[SubjectName])
VALUES('Crypto Currency','?',1005,2013
,'Bachelor','Business Faculty','Okan University',9,'English','2013-03-18',1,1004,4,1006,'Finance')


SELECT * FROM [Thesis]
SELECT * FROM [Supervisior]
SELECT * FROM [Person] 
SELECT * FROM [Institute]
SELECT * FROM [University]
SELECT * FROM [Subject Topics]

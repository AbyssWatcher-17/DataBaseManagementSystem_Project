CREATE TRIGGER [dbo].[T_Person_Supervisior_Deleter] ON [dbo].[Person]
INSTEAD OF DELETE
AS 
BEGIN
   DECLARE @person_id int
   DECLARE @name varchar(20)
   DECLARE @surname varchar(20)
   DECLARE @supervisior_id int 

   DECLARE @P_In_SupervisiorTable int
   SET @P_In_SupervisiorTable=4

   
   SELECT @person_id=Person_ID,@name = Name,@surname =Surname,@supervisior_id=Supervisior_ID FROM DELETED
   PRINT @person_id
   IF @supervisior_id  IS NOT NULL  
     BEGIN
--	 PRINT 'I m here7'
	 Delete FROM [Person] Where (@person_id=Person_ID)
--	 PRINT 'I m here8'
	 Delete FROM [Supervisior] Where (@supervisior_id=Supervisior_ID)
--	 PRINT 'I m here9'
	 END

  ELSE
     BEGIN
--	 PRINT 'I m here6'
    Delete FROM [Person] Where (@person_id=Person_ID)
     END
END
CREATE TRIGGER [dbo].[T_Person_Supervisior_Adder] ON [dbo].[Person]
INSTEAD OF INSERT
AS 
BEGIN
   DECLARE @person_id int
   DECLARE @name varchar(20)
   DECLARE @surname varchar(20)
   DECLARE @supervisior_id int 

   DECLARE @P_In_SupervisiorTable int
   SET @P_In_SupervisiorTable=4

   
   SELECT @name = Name,@surname =Surname,@supervisior_id=Supervisior_ID FROM INSERTED
  -- PRINT @person_id

   IF @supervisior_id  IS NOT NULL  
     BEGIN
	-- PRINT'I m here 1'
	 INSERT INTO [Person](Name,Surname,Supervisior_ID) VALUES (@name,@surname+CAST(@P_In_SupervisiorTable as char),null)
	-- PRINT 'I m here2'
	 Select @person_id =Person_ID From [Person] Where Name=@name and Surname=@surname+CAST(@P_In_SupervisiorTable as char)
  --   PRINT 'I m here3'
     INSERT INTO [Supervisior](Person_ID) VALUES(@person_id)
   --  PRINT 'I m here4'
	 Select @supervisior_id=Supervisior_ID FROM [Supervisior] where Person_ID=@person_id
	-- PRINT 'I m here5'
	 Update  [Person] SET Surname=@surname ,Supervisior_ID=@supervisior_id
	 Where Person_ID =@person_id
   --  PRINT 'I m here6'
	 END

  ELSE
     BEGIN
	-- PRINT 'I m here7'
    INSERT INTO [Person](Name,Surname,Supervisior_ID) VALUES (@name,@surname,null)
     END
END
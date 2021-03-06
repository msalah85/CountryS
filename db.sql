/****** Object:  View [dbo].[View_ClientStatements]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_ClientStatements]
AS
	SELECT        InvoiceID AS ID, AddDate AS Date, TotalAmount AS Amount, TotalAmount AS InAmount, 0 AS OutAmount, N'Invoice' AS Note, ClientID, DeclarationNo, ContainerNo, Profit
FROM            Invoices WITH (NOLOCK)
WHERE        (Deleted = 0) AND (TotalAmount > 0)
UNION ALL
SELECT        PaymentID, AddDate, - PaymentAmount AS Amount, 0 AS InAmount, PaymentAmount AS OutAmount, N'Payment' AS Note, ClientID, '' AS Expr1, '' AS Expr2, 0 AS Expr3
FROM            ClientPayments WITH (NOLOCK)
WHERE        (Deleted = 0) AND (PaymentAmount > 0)
GO
/****** Object:  View [dbo].[View_ClientStatementsFinal]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[View_ClientStatementsFinal]
AS
	WITH Stm
		AS
		(
		   SELECT ID, [Date], Amount, InAmount, OutAmount, Note, Amount AS Balance, ClientID
			   FROM View_ClientStatements
			   GROUP BY [Date], ID, Amount, InAmount, OutAmount, Note, ClientID		  
		), StmRanked AS
		(
		   SELECT ID, [Date], Amount, Note, InAmount, OutAmount, Balance, ClientID, ROW_NUMBER() OVER(ORDER BY [Date] ASC) RowNo
			FROM Stm
		) 
	SELECT ClientID, ID, Balance, InAmount, OutAmount, [Date], Note, c1.RowNo
	FROM StmRanked c1
GO
/****** Object:  View [dbo].[View_ClientPayments]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_ClientPayments]
AS
SELECT        dbo.ClientPayments.PaymentID, dbo.ClientPayments.ClientID, dbo.ClientPayments.AddDate, dbo.ClientPayments.PaymentAmount, dbo.Clients.ClientName, dbo.Banks.BankName, dbo.ClientPayments.BankID, 
                         dbo.ClientPayments.CheckNo
FROM            dbo.ClientPayments INNER JOIN
                         dbo.Clients ON dbo.ClientPayments.ClientID = dbo.Clients.ClientID LEFT OUTER JOIN
                         dbo.Banks ON dbo.ClientPayments.BankID = dbo.Banks.BankID
WHERE        (dbo.ClientPayments.Deleted = 0)
GO
/****** Object:  View [dbo].[View_ExpensesParentsVatMaps]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_ExpensesParentsVatMaps]
AS
SELECT        InvoiceDetails.InvoiceID, Expenses.ExpenseName AS VatName, InvoiceDetails.Amount AS VATAmount, InvoiceDetails_1.Amount AS ServiceChargeAmount, Expenses_1.ExpenseName AS ServiceChargeName, 
                         Settings.Val AS VatRate
FROM            InvoiceDetails INNER JOIN
                         ExpensesMap ON InvoiceDetails.ExpenseID = ExpensesMap.ExpenseID INNER JOIN
                         InvoiceDetails AS InvoiceDetails_1 ON InvoiceDetails.InvoiceID = InvoiceDetails_1.InvoiceID AND ExpensesMap.ParentExpenseID = InvoiceDetails_1.ExpenseID INNER JOIN
                         Expenses ON ExpensesMap.ExpenseID = Expenses.ExpenseID INNER JOIN
                         Expenses AS Expenses_1 ON InvoiceDetails_1.ExpenseID = Expenses_1.ExpenseID INNER JOIN
                         Settings ON ExpensesMap.SettingID = Settings.ID
GO
/****** Object:  View [dbo].[View_Invoices]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Invoices]
AS
SELECT        dbo.Invoices.InvoiceID, dbo.Invoices.AddDate, dbo.Clients.ClientName, SUM(dbo.InvoiceDetails.Amount) + SUM(dbo.InvoiceDetails.VAT) AS TotalAmount, SUM(dbo.InvoiceDetails.VAT) AS VATAmount, dbo.Invoices.ClientID, 
                         dbo.Invoices.ContainerNo, dbo.Invoices.DeclarationNo, dbo.Invoices.Notes, dbo.Invoices.BillOfEntryDate, dbo.Invoices.VatVerified, dbo.Invoices.TransporterID, dbo.Invoices.CraneDriverID, dbo.Clients.ClientTRN
FROM            dbo.Clients INNER JOIN
                         dbo.Invoices ON dbo.Clients.ClientID = dbo.Invoices.ClientID INNER JOIN
                         dbo.InvoiceDetails ON dbo.Invoices.InvoiceID = dbo.InvoiceDetails.InvoiceID
WHERE        (dbo.Invoices.Deleted = 0)
GROUP BY dbo.Invoices.InvoiceID, dbo.Invoices.AddDate, dbo.Clients.ClientName, dbo.Invoices.ClientID, dbo.Invoices.ContainerNo, dbo.Invoices.DeclarationNo, dbo.Invoices.Notes, dbo.Invoices.BillOfEntryDate, dbo.Invoices.VatVerified, 
                         dbo.Invoices.TransporterID, dbo.Invoices.CraneDriverID, dbo.Clients.ClientTRN
GO
/****** Object:  View [dbo].[View_Outgoings]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_Outgoings]
AS
SELECT        dbo.ExpenseTypes.ExpenseTypeName, dbo.Outgoings.OutgoingID, dbo.Outgoings.AddDate, dbo.Outgoings.ExpenseTypeID, dbo.Outgoings.Amount, dbo.Outgoings.RefID, dbo.Outgoings.Notes, dbo.Outgoings.VAT, 
                         dbo.Outgoings.TotalAmount
FROM            dbo.ExpenseTypes INNER JOIN
                         dbo.Outgoings ON dbo.ExpenseTypes.ExpenseTypeID = dbo.Outgoings.ExpenseTypeID
WHERE        (dbo.Outgoings.Deleted = 0)
GO
/****** Object:  View [dbo].[View_Transportation]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_Transportation]
AS
SELECT        dbo.Transportation.TransportID, dbo.Transportation.TransportDate, dbo.Transportation.ConsigneeID, dbo.Transportation.TransporterID, dbo.Transportation.ContainerNo, dbo.Transportation.TransportCharge, 
                         dbo.Transportation.CarageCharge, dbo.Transportation.TotalAmount, dbo.Transportation.Deleted, dbo.Users.UserFullName, dbo.Clients.ClientName, dbo.Transportation.Serial, dbo.Transportation.TypeID, 
                         dbo.UserTypes.TypeName
FROM            dbo.Transportation INNER JOIN
                         dbo.Users ON dbo.Transportation.TransporterID = dbo.Users.UserID INNER JOIN
                         dbo.Clients ON dbo.Transportation.ConsigneeID = dbo.Clients.ClientID INNER JOIN
                         dbo.UserTypes ON dbo.Transportation.TypeID = dbo.UserTypes.TypeID
WHERE        (dbo.Transportation.Deleted = 0)
GO
/****** Object:  View [dbo].[View_TransporterPayments]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_TransporterPayments]
AS
SELECT        dbo.TransporterPayments.PaymentID, dbo.TransporterPayments.TransporterID, dbo.TransporterPayments.AddDate, dbo.TransporterPayments.PaymentAmount, dbo.Users.UserFullName AS TransporterName, 
                         dbo.Banks.BankName, dbo.TransporterPayments.BankID, dbo.TransporterPayments.CheckNo, dbo.TransporterPayments.Serial, dbo.TransporterPayments.TypeID, dbo.UserTypes.TypeName
FROM            dbo.TransporterPayments INNER JOIN
                         dbo.Users ON dbo.TransporterPayments.TransporterID = dbo.Users.UserID INNER JOIN
                         dbo.UserTypes ON dbo.TransporterPayments.TypeID = dbo.UserTypes.TypeID LEFT OUTER JOIN
                         dbo.Banks ON dbo.TransporterPayments.BankID = dbo.Banks.BankID
WHERE        (dbo.TransporterPayments.Deleted = 0)
GO
/****** Object:  View [dbo].[View_VatInView]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[View_VatInView]
as
SELECT        dbo.Invoices.InvoiceID, dbo.Invoices.AddDate, SUM(dbo.InvoiceDetails.VAT) AS VATAmount, dbo.Clients.ClientName, dbo.Clients.ClientTRN
FROM            dbo.Invoices INNER JOIN
                         dbo.Clients ON dbo.Clients.ClientID = dbo.Invoices.ClientID INNER JOIN
                         dbo.InvoiceDetails ON dbo.InvoiceDetails.InvoiceID = dbo.Invoices.InvoiceID
						 where InvoiceDetails.VAT > 0
GROUP BY dbo.Invoices.InvoiceID, dbo.Clients.ClientName, dbo.Invoices.AddDate, dbo.Clients.ClientTRN
GO
/****** Object:  View [dbo].[View_VatOutView]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[View_VatOutView]
as
SELECT        OutgoingID, AddDate, VAT, Amount, TotalAmount
FROM            dbo.Outgoings
where VAT>0
GO
/****** Object:  StoredProcedure [dbo].[Balances_Select]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ==========================================================================================
-- Entity Name:	Balances_Select
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for selecting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Balances_Select]	
As
Begin	
	SELECT (SELECT SUM(TotalAmount) FROM View_Invoices) AS TotalInvoices,
			ISNULL((SELECT SUM(PaymentAmount) FROM ClientPayments WITH(NOLOCK) Where Deleted=0), 0) AS TotalPayments,
			(SELECT SUM(Profit) FROM Invoices WITH(NOLOCK) Where Deleted=0) AS Profit,
			(SELECT SUM(Amount) FROM Outgoings WITH(NOLOCK) Where Deleted=0) AS Outgoings,
			(SELECT SUM(TransportCharge) FROM Transportation WITH(NOLOCK) Where Deleted=0) AS TransFees,
			ISNULL((SELECT SUM(PaymentAmount) FROM TransporterPayments WITH(NOLOCK) Where Deleted=0), 0) AS TransPayments;
End
GO
/****** Object:  StoredProcedure [dbo].[Banks_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Banks_Delete]
	@BankID tinyint
AS
BEGIN
	Delete from Banks Where BankID=@BankID;
	RETURN @@IDENTITY;
END
GO
/****** Object:  StoredProcedure [dbo].[Banks_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Banks_Save]
	@BankID tinyint
	,@BankName nvarchar(50)
AS
BEGIN	
	IF EXISTS(SELECT NULL FROM Banks Where BankID=@BankID)
	BEGIN
		UPDATE [dbo].[Banks] SET [BankName] = @BankName WHERE BankID=@BankID
		RETURN @BankID;
	END
	ELSE
	BEGIN
		INSERT into [Banks] ([BankName]) VALUES(@BankName);
		RETURN @@IDENTITY;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Banks_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Banks_SelectList]
	@DisplayStart tinyint = 0,
	@DisplayLength tinyint = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'asc'
AS
BEGIN
	SET NOCOUNT ON

	SELECT BankID, BankName  
		FROM (SELECT  BankID, BankName, (ROW_NUMBER() OVER(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN Banks.BankID END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN Banks.BankID END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN Banks.[BankName] END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN Banks.[BankName] END desc)) AS RowNo 
		FROM Banks 
		Where (@SearchParam IS NULL OR [BankName] LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount FROM Banks  Where (@SearchParam IS NULL OR [BankName] LIKE '%'+ @SearchParam + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[Client_GetSummary]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Balances_Select
-- ALTER date:	7-1-2017 08:19:03 PM
-- Description:	This stored procedure is intended for selecting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Client_GetSummary]	
	@ID int -- ClientID
As
Begin	
	SELECT (SELECT SUM(TotalAmount) FROM View_Invoices WHERE ClientID = @ID) AS TotalInvoices,
			(SELECT SUM(PaymentAmount) FROM ClientPayments Where Deleted=0 AND  ClientID = @ID) AS TotalPayments,
			(SELECT TOP 1 ClientName FROM Clients Where ClientID=@ID) ClientName;
End
GO
/****** Object:  StoredProcedure [dbo].[ClientPayments_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Mohamed Salah>
-- ALTER date: <1-2-2017>
-- Description:	<Delete payment and update client balance>
-- =============================================
CREATE PROCEDURE [dbo].[ClientPayments_Delete]
	@PaymentID int
AS
BEGIN

DECLARE @Count int;

BEGIN TRAN DeletePayment
	UPDATE ClientPayments SET Deleted=1 Where PaymentID=@PaymentID;
	SET @Count = @@ROWCOUNT;

	IF @Count > 0 -- update client debits and balances
		Update Clients SET Debit = (Debit - PaymentAmount)
			FROM View_ClientPayments JOIN Clients ON Clients.ClientID=View_ClientPayments.ClientID
			Where PaymentID=@PaymentID
COMMIT Tran

	RETURN @Count;
END
GO
/****** Object:  StoredProcedure [dbo].[ClientPayments_Properties]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientPayments_Properties]
	
AS
BEGIN
	SELECT ClientID,ClientName FROM Clients;
	SELECT BankID,BankName FROM Banks;
END
GO
/****** Object:  StoredProcedure [dbo].[ClientPayments_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientPayments_Save]
	@PaymentID int,
	@ClientID int,
	@AddDate date,
	@PaymentAmount money=0,
	@BankID tinyint=NULL,
	@CheckNo nvarchar(50) = NULL
AS
BEGIN
--BEGIN TRAN SavePayment	
	IF EXISTS(SELECT NULL FROM ClientPayments Where PaymentID=@PaymentID)
	BEGIN
		UPDATE [ClientPayments]
	   SET [ClientID] = @ClientID
		  ,[AddDate] = @AddDate
		  ,[PaymentAmount] = @PaymentAmount
		  ,BankID = @BankID
		  ,CheckNo = @CheckNo
		WHERE PaymentID=@PaymentID;

		----------------------Update client debit
		DECLARE @LatestDebit money=0;
		SET @LatestDebit=(SELECT TOP 1 ISNULL([PaymentAmount],0) FROM [ClientPayments] WHERE PaymentID=@PaymentID);
		
		Update Clients SET Debit =(Debit +(@PaymentAmount - @LatestDebit)) Where  [ClientID] = @ClientID;
		-----------------------------------------

		RETURN @PaymentID;
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[ClientPayments] ([ClientID] ,[AddDate] ,[PaymentAmount],[Deleted],BankID, CheckNo)
			VALUES (@ClientID ,@AddDate ,@PaymentAmount,0,@BankID, @CheckNo);

		IF @@IDENTITY > 0 --------------------------------Update client debit
			Update Clients SET Debit =(Debit + @PaymentAmount) Where  [ClientID] = @ClientID
		---------------------------------------------
		
		RETURN @@IDENTITY;
	END

--Commit Tran
END
GO
/****** Object:  StoredProcedure [dbo].[ClientPayments_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ClientPayments_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'asc',
	@ID int = NULL,-- ClientID
	@From datetime = NULL,
	@To datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT PaymentID, ClientID, AddDate, PaymentAmount, ClientName, BankID, BankName, CheckNo  
		FROM (SELECT  PaymentID, ClientID, AddDate, PaymentAmount, ClientName,BankID, BankName, CheckNo 
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [PaymentID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [PaymentID] END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN [ClientName] END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN [ClientName] END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_ClientPayments 
		Where (@ID IS NULL OR ClientID = @ID) AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To) AND (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount, SUM(PaymentAmount) AS TotalPayments FROM View_ClientPayments 
		Where (@ID IS NULL OR ClientID = @ID) AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To) AND (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[Clients_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Clients_Delete]
	@ClientID int
AS
BEGIN
	Delete from Clients Where ClientID=@ClientID;
	RETURN @@IDENTITY;
END
GO
/****** Object:  StoredProcedure [dbo].[Clients_GetNames]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Clients_GetNames
-- Author:	Mohamed Salah
-- ALTER date:	7/1/2017 9:27:39 AM
-- Description:	This stored procedure is intended for selecting a specific rows from clients table
-- ==========================================================================================
CREATE Procedure [dbo].[Clients_GetNames]
	@pageNum int = 1,
	@pageSize int= 10,
	@key nvarchar(50) = NULL
As
Begin
	-- get list
	SELECT [ClientID] as id, ClientName as [text1] FROM (
		Select distinct [ClientID],ClientName,(row_number() over(ORDER BY ClientName ASC)) As RowNo From Clients Where (@key IS NULL) OR (ClientName LIKE @key +'%')
		) List
	Where RowNo > ((@pageNum - 1) * @pageSize)  AND RowNo <= (@pageNum * @pageSize);
	
	-- get count
	SELECT Count(*) AS CNT FROM Clients Where (@key IS NULL) OR (ClientName LIKE @key +'%');
End
GO
/****** Object:  StoredProcedure [dbo].[Clients_Profit]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	    <Author,,Name>
-- ALTER date:  <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Clients_Profit]
	@From date= NULL,
	@To date = NULL
AS
BEGIN
	SET NOCOUNT ON
	SELECT dbo.Clients.ClientName, SUM(dbo.Invoices.Profit) AS Profit
		FROM dbo.Clients INNER JOIN dbo.Invoices ON dbo.Clients.ClientID = dbo.Invoices.ClientID
		WHERE Invoices.AddDate >= @From AND Invoices.AddDate <= @To
		GROUP BY dbo.Clients.ClientName;
END
GO
/****** Object:  StoredProcedure [dbo].[Clients_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Clients_Save]
	@ClientID int
	,@ClientName nvarchar(50)
    ,@Phone nvarchar(50)
    ,@Mobile nvarchar(50)
    ,@Address nvarchar(150)
	,@ClientTRN nvarchar(150) = NULL
AS
BEGIN	
	IF EXISTS(SELECT NULL FROM Clients Where ClientID=@ClientID)
	BEGIN
		UPDATE [dbo].[Clients]
	   SET [ClientName] = @ClientName
		  ,[Phone] = @Phone
		  ,[Mobile] = @Mobile
		  ,[Address] = @Address
		  ,ClientTRN=@ClientTRN
		WHERE ClientID=@ClientID
		RETURN @ClientID;
	END
	ELSE
	BEGIN
		INSERT INTO Clients (ClientName, Phone, Mobile, Address, ClientTRN)
			VALUES (@ClientName,@Phone,@Mobile,@Address,@ClientTRN)
		RETURN @@IDENTITY;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Clients_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Clients_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = '',
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'asc'
AS
BEGIN
	SET NOCOUNT ON

	SELECT ClientID, ClientName, Phone, Mobile, [Address], Debit, Credit ,ClientTRN  
		FROM (SELECT  ClientID, ClientName, Phone, Mobile, [Address], ClientTRN,
		(SELECT SUM(VCP.PaymentAmount) FROM View_ClientPayments VCP Where VCP.ClientID=Clients.ClientID) AS Debit, 
		(SELECT SUM(VIP.TotalAmount) FROM View_Invoices VIP Where VIP.ClientID=Clients.ClientID) AS Credit
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN Clients.ClientID END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN Clients.ClientID END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN Clients.[ClientName] END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN Clients.[ClientName] END desc)) AS RowNo 
		FROM Clients 
		Where (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount FROM Clients 
		Where (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[ClientStatement_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================
-- Author:		<Mohamed Salah>
-- ALTER date:  <16-5-2017>
-- Description:	<Select client invoices and payments in statement>
-- ================================================
CREATE PROCEDURE [dbo].[ClientStatement_SelectList]
	@ID int = NULL,	-- ClientID
	@From date = NULL,
	@To date = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- client name
	SELECT ClientName FROM Clients Where ClientID = @ID;
	
	-- client statement
	WITH Stm
		AS
		(
		   SELECT ID, [Date], Amount, InAmount, OutAmount, Note, Amount AS Balance, ClientID, DeclarationNo, ContainerNo
			   FROM View_ClientStatements
			   WHERE ClientID = @ID
			   GROUP BY [Date], ID, Amount, InAmount, OutAmount, Note, ClientID, DeclarationNo, ContainerNo
		), StmRanked AS
		(
		   SELECT ID, [Date], Amount, Note, InAmount, OutAmount, Balance, ClientID, ROW_NUMBER() OVER(ORDER BY [Date] ASC) RowNo, DeclarationNo, ContainerNo
			FROM Stm
		)
		 
	SELECT ClientID, ID, Note, InAmount, OutAmount, [Date], 
	(SELECT SUM(Balance) FROM StmRanked c2 WHERE c2.RowNo <= c1.RowNo) AS Balance, c1.RowNo, c1.DeclarationNo, c1.ContainerNo
		FROM StmRanked c1
		WHERE (@From IS NULL OR [Date] >= @From) AND (@To IS NULL OR [Date] <= @To);

	-- period profit
	SELECT SUM(Profit) AS Profit FROM Invoices WHERE (@From IS NULL OR [AddDate] >= @From) AND (@To IS NULL OR [AddDate] <= @To);
END

GO
/****** Object:  StoredProcedure [dbo].[Docs_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Docs_Delete
-- ALTER date:	11/01/2018 08:19:03 PM
-- Description:	This stored procedure is intended for VERIFYING DOCUMENT SUBMISSION IN Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Docs_Delete]
	@InvoiceID int
As
Begin
	Update Invoices SET DocVerified = 1, DocVerifiedDate = GETDATE() Where [InvoiceID] = @InvoiceID;
	RETURN @@ROWCOUNT;
End
GO
/****** Object:  StoredProcedure [dbo].[Docs_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Docs_SelectList
-- ALTER date:	10/01/2018 08:19:03 PM
-- Description:	This stored procedure is intended for selecting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Docs_SelectList]
	@DisplayStart int,
	@DisplayLength int,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn varchar(3) = '0',
	@SortDirection varchar(4) = 'desc',
	@SubmissionStatus int = 0, -- Document Verified
	@ClientID INT = NULL,
	@DateFrom date = NULL,
	@DateTo date = NULL
As
Begin
	SELECT InvoiceID, BillOfEntryDate, ContainerNo,DeclarationNo, DocVerified, DocVerifiedDate
	FROM (SELECT InvoiceID, BillOfEntryDate, ContainerNo,DeclarationNo, DocVerified, DocVerifiedDate
		,(ROW_NUMBER() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [InvoiceID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [InvoiceID] END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [BillOfEntryDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [BillOfEntryDate] END desc)) AS RowNo 
		FROM Invoices WITH(NOLOCK)
		Where BillOfEntryDate IS NOT NULL AND
		 (@SubmissionStatus IS NULL OR DocVerified = @SubmissionStatus) 
		 AND (@ClientID IS NULL OR ClientID = @ClientID)	
		 AND (@DateFrom IS NULL OR BillOfEntryDate >= @DateFrom)
		 AND (@DateTo IS NULL OR BillOfEntryDate <= @DateTo)
		 AND (@SearchParam IS NULL OR ContainerNo LIKE '%'+ @SearchParam + '%' OR DeclarationNo LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	SELECT Count(*) AS TableCount FROM Invoices WITH(NOLOCK)
		WHERE BillOfEntryDate IS NOT NULL
		 AND (@SubmissionStatus IS NULL OR DocVerified = @SubmissionStatus)
		 AND (@ClientID IS NULL OR ClientID = @ClientID)	
		 AND (@DateFrom IS NULL OR BillOfEntryDate >= @DateFrom)
		 AND (@DateTo IS NULL OR BillOfEntryDate <= @DateTo)
		 AND (@SearchParam IS NULL OR ContainerNo LIKE '%'+ @SearchParam + '%' OR DeclarationNo LIKE '%'+ @SearchParam + '%')
End
GO
/****** Object:  StoredProcedure [dbo].[Expenses_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Expenses_Delete]
	@ExpenseID int
AS
BEGIN
	Update Expenses SET Deleted = 1 Where ExpenseID=@ExpenseID;
	RETURN @@IDENTITY;
END
GO
/****** Object:  StoredProcedure [dbo].[Expenses_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Update Expenses SET IsVatable = 1 WHERE ExpenseID = 18
--SELECT * FROM Expenses --Where  InvoiceID = 806

--SELECT * FROM Invoices Where  InvoiceID = 806
--SELECT * FROM InvoiceDetails Where  InvoiceID = 806

----------------------------------------------------------


-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Expenses_Save]
	@ExpenseID int
	,@ExpenseName nvarchar(50)
    ,@DefaultValue money = 0,
	@Active	bit = 1,
	@Priority int = 0,
	@IsVatable bit = 0
AS
BEGIN
	IF EXISTS(SELECT NULL FROM Expenses Where ExpenseID=@ExpenseID)
	BEGIN
		UPDATE Expenses
			SET ExpenseName = @ExpenseName, DefaultValue = ISNULL(@DefaultValue, 0),
			Active=@Active, [Priority] = @Priority, Deleted = 0, IsVatable=@IsVatable
			WHERE (ExpenseID = @ExpenseID);
		RETURN @ExpenseID;
	END
	ELSE
	BEGIN
		INSERT INTO Expenses (ExpenseName, DefaultValue, Active, [Priority], Deleted, IsVatable)
			VALUES (@ExpenseName,ISNULL(@DefaultValue, 0), @Active, @Priority, 0, @IsVatable);
		RETURN @@IDENTITY;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Expenses_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Expenses_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = '',
	@SortColumn nvarchar(2) = '3',
	@SortDirection nvarchar(4) = 'asc'
AS
BEGIN
	SELECT ExpenseID, ExpenseName, DefaultValue, Active, Priority, Deleted , IsVatable
	FROM Expenses
	Where (Deleted=0) AND (@SearchParam = '' OR ExpenseName LIKE '%'+ @SearchParam + '%')
	ORDER BY 
			CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN ExpenseID END ASC,
			CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN ExpenseID END DESC,
			CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN ExpenseName END ASC,
			CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN ExpenseName END DESC,
			CASE WHEN @SortColumn = '3' AND @SortDirection = 'asc' THEN [Priority] END ASC,
			CASE WHEN @SortColumn = '3' AND @SortDirection = 'desc' THEN [Priority] END DESC	 
		OFFSET  @DisplayStart ROWS 
		FETCH NEXT @DisplayLength ROWS ONLY;
	select COUNT(*) from Expenses Where (Deleted=0) AND (@SearchParam = '' OR ExpenseName LIKE '%'+ @SearchParam + '%');
END
GO
/****** Object:  StoredProcedure [dbo].[Expenses_SelectRow]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Expenses_SelectRow]
	@Id int = 0
AS
BEGIN
	SET NOCOUNT ON
    SELECT * from Expenses WHERE ExpenseID=@Id;
END
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseTypes_Delete]
	@ExpenseTypeID int
AS
BEGIN
	Delete from ExpenseTypes Where ExpenseTypeID=@ExpenseTypeID;
	RETURN @@IDENTITY;
END
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_Names]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseTypes_Names]
AS
BEGIN
	SET NOCOUNT ON
	SELECT ExpenseTypeID, ExpenseTypeName FROM ExpenseTypes;
END
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseTypes_Save]
	@ExpenseTypeID int
	,@ExpenseTypeName nvarchar(50)
AS
BEGIN
	
	IF EXISTS(SELECT NULL FROM ExpenseTypes Where ExpenseTypeID=@ExpenseTypeID)
	BEGIN
		UPDATE [dbo].[ExpenseTypes]
			SET [ExpenseTypeName] = @ExpenseTypeName
		WHERE ExpenseTypeID=@ExpenseTypeID;
		RETURN @ExpenseTypeID;
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[ExpenseTypes] ([ExpenseTypeName])
			VALUES (@ExpenseTypeName)
		RETURN @@IDENTITY;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_Select2]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	ExpenseTypes_GetNames
-- Author:	Mohamed Salah
-- ALTER date:	5/1/2018 9:27:39 AM
-- Description:	This stored procedure is intended for selecting a specific rows from ExpenseTypes table
-- ==========================================================================================
CREATE Procedure [dbo].[ExpenseTypes_Select2]
	@pageNum int = 1,
	@pageSize int= 10,
	@key nvarchar(50) = NULL
As
Begin
	-- get list
	SELECT [ExpenseTypeID] as id, ExpenseTypeName as [text1] FROM (
		Select distinct [ExpenseTypeID],ExpenseTypeName,(row_number() over(ORDER BY ExpenseTypeName ASC)) As RowNo 
		From ExpenseTypes Where (@key IS NULL) OR (ExpenseTypeName LIKE @key +'%')
		) List
	Where RowNo > ((@pageNum - 1) * @pageSize)  AND RowNo <= (@pageNum * @pageSize);
	
	-- get count
	SELECT Count(*) AS CNT FROM ExpenseTypes Where (@key IS NULL) OR (ExpenseTypeName LIKE @key +'%');
End
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ExpenseTypes_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'asc'
AS
BEGIN
	SET NOCOUNT ON
    -- Insert statements for procedure here
	   SELECT ExpenseTypeID, ExpenseTypeName FROM ExpenseTypes WHERE (@SearchParam IS NULL) OR (ExpenseTypeName LIKE @SearchParam + '%');
	   select COUNT(*) FROM ExpenseTypes WHERE (@SearchParam IS NULL) OR (ExpenseTypeName LIKE @SearchParam + '%');
END
GO
/****** Object:  StoredProcedure [dbo].[ExpenseTypes_SelectRow]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ExpenseTypes_SelectRow]
	@Id int = 0
AS
BEGIN
	SET NOCOUNT ON
    SELECT * from ExpenseTypes WHERE ExpenseTypeID=@Id;
END
GO
/****** Object:  StoredProcedure [dbo].[Images_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Entity Name:	Images_DELETE
-- ALTER date:	5/25/2017 5:48:46 AM
-- Description:	This stored procedure is intended for selecting all rows from Images table
-- ==========================================================================================
CREATE Procedure [dbo].[Images_Delete]
	@ID nvarchar(500) -- image url
As
Begin	
	DELETE MediaFiles Where (MediaUrl = @ID);
	RETURN @@ROWCOUNT; 
End





GO
/****** Object:  StoredProcedure [dbo].[Images_Main]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Entity Name:	Images_Main
-- ALTER date:	5/25/2017 5:48:46 AM
-- Description:	This stored procedure is intended for selecting all rows from Images table
-- ==========================================================================================
CREATE Procedure [dbo].[Images_Main]
	@ID nvarchar(500) -- image url
As
Begin
	DECLARE @PropID	bigint;
	SET @PropID = (SELECT TOP 1 MasterID FROM MediaFiles Where (MediaUrl = @ID));

	Update MediaFiles SET IsMain = 0 Where (MasterID = @PropID); -- reset old
	Update MediaFiles SET IsMain = 1 Where (MediaUrl = @ID);
	RETURN @@ROWCOUNT; 
End





GO
/****** Object:  StoredProcedure [dbo].[Images_Properties]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Entity Name:	Images_Properties
-- ALTER date:	5/25/2017 5:48:46 AM
-- Description:	This stored procedure is intended for selecting all rows from Images table
-- ==========================================================================================
CREATE Procedure [dbo].[Images_Properties]
	@ID bigint -- property id
As
Begin
	SELECT        TOP (1) ExpenseTypes.ExpenseTypeName + ' ' + Outgoings.Notes AS Notes
	FROM            Outgoings INNER JOIN
							 ExpenseTypes ON Outgoings.ExpenseTypeID = ExpenseTypes.ExpenseTypeID
	WHERE        (Outgoings.OutgoingID = @ID);
	SELECT MediaFiles.MediaID,MediaFiles.IsMain, MediaFiles.MediaUrl, MediaFiles.Active, MediaFiles.[Priority], MediaFiles.MediaTypeID, MediaTypes.MediaTypeName
		FROM MediaFiles INNER JOIN MediaTypes ON MediaFiles.MediaTypeID = MediaTypes.MediaTypeID
		WHERE (MediaFiles.MasterID = @ID)
End





GO
/****** Object:  StoredProcedure [dbo].[Images_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[Images_Save]
	@doc xml
As
Begin

BEGIN TRAN SaveMasterDetails

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[#tbl]') AND OBJECTPROPERTY(id, N'IsTable') = 1) DROP Table [dbo].[#tbl] 

SELECT 
	MasterID=XTbl.XCol.value('@MasterID[1]','bigint'),
	MediaUrl=XTbl.XCol.value('@MediaUrl[1]','nvarchar(150)') ,
	[Priority]=XTbl.XCol.value('@Index[1]','int') 
 INTO #tbl FROM  @doc.nodes('//Pictures') AS XTbl(XCol) 
 
 
 INSERT INTO MediaFiles (MasterID, MediaUrl, [Priority], MediaTypeID)
	SELECT temp.MasterID, temp.MediaUrl, temp.[Priority], 1
	FROM [#tbl] AS temp;


Drop table #tbl;

COMMIT TRAN

IF @@ERROR <> 0 
  RETURN 0
ELSE	
  RETURN 1
END

GO
/****** Object:  StoredProcedure [dbo].[Invoices_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Invoices_Delete
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for deleting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Invoices_Delete]
	@InvoiceID int
As
Begin	

DECLARE @Count int;

BEGIN TRAN DeleteInvoice
	Update Invoices SET Deleted = 1 Where [InvoiceID] = @InvoiceID;
	SET @Count = @@ROWCOUNT;

	IF @Count > 0 -- update clients credit and balances
		UPDATE Clients SET Credit = (Credit - TotalAmount)
			FROM View_Invoices Join Clients ON View_Invoices.ClientID=Clients.ClientID
			Where [InvoiceID] = @InvoiceID;
COMMIT TRAN

	RETURN @Count;
End
GO
/****** Object:  StoredProcedure [dbo].[Invoices_Properties]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- ==========================================================================================
-- Entity Name:	Invoices_Properties
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for deleting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Invoices_Properties]
	@ID int=NULL -- for edit invoice
As
Begin
	SELECT Expenses.ExpenseID,Expenses.IsVatable, Expenses.ExpenseName, Expenses.DefaultValue, ExpensesMap.ParentExpenseID
		FROM Expenses WITH (NOLOCK) LEFT OUTER JOIN ExpensesMap ON Expenses.ExpenseID = ExpensesMap.ExpenseID
		WHERE (Expenses.Deleted = 0) AND (Expenses.Active = 1) 
		ORDER BY Expenses.[Priority], Expenses.ExpenseName;
	SELECT ClientID, ClientName FROM Clients WITH(NOLOCK);

	IF @ID IS NOT NULL -- for edit
	BEGIN		
		-- bill master
		SELECT Invoices.InvoiceID, Invoices.ClientID, Invoices.ContainerNo, Invoices.DeclarationNo, CONVERT(VARCHAR(10), Invoices.AddDate, 105) AS AddDate, Invoices.Notes, CONVERT(VARCHAR(10), Invoices.BillOfEntryDate, 105) 
                         AS BillOfEntryDate, Users.UserFullName AS TransporterName, Users_1.UserFullName AS CraneDriverName, Invoices.TransporterID, Invoices.CraneDriverID
		FROM Users RIGHT OUTER JOIN Invoices WITH (NOLOCK) ON Users.UserID = Invoices.TransporterID LEFT OUTER JOIN
								 Users AS Users_1 ON Invoices.CraneDriverID = Users_1.UserID
		WHERE (Invoices.InvoiceID = @ID);

		-- bill details
		SELECT InvoiceDetails.InvoiceDetailsID, InvoiceDetails.InvoiceID, InvoiceDetails.ExpenseID, InvoiceDetails.Amount, InvoiceDetails.VAT,
		 Expenses.ExpenseName,Expenses.IsVatable, Expenses.DefaultValue, InvoiceDetails.Cost, 
                         ExpensesMap.ParentExpenseID
			FROM InvoiceDetails WITH (NOLOCK) INNER JOIN Expenses WITH (NOLOCK) ON InvoiceDetails.ExpenseID = Expenses.ExpenseID LEFT OUTER JOIN
									 ExpensesMap ON InvoiceDetails.ExpenseID = ExpensesMap.ExpenseID
			WHERE (InvoiceDetails.InvoiceID = @ID);
	END
End
GO
/****** Object:  StoredProcedure [dbo].[Invoices_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Entity Name:	Invoices_Save
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for updating Invoices table
-- ==========================================================================================

CREATE Procedure [dbo].[Invoices_Save]
	@doc xml
As
Begin

BEGIN TRAN SaveMasterDetails

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[#tbl]') AND OBJECTPROPERTY(id, N'IsTable') = 1) DROP Table [dbo].[#tbl] 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[#tbl2]') AND OBJECTPROPERTY(id, N'IsTable') = 1) DROP Table [dbo].[#tbl2]

SELECT 
	InvoiceID=XTbl.XCol.value('@InvoiceID[1]','int'),
	ClientID=XTbl.XCol.value('@ClientID[1]','int'),
	AddDate=XTbl.XCol.value('@AddDate[1]','datetime'),
	BillOfEntryDate=XTbl.XCol.value('@BillOfEntryDate[1]','datetime'),
	Profit=XTbl.XCol.value('@Profit[1]','money'),
	TotalAmount=XTbl.XCol.value('@TotalAmount[1]','money'),
	ContainerNo=XTbl.XCol.value('@ContainerNo[1]','nvarchar(50)'),
	DeclarationNo=XTbl.XCol.value('@DeclarationNo[1]','nvarchar(50)'),
	Notes=XTbl.XCol.value('@Notes[1]','nvarchar(1000)'),
	TransporterID=XTbl.XCol.value('@TransporterID[1]','int'),
	CraneDriverID=XTbl.XCol.value('@CraneDriverID[1]','int')
 INTO #tbl FROM  @doc.nodes('//Master') AS XTbl(XCol) 
 
 Update Invoices
	Set
		[ClientID] = #tbl.ClientID,
		[AddDate] = #tbl.AddDate,
		[Deleted] = 0,
		Profit = #tbl.Profit,
		TotalAmount = #tbl.TotalAmount,
		DeclarationNo=#tbl.DeclarationNo,
		ContainerNo=#tbl.ContainerNo,
		Notes=#tbl.Notes,
		BillOfEntryDate = #tbl.BillOfEntryDate,
		TransporterID= #tbl.TransporterID,
		CraneDriverID= #tbl.CraneDriverID
 FROM #tbl INNER JOIN Invoices ON Invoices.[InvoiceID] = #tbl.InvoiceID

 INSERT INTO Invoices([ClientID],
 [AddDate],[Deleted],Profit,TotalAmount,ContainerNo,DeclarationNo,Notes,
  BillOfEntryDate,TransporterID,CraneDriverID)
	 SELECT temp.[ClientID],temp.[AddDate],0,temp.Profit,temp.TotalAmount,temp.ContainerNo,temp.DeclarationNo,
	  temp.Notes,temp.BillOfEntryDate,temp.TransporterID,temp.CraneDriverID

	 FROM  #tbl temp LEFT OUTER JOIN DBO.Invoices AS c ON c.DeclarationNo = temp.DeclarationNo AND c.ContainerNo = temp.ContainerNo
	 WHERE (c.[InvoiceID] IS NULL)

------------------------------------------------------------------Details
 DECLARE @MasterID int
 IF @@IDENTITY > 0
	SET @MasterID = @@IDENTITY;
 ELSE
	SET @MasterID = (SELECT TOP 1 InvoiceID FROM [#tbl]);
------------------------------------------------------------------

SELECT 
	InvoiceDetailsID=XTbl.XCol.value('@InvoiceDetailsID[1]','int') ,
	InvoiceID=@MasterID,
	ExpenseID=XTbl.XCol.value('@ExpenseID[1]','int'),
	Amount=XTbl.XCol.value('@Amount[1]','money'),
	Cost=XTbl.XCol.value('@Cost[1]','money'),
	VAT=XTbl.XCol.value('@VAT[1]','money')
 INTO #tbl2 FROM  @doc.nodes('//Details') AS XTbl(XCol) 


 DELETE FROM InvoiceDetails FROM #tbl2 RIGHT OUTER JOIN InvoiceDetails ON InvoiceDetails.[InvoiceDetailsID] = #tbl2.InvoiceDetailsID
	WHERE (#tbl2.[InvoiceDetailsID] IS NULL) AND InvoiceDetails.InvoiceID=@MasterID

 Update InvoiceDetails
	Set [InvoiceID] = #tbl2.InvoiceID,
		[ExpenseID] = #tbl2.ExpenseID,
		[Amount] = #tbl2.Amount,
		Cost=#tbl2.Cost,
		[VAT] = #tbl2.VAT
	FROM #tbl2 INNER JOIN InvoiceDetails ON InvoiceDetails.[InvoiceDetailsID] = #tbl2.InvoiceDetailsID
	WHERE #tbl2.Amount > 0 OR #tbl2.Cost > 0
     

     INSERT INTO InvoiceDetails([InvoiceID],[ExpenseID],[Amount],Cost,[VAT])
	 SELECT temp.[InvoiceID],temp.[ExpenseID],temp.[Amount],temp.Cost,temp.VAT
	 FROM  #tbl2 temp LEFT OUTER JOIN DBO.InvoiceDetails AS D ON D.[InvoiceDetailsID] = temp.InvoiceDetailsID
	 WHERE (D.[InvoiceDetailsID] IS NULL) AND (temp.Amount > 0 OR temp.Cost > 0)
	 
 ------------------------------------------------------------------Update client balance
 DECLARE @Client_ID int;
 SET @Client_ID = (SELECT TOP 1 ClientID From #tbl);

 UPDATE Clients Set Clients.Credit = (SELECT SUM(TotalAmount) FROM View_Invoices Where View_Invoices.ClientID=@Client_ID)
 Where Clients.ClientID = @Client_ID;
------------------------------------------------------------------

-- add/transporter based on this invoice
EXEC [dbo].[Transportation_SaveAfterInvoice] @MasterID;

Drop table #tbl;
Drop table #tbl2;

COMMIT TRAN

IF @@ERROR <> 0 
	RETURN 0
ELSE	-- Return 1 to the calling program to indicate success. 	
	RETURN @MasterID;

END

GO
/****** Object:  StoredProcedure [dbo].[Invoices_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- ==========================================================================================
-- Entity Name:	Invoices_SelectList
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for selecting a specific row from Invoices table
-- ==========================================================================================
CREATE Procedure [dbo].[Invoices_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'desc',
	@ID int = NULL,-- ClientID
	@From datetime = NULL,
	@To datetime = NULL
As
Begin
	SELECT InvoiceID, AddDate, ClientName, TotalAmount,ContainerNo,DeclarationNo, VATAmount, ServiceChargeAmount
	 FROM (SELECT InvoiceID, AddDate, ClientName, TotalAmount,ContainerNo,DeclarationNo, VATAmount, (SELECT TOP 1 Amount FROM InvoiceDetails Where ExpenseID = 18 AND InvoiceID = View_Invoices.InvoiceID) AS ServiceChargeAmount
		,(ROW_NUMBER() OVER(ORDER BY
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN View_Invoices.[InvoiceID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN View_Invoices.[InvoiceID] END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN [ClientName] END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN [ClientName] END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_Invoices
		Where (@ID IS NULL OR ClientID = @ID) 
			 AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To) 
			 AND (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%' OR ContainerNo LIKE '%'+ @SearchParam + '%' OR DeclarationNo LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 Select Count(*) AS TableCount, SUM(TotalAmount) AS TotalInvoices, -- total
			(SELECT SUM(PaymentAmount) FROM View_ClientPayments Where ClientId = @ID) AS TotalPayments -- payments
		FROM View_Invoices 
		Where (@ID IS NULL OR ClientID = @ID) AND (@From IS NULL OR AddDate >= @From)
			 AND (@To IS NULL OR AddDate <= @To) AND (@SearchParam IS NULL OR [ClientName] LIKE '%'+ @SearchParam + '%' OR ContainerNo LIKE '%'+ @SearchParam + '%' OR DeclarationNo LIKE '%'+ @SearchParam + '%')
End

GO
/****** Object:  StoredProcedure [dbo].[Invoices_SelectRow]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Invoices_SelectRow]
	@Id int = NULL,
	@key nvarchar(50) = NULL,
	@no  nvarchar(50) = NULL
As
Begin
	IF @Id IS NOT NULL
	BEGIN
		-- Master
		SELECT TOP (1) View_Invoices.InvoiceID, View_Invoices.AddDate, View_Invoices.ClientName, View_Invoices.TotalAmount, View_Invoices.ContainerNo, View_Invoices.DeclarationNo, View_Invoices.Notes, View_Invoices.BillOfEntryDate,
              (SELECT TOP (1) Val FROM Settings WHERE (Attr = 'TRN')) AS Val, View_Invoices.TransporterID, View_Invoices.CraneDriverID, Users.UserFullName AS TransporterName, Users_1.UserFullName AS CraneDriverName, View_Invoices.ClientTRN
			FROM Users RIGHT OUTER JOIN Users AS Users_1 RIGHT OUTER JOIN View_Invoices ON Users_1.UserID = View_Invoices.CraneDriverID ON Users.UserID = View_Invoices.TransporterID
			WHERE  (View_Invoices.InvoiceID = @Id); -- Tax Registration Number ==> in Settings table.
		-- Details
		SELECT InvoiceDetails.InvoiceDetailsID, InvoiceDetails.Amount,InvoiceDetails.VAT, Expenses.ExpenseName, ExpensesMap.ParentExpenseID
			FROM InvoiceDetails INNER JOIN Expenses ON InvoiceDetails.ExpenseID = Expenses.ExpenseID LEFT OUTER JOIN ExpensesMap ON InvoiceDetails.ExpenseID = ExpensesMap.ExpenseID
			WHERE (InvoiceDetails.InvoiceID = @Id) Order BY Expenses.[Priority], Expenses.ExpenseName;
	END
	ELSE
	BEGIN
		DECLARE @sql nvarchar(MAX);
		SELECT @sql = 'SELECT TOP (1) View_Invoices.InvoiceID, View_Invoices.AddDate, View_Invoices.ClientName, View_Invoices.TotalAmount, View_Invoices.ContainerNo, View_Invoices.DeclarationNo, View_Invoices.Notes, View_Invoices.BillOfEntryDate,
						  (SELECT TOP (1) Val FROM Settings WHERE (Attr = ''TRN'')) AS Val, View_Invoices.TransporterID, View_Invoices.CraneDriverID, Users.UserFullName AS TransporterName, Users_1.UserFullName AS CraneDriverName, View_Invoices.ClientTRN
						FROM Users RIGHT OUTER JOIN Users AS Users_1 RIGHT OUTER JOIN View_Invoices ON Users_1.UserID = View_Invoices.CraneDriverID ON Users.UserID = View_Invoices.TransporterID WHERE (View_Invoices.'+ @key +'=N'''+ @no +''');'+
					  'SELECT InvoiceDetails.InvoiceDetailsID, InvoiceDetails.Amount, Expenses.ExpenseName, ExpensesMap.ParentExpenseID,InvoiceDetails.VAT
						   FROM InvoiceDetails INNER JOIN Expenses ON InvoiceDetails.ExpenseID = Expenses.ExpenseID INNER JOIN
							  Invoices ON InvoiceDetails.InvoiceID = Invoices.InvoiceID LEFT OUTER JOIN
							  ExpensesMap ON InvoiceDetails.ExpenseID = ExpensesMap.ExpenseID
						   WHERE (Invoices.'+ @key +'=N'''+ @no +''') Order BY Expenses.[Priority], Expenses.ExpenseName;'
		EXEC sp_executesql @sql;
	END
End
GO
/****** Object:  StoredProcedure [dbo].[InvoicesVat_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InvoicesVat_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'asc',
	@From datetime = NULL,
	@To datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT InvoiceID,AddDate, TotalAmount,ClientName , ClientTRN
		FROM (SELECT Invoices.InvoiceID,AddDate, TotalAmount,ClientName , ClientTRN
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [InvoiceID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [InvoiceID] END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM Invoices 
		inner join Clients on Clients.ClientID = Invoices.ClientID
		WHERE 

		  (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
		) outgo 
	WHERE RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount, SUM(Amount) AS TotalPayments FROM View_Outgoings 
		WHERE 
		  (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
END
GO
/****** Object:  StoredProcedure [dbo].[Outgoings_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Mohamed Salah>
-- ALTER date: <1-2-2017>
-- Description:	<Delete payment and update client balance>
-- =============================================
CREATE PROCEDURE [dbo].[Outgoings_Delete]
	@OutgoingID int
AS
BEGIN

DECLARE @Count int;
BEGIN TRAN DeletePayment
	UPDATE Outgoings SET Deleted=1 Where OutgoingID=@OutgoingID;
	SET @Count = @@ROWCOUNT;
COMMIT Tran
	RETURN @Count;
END
GO
/****** Object:  StoredProcedure [dbo].[Outgoings_One]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date:  <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Outgoings_One]
	@ID bigint -- @OutgoingID 
AS
BEGIN
	SELECT TOP (1) ExpenseTypeName, OutgoingID, AddDate, ExpenseTypeID, Amount, RefID, Notes,VAT
		FROM View_Outgoings
		WHERE (OutgoingID = @ID);
END
GO
/****** Object:  StoredProcedure [dbo].[Outgoings_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Outgoings_Save]
	@OutgoingID bigint,
	@AddDate datetime = getdate,
	@ExpenseTypeID int,
	@Amount money,
	@RefID nvarchar(50) = NULL,
	@Notes nvarchar(3000) = NULL,
	@VAT money = 0
AS
BEGIN
--BEGIN TRAN SavePayment
	IF EXISTS(SELECT NULL FROM Outgoings Where OutgoingID = @OutgoingID)
	BEGIN
		UPDATE [Outgoings]
	   SET AddDate = @AddDate,
			ExpenseTypeID = @ExpenseTypeID,
			Amount = @Amount,
			RefID = @RefID,
			Notes = @Notes,
			VAT=@VAT,
			TotalAmount = @Amount + @VAT
		WHERE OutgoingID=@OutgoingID;
		RETURN @OutgoingID;
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Outgoings] (AddDate,ExpenseTypeID,Amount,RefID,Notes,VAT,TotalAmount)
			VALUES (@AddDate,@ExpenseTypeID,@Amount,@RefID,@Notes,@VAT,@Amount + @VAT);
		RETURN @@IDENTITY;
	END
--Commit Tran
END
GO
/****** Object:  StoredProcedure [dbo].[Outgoings_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Outgoings_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'asc',
	@ExpenseTypeID int = NULL,
	@From datetime = NULL,
	@To datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT OutgoingID,AddDate,ExpenseTypeName,Amount,RefID,Notes,VAT, TotalAmount
		FROM (SELECT OutgoingID,AddDate,ExpenseTypeName,Amount,RefID,Notes,VAT, TotalAmount
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [OutgoingID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [OutgoingID] END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN ExpenseTypeName END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN ExpenseTypeName END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_Outgoings 
		WHERE (@SearchParam IS NULL OR ExpenseTypeName LIKE '%'+ @SearchParam + '%' OR Notes LIKE '%'+ @SearchParam + '%')
		 AND (@ExpenseTypeID IS NULL OR ExpenseTypeID = @ExpenseTypeID)
		 AND (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
		) outgo 
	WHERE RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount, SUM(Amount) AS TotalPayments FROM View_Outgoings 
		WHERE (@SearchParam IS NULL OR ExpenseTypeName LIKE '%'+ @SearchParam + '%' OR Notes LIKE '%'+ @SearchParam + '%')
		 AND (@ExpenseTypeID IS NULL OR ExpenseTypeID = @ExpenseTypeID)
		 AND (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
END
GO
/****** Object:  StoredProcedure [dbo].[Settings_Select]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Settings_Select]
@Id nvarchar(50) = 'VAT'
AS
BEGIN
	SET NOCOUNT ON
    SELECT * from Settings where Attr=@id
END
GO
/****** Object:  StoredProcedure [dbo].[Transportation_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Transportation_Delete
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for deleting a specific row from Transportation table
-- ==========================================================================================
CREATE Procedure [dbo].[Transportation_Delete]
	@TransportID int -- 
As
Begin	

DECLARE @Count int;

BEGIN TRAN DeleteInvoice
	Update Transportation SET Deleted = 1 Where [TransportID] = @TransportID;
	SET @Count = @@ROWCOUNT;
COMMIT TRAN

	RETURN @Count;
End
GO
/****** Object:  StoredProcedure [dbo].[Transportation_Properties]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Transportation_Properties
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for deleting a specific row from Transportation table
-- ==========================================================================================
CREATE Procedure [dbo].[Transportation_Properties]
	@ID int = NULL -- User Type ID
As
Begin
	SELECT ClientID, ClientName FROM Clients;
	SELECT UserID, UserFullName FROM Users WHERE (@ID IS NULL OR TypeID = @ID);;
End
GO
/****** Object:  StoredProcedure [dbo].[Transportation_Row]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Transportation_SelectrOW
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended for selecting a specific row from Transportation table
-- ==========================================================================================
CREATE Procedure [dbo].[Transportation_Row]
	@Id int
As
Begin
	SELECT ClientName, UserFullName, TransportID, TransportDate, ConsigneeID, TransporterID, ContainerNo, TransportCharge, CarageCharge, TotalAmount, Deleted
	FROM View_Transportation
	WHERE (TransportID = @Id)	
End
GO
/****** Object:  StoredProcedure [dbo].[Transportation_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<M. Salah>
-- ALTER date:  <18-3-2017>
-- Description:	<Save transportation table>
-- =============================================
CREATE PROCEDURE [dbo].[Transportation_Save]
	@TransportID int,
	@TransportDate date
    ,@ConsigneeID int
    ,@TransporterID int
    ,@ContainerNo nvarchar(50)
    ,@TransportCharge money =0
    ,@CarageCharge money=0
	,@TypeID int
AS
BEGIN
--BEGIN TRAN SavePayment	
	IF EXISTS(SELECT NULL FROM Transportation Where TransportID=@TransportID)
	BEGIN
		UPDATE Transportation 
			SET TransportDate = @TransportDate, ConsigneeID = @ConsigneeID, TransporterID = @TransporterID, ContainerNo = @ContainerNo, 
                         TransportCharge = @TransportCharge, CarageCharge = @CarageCharge, TotalAmount = (@CarageCharge + @TransportCharge), TypeID=@TypeID 
			WHERE (TransportID = @TransportID);		 
		RETURN @TransportID;
	END
	ELSE
	BEGIN
	-- new serial for addition
		DECLARE @Serial bigint;
		SET @Serial = ISNULL((SELECT TOP (1) Serial FROM TransporterPayments WHERE TypeID = @TypeID ORDER BY Serial DESC), 0) + 1;

		Set IDENTITY_INSERT Transportation On;
		INSERT INTO Transportation (TransportID, TransportDate, ConsigneeID, TransporterID, ContainerNo, TransportCharge, CarageCharge, TotalAmount, Deleted, TypeID, Serial)
			VALUES ((SELECT MAX(TransportID)+1 FROM Transportation), @TransportDate,@ConsigneeID,@TransporterID,@ContainerNo,@TransportCharge,@CarageCharge,(@TransportCharge + @CarageCharge), 0, @TypeID, @Serial);
		Set IDENTITY_INSERT Transportation Off;
		RETURN @@IDENTITY;
	END
--Commit Tran
END

GO
/****** Object:  StoredProcedure [dbo].[Transportation_SaveAfterInvoice]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<M. Salah>
-- ALTER date:  <18-1-2018>
-- Description:	<Save transportation table>
-- =============================================
CREATE PROCEDURE [dbo].[Transportation_SaveAfterInvoice]
	@InvoiceID bigint
AS
BEGIN
  DECLARE @TransportCharge money, @CraneCharge money;

  SELECT @TransportCharge = InvoiceDetails.Cost
		FROM Invoices JOIN InvoiceDetails ON  Invoices.InvoiceID = InvoiceDetails.InvoiceID
		WHERE Invoices.InvoiceID = @InvoiceID AND InvoiceDetails.ExpenseID = 7; -- Transporter charge

  SELECT @CraneCharge = InvoiceDetails.Cost
		FROM Invoices JOIN InvoiceDetails ON  Invoices.InvoiceID = InvoiceDetails.InvoiceID
		WHERE Invoices.InvoiceID = @InvoiceID AND InvoiceDetails.ExpenseID = 14; -- Crane charge

	-- transporter
	IF @TransportCharge > 0 AND NOT EXISTS(SELECT NULL FROM Transportation WHERE TypeID= 2 AND InvoiceID = @InvoiceID)-- Insert Transporter fee after invoice
	BEGIN
	-- new serial for addition
		DECLARE @SerialTrans bigint;
		SET @SerialTrans = ISNULL((SELECT TOP (1) Serial FROM Transportation WHERE TypeID = 2 ORDER BY Serial DESC), 0) + 1;

		INSERT INTO Transportation (TransportCharge, TransportDate, TransporterID, ContainerNo, TotalAmount, Deleted, ConsigneeID, InvoiceID, Serial, TypeID)
			SELECT TOP (1) @TransportCharge AS Expr1, GETDATE() AS Expr2, Invoices.TransporterID, Invoices.ContainerNo, Invoices.TotalAmount, 0 AS Expr3, Invoices.ClientID, Invoices.InvoiceID, @SerialTrans AS Expr4, 2 AS Expr5
				FROM Invoices LEFT OUTER JOIN
                             (SELECT InvoiceID FROM Transportation
                               WHERE (InvoiceID = @InvoiceID) AND (TypeID = 2)) AS trans ON Invoices.InvoiceID = trans.InvoiceID
				WHERE(Invoices.InvoiceID = @InvoiceID) AND (Invoices.TransporterID > 0) AND (trans.InvoiceID IS NULL)
	END

	-- creage 
	IF @CraneCharge > 0 AND NOT EXISTS(SELECT NULL FROM Transportation WHERE TypeID= 3 AND InvoiceID = @InvoiceID)-- Insert crane/driver fee after invoice
	BEGIN	
	-- new serial for addition
		DECLARE @SerialCrane bigint;
		SET @SerialCrane = ISNULL((SELECT TOP (1) Serial FROM Transportation WHERE TypeID = 3 ORDER BY Serial DESC), 0) + 1;

		INSERT INTO Transportation (TransportCharge, TransportDate, TransporterID, ContainerNo, TotalAmount, Deleted, ConsigneeID, InvoiceID, Serial, TypeID)
			SELECT TOP (1) @CraneCharge AS Expr1, GETDATE() AS Expr2, Invoices.CraneDriverID, Invoices.ContainerNo, Invoices.TotalAmount, 0 AS Expr3, Invoices.ClientID, Invoices.InvoiceID, @SerialCrane AS Expr4, 3 AS Expr5
				FROM Invoices LEFT OUTER JOIN
                             (SELECT InvoiceID FROM Transportation
                               WHERE (InvoiceID = @InvoiceID) AND (TypeID = 3)) AS trans ON Invoices.InvoiceID = trans.InvoiceID
				WHERE        (Invoices.InvoiceID = @InvoiceID) AND (Invoices.CraneDriverID > 0) AND (trans.InvoiceID IS NULL)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Transportation_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Transportation_SelectList
-- ALTER date:	24/05/2016 08:19:03 PM
-- Description:	This stored procedure is intended
 -- for selecting a specific row from Transportation table
-- ==========================================================================================
CREATE Procedure [dbo].[Transportation_SelectList]
	@DisplayStart int=0,
	@DisplayLength int=50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'desc',
	@Client int = NULL,
	@User int = NULL,
	@From date = NULL,
	@To date = NULL,
	@TypeID int = 2 -- transporter
As
Begin
	SELECT [TransportID], TransportDate, ClientName, TotalAmount, ContainerNo, UserFullName, CarageCharge, TransportCharge, 
		TransporterID, ConsigneeID, TypeID,Serial
	FROM (SELECT [TransportID], TransportDate, ClientName, TotalAmount, ContainerNo, UserFullName, CarageCharge, TransportCharge, 
	TransporterID, ConsigneeID, TypeID,Serial
	,(row_number() over(ORDER BY  
		 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [TransportID] END ASC,
		 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [TransportID] END desc,
		 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN [ClientName] END ASC,
		 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN [ClientName] END desc,
		 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [TransportDate] END ASC,
		 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [TransportDate] END desc)) AS RowNo 
	FROM View_Transportation Where (TypeID = @TypeID) AND (@SearchParam IS NULL  
		 OR [ClientName] LIKE '%'+ @SearchParam + '%'
		 OR ContainerNo LIKE '%'+ @SearchParam + '%'
		 OR UserFullName LIKE '%'+ @SearchParam + '%') 
		 AND (@Client IS NULL OR ConsigneeID = @Client)
		 AND (@User IS NULL OR TransporterID = @User)
		 AND (@From IS NULL OR TransportDate >= @From)
		 AND (@To IS NULL OR TransportDate <= @To)
	) Transportation Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 -- counts
	 Select Count(*) AS TableCount, SUM(TransportCharge) AS TotalFees,
		(SELECT SUM(PaymentAmount) FROM TransporterPayments WHERE (Deleted = 0) AND (TypeID = @TypeID) AND (@User IS NULL OR TransporterID = @User)) AS TotalPayments
	 FROM View_Transportation 
	 Where (TypeID = @TypeID) AND (@SearchParam IS NULL  
		 OR [ClientName] LIKE '%'+ @SearchParam + '%'
		 OR ContainerNo LIKE '%'+ @SearchParam + '%'
		 OR UserFullName LIKE '%'+ @SearchParam + '%') 
		 AND (@Client IS NULL OR ConsigneeID = @Client)
		 AND (@User IS NULL OR TransporterID = @User)
		 AND (@From IS NULL OR TransportDate >= @From)
		 AND (@To IS NULL OR TransportDate <= @To)

End
GO
/****** Object:  StoredProcedure [dbo].[TransporterPayments_Delete]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Mohamed Salah>
-- ALTER date: <1-2-2017>
-- Description:	<Delete payment and update Transporter balance>
-- =============================================
CREATE PROCEDURE [dbo].[TransporterPayments_Delete]
	@PaymentID int
AS
BEGIN
DECLARE @Count int;
BEGIN TRAN DeletePayment
	UPDATE TransporterPayments SET Deleted=1 Where PaymentID=@PaymentID;
	SET @Count = @@ROWCOUNT;

	IF @Count > 0 -- update Transporter debits and balances
		Update Transportation SET Debit = (Debit - PaymentAmount)
			FROM View_TransporterPayments JOIN Transportation ON Transportation.TransporterID=View_TransporterPayments.TransporterID
			Where PaymentID=@PaymentID
COMMIT Tran
	RETURN @Count;
END
GO
/****** Object:  StoredProcedure [dbo].[TransporterPayments_Properties]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransporterPayments_Properties]
	@ID int = NULL -- User Type ID
AS
BEGIN
	SELECT UserID AS TransporterID,UserFullName AS TransporterName FROM Users WHERE (@ID IS NULL OR TypeID = @ID);
	SELECT BankID,BankName FROM Banks;
END
GO
/****** Object:  StoredProcedure [dbo].[TransporterPayments_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransporterPayments_Save]
	@PaymentID int,
	@TransporterID int,
	@AddDate date,
	@PaymentAmount money=0,
	@BankID tinyint=NULL,
	@CheckNo nvarchar(50) = NULL,
	@TypeID int
AS
BEGIN
	
	--BEGIN TRAN SavePayment	
	IF EXISTS(SELECT NULL FROM TransporterPayments Where PaymentID=@PaymentID)
	BEGIN
		UPDATE [TransporterPayments]
	   SET [TransporterID] = @TransporterID
		  ,[AddDate] = @AddDate
		  ,[PaymentAmount] = @PaymentAmount
		  ,BankID = @BankID
		  ,CheckNo = @CheckNo
		  ,TypeID=@TypeID
		WHERE PaymentID=@PaymentID;

		----------------------Update Transporter debit
		DECLARE @LatestDebit money=0;
		SET @LatestDebit=(SELECT TOP 1 ISNULL([PaymentAmount],0) FROM [TransporterPayments] WHERE PaymentID=@PaymentID);
		
		Update Transportation SET Debit =(Debit +(@PaymentAmount - @LatestDebit)) Where  [TransporterID] = @TransporterID;
		-----------------------------------------

		RETURN @PaymentID;
	END
	ELSE
	BEGIN
	-- new serial for addition
		DECLARE @Serial bigint;
		SET @Serial = ISNULL((SELECT TOP (1) Serial FROM TransporterPayments WHERE TypeID = @TypeID ORDER BY Serial DESC), 0) + 1;

		INSERT INTO [dbo].[TransporterPayments] ([TransporterID] ,[AddDate] ,[PaymentAmount],[Deleted],BankID, CheckNo, TypeID, Serial)
			VALUES (@TransporterID ,@AddDate ,@PaymentAmount,0,@BankID, @CheckNo, @TypeID, @Serial);

		IF @@IDENTITY > 0 --------------------------------Update Transporter debit
			Update Transportation SET Debit =(Debit + @PaymentAmount) Where  [TransporterID] = @TransporterID
		---------------------------------------------
		
		RETURN @@IDENTITY;
	END

--Commit Tran
END
GO
/****** Object:  StoredProcedure [dbo].[TransporterPayments_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransporterPayments_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'asc',
	@ID int = NULL,-- TransporterID
	@From datetime = NULL,
	@To datetime = NULL,
	@TypeID int = 2 -- transporter
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT PaymentID, TransporterID, AddDate, PaymentAmount, TransporterName, BankID, BankName, CheckNo,TypeID, Serial 
		FROM (SELECT  PaymentID, TransporterID, AddDate, PaymentAmount, TransporterName,BankID, BankName, CheckNo,TypeID, Serial
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN [PaymentID] END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN [PaymentID] END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN [TransporterName] END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN [TransporterName] END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_TransporterPayments 
		Where (TypeID = @TypeID) AND (@ID IS NULL OR TransporterID = @ID) AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To) AND (@SearchParam IS NULL OR [TransporterName] LIKE '%'+ @SearchParam + '%')
		) Invoices 
	Where RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	 SELECT Count(*) AS TableCount, SUM(PaymentAmount) AS TotalPayments,
		(SELECT SUM(TransportCharge) FROM Transportation Where (Deleted = 0) AND (TypeID = @TypeID) AND (@ID IS NULL OR TransporterID = @ID)) AS TotalFees
	 FROM View_TransporterPayments 
		Where (TypeID = @TypeID) AND (@ID IS NULL OR TransporterID = @ID) AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To) AND (@SearchParam IS NULL OR [TransporterName] LIKE '%'+ @SearchParam + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[Users_DeleteRow]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Users_DeleteRow
-- Author:	Mohamed Salah
-- ALTER date:	7/1/2013 11:55:23 AM
-- Description:	This stored procedure is intended for deleting a specific row from Users table
-- ==========================================================================================
CREATE Procedure [dbo].[Users_DeleteRow]
	@UserID int
As
Begin	
	UPDATE Users SET [IsDeleted] = 1 WHERE [UserID] = @UserID;
	RETURN @@ROWCOUNT;
End
GO
/****** Object:  StoredProcedure [dbo].[Users_Login]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Mohamed Salah Abdullah>
-- ALTER date:  <24-3-2010>
-- Description:	<Check user id exist in tbl_admin_n table>
-- =============================================
CREATE PROCEDURE [dbo].[Users_Login] 
	-- Add the parameters for the stored procedure here
	@Username nvarchar(50),
	@Password nvarchar(50)
AS
BEGIN
    -- Insert statements for procedure here
	SELECT TOP (1) UserID, UserFullName FROM Users --WHERE (Username = @Username) AND ([Password] = @Password); -- employees only =  AND (TypeID = 1)
END
GO
/****** Object:  StoredProcedure [dbo].[Users_Save]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ==========================================================================================
-- Entity Name:	Users_Update
-- Author:	Mohamed Salah
-- ALTER date:	6/12/2013 12:06:02 AM
-- Description:	This stored procedure is intended for updating Users table
-- ==========================================================================================
CREATE Procedure [dbo].[Users_Save]
	@UserID int,
	@UserFullName nvarchar(150),
	@Phone nvarchar(150),
	@Email nvarchar(150),
	@Username nvarchar(150),
	@Password nvarchar(150),
	@Mobile nvarchar(50),
	@TypeID int = 1,
	@Nationality nvarchar(50)
As
Begin
	DECLARE @Items int;
	IF(@UserID > 0 OR EXISTS(SELECT NULL FROM Users WHERE Username=@Username AND [UserFullName] = @UserFullName))  
	BEGIN
		SET NOCOUNT OFF;SET NOCOUNT ON;			
		Update Users
		Set UserFullName = @UserFullName, Phone = @Phone, Email = @Email, Username = @Username, Password = @Password, IsActive = 1, 
                         IsDeleted = 0, Mobile = @Mobile, Nationality = @Nationality, TypeID = @TypeID
		Where [UserID] = @UserID OR (Username=@Username AND [UserFullName] = @UserFullName);
		SET @Items = @UserID;
	END		
	ELSE
	BEGIN
		Insert Into Users([UserFullName],[Phone],[Email],[Username],[Password],[IsActive],[IsDeleted],[Mobile],Nationality, TypeID)
		Values(@UserFullName,@Phone,@Email,@Username,@Password,1,0,@Mobile,@Nationality, @TypeID);
		SET @Items = @@IDENTITY;
	END
	Return @Items;
End
GO
/****** Object:  StoredProcedure [dbo].[Users_Select2]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Entity Name:	Users_Select2
-- Author:	Mohamed Salah
-- ALTER date:	16/1/2018 9:27:39 AM
-- Description:	This stored procedure is intended for selecting a specific rows from Users table
-- ==========================================================================================
CREATE Procedure [dbo].[Users_Select2]
	@pageNum int = 1,
	@pageSize int= 10,
	@key nvarchar(50) = NULL
As
Begin
	-- get list
	SELECT [UserID] as id, UserFullName as [text1] FROM (
		Select distinct [UserID],UserFullName,(row_number() over(ORDER BY UserName ASC)) As RowNo From Users Where (@key IS NULL) OR (UserName LIKE @key +'%')
		) List
	Where RowNo > ((@pageNum - 1) * @pageSize)  AND RowNo <= (@pageNum * @pageSize);
	
	-- get count
	SELECT Count(*) AS CNT FROM Users Where (@key IS NULL) OR (UserName LIKE @key +'%');
End

GO
/****** Object:  StoredProcedure [dbo].[Users_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Users_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = '',
	@SortColumn nvarchar(5) = '0',
	@SortDirection nvarchar(5) = 'asc'
AS
BEGIN
	SET NOCOUNT ON
	   SELECT Users.UserID, Users.UserFullName, Users.Phone, Users.Email, Users.Username, Users.Password, Users.IsActive, Users.IsDeleted, Users.Mobile, Users.Nationality, Users.TypeID, UserTypes.TypeName
		FROM Users INNER JOIN UserTypes ON Users.TypeID = UserTypes.TypeID;
	   SELECT COUNT(*) from Users;
END
GO
/****** Object:  StoredProcedure [dbo].[Users_SelectRow]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ==========================================================================================
-- Entity Name:	Users_SelectRow
-- Author:	Mohamed Salah
-- ALTER date:	7/1/2013 11:55:23 AM
-- Description:	This stored procedure is intended for selecting a specific row from Users table
-- ==========================================================================================
CREATE Procedure [dbo].[Users_SelectRow]
	@UserID int
As
Begin
	SELECT Users.UserID, Users.UserFullName, Users.Phone, Users.Email, Users.Username, Users.Password, Users.IsActive, Users.IsDeleted, Users.Mobile, Users.Nationality, Users.TypeID, UserTypes.TypeName
	FROM Users INNER JOIN UserTypes ON Users.TypeID = UserTypes.TypeID
	WHERE (Users.UserID = @UserID)
End
GO
/****** Object:  StoredProcedure [dbo].[VatIn_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VatIn_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'asc',
	@From datetime = NULL,
	@To datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT InvoiceID,AddDate,VATAmount,ClientName,ClientTRN
		FROM (SELECT InvoiceID,AddDate,VATAmount,ClientName,ClientTRN
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN InvoiceID END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN InvoiceID END desc,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'asc' THEN ClientName END ASC,
			 CASE WHEN @SortColumn = '1' AND @SortDirection = 'desc' THEN ClientName END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_VatInView 
		WHERE 
	    (@SearchParam IS NULL OR ClientName LIKE '%'+ @SearchParam + '%' OR ClientName LIKE '%'+ @SearchParam + '%')
        AND (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
		) outgo 
	WHERE RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	   SELECT Count(*) AS TableCount, SUM(VATAmount) AS TotalVATAmount FROM View_VatInView 
	  WHERE (@SearchParam IS NULL OR ClientName LIKE '%'+ @SearchParam + '%' OR ClientName LIKE '%'+ @SearchParam + '%')
		AND (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To)
END
GO
/****** Object:  StoredProcedure [dbo].[VatOut_SelectList]    Script Date: 4/2/2018 7:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VatOut_SelectList]
	@DisplayStart int = 0,
	@DisplayLength int = 50,
	@SearchParam nvarchar(50) = NULL,
	@SortColumn nvarchar(3) = '0',
	@SortDirection nvarchar(4) = 'asc',
	@From datetime = NULL,
	@To datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	-- list
	SELECT OutgoingID,AddDate,VAT,Amount,TotalAmount
		FROM (SELECT OutgoingID,AddDate,VAT,Amount,TotalAmount
		,(row_number() over(ORDER BY  
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'asc' THEN OutgoingID END ASC,
			 CASE WHEN @SortColumn = '0' AND @SortDirection = 'desc' THEN OutgoingID END desc,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'asc' THEN [AddDate] END ASC,
			 CASE WHEN @SortColumn = '2' AND @SortDirection = 'desc' THEN [AddDate] END desc)) AS RowNo 
		FROM View_VatOutView 
		WHERE 
         (@From IS NULL OR AddDate >= @From)
		 AND (@To IS NULL OR AddDate <= @To)
		) outgo 
	WHERE RowNo > @DisplayStart AND RowNo <= (@DisplayStart + @DisplayLength)
	 
	 -- counts
	   SELECT Count(*) AS TableCount, SUM(VAT) AS TotalVATAmount FROM View_VatOutView 
		WHERE (@From IS NULL OR AddDate >= @From) AND (@To IS NULL OR AddDate <= @To)

	 --- settings
	 select Settings.Val from Settings where Attr = 'TRN'
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ClientPayments"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 161
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clients"
            Begin Extent = 
               Top = 8
               Left = 340
               Bottom = 137
               Right = 510
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClientPayments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_ClientPayments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[30] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Clients"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 163
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Invoices"
            Begin Extent = 
               Top = 24
               Left = 328
               Bottom = 154
               Right = 498
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvoiceDetails"
            Begin Extent = 
               Top = 34
               Left = 638
               Bottom = 190
               Right = 811
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 8325
         Alias = 1755
         Table = 1320
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Invoices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Invoices'
GO

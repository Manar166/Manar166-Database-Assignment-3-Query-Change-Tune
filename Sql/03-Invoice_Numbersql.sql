

----------------3.1------------------

CREATE SEQUENCE [finance].SeqNumber
AS BIGINT 
START WITH 1
INCREMENT BY 1 


-------------3.2-----------------------

INSERT INTO [finance].[Invoices]
(
[InvoiceNumber],[StudentId],
[TermId],[DueAtUtc],
[TotalAmount],[PaidAmount]
)

VALUES
('LAB-INV-2026-'+
RIGHT('000000'+CAST(NEXT VALUE FOR [finance].[SeqNumber] AS VARCHAR(20)),6),
10,14,DATEADD(DAY,30,SYSUTCDATETIME()),4500,0


)



----------------3.3--------------
BEGIN TRANSACTION

DECLARE @InvoiceNumber as BIGINT 

SET @InvoiceNumber=NEXT VALUE FOR [finance].[SeqNumber]

SELECT @InvoiceNumber AS NumberBeforeRollBack

ROLLBACK TRANSACTION 

SET @InvoiceNumber=NEXT VALUE FOR [finance].[SeqNumber]

SELECT @InvoiceNumber AS NumberAfterRollBack

----Rollback doesn't return back the sequential number



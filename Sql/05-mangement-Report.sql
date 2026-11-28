

select	 [Code] as [Course Code] 
		,[Title] As [Course Title]
		,[CreditHours] As [Credit Hours]

from [academic].[Courses]

order by[CreditHours] desc , [Title] asc
--------------------------5.2------------------------------------------------------

select top(5) Id,StudentNumber
from [identity].[StudentProfiles]
order by NEWID();


--------------------------5.3------------------------------------------------------
SELECT
    Id,
    Email
FROM [identity].[Users]
where DATALENGTH(Email)!=DATALENGTH(TRIM(Email))
--------------------------5.4------------------------------------------------------
SELECT
    Id,
    Email
FROM [identity].[Users]
WHERE Email COLLATE Latin1_General_100_CS_AS
      <> LOWER(Email) COLLATE Latin1_General_100_CS_AS;
--------------------------5.5------------------------------------------------------


SELECT Id, Email
FROM [identity].Users
WHERE Email NOT LIKE '%@%'
   OR Email LIKE '@%'
   OR Email NOT LIKE '%@%.%';
--------------------------5.6------------------------------------------------------
SELECT DISTINCT
   SUBSTRING(Email,
   CHARINDEX('@',Email)+1,
   LEN(Email)
    ) AS EmailProvider
FROM [identity].Users
WHERE CHARINDEX('@', Email) > 1
ORDER BY EmailProvider ASC;

--------------------------5.7------------------------------------------------------
SELECT
    Id,
    Email,
    LastLoginAtUtc
FROM [identity].Users
ORDER BY
    CASE WHEN LastLoginAtUtc IS NULL THEN 1 ELSE 0 END,
    LastLoginAtUtc DESC;
--------------------------5.8------------------------------------------------------
SELECT *
FROM [finance].[Payments]
WHERE PaidAtUtc >= '20261001'
  AND PaidAtUtc <  '20261101'
order by PaidAtUtc desc
--------------------------5.9------------------------------------------------------



SELECT
    Id,
    Amount,
    PaidAtUtc,
    PaidAtUtc AT TIME ZONE 'UTC'
              AT TIME ZONE 'Egypt Standard Time'
              AS PaidAtCairo
FROM finance.Payments
WHERE
    CAST(
        PaidAtUtc AT TIME ZONE 'UTC'
                  AT TIME ZONE 'Egypt Standard Time'
        AS TIME
    ) >= '00:00:00'
AND
    CAST(
        PaidAtUtc AT TIME ZONE 'UTC'
                  AT TIME ZONE 'Egypt Standard Time'
        AS TIME
    ) < '05:00:00';
--------------------------5.10------------------------------------------------------

SELECT *
FROM [attendance].[AttendanceSessions]
WHERE DATENAME(WEEKDAY, SessionDate) = 'Friday';

--------------------------5.11------------------------------------------------------
SELECT Id,PhoneNumber
FROM [identity].[Users]
WHERE LEN(PhoneNumber)=11
      AND
      PhoneNumber LIKE '010%' OR
      PhoneNumber LIKE '011%' OR
      PhoneNumber LIKE '012%' OR
      PhoneNumber LIKE '015%' AND
      PhoneNumber NOT LIKE '%[^0-9]%';


--------------------------5.12------------------------------------------------------
SELECT Id,
CASE 
WHEN PhoneNumber IS NULL THEN NULL
WHEN LEN(PhoneNumber)=11 THEN LEFT(PhoneNumber,3)
                        +REPLICATE('*',LEN(PhoneNumber)-5)
                        + RIGHT(PhoneNumber, 2)
    END AS MarkedPhone
FROM [identity].[Users]

--------------------------5.13------------------------------------------------------

SELECT
    InvoiceNumber,
    TRY_CAST(
        RIGHT(
            InvoiceNumber,
            CHARINDEX('-', REVERSE(InvoiceNumber)) - 1
        ) AS BIGINT
    ) AS RunningNumber
FROM finance.Invoices
ORDER BY RunningNumber asc;

--------------------------5.14------------------------------------------------------

SELECT
    Id,
    Title,
    CASE
        WHEN EstimatedMinutes IS NULL
            THEN 'Not set'
        ELSE
           CAST(EstimatedMinutes/60 AS varchar(10))
            + ' h '
            + CAST(EstimatedMinutes % 60 AS VARCHAR(10))
            + ' min'
    END AS LessonDuration
FROM content.Lessons;

--------------------------5.15------------------------------------------------------


SELECT
    Id,
    Title,
    Body
FROM communication.Announcements
WHERE Body LIKE '%[%]%';

--------------------------5.16------------------------------------------------------
SELECT TOP (5) WITH TIES
        [InvoiceNumber],
        [TotalAmount]
FROM [finance].[Invoices]
ORDER BY [TotalAmount] DESC


--------------------------5.17------------------------------------------------------

SELECT TOP (10) PERCENT
    Id,
    InvoiceId,
    Amount,
    PaidAtUtc
FROM finance.Payments
ORDER BY Amount DESC;

--------------------------5.18------------------------------------------------------
SELECT *
FROM [delivery].[Sections]
WHERE TRIM([Location])  != '%HALL A%'
OR Location IS NULL
--------------------------5.19------------------------------------------------------
SELECT [PaidAmount],
       [TotalAmount],
       TotalAmount-PaidAmount AS RemainingAmount ,

       CASE
       WHEN PaidAmount > 0 THEN 'Parially Paid'
       ELSE  'not Paid'
       End AS PaymentStatus ,
       
       CASE 
       WHEN DueAtUtc < SYSUTCDATETIME() THEN 'OverDue'
       ELSE 'Not OverDue'
       END AS DueStatus,

       CAST(PaidAmount*100.0/
             nullif(TotalAmount,0) as decimal(5,1)) as PaidPrecentage

FROM [finance].[Invoices]
WHERE PaidAmount < TotalAmount
ORDER BY RemainingAmount DESC;


--------------------------5.20------------------------------------------------------
DECLARE @PageSize int =20;
DECLARE @PageNumber  int = 3 ;

SELECT  Id,
       Email,
       CreatedAtUtc
FROM [identity].Users
ORDER BY CreatedAtUtc DESC, Id DESC
OFFSET (@PageNumber-1)*@PageSize rows
FETCH NEXT @PageSize ROWS ONLY;

--------------------------5.21------------------------------------------------------
DECLARE @LastSeenId BIGINT =50000

SELECT TOP (50)
    Id,
    ActorUserId
FROM operations.AuditLogs
WHERE Id>@LastSeenId
ORDER BY Id ASC;

--------------------------5.22------------------------------------------------------

SELECT TOP (10)
    Id,
    InvoiceId,
    Amount,
    PaidAtUtc
FROM finance.Payments
ORDER BY PaidAtUtc DESC, Id DESC;

--------------------------5.23------------------------------------------------------

SELECT TOP(10)
        UPPER(TRIM(TITLE)) AS LessonTitle,
        lEN(UPPER(TRIM(TITLE))) AS LessonLENGTH,

    CASE
    WHEN MAX(EstimatedMinutes) is null THEN 'NOT SET'
    WHEN MAX(EstimatedMinutes)<=15 THEN 'Quick'
    WHEN MAX(EstimatedMinutes)<=45 THEN 'standerd'
    else 'Long'
    End as DurationCategory

 FROM [content].[Lessons]
 WHERE IsPublished = 1
  AND LEN(TRIM(Title)) > 40

 GROUP BY UPPER(TRIM(Title))

 ORDER BY LessonLENGTH DESC ,LessonTitle ASC



--------------------------5.24------------------------------------------------------




SELECT TOP (12)
    CONVERT(CHAR(7), DueAtUtc, 120) AS DueMonth,
    [CurrencyCode],

    CASE
        WHEN PaidAmount > 0 THEN 'Partially Paid'
        ELSE 'Not Paid'
    END AS PaymentState,

    COUNT(*) AS InvoiceCount,
    SUM(TotalAmount - PaidAmount) AS TotalOutstanding

FROM finance.Invoices

WHERE DueAtUtc < SYSUTCDATETIME()
  AND PaidAmount < TotalAmount

GROUP BY
    CONVERT(CHAR(7), DueAtUtc, 120),
    [CurrencyCode],
    CASE
        WHEN PaidAmount > 0 THEN 'Partially Paid'
        ELSE 'Not Paid'
    END

ORDER BY DueMonth DESC, [CurrencyCode], PaymentState;





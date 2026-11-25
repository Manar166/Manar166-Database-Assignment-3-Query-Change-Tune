

---------1.1----------------
SELECT StudentId ,TotalAmount,PaidAmount ,
		TotalAmount-PaidAmount AS RemainingAmount,
		DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME()) AS LateDays
FROM [finance].[Invoices]
WHERE PaidAmount<TotalAmount
AND [DueAtUtc]<SYSUTCDATETIME()

-------------------1.2-------------
SELECT StudentId ,TotalAmount,PaidAmount ,
		TotalAmount-PaidAmount AS RemainingAmount,
		DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME()) AS LateDays,
	CASE 
	WHEN TotalAmount-PaidAmount >10000 OR DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>60 THEN 'Urgent' 
	WHEN DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>30 THEN 'Meduim'
	ELSE 'Low'
end As Priorty
FROM [finance].[Invoices]
WHERE PaidAmount<TotalAmount
AND [DueAtUtc]<SYSUTCDATETIME()

---------------1.3---------------------
SELECT StudentId ,TotalAmount,PaidAmount ,
		TotalAmount-PaidAmount AS RemainingAmount,
		DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME()) AS LateDays,
	CASE 
		WHEN TotalAmount-PaidAmount >10000 OR DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>60 THEN 'Urgent' 
		WHEN DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>30 THEN 'Meduim'
		ELSE 'Low'
		end As Priorty
FROM [finance].[Invoices]
WHERE PaidAmount<TotalAmount
AND [DueAtUtc]<SYSUTCDATETIME()
ORDER BY 
CASE 
	WHEN TotalAmount-PaidAmount >10000 OR DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>60 THEN 1 
	WHEN DATEDIFF(DAY,DueAtUtc,SYSUTCDATETIME())>30 THEN 2
	ELSE 3
	END , RemainingAmount DESC;





SELECT
    Id,
    TermCode,
    Name,
    StartDate
FROM delivery.AcademicTerms
ORDER BY StartDate DESC;


INSERT INTO [delivery].[Sections]
([CourseId],[TermId],[SectionCode],[Capacity])
SELECT
[CourseId],14,[SectionCode],[Capacity]
FROM [delivery].[Sections]
WHERE TermId=6

SELECT *
FROM [delivery].[Sections]
WHERE TermId=14

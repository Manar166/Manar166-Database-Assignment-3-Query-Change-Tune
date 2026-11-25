

------------------2.1-------------------

INSERT INTO [academic].[Departments] (Code,Name)
VALUES ('DSAI', N'Data Science & Artificial Intelligence');


-------------------------2.2----------------
INSERT INTO [academic].[Courses] 
	([DepartmentId],[Code],[Title],[CreditHours],[PassingScore])

	VALUES(18,'DSAI-101','Introduction to Data Analysis ',3,60)

	----------------------2.3----------------
INSERT INTO [delivery].[AcademicTerms]
	([AcademicYear],[TermCode],[Name],
	[StartDate],[EndDate],
	[RegistrationStartDate],[RegistrationEndDate])

VALUES(2026,'Summer','Summer-2027',
			'20270615','20270831',
			'20270501','20270610')

----------------------2.4----------------------
INSERT INTO communication.Announcements
(
    Title,
    Body,
    CreatedByUserId
)
VALUES
(
    N'Summer 2027 Registration',
    N'Registration for Summer 2027 opens on May 1, 2027.',
    1
);

------------2.5---------------------
INSERT INTO [identity].[Roles]
(
	[Code],
	[Name]

)

VALUES ('TEACHING_ASSIATANTS','Teaching Assistants');


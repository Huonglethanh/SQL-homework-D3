--I. Calculation
--Ex1: row count= 459
SELECT
	len(EventName) as 'Lenth',
	EventName
FROM
	tblEvent te
order by
	Lenth ASC ;
--Ex2: row count=459
SELECT
	te .EventName ,
	tc .CategoryName,
	CONCAT(te.EventName, '', tc.CategoryName) as 'List Out'
FROM
	tblEvent te
left join tblCategory tc on
	te .CategoryID = tc .CategoryID ;
--Ex3: row count=8
--1st solution
SELECT
	ContinentName ,
	isnull(Summary,
	'No Summary') as 'SubSummary'
FROM
	tblContinent tc;
--2nd solution
SELECT
	ContinentName ,
	case
		when Summary is null then 'No Summary'
		else Summary
	end as 'Subsummary'
from
	tblContinent tc ;
--3rd solution
SELECT
	ContinentName,
	COALESCE (Summary,
	'No summary') as 'Subsummay'
FROM
	tblContinent tc;
--Ex4: row count=43
SELECT
	ContinentID ,
	CountryName ,
	case
		when ContinentID in (1, 3) then 'Eurasia'
		when ContinentID in (5, 6) then 'Americas'
		when ContinentID in (2, 4) then 'Somewhere hot'
		WHEN ContinentID = 7 then 'Somewhere cold'
		else 'Somewhere else'
	end as 'Belongto'
FROM
	tblCountry tc;
--Ex5: row count= 196
SELECT
	Country ,
	KmSquared,
	(KmSquared%20761) as 'Arealeftover',
	((KmSquared-(KmSquared%20761))/ 20761) as 'Waleunits',
	concat ((KmSquared-(KmSquared%20761))/ 20761,
	'x Wale plus',
	KmSquared %20761),
	(20761-KmSquared) as 'Difference'
FROM
	CountriesByArea cba
order by
	ABS (20761-KmSquared) ASC ;
--Ex6: row count=7
SELECT
	*
FROM
	tblEvent te
WHERE
	LEFT (EventName,
	1) in ('a', 'e', 'u', 'i', 'o')
	AND 
RIGHT (EventName,
	1) in ('a', 'e', 'u', 'i', 'o');
--Ex7: row count=21
SELECT
	*
FROM
	tblEvent te
WHERE
	LEFT (EventName,
	1)= RIGHT (EventName,
	1);
--III. Aggregation and GROUPING 
--Ex1: row count=25
SELECT
	ta .AuthorName ,
	count (te.Title) as 'total episode',
	min(te.EpisodeDate) as 'firstdate',
	max(te.EpisodeDate) as 'lastdate'
FROM
	tblAuthor ta
left join tblEpisode te on
	ta.AuthorId = te .AuthorId
group by
	ta .AuthorName
order by
	ta. AuthorName ASC ;
--Ex2: row count= 18
SELECT
	tc.CategoryName,
	Count (*) as 'Number of events'
FROM
	tblEvent te
left join tblCategory tc on
	te .CategoryID = tc .CategoryID
group by
	tc .CategoryName;
--Ex3: row count =1
SELECT
	count (*) as 'number of events',
	MAX(EventDate) as 'last date',
	MIN(EventDate) as 'first date'
FROM
	tblEvent te2 ;
--Ex4:
-- Sort by ContinentName- row count= 6
SELECT
	tc .ContinentName,
	count (EventName) as 'number of events'
FROM
	tblEvent te
left join tblCountry tc2 on
	tc2 .CountryID = te .CountryID
left join tblContinent tc on
	tc .ContinentID = tc2 . ContinentID
WHERE
	tc.ContinentName != 'Europe'
	and tc .ContinentName != 'Not applicable'
group by
	tc . ContinentName;
--Sort by CountryName-row count=42
SELECT
	tc. ContinentName AS Continent,
	tc2. CountryName AS Country,
	COUNT(*) as 'Number of events'
FROM
	tblContinent tc
INNER JOIN tblCountry tc2 
		ON
	tc .ContinentID = tc2 .ContinentID
INNER JOIN tblEvent te 
		ON
	te .CountryID = tc2 .CountryID
GROUP BY
	tc.ContinentName,
	tc2.CountryName;
--Ex5: row count=4

SELECT
	CONCAT(ta.AuthorName, '', td.DoctorName) as combination, 
	COUNT(te.Title) as 'Number of episodes'
FROM
	tblAuthor ta
inner join tblEpisode te on
	ta .AuthorId = te .AuthorId
inner join tblDoctor td on
	td .DoctorId = te . DoctorId
group by
	ta .AuthorName ,
	td .DoctorName
HAVING 
	COUNT(te.Title)> 5;
--Ex6: row count=4
SELECT
	te2 . EnemyName,
	count(te.Title) as 'Number of Episodes',
	YEAR (te .EpisodeDate ),
	YEAR (td.BirthDate)
FROM
	tblEpisode te
inner join tblDoctor td on
	te .DoctorId = td .DoctorId
inner join tblEpisodeEnemy tee on
	tee .EpisodeId = te .EpisodeId
inner join tblEnemy te2 on
	te2 .EnemyId = tee . EnemyId
WHERE
	Year(td.BirthDate) < 1970
group BY
	te2 .EnemyName,
	YEAR (te .EpisodeDate ),
	YEAR (td.BirthDate)
HAVING
	COUNT(te.Title) >1;
--Ex7: row count= 12
SELECT
	upper(left(tc.CategoryName, 1)) AS 'Category initial',
	COUNT(*) as 'Number of events',
	AVG(len (te.EventName)) as 'Average event name length'
FROM
	tblCategory tc
INNER JOIN tblEvent te 
		ON
	tc.CategoryID = te .CategoryID
GROUP BY
	upper(left(tc.CategoryName, 1))
ORDER BY
	'Category initial';
--Ex8: row count=5
SELECT 
	CASE
		WHEN year(te.EventDate) < 1800 THEN '18th century'
		WHEN year(te.EventDate) < 1900 THEN '19th century'
		WHEN year(te.EventDate) < 2000 THEN '20th century'
		ELSE '21st century'
	END AS 'Century',
	COUNT(*) AS 'Number events'
FROM
	tblEvent te
GROUP BY
	cube
(CASE
		WHEN year(te.EventDate) < 1800 THEN '18th century'
		WHEN year(te.EventDate) < 1900 THEN '19th century'
		WHEN year(te.EventDate) < 2000 THEN '20th century'
		ELSE '21st century'
	end)
ORDER BY
	Century;
--III.Calculations using dates
--Ex1: ROW COUNT= 5

SELECT
	te.EventName,
	FORMAT(te.EventDate,
	'dd MM yyyy') AS 'Formating'
FROM
	tblEvent te
WHERE
	year(te.EventDate) = 1998
ORDER BY	
	te.EventDate;
--Ex2:
SELECT
	EventName ,
	FORMAT(te .EventDate,
	'dd MMM yyyy') AS 'Event date',
	ABS (DATEDIFF(day, '19980720', te.EventDate)) as 'Difference days'
FROM
	tblEvent te
order by
	'Difference days' ASC ;
--Ex3: 459
SELECT
	EventName ,
	EventDate ,
	DATENAME(weekday, EventDate) as 'date of weekday',
	DAY (EventDate) as 'number of day'
FROM
	tblEvent te
order by
	'number of day' ASC;
--Ex4: ROW COUNT=459
/*SELECT CONCAT((DATENAME(weekday, EventDate),'',(DAY (EventDate) as 'number of date'),case when datepart (day, EventDate ) in (1,21,31) then 'st'
WHEN datepart(day,EventDate) IN (2,22)  THEN 'nd'
 WHEN datepart(day,EventDate) IN (3,23)  THEN 'rd'
		ELSE 'th'end as 'day number format'),
(MONTH (EventDate) as 'Month') , (YEAR (EventDate) as 'Year')) as' full date'
FROM tblEvent te ;*/
--Whether can we solve this excercise with CONCAT?


SELECT
	te .EventName ,
	DateName(weekday, te.EventDate) + ' ' + 
	DateName(day, te.EventDate) + 
	CASE 
		WHEN DatePart(day, te.EventDate) IN (1, 21, 31) THEN 'st'
		WHEN DatePart(day, te.EventDate) IN (2, 22) THEN 'nd'
		WHEN DatePart(day, te.EventDate) IN (3, 23) THEN 'rd'
		ELSE 'th'
	END + ' ' +
	DATENAME(month, te.EventDate) + ' ' +
	DATENAME(year, te.EventDate) AS 'Full date'
FROM
	tblEvent te ;

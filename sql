--Zadanie 23/2.01a Pivoting
--[master][doctor][profesor]
--23/2.01a Nazwy wszystkich katedr, w których pracuje co najmniej jeden wykładowca (w pierwszej kolumnie), trzy tytuły naukowe: doctor, master, full professor (w pierwszym wierszu) oraz liczbę godzin zajęć prowadzonych w ramach każdej katedry przez każdą z tych trzech grup pracowników. Użyj składni CTE. 8 rekordów. W Department of Economics tylko pracownicy master prowadzą zajęcia (60 godzin) W Department of Informatics doctors mają 15 godzin, masters 12 a full professors 30 
--CTE skladnia
WITH pivotdata AS 
(
 SELECT 
 l.department, acad_position , no_of_hours
 FROM lecturers l left join modules m on l.lecturer_id=m.lecturer_id 
 -- zew polaczenie
)
SELECT department , [doctor] , [master] , [full professor]
--INTO #h                       --export pivota #<-- tabela tymczasowa
FROM pivotdata

PIVOT (
SUM (no_of_hours)
FOR acad_position IN ([doctor] , [master] , [full professor])

) AS P




--Druga skladnia --> derrived table
SELECT * FROM
(
 SELECT 
 l.department, acad_position , no_of_hours
 FROM lecturers l left join modules m on l.lecturer_id=m.lecturer_id 
) AS src

PIVOT (
SUM (no_of_hours)
FOR acad_position IN ([doctor] , [master] , [full professor])

) AS P


--wywolywanie tymczasowej tabeli:
--select * from #h

--unpivoting
 SELECT department , acad_position , no_of_hours
 FROM #h 
UNPIVOT (
no_of_hours FOR acad_position
IN ([doctor],[master],[full professor])
) AS u

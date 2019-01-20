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
--window function

--Skill 2.3/3. Using window functions 
 
--23/3.01 Identyfikatory studentów, daty i kwoty dokonanych przez nich wpłat a także sumy wpłat dla każdego studenta oddzielnie 
--(w tej kolumnie wartości dla każdego studenta mają być takie same) i, w ostatniej kolumnie, sumy wszystkich wpłat 
--(w tej kolumnie wszystkie wartości maję być takie same). 
--Dane posortowanie według identyfikatorów studentów a następnie daty wpłat. 
--73 rekordy. Pierwszy rekord:  1, 2019-10-26, wpłata dzienna: 1300,   suma wpłat studenta: 1670, suma wszystkich wpłat: 70820 Przedostatni rekord: 32, 2019-12-06, 1320, 3220, 7082

SELECT student_id  , date_of_payment  , fee_amount as wplata_dzienna, 
          SUM(fee_amount) OVER(PARTITION BY student_id  )AS Fee_total ,
          SUM(fee_amount) OVER() AS Fee_total_total
FROM tuition_fees
ORDER BY student_id , date_of_payment 


--23/3.02 Identyfikatory i nazwiska studentów, daty i kwoty dokonanych przez nich wpłat a także, dla każdej pozycji,
-- jaką część sumy wpłat dokonanych przez danego studenta stanowiła dana pozycja oraz jaką część sumy wszystkich wpłat stanowiła ta pozycja. 
--73 rekordy. Trzeci rekord:  2, Palmer, 2018-10-30, wpłata: 450, procent dla student 1: 100,   procent sumy wszystkich wpłat: 0.64 
SELECT student_id  , date_of_payment  , fee_amount ,
CAST (100.0 * fee_amount / (SUM(fee_amount) OVER(PARTITION BY student_id  )) AS procent_1 
FROM tuition_fees

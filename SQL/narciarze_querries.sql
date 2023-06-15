USE narciarze;

--1--
SELECT imie,nazwisko,DATEDIFF(YEAR,data_ur,GETDATE()) AS wiek
FROM zawodnicy
ORDER BY wiek desc,nazwisko
--3--
SELECT imie,nazwisko
FROM zawodnicy
WHERE LEFT(imie,1) = LEFT(nazwisko,1)
--4--
SELECT imie,nazwisko
FROM zawodnicy 
LEFT JOIN uczestnictwa_w_zawodach ON uczestnictwa_w_zawodach.id_skoczka = zawodnicy.id_skoczka
WHERE uczestnictwa_w_zawodach.id_skoczka IS NULL

--5--
SELECT imie,nazwisko,COUNT(uczestnictwa_w_zawodach.id_skoczka) as Ilosc_zawodow
FROM zawodnicy LEFT JOIN uczestnictwa_w_zawodach ON zawodnicy.id_skoczka = uczestnictwa_w_zawodach.id_skoczka
GROUP BY  zawodnicy.imie,zawodnicy.nazwisko

--7--
SELECT z.imie,z.nazwisko,s.nazwa
FROM zawodnicy z JOIN uczestnictwa_w_zawodach u ON z.id_skoczka = u.id_skoczka JOIN zawody za ON za.id_zawodow = u.id_zawodow JOIN skocznie s ON s.id_skoczni = za.id_skoczni

--11--
SELECT k.kraj 
FROM kraje k LEFT JOIN zawodnicy z ON z.id_kraju = k.id_kraju
WHERE z.id_kraju IS NULL

--14--
select kraj 
from kraje k left join skocznie s 
on k.id_kraju = s.id_kraju 
join zawody z  
on s.id_skoczni = z.id_skoczni 
group by kraj having count(id_zawodow) = (select top 1 count(id_zawodow) as max from  kraje k left join skocznie s on k.id_kraju = s.id_kraju join zawody z  on s.id_skoczni = z.id_skoczni group by kraj order by max desc);



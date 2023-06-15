USE biuro;

-- 1
SELECT k.imie, k.nazwisko FROM klienci k
	WHERE k.telefon IS NULL
	ORDER BY LEN(k.nazwisko) DESC;

-- 2
SELECT k.imie, k.nazwisko FROM klienci k
	INNER JOIN wynajecia w ON k.klientnr = w.klientnr
	WHERE w.nieruchomoscnr
	IN (SELECT w2.nieruchomoscnr
		FROM wizyty w2
		WHERE w2.klientnr = k.klientnr)
	GROUP BY k.klientnr, k.imie, k.nazwisko ;


-- 3
SELECT k.imie, k.nazwisko FROM klienci k
	LEFT JOIN wynajecia w ON k.klientnr = w.klientnr
	WHERE w.czynsz > k.max_czynsz
	GROUP BY k.klientnr, k.imie, k.nazwisko ;



-- 4
SELECT k.imie, k.nazwisko, COUNT(w.nieruchomoscnr) AS liczba_nieruchomosci FROM klienci k
	LEFT JOIN wizyty w ON k.klientnr = w.klientnr
    WHERE w.data_wizyty < (
        SELECT TOP 1 w2.od_kiedy FROM wynajecia w2
        WHERE w2.klientnr = k.klientnr
        ORDER BY w2.od_kiedy DESC
    )
	GROUP BY k.klientnr, k.imie, k.nazwisko
    HAVING COUNT(w.nieruchomoscnr) > 1

-- 5
SELECT k.imie, k.nazwisko, n.nieruchomoscnr
    FROM klienci k, nieruchomosci n
    WHERE k.max_czynsz > n.czynsz;

-- 6
SELECT w.imie, w.nazwisko
    FROM wlasciciele w
    JOIN nieruchomosci n on w.wlascicielnr = n.wlascicielnr
    GROUP BY w.wlascicielnr, w.imie, w.nazwisko
    HAVING COUNT(n.nieruchomoscnr) = (
        SELECT TOP 1 COUNT(n2.wlascicielnr)
            FROM nieruchomosci n2
            GROUP BY n2.wlascicielnr
            ORDER BY COUNT(n2.wlascicielnr) DESC
        );

-- 7
SELECT w.imie, w.nazwisko, n.nieruchomoscnr
    FROM wlasciciele w
    JOIN nieruchomosci n on w.wlascicielnr = n.wlascicielnr;



-- 8
SELECT b.biuronr, (
    SELECT COUNT(p1.plec)
        FROM personel p1
        WHERE p1.plec = 'K' AND p1.biuronr = b.biuronr) AS K,
       (SELECT COUNT(p1.plec)
        FROM personel p1
        WHERE p1.plec = 'M' AND p1.biuronr = b.biuronr) AS M
    FROM biura b;

-- 9
SELECT DISTINCT b.miasto, (
    SELECT COUNT(p1.plec)
        FROM personel p1
        JOIN biura b2 on p1.biuronr = b2.biuronr
        WHERE p1.plec = 'K' AND b.miasto = b2.miasto) AS K,
       (SELECT COUNT(p1.plec)
        FROM personel p1
        JOIN biura b3 on p1.biuronr = b3.biuronr
        WHERE p1.plec = 'M' AND b.miasto = b3.miasto) AS M
    FROM biura b;

-- 10
SELECT DISTINCT p.stanowisko, (
    SELECT COUNT(p1.plec)
        FROM personel p1
        WHERE p1.plec = 'K' AND p1.stanowisko = p.stanowisko) AS K,
       (SELECT COUNT(p1.plec)
        FROM personel p1
        WHERE p1.plec = 'M' AND p1.stanowisko = p.stanowisko) AS M
    FROM personel p;

--11
SELECT b.biuronr 
FROM biura b LEFT JOIN nieruchomosci n ON b.biuronr = n.biuronr
WHERE n.biuronr IS NULL

--12

SELECT DISTINCT STUFF(k.adres,1,7,'') as miasto
FROM klienci k LEFT JOIN (SELECT DISTINCT miasto from biura) b ON STUFF(k.adres,1,7,'') = b.miasto
WHERE b.miasto IS  NULL

--16
SELECT nieruchomoscnr, SUM(czynsz) as Laczny_czynsz
FROM wynajecia
GROUP BY nieruchomoscnr

--17
SELECT TOP 1 nieruchomoscnr
FROM wizyty 
GROUP BY nieruchomoscnr
ORDER BY count(nieruchomoscnr) DESC

--19
select umowanr, datediff(day, od_kiedy, do_kiedy) as czas_wynajmu_dni
	from wynajecia;
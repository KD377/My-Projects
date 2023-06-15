select title, g.name
from tracks t join genres g on t.genre_id = g.genre_id
where SUBSTRING(title,1,1) = SUBSTRING(g.name,1,1) 

select first_name,last_name
from customers c join orders o on c.customer_id = o.customer_id
where DATEDIFF(day,o.order_date,getdate()) <= 730

SELECT name
from artists a left join albums b on b.artist_id=a.artist_id
where b.artist_id is null

--5-
SELECT a.name
FROM artists a
JOIN albums al ON a.artist_id = al.artist_id
GROUP BY a.name
having count(al.artist_id) = (select top 1 count(artist_id)
from albums
group by artist_id
order by count(artist_id) desc)


-- kolejne-
select a.album_id
from albums a join artists ar on a.artist_id = ar.artist_id
where LEN(ar.name) = LEN(a.title)

select c.first_name as imiê, c.last_name as nazwisko
from customers c join orders o on c.customer_id = o.customer_id
where datename(weekday,o.order_date) = 'Friday' or datename(weekday,o.order_date) = 'Saturday'
GROUP BY c.customer_id,c.first_name,c.last_name

select g.name
from genres g left join tracks t on t.genre_id=g.genre_id
where t.genre_id is null

select p.name, MIN(t.price) as cena
from playlists p join playlists_tracks pt on p.playlist_id = pt.playlist_id join tracks t on t.track_id = pt.track_id
GROUP BY p.name,p.playlist_id
HAVING MIN(t.price) < 0.5

SELECT t.title
from tracks t join orders_tracks ot on ot.track_id = t.track_id 
GROUP BY t.title 
having count(ot.track_id) = (select top 1 count(ot2.track_id)
from tracks t2 join orders_tracks ot2 on ot2.track_id = t2.track_id 
GROUP BY t2.title 
order BY count(ot2.track_id) desc)

select a.name, t.title
from artists a join  albums al on al.artist_id = a.artist_id join tracks t on t.album_id = al.album_id
GROUP BY a.name
HAVING MIN(t.milliseconds) = (SELECT top 1 MIN(t2.milliseconds)
from artists a2 join  albums al2 on al2.artist_id = a2.artist_id join tracks t2 on t2.album_id = al2.album_id
GROUP BY a.name
ORDER BY MIN(t2.milliseconds) desc)


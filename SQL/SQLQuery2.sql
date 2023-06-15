
select b.publication_date
from books b join publishers p on p.publisher_id = b.publisher_id
where LEN(b.title) = LEN(p.name)
order by b.pages

select g.name as gatunek
from genres g join books_genres bg on bg.genre_id = g.genre_id join books b on b.book_id = bg.book_id
where datename(weekday,b.publication_date) = 'Saturday' 


select a.first_name,a.last_name
from authors a left join books_authors ba on ba.author_id = a.author_id
where ba.author_id is null

select r.first_name, r.last_name
from readers r join orders o on o.reader_id = r.reader_id
GROUP BY r.first_name,r.last_name,r.reader_id
HAVING count(o.order_date) = (select top 1 count(o2.order_date)
from readers r2 join orders o2 on o2.reader_id = r2.reader_id
GROUP BY r2.first_name,r2.last_name,r2.reader_id
order by count(o2.order_date) desc)
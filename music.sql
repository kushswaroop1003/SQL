use music;

select * from employee;

/* Q1: Who is the senior most employee based on job title? */

select  top 1 * from employee
order by levels desc;
or
select  * from employee
order by levels desc
limit 1;

/* Q2: Which countries have the most Invoices? */

select top 1 billing_country,count(invoice_id) from invoice
group by (billing_country)
order by count(invoice_id) desc;

Ans: USA-131

/* Q3: What are top 3 values of total invoice? */

select top 3 * from invoice
order by total desc;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

Select * from invoice;

select top 1 billing_city,sum(total) from invoice
group by billing_city
order by sum(total) desc;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select * from customer
select * from invoice;



select top 1 c1.customer_id, c1.first_name, c1.last_name, sum(c2.total) as 'Billing Total'
from invoice c2
inner join customer c1
on c1.customer_id = c2.customer_id
group by c1.customer_id,c1.first_name, c1.last_name
order by sum(total) desc;


/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

#select name, last name, email and genre name only for rock

select distinct c1.email,c1.first_name,c1.last_name,genre.name
from customer c1
inner join invoice c2
on c1.customer_id = c2.customer_id
inner join invoice_line
on c2.invoice_id = invoice_line.invoice_id
inner join track
on invoice_line.track_id = track.track_id
inner join genre
on track.genre_id = genre.genre_id where genre.name like 'rock'
order by first_name;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select * from track;

select top 10 artist.name, genre.name as 'genre',count(genre.name) as 'Count of Albums'
from artist
inner join album1
on artist.artist_id = album1.artist_id
inner join track
on album1.album_id = track.track_id
inner join genre
on track.genre_id = genre.genre_id where genre.name like 'rock'
group by artist.name, genre.name
order by count(artist.artist_id) desc ;


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track
where milliseconds >(select avg(milliseconds) as 'Average length' from track)
order by milliseconds desc;



/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

select * from customer;
select * from artist;
select * from invoice;

select customer.customer_id,customer.first_name, round(sum(invoice.total),2) as 'Amount Spent', artist.name as 'Artist Name' 
from customer
inner join invoice
on customer.customer_id = invoice.customer_id
inner join invoice_line
on invoice.invoice_id = invoice_line.invoice_id
inner join track
on track.track_id = invoice_line.track_id
inner join album1
on track.album_id = album1.album_id
inner join artist
on album1.artist_id = artist.artist_id
group by customer.customer_id,customer.first_name,invoice.total, artist.name
order by artist.name, sum(invoice.total) desc

select * from invoice_line;
select * from artist;

WITH best_selling_artist AS (
  SELECT TOP 1 WITH TIES
    artist.artist_id AS 'Artist Id',
    artist.name AS 'Artist Name',
    SUM(invoice_line.unit_price * invoice_line.quantity) AS 'total Sales'
  FROM invoice_line
  JOIN track ON track.track_id = invoice_line.track_id
  JOIN album1 ON track.album_id = album1.album_id
  JOIN artist ON artist.artist_id = album1.artist_id
  GROUP BY artist.artist_id, artist.name
  ORDER BY 'total Sales' DESC
)
SELECT *
FROM best_selling_artist;

select customer.customer_id,customer.first_name,bsa.artist_name,
sum(il.unit_price * il.quantity) as 'Amount Spent'
from invoice i
join customer
on customer.customer_id = i.invoice_id
join invoice_line il
on il.invoice_id = i.invoice_id
join track t
on t.track_id = il.track_id
join album1
on album1.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = album1.artist_id
group by 1,2,3,4
order by 5 desc)
select * FROM best_selling_artist;


#Country and its most popular genre

	select c.country,genre.name, round(sum(il.unit_price*il.quantity),1)as 'Total Sales'
	from customer c
	join invoice i
	on c.customer_id = i.customer_id
	join invoice_line il
	on i.invoice_id = il.invoice_id
	join track t
	on il.track_id = t.track_id
	join genre
	on t.genre_id = genre.genre_id
	group by c.country,genre.name
	order by 3 desc;

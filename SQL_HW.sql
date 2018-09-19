USE sakila;
Select * from staff;

-- 1A
Select first_name, last_name from actor;


-- 1B
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Actor_Name
FROM   actor as a;


-- 2A
SELECT * from actor 
where first_name='JOE';

-- 2B
SELECT * from actor 
where last_name like '%GEN%';

-- 2C
SELECT last_name, first_name from actor 
where last_name like '%LI%';

-- 2D
select country_id, country 
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3A
ALTER TABLE actor ADD Description  blob(200) NULL;
 
 -- 3B
ALTER TABLE actor DROP Description;
  
  -- 4A
SELECT last_name, COUNT(last_name) as 'count' from actor
group by last_name;
  
  -- 4B
SELECT last_name, COUNT(last_name) as 'name_count' from actor
group by last_name
having name_count >=2;

-- 4C
UPDATE actor SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' 
AND last_name = 'WILLIAMS';

SELECT * FROM actor 
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 4D
UPDATE actor SET first_name = CASE WHEN first_name = 'HARPO' THEN 'GROUCHO'  END WHERE actor_id = 172;

SELECT * FROM actor 
WHERE  last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address_pk; 
CREATE TABLE IF NOT EXISTS address_pk ( 
address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT, 
address varchar(50) NOT NULL, 
district varchar(20) NOT NULL, 
city_id smallint(5) unsigned NOT NULL, 
postal_code varchar(10) DEFAULT NULL, 
phone varchar(20) NOT NULL, 
location geometry NOT NULL, 
last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
PRIMARY KEY (address_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 6A****

SELECT staff.first_name, staff.last_name, address.address, city.city, country.country FROM staff 
INNER JOIN address ON staff.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id;

-- 6B**
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS revenue_received FROM staff 
INNER JOIN payment ON staff.staff_id = payment.staff_id 
WHERE payment.payment_date 
LIKE '2005-08%' 
GROUP BY payment.staff_id;

-- 6C
SELECT title, COUNT(actor_id) AS count_of_actors FROM film 
INNER JOIN film_actor ON film.film_id = film_actor.film_id 
GROUP BY title;

-- 6D
SELECT title, COUNT(inventory_id) as count_of_copies FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible' ;

-- 7A
SELECT title FROM film 
WHERE language_id 
IN (SELECT language_id FROM language WHERE name = "English" ) AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7B
SELECT last_name, first_name FROM actor 
WHERE actor_id 
IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = "Alone Trip"));

-- 7C
SELECT customer.last_name, customer.first_name, customer.email FROM customer 
INNER JOIN customer_list ON customer.customer_id = customer_list.ID 
WHERE customer_list.country = 'Canada';

-- 7D
SELECT title FROM film 
WHERE film_id 
IN (SELECT film_id FROM film_category WHERE category_id IN (SELECT category_id FROM category WHERE name = 'Family'));

-- 7E
SELECT film.title, COUNT(rental_rate) AS 'rent_count' FROM film, inventory, rental 
WHERE film.film_id = inventory.film_id AND rental.inventory_id = inventory.inventory_id 
GROUP BY inventory.film_id 
ORDER BY COUNT(rental_rate) 
DESC, film.title ASC;

-- 7F
SELECT store.store_id, SUM(amount) AS revenue FROM store 
INNER JOIN staff ON store.store_id = staff.store_id 
INNER JOIN payment ON payment.staff_id = staff.staff_id 
GROUP BY store.store_id;

-- 7G
SELECT store.store_id, city.city, country.country FROM store 
INNER JOIN address ON store.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id;


-- 7H

SELECT name, SUM(p.amount) AS gross_revenue FROM category c 
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN inventory i ON i.film_id = fc.film_id 
INNER JOIN rental r ON r.inventory_id = i.inventory_id 
RIGHT JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY name 
ORDER BY gross_revenue 
DESC LIMIT 5;


-- 8A
DROP VIEW IF EXISTS top_five_genres; CREATE VIEW top_five_genres AS

SELECT name, SUM(p.amount) AS gross_revenue FROM category c 
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN inventory i ON i.film_id = fc.film_id 
INNER JOIN rental r ON r.inventory_id = i.inventory_id 
RIGHT JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY name 
ORDER BY gross_revenue 
DESC LIMIT 5;

-- 8B
SELECT * FROM top_five_genres;

-- 8C

DROP VIEW top_five_genres;






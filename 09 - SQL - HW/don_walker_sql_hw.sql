use sakila;

-- 1A - Display first and last name columns of actor table
	select first_name , last_name
		from actor;
        
-- 1B - Combine actor first and last names into one column         
        select 
			upper (
			concat 
            (first_name," ", last_name)
            )
			as actor_name
			from actor;
        
 -- 2A - Query to find actor ID, and last name with first name "Joe" 
        select * 
			from actor 
			where first_name = "Joe";
            
 -- 2B - Query to find all actors whose last name contain the letters "GEN"
		select *
			from actor
            where last_name
            like "%GEN%";

-- 2C - Query to find all actors whose last name contains "LI"
		select *
			from actor
            where last_name
            like "%LI%"
            order by last_name, first_name asc;
            
-- 2D -  Display the country_id and country columns of : Afghanistan, Bangladesh, and China:
		select country_id,country
			from country
            where country in ('Afghanistan', 'Bangladesh', 'China');
        
-- 3A - Insert description column into actor table
		alter table actor
        add description blob;

-- 3B - delete description column
        alter table actor
        drop description;
        
 -- 4A -  List the last names of actors, as well as how many actors have that last name.      
		select count(actor_id), last_name
			from actor
			group by last_name;

-- 4B -  Same as 4A but only for names that are shared by at least two actors
        select count(actor_id), last_name
			from actor
			group by last_name
            having count(actor_id) > 1;

-- 4C - replace GROUCHO WILLIAMS WITH HARPO WILLIAMS
		update actor
        set first_name = 'HARPO'
        where first_name = 'GROUCHO';
        
-- 4D - change HARPO WILLIAMS back to GROUCHO WILLIAMS        
        update actor
        set first_name = 'GROUCHO'
        where first_name  = 'HARPO';
        --  confirm rows were changed correctly
        select first_name, last_name
        from actor
        where last_name = 'WILLIAMS';
        
-- 5A - Display query would you use to re-create address table
		show create table address;

-- 6A - Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
        select staff.first_name, staff.last_name,address.address
        from staff
        join address on
        staff.address_id = address.address_id;

-- 6B - Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
        select sum(payment.amount) , staff.staff_id,staff.first_name, staff.last_name
        from payment
        join staff on
        payment.staff_id = staff.staff_id
		where payment.payment_date
		like '2005-08%'
        group by staff.staff_id;

-- 6C -  List each film and the number of actors for that film. Use tables film_actor and film. Use inner join.
        select count(film_actor.actor_id), film.title
        from film_actor
        join film on
        film_actor.film_id = film.film_id
        group by film.title;

-- 6D - How many copies of film Hunchback Impossible in inventory
        select count(inventory.film_id), film.title
        from inventory
        left join film
			on inventory.film_id = film.film_id
            where film.title = 'Hunchback Impossible'
            group by film.title;

-- 6E - Using the tables payment and customer and JOIN, list the total paid by each customer. List customers alphabetically by last name
		select customer.first_name, customer.last_name, sum(payment.amount)
        from customer
        left join payment
			on customer.customer_id = payment.customer_id
            group by customer.customer_id
            order by customer.last_name asc;
            
-- 7A - Use subqueries to display the movie titles starting with K and Q in English.
        select title
        from film
        where title like 'K%'
        or 
		title like 'Q%'
        and
        language_id in
		(
			select language_id
			from language
			where name = 'English'
			);
			
-- 7B - Use subqueries to display all actors who appear in the film Alone Trip
		select first_name, last_name
        from actor
        where actor_id in
        (
			select actor_id
            from film_actor
            where film_id in
            (
				select film_id
                from film
                where title = 'Alone Trip'
                )
			);

-- 7C - names and emails of Canadian customers. Use joins
        select customer.first_name, customer.last_name, customer.email
        from customer
        join address on
        customer.address_id = address.address_id
        join city on
        city.city_id = address.city_id
        join country on
        country.country_id = city.country_id
        where country.country = 'Canada';

-- 7D - Identify all movies categorized as family films
		select title
		from film
		where film_id in
        (
			select film_id
            from film_category
            where category_id in
            (
				select category_id
                from category
                where name = 'family'
                )
			);
            
-- 7E - Display the most frequently rented movies in descending order.
		select title, rental_rate
        from film
        order by rental_rate desc;

-- 7F. Write a query to display how much business, in dollars, each store brought in.
		select sum(total_sales) , store
        from sales_by_store
        group by store;

-- 7G. Write a query to display for each store its store ID, city, and country
		select store.store_id, city.city, country.country
        from store
        join address on
        store.address_id = address.address_id
        join city on
        city.city_id = address.city_id
        join country on
        country.country_id = city.country_id;

-- 7H - List the top 5 genres in gross revenue in desc order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
		select category,total_sales
        from sales_by_film_category
        order by total_sales desc
        limit 5;

-- 8A - create view of 7H
		create view top_5_money_makers as
        select category,total_sales
        from sales_by_film_category
        order by total_sales desc
        limit 5;
                
-- 8B - display view in 8A
		select *
        from top_5_money_makers;

-- 8C - drop view created in 8A
		drop view top_5_money_makers;

  
            
            
            
            
      
      
      
      
      
      
      
      
      
      
        
        
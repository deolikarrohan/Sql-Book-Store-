CREATE TABLE Books(
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(100),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);

SELECT * FROM Books;

DROP TABLE Books;

COPY Books (Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Program Files\PostgreSQL\17\data\Books SQL.csv'
CSV HEADER;

CREATE TABLE Customers(
Customer_ID INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone INT,
City VARCHAR(100),
Country VARCHAR(100)
);

SELECT * FROM Customers;

DROP TABLE IF EXISTS Orders

CREATE TABLE Orders(
Order_ID INT PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID) ,
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

SELECT * FROM Orders;
SELECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;

COPY Orders (Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM '‪C:\Users\ASUS\Desktop\satish dhawale sir\SQL\project sql\Orders.csv'
DELIMITER'
CSV HEADER;

 --1) Retrieve all books in the "Fiction" genre:

SELECT title , genre
FROM Books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950:

SELECT title, published_year
FROM Books
WHERE Published_year>1950;

-- 3) List all customers from the Canada:

SELECT name, country
FROM customers
WHERE Country='Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM orders
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_stock
FROM Books,


-- 6) Find the details of the most expensive book:

SELECT * FROM books
Order By Price Desc
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT c.name, o.quantity
FROM customers c 
JOIN  orders o ON c.customer_id = o.customer_id
WHERE quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT genre
FROM books;

-- 10) Find the book with the lowest stock:

SELECT * FROM Books
Order By stock 
limit 1;


-- 11) Calculate the total revenue generated from all orders:

 SELECT SUM(total_amount) AS Total_revenue
 FROM orders


-- 1) Retrieve the total number of books sold for each genre:

SELECT B.genre, sum(O.quantity) AS total_sold
FROM orders o
JOIN  books b ON o.book_id = b.book_id
GROUP BY genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT genre, AVG(price) AS Avg_price
FROM books
WHERE genre='Fantasy'
GROUP BY genre;

-- 3) List customers who have placed at least 2 orders:

SELECT c.name, COUNT (o.order_id)
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
HAVING COUNT (order_id)>=2;


-- 4) Find the most frequently ordered book:

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM books b
JOIN orders o ON o.book_id = b.book_id
GROUP BY o.book_id, b.title 
ORDER BY order_count desc 
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM books
WHERE genre='Fantasy' 
ORDER BY price desc limit 3

-- 6) Retrieve the total quantity of books sold by each author:

SELECT B.author, sum(O.quantity) AS total_book_sold
FROM orders o
JOIN  books b ON o.book_id = b.book_id
GROUP BY author;

-- 7) List the cities where customers who spent over $30 are located:

	SELECT
	C.NAME,
	C.CITY,
	O.TOTAL_AMOUNT
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE
	TOTAL_AMOUNT >= 30;


-- 8) Find the customer who spent the most on orders:

SELECT
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
	GROUP BY 	C.NAME
ORDER BY TOTAL_SPENT DESC ;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id
;


--10) Find the top spending customer in each country based on total order amount.

 SELECT * FROM 
 (SELECT c.name, c.country, SUM(o.total_amount) AS total_spent,
 RANK() OVER(PARTITION BY c.country ORDER BY SUM(o.total_amount) DESC) AS rank
  FROM customers c
 JOIN orders o ON c.customer_id = o.customer_id
 GROUP BY c.name, c.country) 
WHERE rank=1;
 
--11) Calculate running total of sales over time.

SELECT order_date, SUM(total_amount) As daily_sales,
SUM(SUM(total_amount)) OVER (ORDER BY order_date ) AS running_total
FROM orders 
GROUP BY order_date;


--12) Find the most sold book (by quantity) in each genre.

SELECT * FROM(
SELECT b.book_id, b.title, b.genre, SUM(o.quantity) AS total_sold,
ROW_NUMBER() OVER (partition by b.genre ORDER BY SUM(o.quantity)DESC )AS rn
FROM books b
JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title)
WHERE rn=1;

SELECT * FROM Orders;
SELECT * FROM Books;
SELECT * FROM Customers;

--13) Rank customers based on number of orders placed.

SELECT c.name, COUNT(o.order_id) AS total_orders ,
DENSE_RANK() OVER(ORDER BY COUNT(o.order_id) DESC) AS rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY  c.name










--1. What are the Top 5 Most Frequently Ordered Product Categories?
--Insight: Helps identify the most popular product categories.

SELECT p.category, COUNT(oi.product_id) AS order_count
FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY order_count DESC
LIMIT 5


--2. What is the Average Order Value (AOV) for all customer orders?
--Insight: Helps evaluate customer spending habits.

SELECT ROUND(AVG(price),2) AS average_order_value
FROM order_items

--3. Who are the Top 10 Most Active Users based on the number of orders placed?
--Insight: Identifies the most frequent customers.

SELECT o.user_id , u.name , COUNT(o.order_id) AS total_orders
FROM users u 
JOIN orders o ON u.user_id = o.user_id
GROUP BY  o.user_id, u.name
ORDER BY total_orders DESC
LIMIT 10

--4. At what hour of the day do most orders occur?
--Insight: Helps in managing peak-hour demand.

SELECT EXTRACT(HOUR FROM order_date) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1

--5. Which orders had the longest delivery times?
--Insight: Helps analyze inefficiencies in delivery times.

SELECT  o.order_id, d.delivery_time - o.order_date AS delivery_time_minutes
FROM orders o
LEFT JOIN deliveries d ON o.order_id = d.order_id
WHERE delivery_time IS NOT NULL
ORDER BY delivery_time_minutes DESC
LIMIT 5

--6. What is the total revenue contribution of each product category?
--Insight: Shows which product categories drive revenue.

SELECT p.category, SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC

--7. What is the average delivery time in different cities or areas?
--Insight: Helps optimize delivery times in different regions.

SELECT r.assigned_area, 
       ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_date)) / 60),1) 
	   AS avg_delivery_time_min
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN riders r ON d.rider_id = r.rider_id
GROUP BY r.assigned_area
ORDER BY avg_delivery_time_min

--8. How do Online Payments compare to Cash on Delivery in terms of transaction volume and revenue?
--Insight: Helps evaluate payment method preferences and revenue impact.

SELECT payment_method, 
       COUNT(*) AS total_transactions, 
	   SUM(oi.price) AS total_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY payment_method
Order BY total_revenue DESC

--9. What is the reorder rate of top-selling products?
--Insight: Identifies frequently reordered products.

SELECT p.name, COUNT(o.order_id) AS total_orders, COUNT(DISTINCT o.user_id) AS unique_users,
       COUNT(o.order_id) / COUNT(DISTINCT o.user_id) AS reorder_rate
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY reorder_rate DESC
LIMIT 10;

--10. What is the percentage of late deliveries in each city?
--Insight: Identifies cities with the highest late deliveries.

SELECT r.assigned_area, 
       ROUND(COUNT(CASE 
	          WHEN d.delivery_time > o.order_date + INTERVAL '10 minutes' 
			  THEN 1 END) * 100 / COUNT(*),2) AS late_delivery_percentage
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN riders r ON d.rider_id = r.rider_id
GROUP BY r.assigned_area
ORDER BY late_delivery_percentage DESC

--11. Which customers have not placed any orders in the last 3 months?
--Insight: Helps identify inactive customers for re-engagement campaigns.

SELECT u.user_id, u.name, u.email
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_date IS NULL OR o.order_date < CURRENT_DATE - INTERVAL '3 months'

--12. How can users be segmented into High, Medium, and Low-frequency buyers based on their order history?
--Insight: Helps categorize customers for targeted marketing.

SELECT user_id, COUNT(order_id) AS total_orders,
       CASE 
           WHEN COUNT(order_id) >= 10 THEN 'High'
           WHEN COUNT(order_id) BETWEEN 4 AND 9 THEN 'Medium'
           ELSE 'Low'
       END AS customer_segment
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC

--13. Which time slots experience the highest order cancellations?
--Insight: Helps manage order cancellations effectively.

SELECT EXTRACT(HOUR FROM order_date) AS order_hour, COUNT(*) AS cancellation_count
FROM orders
WHERE status = 'Cancelled'
GROUP BY order_hour
ORDER BY cancellation_count DESC

--14. What is the average delivery speed of riders, and who are the fastest/slowest ones?
--Insight: Helps identify the most efficient and slowest delivery personnel.

SELECT r.rider_id, r.name, 
       ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_date)) / 60),2) 
	   AS avg_delivery_time_min
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN riders r ON d.rider_id = r.rider_id
GROUP BY r.rider_id, r.name
ORDER BY avg_delivery_time_min ASC

--15. Which warehouses are running low on inventory and need restocking?
--Insight: Helps in inventory management and replenishment planning.

SELECT warehouse_location, product_id, stock_quantity
FROM inventory
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC

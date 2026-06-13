# 📦 Brazilian E-Commerce Analysis (Olist) using SQL

## 📖 Project Overview

This project analyzes the Brazilian E-Commerce Public Dataset (Olist) using SQL to uncover customer behavior, sales performance, seller efficiency, payment trends, logistics performance, and customer retention patterns.

The objective is to transform raw transactional data into actionable business insights and support data-driven business decisions.

---

## 🎯 Business Objectives

* Analyze customer purchasing behavior
* Measure Customer Lifetime Value (CLV)
* Identify repeat customers and retention trends
* Evaluate seller performance and cancellation rates
* Analyze revenue trends and customer contribution
* Understand product category performance
* Assess delivery and logistics efficiency
* Examine customer satisfaction drivers

---

## 🛠️ Tools & Technologies

* MySQL
* SQL
* MySQL Workbench
* Git
* GitHub

---

## 📂 Dataset

The Olist Brazilian E-Commerce Dataset contains information related to:

* Customers
* Orders
* Order Items
* Products
* Sellers
* Payments
* Reviews

### Key Tables Used

* customer
* orders
* orderitem
* product
* seller
* orderpayment
* orderreview

---

# 🗂️ Entity Relationship Diagram (ERD)

```text
customer
│
├── customer_id (PK)
│
▼
orders
├── order_id (PK)
├── customer_id (FK)
│
├──────────────► orderpayment
│                └── order_id (FK)
│
├──────────────► orderreview
│                └── order_id (FK)
│
└──────────────► orderitem
                 ├── order_id (FK)
                 ├── product_id (FK)
                 └── seller_id (FK)
                           │
                           ▼
                        seller
                        └── seller_id (PK)

orderitem
│
└──────────────► product
                 └── product_id (PK)
```

> Add actual ERD screenshot in the repository and replace this diagram with an image.

```markdown
![ERD](Screenshots/olist_erd.png)
```

---

# 📊 SQL Analysis Performed

## Customer Analytics

* Top Customers by Total Spend
* Customer Lifetime Value (CLV)
* Repeat Customer Analysis
* Monthly Active Customers (MAC)
* Customer Retention Analysis
* First Purchase vs Repeat Purchase Analysis

## Revenue Analytics

* Monthly Revenue Trend
* Average Order Value (AOV)
* Revenue Contribution of Top 20% Customers
* Pareto (80/20) Analysis

## Seller Analytics

* Top Sellers by Order Volume
* Seller Cancellation Rate Analysis

## Product Analytics

* Most Popular Product Category
* Category-wise Revenue Analysis
* Products Never Sold
* Product Categories with Highest Cancellation Rate

## Logistics Analytics

* Delivery Performance by State
* Late Delivery Percentage
* Average Delivery Delay
* Shipping Delay Impact on Customer Reviews

---

# 🔥 Sample Advanced SQL Queries

## 1. Customer Lifetime Value (CLV)

```sql
SELECT
    c.customer_unique_id,
    ROUND(SUM(op.payment_value),2) AS customer_lifetime_value
FROM customer c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN orderpayment op
    ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;
```

---

## 2. Revenue Contribution of Top 20% Customers

```sql
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) revenue
    FROM customer c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN orderpayment op
        ON o.order_id = op.order_id
    GROUP BY 1
),

ranked AS (
    SELECT *,
           NTILE(5) OVER(ORDER BY revenue DESC) AS customer_bucket
    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(CASE WHEN customer_bucket = 1 THEN revenue END)
        *100/
        SUM(revenue),2
    ) AS top_20_percent_contribution
FROM ranked;
```

---

## 3. Customer Retention Analysis

```sql
WITH monthly_orders AS (
    SELECT
        customer_id,
        DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS order_month
    FROM orders
),

retention AS (
    SELECT
        customer_id,
        order_month,
        LEAD(order_month)
            OVER(
                PARTITION BY customer_id
                ORDER BY order_month
            ) AS next_month
    FROM monthly_orders
)

SELECT
    order_month,
    COUNT(DISTINCT customer_id) customers,
    COUNT(DISTINCT CASE
        WHEN next_month IS NOT NULL
        THEN customer_id
    END) retained_customers
FROM retention
GROUP BY 1;
```

---

## 4. Delivery Delay Impact on Customer Reviews

```sql
SELECT
    CASE
        WHEN order_delivered_customer_date >
             order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On Time'
    END AS delivery_status,

    ROUND(AVG(review_score),2) avg_review_score

FROM orders o
JOIN orderreview r
    ON o.order_id = r.order_id

WHERE order_status='delivered'

GROUP BY 1;
```

---

# 📈 Advanced SQL Concepts Used

* Joins
* Common Table Expressions (CTEs)
* Window Functions
* Aggregate Functions
* Date Functions
* CASE Statements
* Subqueries
* Cohort Analysis
* Customer Retention Analysis
* Pareto Analysis
* Ranking Functions
* NTILE()
* LEAD() / LAG()

---

# 📌 Key Findings & Insights

## Customer Insights

* High-value customers generated a significant share of total revenue.
* Customer retention declined across subsequent months.
* Repeat customers represented a smaller percentage of total customers but contributed meaningful revenue.
* Monthly Active Customer trends revealed changing engagement patterns.

## Revenue Insights

* Top 20% of customers contributed approximately 53.77% of total revenue.
* Revenue distribution followed the Pareto principle.
* Average Order Value provided a benchmark for customer spending behavior.

## Seller Insights

* Several sellers showed significantly higher cancellation rates.
* Seller-level analysis revealed operational inefficiencies affecting customer experience.

## Logistics Insights

* Approximately 8% of delivered orders arrived later than the estimated delivery date.
* Around 92% of deliveries were completed on time.
* Late deliveries received lower review scores on average.
* Delivery performance varied considerably across states.

---

# 💡 Business Recommendations

* Implement customer loyalty and retention programs.
* Focus marketing campaigns on high-value customer segments.
* Closely monitor sellers with elevated cancellation rates.
* Improve logistics performance in underperforming regions.
* Reduce delivery delays to increase customer satisfaction and ratings.

---

# 🚀 Key Learning Outcomes

* Solved 40+ real-world business problems using SQL.
* Built customer retention and CLV analysis.
* Applied advanced SQL concepts including CTEs and Window Functions.
* Generated business insights from large-scale e-commerce data.
* Developed analytical thinking and business problem-solving skills.

---

# 📁 Project Structure

```text
Brazilian-Ecommerce-Analysis
│
├── Dataset
├── SQL Queries
├── Business Questions
├── Results
├── Screenshots
├── README.md
└── ERD
```

---

# 👨‍💻 Author

**Shivam Kumar Mishra**

Aspiring Data Analyst

📧 Email: [your-email@example.com](mailto:your-email@example.com)

💼 LinkedIn: https://linkedin.com/in/your-profile

💻 GitHub: https://github.com/githubshivamMishra

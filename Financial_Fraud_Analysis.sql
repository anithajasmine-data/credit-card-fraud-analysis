-- like creating a folder
/* Create a schema named finance, set finance as the default schema, 
and create tables with cc_data.csv and location_data.csv */
create schema finance;  -- like creating a folder
use finance;
CREATE TABLE cc_data (
    `index` int,
    trans_date varchar(50),
    cc_num varchar(30),
	merchant varchar(255),
    category varchar(100),
    amt decimal(10,2),
	first varchar(100),
	last varchar(100),
	gender char(1),
	street VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(10),
	zip VARCHAR(20),
	lat decimal(10,6),
	`long` decimal(10,6),
	city_pop int,
	job varchar(255),
	dob date,
	trans_num VARCHAR(50),
	unix_time bigint,
	merch_lat decimal(10,6),
	merch_long decimal(10,6),
	is_fraud tinyint
    );
    select * from cc_data limit 5;
CREATE TABLE location_data (
    cc_num VARCHAR(30),
    lat DECIMAL(10,6),
    `long` DECIMAL(10,6)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/locationdata_1774189281759.csv'
INTO TABLE location_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



SELECT COUNT(*) FROM cc_data;
-- The cc_data table contains 389176 rows

-- ---------- DATA EXPLORATION L----------
-- Calculate the total number of transactions in the cc_data table
select COUNT(*) as total_transactions
from cc_data;
-- The cc_data table contains 389176 total tracsactions

-- Identify the top 10 most frequent merchants in the cc_data table
select * from cc_data limit 5;
select merchant,count(*) as transaction_count
from cc_data
group by merchant
order by transaction_count desc limit 10;

-- Find the average transaction amount for each category of transactions in the cc_data table
select category, avg(amt) as average_transaction_amount
from cc_data
group by category;

/* Determine the number of fraudulent transactions and the percentage
 of total transactions that they represent */
select
	count(case when is_fraud = 1 then 1 end) as fraud_count,
	(count(case when is_fraud = 1 then 1 end) * 100/count(*)) as fraud_percentage
    from cc_data;
/* THE DATA SET CONTAINS 2,253 FRADULENT TRANSACTIONS,WHIch represent
approximately 0.58% of total transactions */
    
/*  Join the cc_data and location_data tables to identify 
the latitude and longitude of each transaction */
select * from cc_data limit 10;
select * from location_data limit 10;
select c.cc_num,c.merchant,c.amt,l.lat,l.long
from cc_data as c 
join location_data as l
on c.cc_num = l.cc_num limit 10;

-- Identify the city with the highest population in the location_data table
select * from location_data limit 10;
describe location_data;
-- There is no city name and population in this table.Since data is missing here

-- Find the earliest and latest transaction dates in the cc_data table
select 
    min(trans_date_trans_time) as earliest_date,
    max(trans_date_trans_time) as latest_date
from cc_data;    

/* Using Data Aggregation with SQL:
What is the total amount spent across all transactions in the cc_data table? */
select * from cc_data limit 10;
select sum(amt) as total_amount_spent from cc_data;
-- the total amount spent across all transactions are '27415041.290000737'

-- How many transactions occurred in each category in the cc_data table?
select category, count(*) as transaction_count 
from cc_data
group by category;

-- What is the average transaction amount for each gender in the cc_data table?
select gender,avg(amt) as transaction_amount
from cc_data group by gender;

-- Which day of the week has the highest average transaction amount in the cc_data table?
select DAYNAME(trans_date_trans_time) AS day_of_week,
avg(amt) as avg_amount
from cc_data
group by day_of_week
order by avg_amount desc
limit 1;

-- Register the Python UDF
REGISTER 'task2udf.py' USING jython AS PriceCategory;

-- Load the cust_order.csv data from /input directory in HDFS
cust_order = LOAD 'hdfs:///input/cust_order.csv' USING PigStorage(',') AS (order_id:int, order_date:chararray, customer_id:int, shipping_method_id:int, dest_address_id:int);

-- Load the order_line.csv data from /input directory in HDFS
order_line = LOAD 'hdfs:///input/order_line.csv' USING PigStorage(',') AS (line_id:int, order_id:int, book_id:int, price:double);

-- Join the two datasets based on order_id
joined_data = JOIN cust_order BY order_id, order_line BY order_id;

-- Remove double quotes from order_date
cleaned_data = FOREACH joined_data GENERATE *, REPLACE(cust_order::order_date, '"', '') AS cleaned_order_date;

-- Extract the year, month, and day using ToDate and related functions
extracted_date = FOREACH cleaned_data
GENERATE
    CONCAT('(',
           (chararray)GetYear(ToDate(cleaned_order_date, 'yyyy-MM-dd HH:mm:ss')),
           ',',
           (chararray)GetMonth(ToDate(cleaned_order_date, 'yyyy-MM-dd HH:mm:ss')),
           ',',
           (chararray)GetDay(ToDate(cleaned_order_date, 'yyyy-MM-dd HH:mm:ss')),
           ')') AS order_day,
    cust_order::order_id AS order_id,  -- Specify the source of order_id
    order_line::book_id AS book_id,
    order_line::price AS price;

-- Group by the extracted date
grouped_by_date = GROUP extracted_date BY order_day;

-- Aggregate the data
aggregated_data = FOREACH grouped_by_date {
    unique_orders = DISTINCT extracted_date.order_id;
    num_orders = COUNT(unique_orders);
    num_books = COUNT(extracted_date.book_id);
    total_price = SUM(extracted_date.price);
    GENERATE group AS order_day, num_books AS num_books, num_orders AS num_orders, total_price AS total_price;
}

-- Categorize the total_price using the Python UDF
categorized_data = FOREACH aggregated_data GENERATE order_day, num_books, num_orders, total_price, PriceCategory.price_category(total_price) AS note;

-- Order the results by total_price in descending order
ordered_data = ORDER categorized_data BY total_price DESC;

-- Store the results
STORE ordered_data INTO 'hdfs:///output/task2' USING PigStorage('\t');
# Handling Big Data with Apache Pig

## Overview

This project demonstrates how to process large datasets stored on Hadoop Distributed File System (HDFS) using Apache Pig scripts. It includes two main tasks: querying and analyzing data stored in CSV files to generate insights, such as the number of orders, the number of books sold, and total price for each day. Additionally, a custom User Defined Function (UDF) is used to categorize order totals into high, medium, and low value.

## Files

- **task1.pig**: Apache Pig script for the first task, which processes `cust_order.csv` and `order_line.csv` files to calculate daily order statistics.
- **task2.pig**: Apache Pig script for the second task, which extends Task 1 by categorizing orders based on their total price using a UDF.
- **task2udf.py**: Python script implementing the UDF for categorizing orders as "high value," "medium," or "low value."
- **cust_order.csv**: Input data containing customer order details.
- **order_line.csv**: Input data containing details of books sold and their prices.
- **README.md**: Instructions to run the tasks on Hadoop.

## Prerequisites

- AWS CLI installed and configured.
- Python 3.x.
- Apache Pig installed on Hadoop.

## Steps to Run Tasks on AWS EMR

1. **Enter Jumphost**:
   ```bash
   ssh jumphost
   ```

2. **Create Directory**:
   ```bash
   mkdir assignment
   ```

3. **Exit Jumphost**:
   ```bash
   exit
   ```

4. **Move Files to Jumphost**:
   ```bash
   scp -i [PATH_TO_PRIVATE_KEY] [LOCAL_PATH_TO_FILES] [REMOTE_USER]@[REMOTE_HOST]:/home/ec2-user/assignment/
   ```

   Example:
   ```bash
   scp -i "/Users/marwan/Desktop/Big Data/s3969393-cosc2637.pem" /Users/marwan/Desktop/assignment2_bigdata/* ec2-user@s3969393.jump.cosc2637.route53.aws.rmit.edu.au:/home/ec2-user/assignment
   ```

5. **Enter Jumphost Again**:
   ```bash
   ssh jumphost
   ```

6. **Give Permissions**:
   ```bash
   chmod +x *
   ```

7. **Create Cluster**:
   ```bash
   ./create_cluster.sh
   ```

8. **Move to Assignment Directory**:
   ```bash
   cd assignment
   ```

9. **Move Files to Hadoop**:
   ```bash
   scp -i [PATH_TO_PRIVATE_KEY] * hadoop@s3969393.emr.cosc2637.route53.aws.rmit.edu.au:/home/hadoop
   ```

10. **Enter Hadoop**:
    ```bash
    ssh hadoop@s3969393.emr.cosc2637.route53.aws.rmit.edu.au -i s3969393-cosc2637.pem
    ```

11. **Create HDFS Input Directory**:
    ```bash
    hdfs dfs -mkdir /input
    ```

12. **Move Input Files to HDFS**:
    ```bash
    hdfs dfs -put cust_order.csv /input/
    hdfs dfs -put order_line.csv /input/
    ```

13. **Execute Task 1**:
    ```bash
    pig -x mapreduce -f task1.pig
    ```

14. **Execute Task 2**:
    ```bash
    pig -x mapreduce -f task2.pig
    ```

15. **View Task 1 Output**:
    ```bash
    hdfs dfs -cat /output/task1/part-*
    ```

16. **View Task 2 Output**:
    ```bash
    hdfs dfs -cat /output/task2/part-*
    ```

## Task Descriptions

1. **Task 1**: 
   - Processes the `cust_order.csv` and `order_line.csv` files to output daily order statistics, including:
     - Order date.
     - Number of orders.
     - Number of books sold.
     - Total price.

2. **Task 2**: 
   - Extends Task 1 by using a Python UDF to categorize total prices into "high value," "medium," or "low value" based on defined thresholds.

## Output Format

Task 1 output:
```
(order_day)    num_orders    num_books    total_price
```

Task 2 output:
```
(order_day)    num_orders    num_books    total_price    note
```

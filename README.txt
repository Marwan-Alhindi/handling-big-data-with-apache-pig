Instructions to run tasks:

1. Enter jumphost by the following command:
- ssh jumphost
2. Create a directory:
- mkdir assignment
3. Exit jumphost:
- exit
4. Move all the files from local computer to jumphost (to assignment directory):
- scp -i [PATH_TO_PRIVATE_KEY] [LOCAL_PATH_TO_FILES] [REMOTE_USER]@[REMOTE_HOST]:[REMOTE_PATH]
- E.g mine would be like this: scp -i "/Users/marwan/Desktop/Big Data/s3969393-cosc2637.pem" /Users/marwan/Desktop/assignment2_bigdata/* ec2-user@s3969393.jump.cosc2637.route53.aws.rmit.edu.au:/home/ec2-user/assignment
5. Enter jumphost again:
- ssh jumphost
6. Give permession for all files
- chmod +x *
- Incase the key file is in jumphost type: chmod 400 [key file name]
7. Create a cluster:
- ./create_cluster.sh
8. Go to assignment directory:
- cd assignment
9. Move all files to hadoop:
- scp -i [PATH_TO_PRIVATE_KEY] [LOCAL_PATH_TO_FILES] [REMOTE_USER]@[REMOTE_HOST]:[REMOTE_PATH]
- E.g mine would be like this: scp -i "/home/ec2-user/s3969393-cosc2637.pem" * hadoop@s3969393.emr.cosc2637.route53.aws.rmit.edu.au:/home/hadoop
10. Go back to main directory:
- cd
11. Get the command to enter hadoop:
- cat instructions
12. Enter hadoop:
- E.g mine would be like this: ssh hadoop@s3969393.emr.cosc2637.route53.aws.rmit.edu.au -i s3969393-cosc2637.pem
- You need to change it to your key.
13. Create an input directory:
- hdfs dfs -mkdir /input
14. Move input files to the directory (if already exists, skip):
- hdfs dfs -put cust_order.csv /input/
- hdfs dfs -put order_line.csv /input/
15. Execute task1:
- pig -x mapreduce -f task1.pig
16. Execute task2:
- pig -x mapreduce -f task2.pig
17. View output:
- hdfs dfs -cat hdfs:///output/task1/part-*
- hdfs dfs -cat hdfs:///output/task2/part-*
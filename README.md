#Big Data Programming Project 1 Read me file

#CLI BASH
1.copy the crime_data_australia_answers.sh and avg_crime.sh present in the 'scripts' folder into the directory containing the crimedata-australia.csv dataset.
2.give required execution permission to the script
3. execute crime_data_australia_answers.sh using below command
./crime_data_australia_answers.sh


#SQL and MongoDB
SQL:
1.copy all files in the 'queries' folder into directory containing the Players.csv & Teams.csv dataset and from where you want to run the script to populate the databases.
2.give required execution permission to the scripts
3. FOR SQL queries:
	3.1 execute the queries in createTables.sql file in your selected database first.
	3.2 execute populate_players.sh and populate_teams.sh scripts.
	3.3 execute the queries in sqlQueries.sql.
4. For MongoDB queries:
	4.1 create new database (use slinky)
	4.2 create tables in selected database using following commands:
		db.createCollection("Teams");
		db.createCollection("Players");
	4.3 execute following commands from the mongo instance. Make sure the dataset exists in same path.
		(you might need to change username(-u) password(-p) and database name(-d) according to your own)
		mongoimport -u slinky -p atCBaS4Fqm --authenticationDatabase 'slinky' --type csv -d slinky -c Teams --headerline --drop Teams.csv

		mongoimport -u slinky -p atCBaS4Fqm --authenticationDatabase 'slinky' --type csv -d slinky -c Players --headerline --drop Players.csv
	4.4 execute the queries present in mongoDBqueries.js in the database environment.

#Hadoop

1.create a directory in hadoop filesystem
	hadoop dfs -mkdir /taxi_dataset
2.verify if the directory has been created using hdfs dfs -ls / command
3.Place the yellow_tripdata_2019-01.csv files into namenode using below command 
	sudo docker cp yellow_tripdata_2019-01.csv f91b82013009:yellow_tripdata_2019-01.csv 
	(Please note the f91... id will vary according to the id of the namenode you will be running)
4.Copy all the java files in the 'hadoop files' folder given in the zip into hdfs using same command as above and changing file name accordingly.
5. Connnect to namenode using following command:
	sudo docker exec -it namenode bash
6. Copy the above dataset file and java files into home folder in the namenode.(cp command) 
	eg: cp yellow_tripdata_2019-01.csv home/
7. cd to home folder using cd home
8. Load dataset into hdfs using following command:
	hdfs dfs -put yellow_tripdata_2019-01.csv /taxi_dataset
9. Run following commands for each Java file by changing file name, jar name and output directory name accordingly.
	hadoop com.sun.tools.javac.Main AveragePassengerPerHourWeekday.java
	jar cf avgweekday.jar AveragePassengerPerHourWeekday*.class
	hadoop jar avgweekday.jar AveragePassengerPerHourWeekday /taxi_dataset /taxi_dataset_q4_weekday
10. For question number 3 in hadoop assignment run the PaymentTypes.sh script in the 'hadoop files' folder from  the directory containing the dataset.
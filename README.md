# Neoway-liquid-exercise
Neoway liquid exercise to create a matching table between business record and liquor license;
# create database
Download and setup MySQL.
Create database main_business and two tables business_record and liquor_license using file createtables.SQL. 
* Put csv files into the same location as MySQL.
# Create clean functions and match query
See file query.SQL.
install UDF function PREG_CAPTURE.Follow instructions in https://github.com/mysqludf/lib_mysqludf_preg. 
# Matching rate:111/388(28.6%) in liquor_license table
See matching table in file query_result.csv.
# Create a bot to capture license data using Python
See the code in liquorbot.py and result in licenseinformation.text.

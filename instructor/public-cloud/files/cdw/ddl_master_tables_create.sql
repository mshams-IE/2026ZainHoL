DROP DATABASE IF EXISTS master_data CASCADE;
CREATE DATABASE IF NOT EXISTS master_data;

DROP TABLE IF EXISTS master_data.contract;
CREATE TABLE IF NOT EXISTS master_data.contract (id STRING, description STRING) STORED BY 'org.apache.iceberg.mr.hive.HiveIcebergStorageHandler' STORED AS PARQUET;
INSERT INTO master_data.contract
values('1', 'Month-to-month'),
('2', 'One year'),
('3', 'Two year');

DROP TABLE IF EXISTS master_data.misc;
CREATE TABLE IF NOT EXISTS master_data.misc (id STRING, description STRING) STORED BY 'org.apache.iceberg.mr.hive.HiveIcebergStorageHandler' STORED AS PARQUET;
INSERT INTO master_data.misc 
values('Y', 'Yes'),
('N', 'No'),
('F', 'Female'),
('M', 'Male'),
('1', 'Yes'), 
('0', 'No');
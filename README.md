### **README – FleetLogix Data Engineering Project**

Author: Juan Pablo Peña Gutiérrez

## DISCLAIMER (SOME DOCUMENTS, REPORTS, AND WORKBOOKS ARE IN SPANISH; THESE FILES WILL BE TRANSLATED SOON)

#### **Overview**

FleetLogix is a comprehensive data engineering project that simulates the real-world ecosystem of a modern logistics company.




### Over the course of 4 phases, the following was built:

* A transactional database in PostgreSQL with thousands of records generated using Faker.
* A set of operational queries optimized with indexes.
* A Snowflake data warehouse based on a dimensional model.
* A professional, fully automated ETL pipeline in Python.
* A serverless architecture on AWS designed for real-time ingestion, processing, and analysis



The project replicates the complete data lifecycle: from generation in operational systems to utilization in high-performance analytical environments.


#### **Project Objectives**

1. Simulate the data environment of a real logistics company.
2. Create a scalable transactional database.
3. Design a reporting model using SQL queries and indexes.
4. Implement a robust data warehouse in Snowflake.
5. Automate a realistic and modular ETL process.
6. Design a modern, serverless architecture on AWS.





#### **Project Structure**

Translated with DeepL.com (free version)### **README – FleetLogix Data Engineering Project**

Author: Juan Pablo Peña Gutiérrez

## DISCLAIMER (SOME DOCUMENTS, REPORTS, AND WORKBOOKS ARE IN SPANISH; THESE FILES WILL BE TRANSLATED SOON)

#### **Overview**

FleetLogix is a comprehensive data engineering project that simulates the real-world ecosystem of a modern logistics company.




### Over the course of 4 phases, the following was built:

* A transactional database in PostgreSQL with thousands of records generated using Faker.
* A set of operational queries optimized with indexes.
* A Snowflake data warehouse based on a dimensional model.
* A professional, fully automated ETL pipeline in Python.
* A serverless architecture on AWS designed for real-time ingestion, processing, and analysis



The project replicates the complete data lifecycle: from generation in operational systems to utilization in high-performance analytical environments.


#### **Project Objectives**

1. Simulate the data environment of a real logistics company.
2. Create a scalable transactional database.
3. Design a reporting model using SQL queries and indexes.
4. Implement a robust data warehouse in Snowflake.
5. Automate a realistic and modular ETL process.
6. Design a modern, serverless architecture on AWS.


#### **Project Structure**

Project\_FleetLogix\_JuanPablo/
│
├── /reports
│   ├── ERD\_FleetLogix.pdf
│   ├── reporte_avance1.pdf
│   ├── reporte_avance2.pdf
│   ├── reporte\_avance3.pdf
│   ├── reporte_avance4.pdf
|
├── notebooks
│   ├──.env
│   ├── 03_etl_pipeline.py
│   ├── 03_dimensional_model_snowflake.sql
│   ├── 02_optimization_indexes.sql
│   ├── 02_queries_operativas.sql
│   ├── 01_schema_postgres.sql
│
├── data
│   ├── 01_data_generation_faker.py
│
└── README.md   


#### **Phased Development**


###### Phase 1 – Transactional Model + Data Generation

#### Activities Completed
- Design of the ER diagram for the transactional database.
- Creation of the complete schema in PostgreSQL.
- Mass data generation using Faker, NumPy, and Pandas, respecting foreign keys.
- Mass insertion using batch inserts.
- Referential integrity validation.

**Results**
- Database populated with consistent and complete data.
- Environment ready for operational testing and analytical queries.



######Milestone 2 – Operational Queries + Optimization

#### Activities Performed

- Development of 12 operational queries, including:
- Daily KPIs
- Delays
- Driver rankings
- Fuel efficiency
- Metrics by route, vehicle, and customer
- Creation of indexes to improve execution times.

**Results**
- Reduction in execution times by up to 90% for the heaviest queries.
- Organized and documented SQL repository.  




###### Milestone 3  Data Warehouse + Automated ETL

#### Activities Performed

### Construction of the star schema in Snowflake:
dim\_date
dim\_time
dim\_driver (SCD Type 2)
dim\_vehicle (SCD Type 2)
dim\_route
dim\_customer
fact\_deliveries



### Implementation of the professional ETL pipeline:

- Extraction from PostgreSQL
- Advanced transformations
- Incremental loads
- Pre-calculation of metrics
- Error handling
- Advanced logging
- Daily automation with schedule


**Results** 

- Full data load with advanced metrics such as:
- deliveries per hour
- fuel efficiency
- revenue per delivery
- real-time delivery status
- Snowflake serving as the central data warehouse.




###### Update 4: Proposed Architecture (AWS)

### 1️ API Gateway
- Acts as the **entry point** for drivers’ mobile apps.
- Receives delivery events in JSON format.
- Allows mobile apps to be decoupled from the backend.

### 2️ AWS Lambda
**Three main Lambda functions** are proposed:
- **Delivery completion verification**
- **Estimated Time of Arrival (ETA) calculation**
- **Route deviation detection and alert generation**

The functions are designed to run in an **event-driven** manner, without dedicated servers.

### 3️ Amazon S3
- Storage of historical data.
- File organization by date (`year/month/day`).
- Ideal for later analysis and low cost.

### 4️ Amazon RDS (PostgreSQL)
- Conceptual migration of the local database.
- Managed relational database.
- Used for structured and transactional data.

### 5️ Amazon DynamoDB
- Storage of the **current delivery status**.
- High read/write speeds.
- Ideal for real-time operational data.

---

### 6 Security and Best Practices
- Do not hardcode credentials or passwords.
- Conceptual use of environment variables.
- Clear separation between logic, data, and configuration.
- Pre-configured architecture
---

## Observability and Logs
- Lambda functions generate logs in **CloudWatch**.
- Basic event auditing is provided.
- Logs enable traceability and debugging.




#### **Technologies Used**
- Python: pandas, numpy, schedule, snowflake-connector
- Databases: PostgreSQL, Snowflake
- Cloud: AWS (Lambda, S3, EventBridge, API Gateway, RDS, DynamoDB)
- Modeling: SQL, dimensional modeling
- Orchestration: Schedule
- Dev Tools: Git, Virtual Env


*Author*
- Juan Pablo Peña Gutiérrez
- Data Science Student 
##  Observability and Logs
- Lambda functions generate logs in **CloudWatch**.
- Basic event auditing is proposed.
- Logs enable traceability and debugging.




#### **Technologies Used**
- Python: pandas, numpy, schedule, snowflake-connector
- Databases: PostgreSQL, Snowflake
- Cloud: AWS (Lambda, S3, EventBridge, API Gateway, RDS, DynamoDB)
- Modeling: SQL, dimensional design
- Orchestration: Schedule
- Dev Tools: Git, Virtual Env


*Author*
- Juan Pablo Peña Gutiérrez
- Data Science Student 




---
hide:
  - toc
---
# Cloudera Data Lifecycle Hands on Lab


Welcome to this Data Lifecycle Hands on Lab, where you'll explore the full data lifecycle through a real-world use case: predicting customer churn for a telecommunications company. This lab provides practical experience using _Cloudera on cloud_ data services, guiding you through key stages from data ingestion and processing to analysis and actionable insights.

!!! tip "Update Lab Guide for your assigned username"
    By entering your assigned username (e.g. `user001`) and clicking the **UPDATE EXAMPLES** button, the code examples you'll be customized for your user. 
    
    Click the reset button to start again if you make a mistake.
    
    <div class="username-input-container">
        <input type="text" id="user-username-input" placeholder="e.g., john.doe">
        <button id="user-username-save">UPDATE EXAMPLES</button>
        <button id="user-username-clear">RESET</button>
    </div>

    ```sql title="Test Block"
    changed_user=USERNAME;
    ```

    `changed_user=USERNAME;`
    
!!! info "What to expect"
    - Ingest real time data to an Open Lakehouse
    - Run Data Engineering transformation
    - Query/explore data and build Data Viz applications
    - Train and deploy a ML model to predict customer churn
    - Enrich data analytics with real time scoring

![Data Lifecycle Overview](./assets/images/data_lifecycle_overview.png)

<div class="grid cards"  markdown>

- :simple-apachenifi:{ .lg .middle } &nbsp; **Lab 1. Cloudera Data Flow**

    ***

    **Goals**

    - [ ] Consume data from a Kafka topic
    - [ ] Convert the data to Parquet format
    - [ ] Store the data in a table in the Lakehouse

    ***

    [:octicons-arrow-right-24: Go to Cloudera Data Flow Lab Guide](labs/lab1-cdf/README.md)

- :simple-apachespark:{ .lg .middle } &nbsp; **Lab 2. Cloudera Data Engineering**

    ***

    **Goals**

    - [ ] Run a data enrichment process
    - [ ] Run a process to simulate changes to the data
    - [ ] Configure the execution of a pipeline using low-code/no-code tools

    ***

    [:octicons-arrow-right-24: Go to Cloudera Data Engineering Lab Guide](labs/lab2-cde/README.md)

- :simple-cloudera:{ .lg .middle } &nbsp; **Lab 3. Cloudera Data Warehouse**

    ***

    **Goals**

    - [ ] Configure Cloudera Data Warehouse
    - [ ] Query data in Iceberg
    - [ ] Created a visualization within Cloudera Data Viz

    ***

    [:octicons-arrow-right-24: Go to Cloudera Data Warehouse Lab Guide](labs/lab3-cdw/README.md)

- :simple-cloudera:{ .lg .middle } &nbsp; **Lab 4. Cloudera AI**

    ***

    **Goals**

    - [ ] Train a Machine Learning model to predict customer churn
    - [ ] Deploy the trained model for real time scoring/prediction

    ***

    [:octicons-arrow-right-24: Go to Cloudera AI Lab Guide](labs/lab4-cai/README.md)

- :simple-cloudera:{ .lg .middle } &nbsp; **Lab 5. Cloudera Data Vizualization**

    ***

    **Goals**

    - [ ] Enrich Data Viz application with real time model scoring

    ***

    [:octicons-arrow-right-24: Go to Cloudera DataViz Lab Guide](labs/lab5-dataviz/README.md)

</div>

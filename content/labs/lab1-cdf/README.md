# Lab 1 - Cloudera Data Flow

In this lab you will take a tour of Cloudera Data Flow by configuring and deploying a NiFi flow from the Catalog to ingest data from a Kafka topic into the Open Lakehouse.

**Goals**

- [ ] Consume data from a Kafka topic
- [ ] Convert the data to Parquet format
- [ ] Store the data in a table in the Lakehouse

![Lab 1](lab1_cdf.png)

## Requirements

Ensure the following requirements are met in order to run this exercise:

- [ ] Your **CDP Workload Password** is set by following the See the [Cloudera on Cloud Account Guide](../../guides/cdp-account/README.md#setting-your-cdp-workload-password).

## Tasks

### Open Cloudera Data Flow

From the Cloudera on cloud Tenant home page, click on Data Flow.

![Cloudera on Cloud Tenant Home](cloudera_on_cloud_tenant_home.png)

Once in Data Flow, click on **Catalog** from the left menu. The data ingestion application templates are listed here. For the purpose of this workshop, we have created and published a template that allows you to read Kafka topic data and ingest/store it in the Lakehouse provided by Cloudera on cloud.

Click on the Flow called `{{ kafka_to_lakehouse_flow_name | default("cdp_hol_kafka_to_lakehouse") }}` to start deploying it.

![Cloudera DataFlow Flow Catalog](cdf_flow_catalog.png)

### Configure and Deploy Flow

When the flow is clicked, the panel shown in the image below appears with the Flow information. It shows the available versions, creation date, creator user, and a button **Deploy** to start the deployment.

![Cloudera DataFlow Deploy Flow](cdf_deploy_flow.png)

 Click on that **Deploy** button, and select **Create New Deployment**.

![Cloudera DataFlow Deploy Flow](cdf_deploy_flow2.png)

The popup window that appears allows you to select the target Data Flow workspace in which you want to deploy the Flow. In this case, the workspace to be selected is **`{{ cdp_environment_name | default("cloudera-cdp-hol-cdp-env") }}`**. Once selected, click **Continue**.

!!! info
    The workshop instructor will tell you which environment to select.

![Cloudera DataFlow Deploy Flow Step 1](cdf_deploy_flow_step1.png)

From this point, you will need to enter the Flow configuration.

Start by assigning a **Deployment Name**, **Target Project** as outlined below, and click **Next**.
- For **Deployment Name**, please prefix the with your username.  `USERNAME-kafka-to-lakehouse`
- Select `Unassigned` for the **Target Project**. Using a project is a way to organize your flows.
- Flow Name is already pre-filled by default.
- Option **Automatically start flow upon successful deployment** should be enabled


![Cloudera DataFlow Deploy Flow Step 2](cdf_deploy_flow_step2.png)

- Once all values are entered, click **Next**.

![Cloudera DataFlow Deploy Flow Step 3](cdf_deploy_flow_step3.png)

In this part of Parameters, you must enter the following values:

- **CDP Workload User Password**: Enter your Workload Password. See the [Cloudera on Cloud Account Guide](../../guides/cdp-account/README.md#setting-your-cdp-workload-password) for details on how to set your Cloudera on Cloud workload password.
- **CDP Workload Username**: Enter your Workload Username, `USERNAME`.
- **CDW Hive JDBC url**: `{{ hive_jdbc_url }}`
- **Kafka Brokers**: `{{ kafka_brokers }}`
- **Kafka Topic**: `{{ kafka_topic }}`

For the purposes of this workshop, the remaining values were filled out for you and don't need to change.

Review that the parameters were entered correctly. Then click **Next**.

!!! NOTE
    For the purposes of the workshop, your Username is also the name of the database where you will store the data, and the name of the Kafka Consumer Group ID for reading messages.

![Cloudera DataFlow Deploy Flow Step 4](cdf_deploy_flow_step4.png)

There is no need to configure auto-scaling parameters. Click **Next**.

![Cloudera DataFlow Deploy Flow Step 5](cdf_deploy_flow_step5.png)

We are also not going to configure KPIs now. Click **Next** to continue the configuration.

![Cloudera DataFlow Deploy Flow Step 6](cdf_deploy_flow_step6.png)

Review all the information entered for your Flow, then click on **Deploy** to start the deployment process.

![Cloudera DataFlow Deploy Flow Step 7](cdf_deploy_flow_step7.png)

### Track and Manage Deployment

The blue box indicates that the Flow deployment process has been started. By clicking on the **Load More** button you will be able to see the different stages of the deployment. After approximately 60 to 90 seconds, the last event should be _Deployment Successful_.

![Cloudera DataFlow Track Deployment](cdf_track_deployment.png)

Once the deployment is finished, click on **Actions** -> **Manage Deployment** to see the details of the recently deployed Flow.

![Cloudera DataFlow Manage Deployment](cdf_manage_deployment.png)

### View the deployed NiFi Canvas

In the Deployment Manager window you will see the Flow information displayed.

It is time to execute the application processes from the graphical Flow Management interface. Click on **Actions** -> **View in NiFi**, to open Cloudera Flow Management canvas in a new window/tab.

![Cloudera DataFlow View in NiFi](cdf_view_in_nifi.png)

Double-click on the churn-kafka-to-lakehouse Process Group to open it.

![NiFi Open Process Group](cdf_nifi_open_process_group.png)

When opening the Process Group, there are two further Process Groups. Click on the `Kafka to Iceberg Process Group` to see the Processors that compose the main Flow application. 

![NiFi Open Kafka to Iceberg Process Group](cdf_nifi_open_kafka_to_iceberg_process_group.png)

To summarize, there are four Processors:

- _ConsumeKakfaRecord_, consumes data from the Kafka topic, reading the data in JSON and outputting in AVRO.
- _MergeRecords_, to group the flow files and streamline the data flow.
- _ConvertAvroToParquet_, conversion needed to store the data in PARQUET format.
- _PutIceberg_, to insert the data into the table in the Lakehouse. The destination table is called telco_kafka_iceberg, and each user has an assigned database (`USERNAME` is the name of the database).

As you can see, the Processors are not started, they are paused.

![NiFi Process Group](cdf_nifi_process_group.png)

### Enable and Start the Flow

We will now enable and start the NiFi flow to ingest data from Kafka and write to Iceberg.

Right Click on a blank area of on the NiFi canvas (i.e. not on any of the Processors) and click **Enable**. At this point the Processors state will show as stopped (:material-stop:).

![NiFi Enable Flow](cdf_nifi_enable_flow.png)

Start the Processors, by right clicking of a blank area of the NiFi canvas and click **Start**.

![NiFi Start Flow](cdf_nifi_start_flow.png)

The Processors will now show as running (:material-play:). After a few moments, from the _Out_ field in every processor, you can see that data has flowed through in the past 5 minutes. You have consumed data from Kafka and written to Iceberg!

!!! tip
    You can refresh the counter by pressing the Ctrl+R (Windows) or Command+R (Mac) combination on the keyboard.

![NiFi Successful Flow](cdf_nifi_successful_flow.png)

### Inspect and Modify the Flow

Flow Management allows us to see and access data in motion during the execution of the data flow.

Between Processors **ConsumeKafkaRecord_2_6** and **MergeContent**, there is a connection. This connection is what joins the Processors and transmits data from one to the other, and you can check how much data is queued at every step of the process.

Let's see this in action by building up the queue. We have already consumed Kafka data so let's modify the  ConsumeKafkaProcessor to pull the data with different kafka consumer groups.

First, right-click on **MergeContent** processor and click **Stop**. Repeat the same for processor **ConsumeKafkaRecord_2_6**

![NiFi Stop Processor](cdf_nifi_stop_processor.png)

Right click on **ConsumeKafkaRecord_2_6** processor and click on **Configure**

![NiFi Configure Processor](cdf_nifi_configure_processor.png)

![NiFi Configure Processor](cdf_nifi_modify_config.png)

Under the **Properties** tab, change the consumer group id by clicking on **Group ID** value and changing the consumer group id (eg. `#{CDP Workload Username}-group-v1`). Click **OK** and **Apply**

![NiFi Change Group ID property](cdf_nifi_change_group_id_config.png)

Start the **ConsumeKafkaRecord_2_6** processor by right clicking and **Start**.

![NiFi Start Processor](cdf_nifi_start_processor.png)

You will see data start to queue up in the connector shortly after starting.

![NiFi Queue Filling](cdf_nifi_queue_filling.png)

!!! tip
    You can refresh the counter by pressing the Ctrl+R (Windows) or Command+R (Mac) combination on the keyboard.

At some point there should be a number next to the legend _Queued_ in the connection between **ConsumeKafkaRecord_2_6** and **MergeContent**.

To see the queued data, right-click on the connection and click on the option **List Queue**, opening a popup window.

![NiFi List Queue](cdf_nifi_list_queue.png)

The next popup window lists the queued data. Click on the information icon (:material-information:) that appears
on the left side to view the events.

![NiFi View Queue](cdf_nifi_view_queue.png)

Once the FlowFile detail window appears, click on the button **VIEW** to open the content of consumed events.

![NiFi View Flow File](cdf_nifi_view_flowfile.png)

The new window that opens shows the data of the FlowFile content. Being in AVRO format, it is not fully readable. A deserializer must be selected to correctly display the data. For this, in the upper left, select the option `formatted` from the **View as** menu.

![NiFi View Flow File Content](cdf_nifi_view_flowfile_content.png)

Now you can display the data correctly. Notice that the fields or attributes indicated at the beginning of the workshop appear. You can close that FlowFile window and the popups, returning to the canvas with the four Processors.

![NiFi View Flow File Formatted Content](cdf_nifi_view_flowfile_content_formatted.png)

Start the stopped **MergeContent** processor again to resume the flow. Remember that you can refresh the flow counters with the combination `Control+R` or `Command+R`.

![Start Merge Content Processor](cdf_nifi_start_mergerecords_processor.png)

If the previous steps were executed correctly, the connection of the Processor **PutIceberg** to a funnel should be of type success.

![Put Iceberg Processor Success](cdf_nifi_puticeberg_processor_funnel.png)

### Bonus - Data Provenance

NiFi is a powerful ingestion tool that gives you granular visibility into everything that's done to the data.

For example, right-click on any processor and then click on **View data provenance** to see this in action.

![NiFi Data Provenance](cdf_nifi_data_provenance.png)

**End of Lab 1**
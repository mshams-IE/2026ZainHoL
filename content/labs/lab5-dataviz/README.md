# Lab 5 - Cloudera Data Vizualization

In this lab you will dive deeper into Cloudera Data Vizualization by using the output of the machine learning model to enrich your DataViz application.

!!! info 
    The screenshots below are provided for guidance only and may not reflect exact details. Please read the lab steps carefully

**Goals**

- [ ] Enrich Data Viz application with real time model scoring
- [ ] Add a new field that makes calls to the Cloudera AI Machine Learning model

![Lab 5](lab5_dataviz.png)

## Requirements

Ensure the following requirements are met in order to run this exercise:

- [ ] Name of the Impala Data Warehouse assigned to your user
- [ ] Name of Data Vizualization Cluster assigned to your user
- [ ] Cloudera AI models deployed as part of [Lab 4 - Cloudera AI](../lab4-cai/README.md)

!!! info
    The workshop instructor will assign your user to a Data Warehouse and Data Vizualisation cluster.

## Tasks

### Open Cloudera Data Vizualization in Data Warehouse

From the Cloudera on cloud Tenant home page, click on Data Warehouse.

![Cloudera on Cloud Tenant Home](cloudera_on_cloud_tenant_home.png)

In the pop up window that appears, click on **Manage Data Warehouse** to open the Data Warehouse Home page.

![Cloudera on Cloud Tenant Home](cloudera_on_cloud_tenant_home_cdw.png)

The Data Warehouse Home shows the deployed database catalogs, and virtual warehouses and allows access to data vizualization clusters.

Click on **Data Vizualization** from the left menu.

![Cloudera Data Warehouse](cdw_home_page.png)

In Data Visualization, click on the **Data Viz** button for the cluster instance your user was assigned.

![CDW Open Data Viz](cdw_open_data_viz.png)

### Add Field to Data Vizualization Dataset

Edit the previously created Dataset, in **Data** -> **`USERNAME`.telco_data_curated**.

![CDW Data Viz Dashboard CML Field Step 1](cdw_dv_cml_dashboard_step1.png)

Once in the Dataset, go to **Fields** in the left menu and then click on **EDIT FIELDS** to edit the fields of your dataset.

![CDW Data Viz Dashboard CML Field Step 2](cdw_dv_cml_dashboard_step2.png)

In the list of **Dimensions**, click the down arrow of the last field in the list, and select the option **Clone**.

![CDW Data Viz Dashboard CML Field Step 3](cdw_dv_cml_dashboard_step3.png)

Once the field is cloned, click on the pencil next to the field to edit it.

![CDW Data Viz Dashboard CML Field Step 4](cdw_dv_cml_dashboard_step4.png)

In the popup window that appears, enter the name of the new field in **Display Name**. We suggest that you enter `ChurnScore`.

![CDW Data Viz Dashboard CML Field Step 5](cdw_dv_cml_dashboard_step5.png)

Go to the **Expression** tab and enter the following value in the Expression field. This will allow you to call the REST API of the Model you have previously deployed.

```json
cviz_rest('{"url":"<url_workspace>","accessKey":"<access_key>","colnames":["monthlycharges","totalcharges","tenure","gender","dependents","onlinesecurity","multiplelines","internetservice","seniorcitizen","techsupport","contract","streamingmovies","deviceprotection","paymentmethod","streamingtv","phoneservice","paperlessbilling","partner","onlinebackup"],"response_colname":"result"}')
```

![CDW Data Viz Dashboard CML Field Step 6](cdw_dv_cml_dashboard_step6.png)

We will now get values for the `<url_workspace>` and `<access_key>` placeholders from our deployed model in Cloudera AI.

### Retrieve Field Details from Cloudera AI model

Open Cloudera AI in tab of the web browser. Open the Project that you created in [Lab 4 - Cloudera AI](../lab4-cai/README.md).

Go to the section of Models of your project, and click on the Model that begins with the name _ModelViz_, followed by your assigned username.

![CDW Data Viz Dashboard CML Field Step 7](cdw_dv_cml_dashboard_step7.png)

In the Overview tab, copy the **URL** that allows you to interact and call the workspace API.

![CDW Data Viz Dashboard CML Field Step 8](cdw_dv_cml_dashboard_step8.png)

In Data Vizualization, replace the copied Workspace API value in the placeholder attribute `<url_workspace>` of the Expression field.

![CDW Data Viz Dashboard CML Field Step 9](cdw_dv_cml_dashboard_step9.png)

Returning to Cloudera AI, copy the **accessKey** of the model.

![CDW Data Viz Dashboard CML Field Step 10](cdw_dv_cml_dashboard_step10.png)

In Data Vizualization, replace the copied value in the placeholder attribute `<access_key>` of the Expression field.

![CDW Data Viz Dashboard CML Field Step 11](cdw_dv_cml_dashboard_step11.png)

Finish the process by clicking the **Validate Expression** button below the expression window.

If the message appears in green _Validation Successful_, Click on **Apply** to save the settings made.

![CDW Data Viz Dashboard CML Field Step 12](cdw_dv_cml_dashboard_step12.png)

The new field should appear in the list of fields. Change the data type, selecting the type _Integer_, which is represented by the symbol **#**.

![CDW Data Viz Dashboard CML Field Step 13](cdw_dv_cml_dashboard_step13.png)

Finish the process by clicking on the green **SAVE** button in the top menu.

![CDW Data Viz Dashboard CML Field Step 14](cdw_dv_cml_dashboard_step14.png)

### Add Real Time Model Visual to Dashboard

Return to the dashboard by selecting the option **VISUALS** from the top menu, and clicking on the name of the dashboard that was previously created.

![CDW Data Viz Dashboard CML Field Step 15](cdw_dv_cml_dashboard_step15.png)

Once in the dashboard, click on the button **Edit** which is in the upper left.

![CDW Data Viz Dashboard CML Field Step 16](cdw_dv_cml_dashboard_step16.png)

Edit the lower table by clicking on it and then on the **Build** button from the right vertical menu. Add the new field, **ChurnScore**, at the beginning of the table, by clicking and dragging from the option **Dimensions** available.

![CDW Data Viz Dashboard CML Field Step 17](cdw_dv_cml_dashboard_step17.png)

Click on the **REFRESH VISUAL** button to update the table.

The new column, ChurnScore, should appear at the beginning of the table, with a value of numeric type.

Finish the process of updating the dashboard by clicking the button **SAVE** from the top left menu.

![CDW Data Viz Dashboard CML Field Step 18](cdw_dv_cml_dashboard_step18.png)

**End of Lab 3**

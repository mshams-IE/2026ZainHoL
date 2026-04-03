# Lab 4 - Cloudera AI

In this lab you will get hands-on with Cloudera AI by training a machine learning model. You will then deploy the model as a REST API for real time predication.

**Goals**

- [ ] Train a Machine Learning model to predict customer churn
- [ ] Deploy the trained model for real time scoring/prediction

![Lab 4](lab4_cai.png)

## Requirements

None.

## Tasks

### Open Cloudera Machine Learning

From the Cloudera on cloud Tenant home page, click on Machine Learning.

![Cloudera on Cloud Tenant Home](cloudera_on_cloud_tenant_home.png)

The Cloudera AI Home shows all available Workbenches, which is a compute resource allocation for Data Science related jobs.

Click on the `{{ (cai_workbench_name) | default("only")}}` Workbench that appears.

![Cloudera AI](cai_home_page.png)

### Create Cloudera AI project

The Cloudera AI workbench landing page which opens page provides an overview of your existing CML projects, allows you to create new ones, and manage your Cloudera AI environment.

To begin, click the **Create a new project** button to create a new project.

![Cloudera AI Create Project](cai_create_new_project.png)

Enter the following information to create a new project:

- **Project Name**: Enter `Telco Churn`
- **Project Visibility**: Select `Private`
- **Initial Setup**: Select `Git`
- In the text field below **HTTPS**, enter the url of the git repo: [https://github.com/jimright/ClouderaAI-TelcoChurn.git](https://github.com/jimright/ClouderaAI-TelcoChurn.git)

Keep the rest of the settings the same. Click the button **Create Project**

![Cloudera AI Enter Project Details](cai_create_project_details.png)

Once the project is created, you should see the screen shown below.
On this screen are the following sections.

- **Models**, deploy and manage models as REST APIs to serve predictions.
- **Jobs**, automate and orchestrate the execution of batch analytics workloads.
- **Files**, assets that are part of the project, such as files, scripts and code.

![Cloudera AI Project Home Page](cai_project_home_page.png)

### Set environment variable for User Database

The scripts to train the model query the database tables in Cloudera Data Warehouse. To specify the database to access we can set an environment variable in the Cloudera AI project.

Click **Project Settings** to open the settings page. In the Project Settings page, click on the **Advanced** menu tab along the top of the page.

![Cloudera AI Project Settings](cai_project_settings.png)

In the Advanced settings, under Environment Variables, add a new variable by pressing the :material-plus: button beside one of the existing environment variables.
For the new environment variable enter the following:

- **Key**: Enter `DATABASE`.
- **Value**: Enter your Workload Username, `USERNAME`

Click on the button **Submit** to save the new environment variable.

![Cloudera AI Database Environment Variable](cai_project_environment_variable.png)

A popup showing successful environment variable update should appear. Click **Overview** to return to the Project overview page.

![Cloudera AI Save Environment Variable](cai_project_environment_variable_saved.png)

### Launch Cloudera AI Session

This Telco Churn project consists of running three scripts. We will execute these through a session, which is an allocation of isolated compute resource for each user.

For this, click on the blue **New Session** button, located in the upper right.

- The **Editor** for the session should be `PBJ Workbench`
- **Kernel** should be set to version `Python 3.10` or greater
- **Edition** should be set to `Standard`
- Make sure to **enable Spark**, marking the corresponding check

Click on the button **Start Session** to launch the session.

![Cloudera AI New Session](cai_new_session.png)

When you start a session for the first time, it will ask if you want to use a data connection. This project does not need this type of connection. Mark the check of **Don’t show me this again**, and then click the **Close** button, so this window will not appear anymore.

![Cloudera AI Session Data Connection](cai_new_session_data_connection.png)

The editor/notebook located on the right side of the window will be in Scheduling status, and the bottom command bar flashing red. This means that CML is allocating computation for your session.

![Cloudera AI Session Scheduling](cai_new_session_scheduling.png)

After a few seconds, the status changes to Running, and the command bar to green. This means that the session is ready to run code.

![Cloudera AI Session Running](cai_session_running.png)

### Run the Bootstrap Script

The first script/code to run is `0_bootstrap.py`. This Python code configures the libraries required for the project and integration with Lakehouse tables you populated before.

Select (just one click) the file in the bar located on the left side of the interface, this will make the code appear in the editor. Once the file is selected, click on the :material-play-box: button to run the code.

![Cloudera AI Run Bootstrap Script](cai_run_bootstrap_script.png)

When you start execution, you will see code output on the right side of the interface, and the bottom command bar flashing red, indicating that it is busy.

![Cloudera AI Bootstrap Script Running](cai_bootstrap_script_running.png)

The green command bar indicates that the execution of the code has been finished. The bootstrap code takes 3-4 minutes to run.

![Cloudera AI Bootstrap Script Completed](cai_bootstrap_script_completed.png)

### Run the Train Strategy Script

The second script/code to run is `1_trainStrategy_job.py`. This Python code will create the Experiment to run the model with three different hyper parameters and records the precision.

Select (just one click) the file in the bar located on the left side of the interface, this will make the code appear in the editor. Once the file is selected, click on the :material-play-box: button to run the code.

Once the execution is finished (approximately 1 minute), click on the **Project**, located in the upper right bar of the session to go back to the project home.

![Cloudera AI Train Strategy Script](cai_run_trainstrategy_script.png)

From the Project menu, click on the **Experiments** option, from the left menu, and then on **expRetrain** in the list of Experiments that appears.

![Cloudera AI Experiements](cai_experiments_page.png)

On this screen you will see the three runs of this experiment. Note the **precision** column. This is the precision that each hyper parameter is delivering.

![Cloudera AI Experiement Details](cai_experiment_details.png)

### Run the Deploy Model Script

Let's go back to the session to run the last code. Since sessions run in Kubernetes containers, it's very easy to get back to where we were.

Click on the **Sessions** button from the left menu. The list of active sessions that will appear. There should be one active session. If you didn't name your session when you started it, it should be called _Untitled Session_. Click on this to reopen the session.

![Cloudera AI Session List Details](cai_session_list.png)

The third and last script/code to run is `2_deploy_models.py`. This Python code takes the hyper parameter of the execution of the Experiment with the best precision and deploys a model as a REST API. This model can be integrated in Data Visualization.

Select (just one click) the file in the bar located on the left side of the interface, this will make the code appear in the editor. Once the file is selected, click on the :material-play-box: button to run the code.

![Cloudera AI Run Deploy Model Script](cai_run_champion_script.png)

After a few seconds, you will see the message `Deploying ModelViz....` repeated several times, and the bottom command bar will be red.

![Cloudera AI Deploy Model Script Running](cai_champion_script_deploying.png)

After about 2 minutes, the last message should be _Model is deployed_, and the bar will be green. This means that the Deployment of the two Models is complete.

Click on the **Project** button, located in the upper right bar of the session to return to the home page of the project.

![Cloudera AI Deploy Model Script Success](cai_champion_script_deploy_success.png)

### Test Deployed Model

Once on the home page of the project, you will the deployed Model displayed. Click on the model that starts with **ModelViz**.

![Cloudera AI Deployed Models](cai_project_deployed_models.png)

Here you will see Model information and settings in the Overview tab.

![Cloudera AI Churn Model Details](cai_model_churn_details.png)

To test it and make a request to the model, scroll down, and click on the button **Test**, which will take the value in JSON format that is in the field **Input** and will make the request call to the model.

What you see in the **Result** field is the response from the model in JSON format.

If you wish, you can change some of the parameters of the **Input** field (for example, change some values from `No` to `Yes`), and call the model again, and observe the value of the attribute probability of the response to see if there were any changes.

![Cloudera AI Churn Model Test](cai_model_churn_test.png)

**End of Lab 4**
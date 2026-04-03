# Instructor Guide for Cloudera on cloud Data Lifecycle Hands on Lab

This guide provides detailed instructions on setting up the workshop environment, preparing virtual machines with the necessary prerequisites, and publishing the workshop guide for participants.

> [!IMPORTANT]
> **POC or Workshop Environment Request**
>
> If the sales cycle requires a Cloudera-paid POC or Workshop, this needs VP approval and must be done in a separate CDP tenant and cloud account.
> 
> **Action Required:** Raise a JIRA using the [Workshop Request Template](https://cloudera.atlassian.net/jira/software/c/projects/CDPAR/form/467). All fields in the description are required. Any missing information will delay the process.
>
> **POC Duration:** The duration of the POC should be two weeks or less. Please give ample advance notice to accommodate tenant rotation scheduling.
>
> For complete details on requirements, responsibilities, and processes, see the [CDP Tenants for POCs/HOLs/Workshops Wiki](https://cloudera.atlassian.net/wiki/spaces/SE/pages/1542750294/CDP+Tenants+for+Cloudera+Paid+POCs+HOLs+and+Workshops).

## Hands on Lab Cloudera on Cloud Environment Setup

The `public-cloud/` folder contains Ansible playbooks and Terraform configuration files to setup the Cloudera on Cloud environment, data services. The setup playbooks also create assets required for the Hands on Lab.

> [!IMPORTANT]  
> The commands below are run from the `public-cloud/` directory this repository.

* Ensure Python virtual environment with `ansible-navigator` is activated.

* Set the required environment variables.

```bash
export AWS_ACCESS_KEY_ID=your-aws-access-key-id
export AWS_SECRET_ACCESS_KEY=your-aws-secret-access-key
export AWS_SESSION_TOKEN=your-aws-session-token # (optional if using AWS SSO)
export CDP_ACCESS_KEY_ID=your-cdp-access-key-id
export CDP_PRIVATE_KEY=your-cdp-private-key
```

* Copy `config-template.yml` to `config.yml` and update the parameters as required.

   ```bash
   cp config-template.yml config.yml
   ```

* Notably, you should add and/or change the below parameters. The Data Services configurations (e.g. GPU for CML) can be edited in the config.yml file.

```yaml
prefix: "<ENTER_VALUE>" # Short prefix to append to all resources created
infra_region:   us-east-2 # CSP region for infra

owner_email: "<ENTER_VALUE>"           # email address of owner

# Your CDP workload credentials
cdp_workload_username: "<ENTER_VALUE>"         # str;
cdp_workload_password: "<ENTER_VALUE>"         # str; 

# Number of Hands on Lab Attendees
# Used to determine the scaling in the Data Service configuation
num_attendees: <ENTER_VALUE>
```

* To setup the environment and datalake run the command below.

```bash
ansible-navigator run setup-cdp-env.yml -e @./config.yml
```

* To enable the required data hub and data services run the command below.

```bash
ansible-navigator run setup-cdp-services.yml -e @./config.yml
```

* To update the data and configure the assets required for the hands on lab run the command below.

```bash
ansible-navigator run setup-hol-assets.yml -e @./config.yml
```

### Assigning Lab Atteendees to Cloudera on Cloud Group

By default a `{{ prefix }}-attendee` Cloudera on Cloud group is created as part of the environment setup. This group has the roles and resource roles to complete each of the lab exercises.

Before the lab, you will need to assign the attendee users to this group. Then run **Synchronize Users** for the Hands on Lab Cloudera on cloud environment.

Alternatively, if users are logging in via Keycloak, we should update the configuration file, `config.yml`, with the Keycloak group name so that users are automatically added when they login via their Keycloak account. A sample of the required changes to the configuration file is shown below.

```yaml
cdp_attendee_group:
  name: "<KEYCLOAK_GROUP_NAME>" # NOTE: This can be a pre-existing group aligning with the Keycloak realm
  create_group: no
  add_to_idbroker: yes
  sync_on_login: no
...
```

### Teardown

The cleanup is split into three separate playbooks - one to cleanup tghe hands on lab assets; one to remove all Data Services and the third to remove the Cloudera Environment and infrastructure.

Tear down hands on lab assets by running the following command:

```bash
ansible-navigator run teardown-hol-assets.yml -e @./config.yml
```

Tear down data services by running the following command:

```bash
ansible-navigator run teardown-cdp-services.yml -e @./config.yml
```

Tear down the CDP environment and infrastructure by running the command below:

```bash
ansible-navigator run teardown-cdp-env.yml -e @./config.yml
```

### Known Issues / Manual Steps

| Issue | Description | Workaround |
|-------|-------------|------------|
| Automation of DataViz remote data setting is not currently possible. | A way to easily automate setting adding the Cloudera AI model URL in each Cloudera DataViz cluster is not yet available | Manually configure the Remote Data Setting from each DataViz cluster to reach Cloudera AI model url/workbench. This is done via the DataViz `Site Settings` -> `Advanced Settings`. Set _URLs that remote data columns can be fetched from_ to include a url of the form `https://modelservice.<workspace_url>/model` |
| DataViz cluster teardown failed during `teardown-cdp-services.yml` playbook | The API lookup of existing DataViz clusters periodically fails. This sometimes causes the `Remove the CDW DataViz Clusters` task to fail with error _unable to get viz-webapp (cause: sql: no rows in result set)_  | Rerun the `teardown-cdp-services.yml`. |

## Publishing the Workshop Guide to GitHub Pages

Two methods are available to publish this automation lab guide to GitHub pages - a GitHub Action (recommended) and manually publishing.

> [!NOTE]  
> Follow the manual steps to test your guide locally (via the `mkdocs serve` command).

### Using GitHub Action

The [publish_mkdocs.yml](../.github/workflows/publish_mkdocs.yml) GitHub action is used to automatically publish the the lab guide to GitHub pages.

The action is triggered on a push to the `main` branch. The action can also be launched manually if required.

### Steps to manually publish the guide

* Create a Python Virtual Environment

   ```bash
   python3 -m venv ~/mkdocs_venv
   source ~/mkdocs_venv/bin/activate
   ```

* Clone the <REPOSITORY_NAME> GitHub repository

  ```bash
  git clone https://github.infra.cloudera.com/GOES/<REPOSITORY_NAME>.git
  ```

* Install Required Dependencies for MkDocs

   ```bash
   cd <REPOSITORY_NAME>/instructor/mkdocs
   pip install -r requirements.txt
   ```

* Run the following command to test your guide locally:

   ```bash
   mkdocs serve
   ```

   Open `http://127.0.0.1:8000` in your browser to view the guide.

* Use the following command to publish the guide to the `origin` repository's GitHub Pages:

   ```bash
   mkdocs gh-deploy -r origin --no-history
   ```

* The lab guide should now be live on your GitHub Pages site. The URL for the site can be found via the `Settings -> Pages` menu of the repository, or go to https://github.infra.cloudera.com/pages/GOES/<REPOSITORY_NAME>/

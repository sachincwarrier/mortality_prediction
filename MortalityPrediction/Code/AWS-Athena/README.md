# MIMIC-III data using AWS Athena

### mimic-iii-athena.yaml
This is an [AWS CloudFormation Template](https://aws.amazon.com/cloudformation/) that will deploy a database in the [AWS Glue](https://aws.amazon.com/glue/) Data Catalog that contains all of the MIMIC-III tables.  It also deploys a Jupyter Notebook instance in [Amazon SageMaker](https://aws.amazon.com/sagemaker/) that contains the content of this [mimic-code](https://github.com/MIT-LCP/mimic-code/) GitHub repository and is set up to access the MIMIC-III data through AWS Glue.

Use the mimic-iii-athena.yaml file to deploy this AWS CloudFormation template into your AWS account.  On the first screen, the template link has already been specified, so just click next.  On the second screen, provide a Stack name (letters and numbers) and click next, on the third screen, just click next.  On the forth screen, at the bottom, there is a box that says **I acknowledge that AWS CloudFormation might create IAM resources.**.  Check that box, and then click **Create**.  Once the Stack has complete deploying, look at the **Outputs** tab of the AWS CloudFormation console for links to your Juypter Notebooks instance.


### mimictoparquet_glue_job.py
This Python script can be run  as an AWS Glue job to convert the CSV.gz files to Apache Parquet format.  It uses Apache Spark to help conver the files.  You do not need to execute these if you use the above ```mimic-iii-athena.yaml``` CloudFormation template. 

### mimic-aws-athena-ddl.sql
This is a SQL script that can be run directly within AWS Athena to define each of the MIMIC-III dataset tables from the Apache Parquet files provide in the AWS OpenData program.  You do not need to execute these if you use the above ```mimic-iii-athena.yaml``` CloudFormation template.  The table spaces are defined for you by that automation.  However, if you wanted to define the tables yourself within your account, you can use these SQL statements.

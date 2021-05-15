# Project Title : Mortality Prediction in ICU


## Overview
This code repository presents a set of reproducible code for the final project of CSE6250. 
The aim of the project is to predict in-hospital mortality in the early stage of ICU stay (6-hour since ICU admission). If a patient is predicted dead, the model would further provide an estimate of death hours since ICU admission. Please refer to the paper for further explanation on the data source, methodology, model architecture and results. A presentation video is also available at [YouTube](https://youtu.be/BnJrGJnj9sA).

The directory structure of this repository is shown below.
```
CSE6250_Project_ICU_Mortality_Prediction
├── Code
│   ├── AWS-Athena
│   │   ├── mimic-aws-athena-ddl.sql
│   │   ├── mimic-iii-athena.yaml
│   │   ├── mimictoparquet_glue_job.py
│   │   ├── README.md
│   │   
│   ├── Python
│       ├── Data_Pre-processing.ipynb
│       ├── Cohort_Construction.ipynb
│       ├── Exploratory_Data_Analysis.ipynb
│       ├── Feature_Engineering.ipynb
│       ├── Phase1_Model.ipynb
│       ├── Phase2_Model.ipynb
│       ├
│       ├── img
│       ├	├── figure1.png
│       ├	├── figure2.png
│       ├	├── figure3.png
│       ├	├── figure4.png
│       ├	├── figure5.png
│    	│ 
│    	├──Data
│       │	├── data_12hr_df.csv
│       │	├── data_18hr_df.csv
│       │	├── data_6hr_df.csv
│       │	├── ICU_12hr_df.csv
│       │	├── ICU_18hr_df.csv
│       │	├── ICU_6hr_df.csv
│       │	├── X12_test.csv
│       │	├── X12_train.csv
│       │	├── X18_test.csv
│       │	├── X18_train.csv
│       │	├── X6_test.csv
│       │	├── X6_train.csv
│       │	├── Y12_test.csv
│       │	├── Y12_train.csv
│       │	├── Y18_test.csv
│       │	├── Y18_train.csv
│       │	├── Y6_test.csv
│       │	├── Y6_train.csv
│       │   
│       │
│   	└── SQL
│       	├── mp_bg.sql
│ 		├── mp_bg_art.sql
│       	├── mp_cohort.sql
│       	├── mp_data.sql
│       	├── mp_data_12hr.sql
│       	├── mp_data_18hr.sql
│       	├── mp_data_6hr.sql
│       	├── mp_gcs.sql
│       	├── mp_hourly_cohort.sql
│       	├── mp_lab.sql
│       	├── mp_uo.sql
│    		├── mp_vital.sql
│       	└── README.md
├── README.md
├── Team99_MortalityPrediction.pdf
└── Motality_prediction_ICU.ppt

```

The project consists of 2 stages:

*Stage 1. Feature Engineering using AWS Athena*

*Stage 2. Machine Learning using Python*

* Stage 1 is implemented in Athena using spark and AWS Glue in Amazon AWS cluster . Relevant SQL queries can be found the directory `Code/SQL`.
* Stage 2 is implemented in Python 3.6 on a Amazon Sage-maker. The relevant Python notebooks can be found in the directory `Code/Python`.
* Presentation slides and paper can be found in the root directory.


## Environment Setup
**Stage 1. Feature Engineering using Spark and AWS Glue on Amazon Athena**

Stage 1 has been deployed using Spark and AWS Glue on Amazon Athena

**Stage 2. Machine Learning using Python on Amazon SageMaker**

Stage 2 has been deployed on Amazon SageMaker notebook instance ’ml.t3.large’. Python 3.6 and relevant packages have been used. 

In Order to setup the enviornment Use the mimic-iii-athena.yaml(https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/AWS-Athena/mimic-iii-athena.yaml) file to deploy this AWS CloudFormation template into your AWS account. The detailed information is available in the Read me file under folder AWS-Athena(https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/AWS-Athena/README.md)

## Stage 1. Feature Engineering using Spark and AWS Glue on Amazon Athena

In Stage 1, we have extracted features for the first 6 hours, 12 hours or 18 hours since ICU admission for each ICU stay from MIMIC-III database. Specifically, we have selected the following dataset from MIMIC-III as input data. A data transformation job (https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/AWS-Athena/mimictoparquet_glue_job.py) using AWS Glue was used to convert the original MIMIC-III CSV dataset to Apache Parquet.
. Data output in Stage 1 is then used as feature input for Stage 2 model prediction. 

| Input data from MIMIC-III   | Intermediate Athena tables          | Final Athena tables from Stage 1      |
|:----------------------------|:----------------------------------- |:--------------------------------------|
|ICUSTAYS.csv                 | mp_cohort                   		| mp_data_6hr	  	          			|
|ADMISSIONS.csv               | mp_hourly_cohort            		| mp_data_12hr	            			|
|PATIENTS.csv                 | mp_gcs                      		| mp_data_18hr	            			|
|CHARTEVENTS.csv              | mp_bg, mp_bg_art            		|                             			|
|LABEVENTS.csv                | mp_lab                      		|                             			| 
|OUTPUTEVENTS.csv             | mp_uo                       		|                             			|
|                             | mp_vital                    		|                             			|
|                             | mp_data                     		|                             			|

In the proof-of-concept stage, we have done data preprocessing and feature engineering on a AWS Athena database. The set of SQL scripts shown in the table below should produce all tables needed in this project. Note that reference has been made to the SQL queries provided in this [Repo](https://github.com/alistairewj/mortality-prediction/tree/master/queries) when constructing relevant features.

First we neewd to run the Python Notebook `Data_Pre-processing.ipynb` (https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Data_Pre-processing.ipynb) to do intital pre-processing and creation of the following tables in AWS Athena.

| SQL scripts       	| Description          
|:----------------------|:----------------------|
| mp_cohort.sql         | Create table for patient cohort
| mp_gcs.sql        	| Extract patients' Glasgow Coma Scale|
| mp_bg.sql           	| Extract patients' blood gas and chemistry values|
| mp_lab.sql        	| Extract patients' lab results|  
| mp_uo.sql             | Extract patients' urine output|
| mp_vital.sql          | Extract patients' vital signs, eg. heart rate|
| mp_data.sql         	| Combine all tables created above to get all features at every ICU hour for each patient |

After creating of the basic tables, create the table by executing the content in the file (https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/SQL/mp_cohort_athena_query.txt) in Athena Query Editor. This will create the mp_hourly_cohort table which has a generated sequence of ICU hours per patient

Once the table mp_hourly_cohort is created run the Python Notebook `Cohort_Construction.ipynb` (https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Cohort_Construction.ipynb). This will create the following tables.


| SQL scripts       	| Description          
|:----------------------|:----------------------|
| mp_data_6hr.sql     	| Aggregate features extracted from mp_data table during the first 6 hours of ICU stay |
| mp_data_12hr.sql     	| Aggregate features extracted from mp_data table during the first 12 hours of ICU stay |
| mp_data_18hr.sql     	| Aggregate features extracted from mp_data table during the first 18 hours of ICU stay |

Once we are done with the aboce step. Please execute the notebook `Feature_Engineering.ipynb`(https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Feature_Engineering.ipynb) in order to implement feature Engineering. The output would be passed on to next phase where we implement the Machine Learning using python.

## Stage 2. Machine Learning using Python

Stage 2 consists two phases of model training. Before we trained our models, we have done some exploratory data analysis to understand the study population. Please refer to the notebook `Exploratory_Data_Analysis.ipynb`(https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Exploratory_Data_Analysis.ipynb) for relevant summary statistics and data visualization of the study population.

In Phase 1 the study response variable, mortality, is a binary variable. As such, we used a set of supervised classifica- tion algorithms to develop different predictive models. These included Logistic Regression, Support Vector Machine (SVM), Decision Tree, Neural Network and Random Forest. Finally, each model was tested with the test set, and performance metrics such as accuracy, precision, recall, F-score and AUC- ROC were calculated at the multiple time frame window like 6 hr ,12 hr and 18 hr. Please refer to the notebook `Phase1_Model.ipynb` (https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Phase1_Model.ipynb)for details of model construction, and the paper for further discussion on model comparison using 6-hour, 12-hour and 18-hour ICU data.

In Phase 2, a multiclass classifier has been trained to predict the death hours since ICU admission for those predicted dead patients in Phase 1. We have defined 3 classes for death time in hours since ICU admission. 

* Class 0 : death time < 1 day
* Class 1 : 1 day <= death time < 1 week
* Class 2 : death time >= 1 week 

Similar to Phase 1, we have built a custom machine learning pipeline to select features, transform data, impute missing values and train a random forest classifier using grid search on 5-fold CV. We have tested the trained model on a separate test set (20% of the entire dataset), and plotted the micro-average ROC curve, macro-average ROC curve and ROC curves for each class.  Please refer to the notebook `Phase2_Model.ipynb`(https://github.gatech.edu/schandra63/CSE6250_Project_ICU_Mortality_Prediction/blob/master/Code/Python/Phase2_Model.ipynb) for details of model construction, and the paper for further discussion on model comparison using 6-hour, 12-hour and 18-hour ICU data.


| Notebook                			|  Description   |
| :---------------------------------|:---------------|
| Data_Pre-processing.ipynb         | Pre-processing of the Data inorder to create Intermediate tables in Athena
| Cohort_Construction.ipynb         | Cohort Construction of the Data inorder to create Final tables in Athena
| Feature_Engineering.ipynb         | Feature Engineering on the Cohort Dataset |
| Exploratory_Data_Analysis.ipynb.  | Exploratory data analysis on the study population |
| Phase1_model.ipynb      			| Binary classifier to predict in-hospital mortality in Phase 1|
| Phase2_model.ipynb      			| Multiclass classifier to predict death hours since ICU admission in Phase 2|


## Challenges Faced During the Project Implementation.

1) Since the AWS Implementation of MIMIC Database was recently done, there were lot of challenges in setting up the enviornment in Athena compared to the traditional way of loading the data into Postgressql. In majority of the previous projects, all the data processing activities were performed on Postregsql which had to be modified inorder to adapt to Amazon Athena and Apache parquet format. 
2) Understanding the data and to construct a meaningfull chohort from the dataset was a challenging and time consuming task as there were so much of information spread across multiple tables in the MIMIC database. Also implementing the Feature Engineering was a time consuming effort.
3)Coming up with the Various Machine learning Models and trying to implement the same in Amazon Sage maker which was pretty new to me was a challenging task which heled me in unserstanding many things about the AWS infrastructure and as to how we can create and run ML models on AWS setup.

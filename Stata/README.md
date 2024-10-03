# Reproducible Research Fundamentals 2024 - Stata

Welcome to the **Reproducible Research Fundamentals 2024** training repository. This repository will guide you through all the exercises across the following stages:

- **0. GitHub Workflow**: Gain essential GitHub skills, including how to create branches, commit changes, and open pull requests.
- **1. Data Processing**: Learn to clean and tidy your datasets in preparation for analysis.
- **2. Data Construction**: Build indicators and variables from the processed data.
- **3. Data Analysis**: Conduct analyses using the constructed data.
- **4. Reproducibility Package**: Package all work into a reproducible format for sharing and validation.


This package includes three main folders: Code, Datawork, Output, ado

Code folder is organized as follows: 

1. Main.do: Main do file to run all the other files, load all the packages and set up directory. One should edit the "Username" and directory path to their local system and folders. 
2. 01-Processing-data.do: This file processes the data for it to be tidy. 
3. 02-Constructing-data.do: This file constructs the indicators later required for the analysis process. 
4. 03-Analysis-data.do: This file analyses the data and produces figures and tables as outputs. 

Datawork folder is organized as follows: 
A. Data:
1. Raw: This has all the raw data.
2. Intermediate: This has data after processing.
3. Final: Final data is data after construction process and is the final data used for analysis. 
4. Documentation 

B. Documentation: The folder includes a survey questionnaire file. 

Output Folder is organized as follows: 



There is a ado folder which includes all dependencies needed to run the package.  

Feel free to update this README as you progress through the sessions and customize it to reflect the details of your project. For more details on the elements required for a reproducibility package, refer to our [README template](https://github.com/worldbank/wb-reproducible-research-repository/blob/main/resources/README_Template.md), which you will cover in the **Reproducibility Package** session.

Remember this is what you will share with your peer at the end of the training for review. 


Training: For the rrf 24
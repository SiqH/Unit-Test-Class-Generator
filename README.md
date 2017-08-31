# Unit-Test-Class-Generator
Generate Unit Test class for Salesforce Apex Class and Trigger

## Please follow the steps given below sequencially to run the application:
Step-1: Install [Force.com CLI](https://developer.salesforce.com/tools/forcecli) if it is not installed already

Step-2: Create/Save **ApexClassSymbolTable.cls, GenerateApexClass.cls, ApexTestClassGenUtil.cls and UnitTestDataFactory.cls** classes in order

Step-3: Create/Save sample **TemperatureConverter.cls and AccountDeletion.trigger**

Step-4: Create the Visualforce Component **UnitTestClassComponent.component**

Step-5: Create 2 Visualforce Email Templates **GenerateTestClassTemplate.email and GenerateTriggerTestClassTemplate.email**

Step-6: Copy 2 Sample JSON file somewhere in your local machine

Step-7: Go to the command prompt from the directory where you have saved the Sample JSON files

Step-8: Log into the Salesforce Org, where you have copied/created the files mentioned above using **force login** command

Step-9: Once your login is successful run **force apex apexjson.txt** to generate Unit Test Class for **TemperatureConverter.cls**

Step-10: Run **force apex triggerjson.txt** to generate Unit Test Class for **AccountDeletion.trigger**

### You can modify the Sample JSON files to modify test data or create your own test cases 

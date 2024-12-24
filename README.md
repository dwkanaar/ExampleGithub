# ExampleGithub: How to use PyTaskExec

PyTaskExec is part of the PyComponents suite of Python tools, which was created to help run MaSQE code more easily when sweeping over parameters without needing to manually re-run the code.
This repository will explain how to use the PyTaskExec files through an example of how I use it and the commands I use.

## The basic concept of PyTaskExec 

The purpose of PyTaskExec is to run an executable with different variables.
In MaSQE we specify the parameters using XML files and the compiled C++ executable can use those variables using the XML parser prof. Anderson wrote.
So PyTaskExec works is a way to facilitate this for a sweep over parameters by creating a bunch of .xml files based of a template.
These .xml files are created in separate directories so that the executable can be run in each directory with that directory's xml file.
Then, the resulting output of running the executable with a particular XML file is output in that directory.
Finally, the output data in each directory is collected into a SQL database (.db file).

## Step 1. Create XML files used for the parameters you want to sweep

The first step is to make a template and example XML file.
The example .xml file, [Sweep.xml](Sweep.xml), that I used to run over parameters looked like this:
```
<?xml version="1.0" standalone="no"?>
<Run_Parameters>
	<runParameter1 value = "1.0" type = "double" />
	<runParameter2 value = "0.0" type = "double" />  
</Runr_Parameters>
```
The template file, Sweep.tpl, is then: 
```
<?xml version="1.0" standalone="no"?>
<Run_Parameters>
<runParameter1 value = "$val1r" type = "double" />
<runParameter2 value = "$val2" type = "double" />  
</Run_Parameters>
```
These files are used as input into the .xml file, SetupSweep.xml, which is the actual input file for the first command.
```
<?xml version="1.0" encoding="utf-8"?>
<TaskBuilderData>

    <taskRanges>
        <runParameter1>
            <min> 0.0 </min>
            <max> 9.0 </max>
            <increment> 1.0</increment>
            <runParameter2>
                <min> 0.0 </min>
                <max> 99.0 </max>
                <increment> 1.0</increment>
            </runParameter2>
        </runParameter1>
    </taskRanges>
   
    <jobData>
        <executableCommand   value = "python3 u/home/d/dwkanaar/MaSQE/RunFiles/PyExecDK.py"/>
        <runFileName         value = "Sweep.xml" />
        <runFileTemplate     value = "Sweep.tpl"  type = "file" />
        <outputHandlerScript value = "DefaultOutputHandler.py" />
    </jobData>

    <runParameters>
        <numDisorder     value =   "0.0"     type = "double" />
        <counter     value =  "0.0"    type = "double" />
    </runParameters>

    <outputData>
        <Capture_Data_0      type = "double" />
        <Capture_Data_1      type = "double" />
        <Capture_Data_3      type = "double" />
    </outputData>
</TaskBuilderData>
```
In this file you choose the parameters you want to capture in this case:
```
    <outputData>
        <Capture_Data_0      type = "double" />
        <Capture_Data_1      type = "double" />
        <Capture_Data_3      type = "double" />
    </outputData>
```
Capture_Data_0, Capture_Data_1, and Capture_Data_2. To later capture these the C++ executable has to print them out in a certain way.
This way is
```
Capture_Data_0 : value
```
which can be done in C++ in the following manner:
```
logStream << "Capture_Data_" << " : " << value << "\n";
```
### Notes on this step:
First, note that the command that I execute in each directory is:
```
<executableCommand   value = "python3 u/home/d/dwkanaar/MaSQE/RunFiles/PyExecDK.py"/>
```
which is a Python command that uses the .xml in each directory as input for a C++ executable.
However, you can also just run the executable directly if you don't have any processing you want to do in python by changing this line to:
```
<executableCommand   value = "u/home/d/dwkanaar/MaSQE/Release/RunSingleParticle -f Sweep.xml"/>
```
as long as the Sweep.xml file has all the inputs needed for the executable.
The Sweep.xml files can contain more than just the sweep parameters.

Second, note that file names:
```
        <runFileName         value = "Sweep.xml" />
        <runFileTemplate     value = "Sweep.tpl"  type = "file" />
```
have to match the names you gave the .xml and .tpl files you made at the beginning of Part 1.


## Part 2: Create the database file

The next step is to create the SQL .db file that PyTaskExec will later be used to create the ./TaskData/SweepData1 directories housing the XML files.
The command is
```
python3 /u/home/d/dwkanaar/MaSQE/PyComponents/PyTaskExec/TaskDbBuilder.py -x SetupSweep.xml -t SetupSweep -d SweepData.db
```
where you have to replace the path with the path to your PyComponents directory. 

-x file uses SetupSweep.xml as the file that the template is based on as the output
-d SweepData.db makes the database you output called SweepData.db

The .db files are SQL databases which on Linux you look around in without needing to know SQL using the DBbrowser program.
You can also use python to read the .db files using SQL commands and pandas and sqlite3 like:
```
import pandas as pd
import sqlite3

cnx=sqlite3.connect('SweepData.db')
df=pd.read_sql_query('SELECT Capture_Data_0, Capture_Data_1, Capture_Data_2 FROM SweepData',cnx)
print(df.to_string())
```

## PArt 3: Create the TaskData directory and XML files per directory

Next PyTaskExec creates the individual directory for the XML files within a new directory, ./TaskData, where the Python file is run. 
The command to run this file is:
```
python3 ../PyComponents/PyTaskExec/CreateTaskDataFiles.py -x SetupSweep.xml -d SweepData.db
```
where -d SweepData.db is the database we just created and -x SetupWeep.xml is the same XML file used to create the database.


## Part 4: Run the files as one job/command:

The following command will run the command you instructed to be run in each of the directories:
```
python3 ./PyComponents/PyTaskExec/ExecRun -d SetupDisorderSweep.db -t SetupDisorderSweep -n 4
```
The option -n 4 tells the code to run on 4 threads at once. This means it will start the first 4 XML input and then run the next ones as they complete, having 4 executables running at once.
If you are using an interactive node on the cluster be careful to make sure your code can run with that much memory. 

This command can be used in a job.sh file to run it on the cluster, however, this will only be a singular job.
It might be faster to use a jobarray which will be covered in Part 6.

## Part 5: Capture the data

The data is then captured from the output files from the jobs using the CaptureOutput.py file like:
```
python3 /u/home/d/dwkanaar/MaSQE/PyComponents/PyTaskExec/CaptureOutput.py -d SweepData.db -x SetupSweep.xml -a joblog.5039152
```
Where the SweepData.db file has to be in the TaskData Directory where you call this command or call it with ../SweepData.db.
-a joblog.5039152 has to be replaced with the name of the job you had which can be easily checked by going into the folder and looking at the name of the job. 

## Part 6: Using Job array instead of single job



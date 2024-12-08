# ExampleGithub: How to use PyTaskExec

PyTaskExec is part of the PyComponents suite of Python tools, which was created to help run MaSQE code more easily when sweeping over parameters without needing to manually re-run the code.
This repository will explain how to use the PyTaskExec files through an example of how I use it and the commands I use.

## The basic concept of PyTaskExec 

The purpose of PyTaskExec is to run an executable with different variables.
In MaSQE we specify the parameters using XML files and the compiled C++ executable can use those variables using the XML parser prof. Anderson wrote.
So PyTaskExec works in a way to facilitate this for a sweep over parameters by creating a bunch of .xml files based of a template.
These .xml files are created in separate folders so that the executable can be run in each folder with that folder's xml file.
Then, the resulting output of running the executable with a particular XML file is output in that folder.
Finally, the output data in each folder is collected into a database (.db file).

## Step 1. Create XML files used for the parameters you want to sweep

The first step is to make a template and example XML file.
The example .xml file, Sweep.xml, that I used to run over parameters looked like this:
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
Capture_Data_0 (Check Cluster later)
```
### Notes on this step:
First, note that the command that I execute in each folder:
```
<executableCommand   value = "python3 u/home/d/dwkanaar/MaSQE/RunFiles/PyExecDK.py"/>
```
is a Python command that uses the .xml in each folder.
However, if you can just run the executable you could do something like:
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

The next step is to create the .db file that PyTaskExec will later use to create the ./TaskData/SweepData1 folders housing the xml files.
The command is
```
python3 /u/home/d/dwkanaar/MaSQE/PyComponents/PyTaskExec/TaskDbBuilder.py -x SetupSweep.xml -t SetupSweep -d SweepData.db
```
where you have to replace the path with the path to your PyComponents folder. 

-x file uses SetupSweep.xml as the file that the template is based on as the output
-d SweepData.db makes the database you output called SweepData.db

After this step you

Then  run


python3 ../PyComponents/PyTaskExec/CreateTaskDataFiles.py -x SetupDisorderSweep.xml -d SetupDisorderSweep.db

To create the TaskData folders with the xml files in them with the parameters you want to run

Then to run the files as one job/command:

python3 ./PyComponents/PyTaskExec/ExecRun -d SetupDisorderSweep.db -t SetupDisorderSweep -n 4

 Or to run it as a job array if it’s a very parallel job.

Then to capture the data
You need the db in the file and run 
python3 /u/home/d/dwkanaar/MaSQE/PyComponents/PyTaskExec/CaptureOutput.py -d SweepData.db -x SetupSweep.xml -a joblog.5039152


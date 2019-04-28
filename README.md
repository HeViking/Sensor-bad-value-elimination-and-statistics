# Sensor-bad-value-elimination-and-statistics
Eliminate the bad value of the continuous data collected by the sensor, and determine whether there is linear deviation and periodic deviation, the average value of the statistical data, absolute error, relative error

function [average,error] = Isee(x0,c,detail)

The equivalent precision measurement result is processed, and the expression of the measurement result is output (mean value ± absolute error)

[average,error] = Isee(x0,c,detail)

-----Input parameters-------

x0: measured source data (one-dimensional vector: 1*n vector)

c: correction value (a number) (default is 0)

detail: Whether to display detailed processing results (one number, default value is 0), =0 not displayed, =1 display, = 2 only shows the final result (suitable for multi-category data analysis)

-----Output parameters-------

average: average

error: absolute error

—————Example of use————————

 1.
 >>Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32]);

 2. Create a new variable a, double-click to edit the variable, enter or copy the data, and note that it needs to be a 1*n-dimensional vector (ie, horizontally arranged).
 >>Isee(a);

 3. Advanced application
 >>Isee([1,2,3], 0.1 , 1); % correction value is 0.1 , showing detailed results
 
 
 
 
 
 function [ ] = txtsee( file )
 
 Processes the txt data in the specified format, and outputs the processed result.
 
 Enter the parameter file: the path to Notepad, such as 'data.txt' (the default directory is matlab's work path) or 'C:\Users\Administrator\Desktop\data.txt'
 
 output: average and absolute error of each data
 
Note: This function needs to be used in Matlab2010 or higher.

function [ ] = txtsee( file )
% Processes the txt data in the specified format, and outputs the processed result.
%[ ] = txtsee( file )
% Enter the parameter file: the path to Notepad, such as 'data.txt' (the default directory is matlab's work path) or 'C:\Users\Administrator\Desktop\data.txt'
% output: average and absolute error of each data
%Note: This function needs to be used in Matlab2010 or higher.

class = ['North latitude: '; 'East: '; 'Temperature: '; 'Height: '; 
weidu_n = 1;
jingdu_n = 1;
temper_n = 1;
height_n = 1;
pressure_n = 1;
PM_n = 1;

%Open the established file
fp = fopen(file);

while ~feof(fp)
    line = fgetl(fp); % reads a line of string data
    if(strfind(line,class(1,:)) == 1)   % reads a line of string data
        k = strfind(line , 'degree');  % North latitude
        temp = line(4:k-1);
        weidu(weidu_n) = str2num(temp);
        weidu_n = weidu_n + 1;
    end
    
    if(strfind(line,class(2,:)) == 1)   %East
        k = strfind(line , 'degree');
        temp = line(4:k-1);
        jingdu(jingdu_n) = str2num(temp);
        jingdu_n = jingdu_n + 1;
    end
    
    if(strfind(line,class(3,:)) == 1)   %degree Celsius
        k = strfind(line , 'degree Celsius');
        temp = line(4:k-1);
        temper(temper_n) = str2num(temp);
        temper_n = temper_n + 1;
    end
    
    if(strfind(line,class(4,:)) == 1)   %degree Celsius
        k = strfind(line , 'm');
        temp = line(4:k-1);
        height(height_n) = str2num(temp);
        height_n = height_n + 1;
    end
    
    if(strfind(line,class(5,:)) == 1)   %pressure
        k = strfind(line , 'PA');
        temp = line(4:k-1);
        pressure(pressure_n) = str2num(temp);
        pressure_n = pressure_n + 1;
    end
    
    if(strfind(line,'PM2.5£º') == 1)  %PM2.5, the length is different
        k = strfind(line , 'ug/m3');
        temp = line(7:k-1);
        PM(PM_n) = str2num(temp);
        PM_n = PM_n + 1;
    end
end
fclose(fp);

fprintf('%s',class(1,:));
Isee(weidu,0,2);  % Processes the acquired data. See help Isee for details.
??????????????????% To view specific information, change the third parameter from 2 to 1.
fprintf('%s',class(2,:));
Isee(jingdu,0,2);

fprintf('%s',class(3,:));
Isee(temper,0,2);

fprintf('%s',class(4,:));
Isee(height,0,2);

fprintf('%s',class(5,:));
Isee(pressure,0,2);

fprintf('PM2.5£º');
Isee(PM,0,2);
end


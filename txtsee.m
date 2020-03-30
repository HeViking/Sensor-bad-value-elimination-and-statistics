function [ ] = txtsee( file )
%对既定格式的txt数据进行处理，输出处理后的结果
%[ ] = txtsee( file )
%输入参数file：记事本的路径，如'data.txt'(默认目录为matlab的work路径)或'C:\Users\Administrator\Desktop\data.txt'
%输出结果：每项数据的平均值和绝对误差
%注意：本函数需在Matlab2010或更高版本使用

%初始化
class = ['北纬：';'东经：';'温度：';'高度：';'气压：'];
weidu_n = 1;
jingdu_n = 1;
temper_n = 1;
height_n = 1;
pressure_n = 1;
PM_n = 1;

%打开既定文件
fp = fopen(file);

while ~feof(fp)
    line = fgetl(fp); %读取一行字符串数据
    if(strfind(line,class(1,:)) == 1)   %北纬
        k = strfind(line , '度');
        temp = line(4:k-1);
        weidu(weidu_n) = str2num(temp);
        weidu_n = weidu_n + 1;
    end
    
    if(strfind(line,class(2,:)) == 1)   %东经
        k = strfind(line , '度');
        temp = line(4:k-1);
        jingdu(jingdu_n) = str2num(temp);
        jingdu_n = jingdu_n + 1;
    end
    
    if(strfind(line,class(3,:)) == 1)   %温度
        k = strfind(line , '摄氏度');
        temp = line(4:k-1);
        temper(temper_n) = str2num(temp);
        temper_n = temper_n + 1;
    end
    
    if(strfind(line,class(4,:)) == 1)   %高度
        k = strfind(line , '米');
        temp = line(4:k-1);
        height(height_n) = str2num(temp);
        height_n = height_n + 1;
    end
    
    if(strfind(line,class(5,:)) == 1)   %气压
        k = strfind(line , 'PA');
        temp = line(4:k-1);
        pressure(pressure_n) = str2num(temp);
        pressure_n = pressure_n + 1;
    end
    
    if(strfind(line,'PM2.5：') == 1)  %PM2.5，长度不一样
        k = strfind(line , 'ug/m3');
        temp = line(7:k-1);
        PM(PM_n) = str2num(temp);
        PM_n = PM_n + 1;
    end
end
fclose(fp);

fprintf('%s',class(1,:));
Isee(weidu,0,2);  %对获取到的数据进行处理，详情参考help Isee
                  %若要查看具体信息，可将第三个参数从2改为1
fprintf('%s',class(2,:));
Isee(jingdu,0,2);

fprintf('%s',class(3,:));
Isee(temper,0,2);

fprintf('%s',class(4,:));
Isee(height,0,2);

fprintf('%s',class(5,:));
Isee(pressure,0,2);

fprintf('PM2.5：');
Isee(PM,0,2);
end


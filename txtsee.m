function [ ] = txtsee( file )
%�Լȶ���ʽ��txt���ݽ��д�����������Ľ��
%[ ] = txtsee( file )
%�������file�����±���·������'data.txt'(Ĭ��Ŀ¼Ϊmatlab��work·��)��'C:\Users\Administrator\Desktop\data.txt'
%��������ÿ�����ݵ�ƽ��ֵ�;������
%ע�⣺����������Matlab2010����߰汾ʹ��

%��ʼ��
class = ['��γ��';'������';'�¶ȣ�';'�߶ȣ�';'��ѹ��'];
weidu_n = 1;
jingdu_n = 1;
temper_n = 1;
height_n = 1;
pressure_n = 1;
PM_n = 1;

%�򿪼ȶ��ļ�
fp = fopen(file);

while ~feof(fp)
    line = fgetl(fp); %��ȡһ���ַ�������
    if(strfind(line,class(1,:)) == 1)   %��γ
        k = strfind(line , '��');
        temp = line(4:k-1);
        weidu(weidu_n) = str2num(temp);
        weidu_n = weidu_n + 1;
    end
    
    if(strfind(line,class(2,:)) == 1)   %����
        k = strfind(line , '��');
        temp = line(4:k-1);
        jingdu(jingdu_n) = str2num(temp);
        jingdu_n = jingdu_n + 1;
    end
    
    if(strfind(line,class(3,:)) == 1)   %�¶�
        k = strfind(line , '���϶�');
        temp = line(4:k-1);
        temper(temper_n) = str2num(temp);
        temper_n = temper_n + 1;
    end
    
    if(strfind(line,class(4,:)) == 1)   %�߶�
        k = strfind(line , '��');
        temp = line(4:k-1);
        height(height_n) = str2num(temp);
        height_n = height_n + 1;
    end
    
    if(strfind(line,class(5,:)) == 1)   %��ѹ
        k = strfind(line , 'PA');
        temp = line(4:k-1);
        pressure(pressure_n) = str2num(temp);
        pressure_n = pressure_n + 1;
    end
    
    if(strfind(line,'PM2.5��') == 1)  %PM2.5�����Ȳ�һ��
        k = strfind(line , 'ug/m3');
        temp = line(7:k-1);
        PM(PM_n) = str2num(temp);
        PM_n = PM_n + 1;
    end
end
fclose(fp);

fprintf('%s',class(1,:));
Isee(weidu,0,2);  %�Ի�ȡ�������ݽ��д�������ο�help Isee
                  %��Ҫ�鿴������Ϣ���ɽ�������������2��Ϊ1
fprintf('%s',class(2,:));
Isee(jingdu,0,2);

fprintf('%s',class(3,:));
Isee(temper,0,2);

fprintf('%s',class(4,:));
Isee(height,0,2);

fprintf('%s',class(5,:));
Isee(pressure,0,2);

fprintf('PM2.5��');
Isee(PM,0,2);
end


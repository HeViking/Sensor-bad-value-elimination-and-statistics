function [average,error] = Isee(x0,c,detail)
%对等精密度测量结果进行处理，输出测量结果的表达式(平均值 ± 绝对误差)
%[average,error] = Isee(x0,c,detail)
%—————输入参数———————
%x0:测量的源数据（一维向量:1*n向量）
%c:修正值（一个数）（默认值为0）
%detail：是否显示详细处理结果（一个数,默认值为0），=0不显示，=1显示，=2只显示最终结果（适合多类别数据分析）
%—————输出参数———————
%average：平均值
%error：绝对误差
%—————使用范例———————
% 1.>>Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32]);
%
% 2.新建变量a，双击编辑变量，输入或复制数据，注意需为 1*n 维向量(即打横排列)。
%   >>Isee(a);
% 3.高级应用
%   >>Isee([1,2,3],  0.1 , 1);   %修正值为0.1  ， 显示详细结果


%重要局部变量
%v : 剩余误差（一维向量）
%standard ：标准差的估计值
%indeter ： 随机不确定度
%avererror : 算术平均值标准差估计值
%rela_error ： 相对误差
%average0 ：  四舍五入后的平均值
%error0 : 四舍五入后的绝对误差

%length0 ：原数据个数
%length ：剔除坏值后的数据个数
%bad : 坏值集合
%bad_n ：坏值个数
%flag_bad :坏值标志，=1有坏值，=0无坏值
%flag_same :数据相同标志 , =length全部相同

%格拉布斯系数表
%       1     2        3       4        5       6          7        8        9        10
G = [   0  ,  0   ,  1.15  ,  1.46  , 1.67  ,  1.82   ,  1.94  ,  2.03  ,   2.11  ,  2.18, ...
    2.23 , 2.29 ,  2.33  ,  2.37  , 2.41  ,  2.44   ,  2.47  ,  2.50  ,   2.53  ,  2.56, ...
    2.58 , 2.60 ,  2.62  ,  2.64  , 2.66];

%*****************输入参数处理*********************************
if(nargin < 3)
    detail = 0;
end
if(nargin < 2)
    c = 0;    %没有输入修正值时，修正值为0
end
if(nargin < 1)
    error('【请输入第一个参数，即源数据】。详情请参考 help HHL');
end

%****************初始化*********************
flag_bad = 1;          %坏值标志
bad_n = 0;             %坏值个数
[a,length0] = size(x0);    %原数据长度
temp = x0;
for i=1:length0        %第一步：加上修正值
    temp(i) = temp(i) + c;
end

if(length0 <= 2)     %待处理的数据数小于2直接退出
    disp('数据量太少，数据量应大于2个')
    return;
end

%***************************剔除坏值**************************************
while(flag_bad == 1)     %没有坏值时可以结束
    z = temp;
    [a,length] = size(temp);      %处理数据长度
    
    average = mean(z);    %第二步：求平均值
    
    for i=1:length        %第三步：求剩余误差
        v(i) = z(i) - average;
    end
    
    %第四步：求标准差估计值(贝塞尔公式)
    sum1 = 0;
    for i=1:length
        sum1 = sum1 + v(i)^2;
    end
    standard = sqrt(  sum1 / (length - 1 )  );
    
    %第五步：计算随机不确定度，剔除坏值
    if(length <= 25)     %求随机不确定度
        indeter = G(length) * standard;
    else
        indeter = 3 * standard;
    end
    flag_bad = 0;  %剔出坏值初始化，无坏值
    temp = [];
    j = 1;
    for i=1:length       %剔除坏值
        if(abs(v(i)) > indeter)   %坏值
            bad(bad_n+1) = z(i);  %记录坏值
            bad_n = bad_n +1;
            flag_bad = 1;         %坏值标志
        else
            temp(j) = z(i);
            j = j+1;
        end
    end
    
    %判断剩下的数据数
    [a ,length_temp] = size(temp);
    if(length_temp <= 2  ||  length_temp < length0 /2)     %待处理的数据数小于3  或 小于源数据量的一半 直接退出
        disp('坏值太多，请重新测量')
        return;
    end
end

%***************特殊情况判断，判断数据是否都相等******************************
flag_same = 1;
for i=2:length
    if(  abs(z(i) - z(1)) <  10^(-7) )
        flag_same = flag_same + 1;
    end
end
if(flag_same == length)  %数据都相同，直接输出
    fprintf('测量数据平均值为 %g  ,  绝对误差为 0 ， 相对误差为 0 %%\n',average);
    fprintf('源数据共有%d个，',length0);
    if(bad_n == 0)
        fprintf('数据良好，没有坏值\n');
    else
        fprintf('坏值共有%d个，如下所示：',bad_n);
        bad
    end
    return;
end
%**********************第七步：马利科夫判据**************************
deta = 0;
if(detail ~= 2)
    if(mod(length , 2) == 0)  %待处理数据长度为偶数
        for i=1:length /2
            deta = deta + v(i);
        end
        for i= length /2 +1 : length
            deta = deta - v(i);
        end
    else   %为奇数
        for i=1:(length-1) /2
            deta = deta + v(i);
        end
        for i= (length +3) / 2 : length
            deta = deta - v(i);
        end
    end
    
    if( abs(deta) > abs( max(v) ))
        disp('存在线性系差，数据原则上不能使用！')
    end
    
    %*******************阿卑——赫梅特判据******************************
    sum1 = 0;
    for i=1:length-1
        sum1 = sum1 + v(i)*v(i+1);
    end
    
    if(abs(sum1)  >  sqrt(length-1)* standard^2)
        disp('存在周期性系差，数据原则上不能使用！')
    end
end
%****************计算绝对误差、相对误差********************
avererror = standard / sqrt(length);    %第八步：计算算术平均值标准差估计值
if( length <=25 )                       %第九步：计算算术平均值的不确定度
    error =  G(length) * avererror;
else
    error =  3 * avererror;
end
rela_error = error/average * 100;

%************************测量结果报告****************************
%绝对误差保留一位有效数字，平均值保留到与绝对误差相同的位
temp = error;
if (error <1)    %绝对误差小于1
    for i=1:500
        temp = temp * 10;
        if(temp >= 1)
            break;
        end
    end
    wei = i;   %绝对误差保留到的位数
    error0 = roundn(error,-wei);   %四舍五入，保留到小数点后第wei位
    average0 = roundn(average,-wei);
else
    for i=0:500
        temp = temp / 10;
        if(temp <= 1)
            break;
        end
    end
    wei = i;   %绝对误差保留到的位数
    error0 = roundn(error,wei);      %四舍五入，保留到小数点前第wei+1位
    average0 = roundn(average,wei);
end

if(detail ~= 2)
    fprintf('最终结果 ： %g ± %g\n' , average0 , error0);
else
    fprintf(' %g ± %g\n' , average0 , error0);
end

if(detail ~= 1)   %不显示详细结果
    return;
end

fprintf('测量数据平均值为 %g  ,  绝对误差为 %g ， 相对误差为 %g %%\n',average , error  ,  rela_error);
fprintf('源数据共有%d个，',length0);
if(bad_n == 0)
    fprintf('数据良好，没有坏值\n');
else
    fprintf('坏值共有%d个，如下所示：',bad_n);
    bad
end

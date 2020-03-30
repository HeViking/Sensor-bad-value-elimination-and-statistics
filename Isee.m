function [average,error] = Isee(x0,c,detail)
%�ԵȾ��ܶȲ���������д��������������ı��ʽ(ƽ��ֵ �� �������)
%[average,error] = Isee(x0,c,detail)
%�������������������������������
%x0:������Դ���ݣ�һά����:1*n������
%c:����ֵ��һ��������Ĭ��ֵΪ0��
%detail���Ƿ���ʾ��ϸ��������һ����,Ĭ��ֵΪ0����=0����ʾ��=1��ʾ��=2ֻ��ʾ���ս�����ʺ϶�������ݷ�����
%�������������������������������
%average��ƽ��ֵ
%error���������
%����������ʹ�÷�����������������
% 1.>>Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32]);
%
% 2.�½�����a��˫���༭����������������ݣ�ע����Ϊ 1*n ά����(���������)��
%   >>Isee(a);
% 3.�߼�Ӧ��
%   >>Isee([1,2,3],  0.1 , 1);   %����ֵΪ0.1  �� ��ʾ��ϸ���


%��Ҫ�ֲ�����
%v : ʣ����һά������
%standard ����׼��Ĺ���ֵ
%indeter �� �����ȷ����
%avererror : ����ƽ��ֵ��׼�����ֵ
%rela_error �� ������
%average0 ��  ����������ƽ��ֵ
%error0 : ���������ľ������

%length0 ��ԭ���ݸ���
%length ���޳���ֵ������ݸ���
%bad : ��ֵ����
%bad_n ����ֵ����
%flag_bad :��ֵ��־��=1�л�ֵ��=0�޻�ֵ
%flag_same :������ͬ��־ , =lengthȫ����ͬ

%������˹ϵ����
%       1     2        3       4        5       6          7        8        9        10
G = [   0  ,  0   ,  1.15  ,  1.46  , 1.67  ,  1.82   ,  1.94  ,  2.03  ,   2.11  ,  2.18, ...
    2.23 , 2.29 ,  2.33  ,  2.37  , 2.41  ,  2.44   ,  2.47  ,  2.50  ,   2.53  ,  2.56, ...
    2.58 , 2.60 ,  2.62  ,  2.64  , 2.66];

%*****************�����������*********************************
if(nargin < 3)
    detail = 0;
end
if(nargin < 2)
    c = 0;    %û����������ֵʱ������ֵΪ0
end
if(nargin < 1)
    error('���������һ����������Դ���ݡ���������ο� help HHL');
end

%****************��ʼ��*********************
flag_bad = 1;          %��ֵ��־
bad_n = 0;             %��ֵ����
[a,length0] = size(x0);    %ԭ���ݳ���
temp = x0;
for i=1:length0        %��һ������������ֵ
    temp(i) = temp(i) + c;
end

if(length0 <= 2)     %�������������С��2ֱ���˳�
    disp('������̫�٣�������Ӧ����2��')
    return;
end

%***************************�޳���ֵ**************************************
while(flag_bad == 1)     %û�л�ֵʱ���Խ���
    z = temp;
    [a,length] = size(temp);      %�������ݳ���
    
    average = mean(z);    %�ڶ�������ƽ��ֵ
    
    for i=1:length        %����������ʣ�����
        v(i) = z(i) - average;
    end
    
    %���Ĳ������׼�����ֵ(��������ʽ)
    sum1 = 0;
    for i=1:length
        sum1 = sum1 + v(i)^2;
    end
    standard = sqrt(  sum1 / (length - 1 )  );
    
    %���岽�����������ȷ���ȣ��޳���ֵ
    if(length <= 25)     %�������ȷ����
        indeter = G(length) * standard;
    else
        indeter = 3 * standard;
    end
    flag_bad = 0;  %�޳���ֵ��ʼ�����޻�ֵ
    temp = [];
    j = 1;
    for i=1:length       %�޳���ֵ
        if(abs(v(i)) > indeter)   %��ֵ
            bad(bad_n+1) = z(i);  %��¼��ֵ
            bad_n = bad_n +1;
            flag_bad = 1;         %��ֵ��־
        else
            temp(j) = z(i);
            j = j+1;
        end
    end
    
    %�ж�ʣ�µ�������
    [a ,length_temp] = size(temp);
    if(length_temp <= 2  ||  length_temp < length0 /2)     %�������������С��3  �� С��Դ��������һ�� ֱ���˳�
        disp('��ֵ̫�࣬�����²���')
        return;
    end
end

%***************��������жϣ��ж������Ƿ����******************************
flag_same = 1;
for i=2:length
    if(  abs(z(i) - z(1)) <  10^(-7) )
        flag_same = flag_same + 1;
    end
end
if(flag_same == length)  %���ݶ���ͬ��ֱ�����
    fprintf('��������ƽ��ֵΪ %g  ,  �������Ϊ 0 �� ������Ϊ 0 %%\n',average);
    fprintf('Դ���ݹ���%d����',length0);
    if(bad_n == 0)
        fprintf('�������ã�û�л�ֵ\n');
    else
        fprintf('��ֵ����%d����������ʾ��',bad_n);
        bad
    end
    return;
end
%**********************���߲��������Ʒ��о�**************************
deta = 0;
if(detail ~= 2)
    if(mod(length , 2) == 0)  %���������ݳ���Ϊż��
        for i=1:length /2
            deta = deta + v(i);
        end
        for i= length /2 +1 : length
            deta = deta - v(i);
        end
    else   %Ϊ����
        for i=1:(length-1) /2
            deta = deta + v(i);
        end
        for i= (length +3) / 2 : length
            deta = deta - v(i);
        end
    end
    
    if( abs(deta) > abs( max(v) ))
        disp('��������ϵ�����ԭ���ϲ���ʹ�ã�')
    end
    
    %*******************����������÷���о�******************************
    sum1 = 0;
    for i=1:length-1
        sum1 = sum1 + v(i)*v(i+1);
    end
    
    if(abs(sum1)  >  sqrt(length-1)* standard^2)
        disp('����������ϵ�����ԭ���ϲ���ʹ�ã�')
    end
end
%****************���������������********************
avererror = standard / sqrt(length);    %�ڰ˲�����������ƽ��ֵ��׼�����ֵ
if( length <=25 )                       %�ھŲ�����������ƽ��ֵ�Ĳ�ȷ����
    error =  G(length) * avererror;
else
    error =  3 * avererror;
end
rela_error = error/average * 100;

%************************�����������****************************
%��������һλ��Ч���֣�ƽ��ֵ����������������ͬ��λ
temp = error;
if (error <1)    %�������С��1
    for i=1:500
        temp = temp * 10;
        if(temp >= 1)
            break;
        end
    end
    wei = i;   %������������λ��
    error0 = roundn(error,-wei);   %�������룬������С������weiλ
    average0 = roundn(average,-wei);
else
    for i=0:500
        temp = temp / 10;
        if(temp <= 1)
            break;
        end
    end
    wei = i;   %������������λ��
    error0 = roundn(error,wei);      %�������룬������С����ǰ��wei+1λ
    average0 = roundn(average,wei);
end

if(detail ~= 2)
    fprintf('���ս�� �� %g �� %g\n' , average0 , error0);
else
    fprintf(' %g �� %g\n' , average0 , error0);
end

if(detail ~= 1)   %����ʾ��ϸ���
    return;
end

fprintf('��������ƽ��ֵΪ %g  ,  �������Ϊ %g �� ������Ϊ %g %%\n',average , error  ,  rela_error);
fprintf('Դ���ݹ���%d����',length0);
if(bad_n == 0)
    fprintf('�������ã�û�л�ֵ\n');
else
    fprintf('��ֵ����%d����������ʾ��',bad_n);
    bad
end

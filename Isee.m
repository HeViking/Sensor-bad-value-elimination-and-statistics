function [average,error] = Isee(x0,c,detail)
% The equivalent precision measurement result is processed, and the expression of the measurement result is output (mean value ＼ absolute error)
%[average,error] = Isee(x0,c,detail)
%-----Input parameters-------
%x0: measured source data (one-dimensional vector: 1*n vector)
%c: correction value (a number) (default is 0)
%detail: Whether to display detailed processing results (one number, default value is 0), =0 not displayed, =1 display, = 2 only shows the final result (suitable for multi-category data analysis)
%-----Output parameters-------
%average: average
%error: absolute error
%！！！！！Example of use！！！！！！！！
% 1.>>Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32]);
%
% 2. Create a new variable a, double-click to edit the variable, enter or copy the data, and note that it needs to be a 1*n-dimensional vector (ie, horizontally arranged).
% >>Isee(a);
% 3. Advanced application
% >>Isee([1,2,3], 0.1 , 1); % correction value is 0.1 , showing detailed results


% important local variable
%v : residual error (one-dimensional vector)
%standard : estimated value of standard deviation
%indeter : random uncertainty
%avererror : Arithmetic mean standard deviation estimate
%rela_error : relative error
%average0 : Average after rounding
%error0 : absolute error after rounding

%length0 : the number of original data
%length : the number of data after the bad value is removed
%bad : bad value set
%bad_n : the number of bad values
%flag_bad: bad value flag, =1 has bad value, =0 no bad value
%flag_same : data with the same flag, =length all the same

% Grubbs coefficient table
% 1 2 3 4 5 6 7 8 9 10
G = [ 0 , 0 , 1.15 , 1.46 , 1.67 , 1.82 , 1.94 , 2.03 , 2.11 , 2.18 , ...
????2.23 , 2.29 , 2.33 , 2.37 , 2.41 , 2.44 , 2.47 , 2.50 , 2.53 , 2.56 , ...
????2.58, 2.60, 2.62, 2.64, 2.66];

%***************** Input parameter processing ***************************** ****
if(nargin < 3)
????Detail = 0;
end
if(nargin < 2)
????c = 0; % has no correction value, the correction value is 0
end
if(nargin < 1)
????Error('[Please enter the first parameter, ie source data]. for details, please refer to help HHL');
end

%****************initialization*********************
Flag_bad = 1; % bad value flag
Bad_n = 0; % bad value
[a,length0] = size(x0); % original data length
Temp = x0;
for i=1:length0 %Step 1: Add correction value
????Temp(i) = temp(i) + c;
end

if(length0 <= 2) % The number of pending data is less than 2 and exits directly
????disp ('The amount of data is too small, the amount of data should be greater than 2')
????return;
end

%*************************** Exclude bad values******************* *******************
while(flag_bad == 1) % can end without bad values
????z = temp;
????[a,length] = size(temp); %Processing data length
????
????Average = mean(z); %Step 2: Average
????
????for i=1:length %Step 3: Find residual error
????????v(i) = z(i) - average;
????end
????
????%Step 4: Find the standard deviation estimate (Bessel formula)
????Sum1 = 0;
????for i=1:length
????????Sum1 = sum1 + v(i)^2;
????end
????Standard = sqrt( sum1 / (length - 1 ) );
????
????%Step 5: Calculate random uncertainty and eliminate bad values
????if(length <= 25) % find random uncertainty
????????Indeter = G(length) * standard;
????else
????????Indeter = 3 * standard;
????end
????Flag_bad = 0; % culling bad value initialization, no bad value
????Temp = [];
????j = 1;
????for i=1:length % reject bad values
????????if(abs(v(i)) > indeter) % bad value
????????????Bad(bad_n+1) = z(i); % records bad values
????????????Bad_n = bad_n +1;
????????????Flag_bad = 1; % bad value flag
????????else
????????????Temp(j) = z(i);
????????????j = j+1;
????????end
????end
????
????% judges the remaining data
????[a ,length_temp] = size(temp);
????if(length_temp <= 2 || length_temp < length0 /2) % The number of data to be processed is less than 3 or less than half of the amount of source data
????????disp ('too bad value, please re-measure')
????????return;
????end
end

%***************Special case judgment, judge whether the data are equal************************* *****
Flag_same = 1;
for i=2:length
????if( abs(z(i) - z(1)) < 10^(-7) )
????????Flag_same = flag_same + 1;
????end
end
if(flag_same == length) % data is the same, direct output
????fprintf ('measured data average is %g, absolute error is 0, relative error is 0%%\n', average);
????fprintf('source data has %d, ', length0);
????if(bad_n == 0)
????????fprintf ('good data, no bad value\n');
????else
????????fprintf ('bad values ??total %d, as shown below: ', bad_n);
????????Bad
????end
????return;
end
%**********************Step 7: Malikov Criterion***************** *********
Deta = 0;
if(detail ~= 2)
????if(mod(length , 2) == 0) % The length of the data to be processed is even
????????for i=1:length /2
????????????Deta = deta + v(i);
????????end
????????for i= length /2 +1 : length
????????????Deta = deta - v(i);
????????end
????else % is odd
????????for i=1:(length-1) /2
????????????Deta = deta + v(i);
????????end
????????for i= (length +3) / 2 : length
????????????Deta = deta - v(i);
????????end
????end
????
????if( abs(deta) > abs( max(v) ))
????????disp ('There is a linearity difference, the data cannot be used in principle!')
????end
????
????%********************Ah - Hemet's Criterion ********************* *********
????Sum1 = 0;
????for i=1:length-1
????????Sum1 = sum1 + v(i)*v(i+1);
????end
????
????if(abs(sum1) > sqrt(length-1)* standard^2)
????????disp ('There is a periodic difference, the data cannot be used in principle!')
????end
end
%**************** Calculate absolute error, relative error **********************
Avererror = standard / sqrt(length); %Step 8: Calculate the arithmetic mean standard deviation estimate
if( length <=25 ) % Step 9: Calculate the uncertainty of the arithmetic mean
????Error = G(length) * avererror;
else
????Error = 3 * avererror;
end
Rela_error = error/average * 100;

%************************Measurement report********************** ******
% absolute error retains one significant digit and the average remains to the same bit as the absolute error
Temp = error;
if (error <1) % absolute error is less than 1
????for i=1:500
????????Temp = temp * 10;
????????if(temp >= 1)
????????????Break;
????????end
????end
????Wei = i; the number of digits % absolute error is retained
????Error0 = roundn(error,-wei); % rounded off, reserved to the wei position after the decimal point
????Average0 = roundn(average,-wei);
else
????for i=0:500
????????Temp = temp / 10;
????????if(temp <= 1)
????????????Break;
????????end
????end
????Wei = i; the number of digits % absolute error is retained
????Error0 = roundn(error,wei); % rounded off, reserved to the first wei+1 before the decimal point
????Average0 = roundn(average,wei);
end

if(detail ~= 2)
????fprintf('final result: %g ＼ %g\n' , average0 , error0);
else
????fprintf(' %g ＼ %g\n' , average0 , error0);
end

if(detail ~= 1) % does not show detailed results
???? return;
end

fprintf('measured data average is %g, absolute error is %g, relative error is %g %%\n', average, error, rela_error);
fprintf('source data has %d, ', length0);
if(bad_n == 0)
???? fprintf ('good data, no bad value\n');
else
???? fprintf ('bad values total %d, as shown below: ', bad_n);
???? Bad
end
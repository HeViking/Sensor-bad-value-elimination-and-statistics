# 函数简介
删除传感器采集数据的坏值，判断是否存在线性偏差和周期偏差，统计数据的平均值、绝对误差、相对误差  
本项目使用Matlab2014实现（需在Matlab2010或更高版本使用）

# ISee函数详细介绍
对等精密度测量结果进行处理，输出测量结果的表达式(平均值 ± 绝对误差)  
`[average,error] = Isee(x0,c,detail)`
#### 输入参数
`x0`:测量的源数据（一维向量:1*n向量）  
`c`:修正值（一个数）（默认值为0）  
`detail`：是否显示详细处理结果（一个数,默认值为0），=0不显示，=1显示，=2只显示最终结果（适合多类别数据分析）  
#### 输出参数  
`average`：平均值  
`error`：绝对误差  
#### 使用范例  
 1.直接在命令行中输入
`Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32]);`

 2.新建变量a，双击编辑变量，输入或复制数据，注意需为 1*n 维向量(即打横排列)。  
   `Isee(a);`  
   
 3.高级应用  
   `Isee([205.3,204.94,205.63,205.24,206.65,204.97,205.36,205.16,205.01,204.7,205.56,205.35,205.21,205.19,205.21,205.32],0,1);
   %修正值为0  ， 显示详细结果`
   
最终结果 ： 205.2 ± 0.1  
测量数据平均值为 205.21  ,  绝对误差为 0.148339 ， 相对误差为 0.0722863 %  
源数据共有16个，坏值共有1个，如下所示：  
bad =  
  206.6500  
  
 # txtsee函数详细介绍
\[ \] = txtsee( file )  
 对既定格式的txt文件进行处理，输出处理后的结果  
 
输入参数file：记事本的路径，如'data.txt'(默认目录为matlab的work路径)或'C:\Users\Administrator\Desktop\data.txt'  
输出结果：每项数据的平均值和绝对误差  

#### 使用范例
`txtsee(‘data.txt’) `

计算结果：  
北纬： 23.0435 ± 3e-06  
东经： 113.386 ± 4e-06  
温度： 16.01 ± 0.06  
高度： 78.2 ± 0.1  
气压： 102267 ± 1  
PM2.5： 103 ± 1  

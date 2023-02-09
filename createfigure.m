function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  x 数据的向量
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 11-Oct-2022 09:38:11 自动生成

% 创建 figure
figure('OuterPosition',[502.6 101 574.4 508.8]);

% 创建 axes
axes1 = axes;
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(X1,YMatrix1);
set(plot1(1),'DisplayName','I-MOMFEA');
set(plot1(2),'DisplayName','NSGA-III');
set(plot1(3),'DisplayName','KnEA');
set(plot1(4),'DisplayName','MOEAD');
set(plot1(5),'DisplayName','RVEA');

% 创建 ylabel
ylabel('延时');

% 创建 xlabel
xlabel('迭代次数');

grid(axes1,'on');
% 创建 legend
legend(axes1,'show');


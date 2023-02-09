function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  x ���ݵ�����
%  YMATRIX1:  y ���ݵľ���

%  �� MATLAB �� 11-Oct-2022 09:38:11 �Զ�����

% ���� figure
figure('OuterPosition',[502.6 101 574.4 508.8]);

% ���� axes
axes1 = axes;
hold(axes1,'on');

% ʹ�� plot �ľ������봴������
plot1 = plot(X1,YMatrix1);
set(plot1(1),'DisplayName','I-MOMFEA');
set(plot1(2),'DisplayName','NSGA-III');
set(plot1(3),'DisplayName','KnEA');
set(plot1(4),'DisplayName','MOEAD');
set(plot1(5),'DisplayName','RVEA');

% ���� ylabel
ylabel('��ʱ');

% ���� xlabel
xlabel('��������');

grid(axes1,'on');
% ���� legend
legend(axes1,'show');


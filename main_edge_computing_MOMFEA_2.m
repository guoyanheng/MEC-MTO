%%%%% This code is used for Edge Computing based on intelligent optimization algorithm %%%%%

clear all;
clc;

global Alg_set_EC EC_Deployment_para_setting EC_Offloading_para_setting;

%% load files path
addPath;

%% ����ģ�Ͳ���
EC_Deployment_para_setting = [];
EC_Deployment_para_setting = para_setting(EC_Deployment_para_setting);
% ��ȡ��������Χ��ά��
[lb1,ub1,dim1] = getPara_Model(EC_Deployment_para_setting);

EC_Offloading_para_setting = [];
EC_Offloading_para_setting = para_setting_1(EC_Offloading_para_setting);
% ��ȡ��������Χ��ά��
[lb2,ub2,dim2,EC_Offloading_para_setting] = getPara_Model_offloading(EC_Offloading_para_setting);

%% �㷨�Ż�����
 Alg_set_EC = {'I-MOMFEA','MOMFEA'};
%Alg_set_EC = {'I-MOMFEA'};
n_algs = length(Alg_set_EC);
runs =30;
Result_MEC = cell(runs,n_algs);
fid = fopen(['MEC_results.txt'],'w+');
for i = 1:length(Alg_set_EC)
    fprintf(fid,'%s�㷨���:  \n',Alg_set_EC{i});
    fprintf('%s�㷨���:  \n',Alg_set_EC{i});
    for j = 1:runs
        fprintf('run %s *****\n',num2str(j));
        switch Alg_set_EC{i}
            case 'I-MOMFEA'
                pop1 = 100;
                pop2 = 100;
                max_iter = 500;
                [edge_computing_sol,Index,time] = MOMFEA_edge_computing(pop1,lb1,ub1,dim1,pop2,lb2,ub2,dim2,max_iter,EC_Deployment_para_setting,EC_Offloading_para_setting);
            case 'MOMFEA'
                pop1 = 100;
                pop2 = 100;
                max_iter = 500;
                [edge_computing_sol,Index,time] = MOMFGWO_edge_computing(pop1,lb1,ub1,dim1,pop2,lb2,ub2,dim2,max_iter,EC_Deployment_para_setting,EC_Offloading_para_setting);
        end
%         fprintf(fid,'***%s�㷨���:  ��ʱΪ%s, Task1: SpacingΪ%s, Task2: SpacingΪ%s ****\n',Alg_set_EC{i},num2str(time),num2str(Index.Task1_index.Spacing),num2str(Index.Task2_index.Spacing));
        fprintf('***%s�㷨���:  ��ʱΪ%s, Task1: SpacingΪ%s, Task2: SpacingΪ%s ****\n',Alg_set_EC{i},num2str(time),num2str(Index.Task1_index.Spacing),num2str(Index.Task2_index.Spacing));
        fprintf('***%s�㷨���:  ��ʱΪ%s, Task1: SpanΪ%s, Task2: SpanΪ%s ****\n',Alg_set_EC{i},num2str(time),num2str(Index.Task1_index.Span),num2str(Index.Task2_index.Span));
        fprintf('***%s�㷨���:  ��ʱΪ%s, Task1: PDΪ%s, Task2: PDΪ%s ****\n',Alg_set_EC{i},num2str(time),num2str(Index.Task1_index.PD),num2str(Index.Task2_index.PD));
        results_temp = [];
        results_temp.sol = edge_computing_sol;
        results_temp.time = time;
        results_temp.Index = Index;
        Result_MEC{j,i} = results_temp;
        
        Index_Spacing1(j,i) = Index.Task1_index.Spacing;
        Index_Span1(j,i) = Index.Task1_index.Span;
        Index_PD1(j,i) = Index.Task1_index.PD;
        Index_Spacing2(j,i) = Index.Task2_index.Spacing;
        Index_Span2(j,i) = Index.Task2_index.Span;
        Index_PD2(j,i) = Index.Task2_index.PD;
        Index_time(j,i) = time;
    end
    average_time(1,i) = mean(Index_time(:,i));
    fprintf(fid,'***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_EC{i},num2str(average_time(1,i)));
    fprintf('***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_EC{i},num2str(average_time(1,i)));
    
    best_Spacing1(1,i) = min(Index_Spacing1(:,i));
    worst_Spacing1(1,i) = max(Index_Spacing1(:,i));
    average_Spacing1(1,i) = mean(Index_Spacing1(:,i));
    variance_Spacing1(1,i) = var(Index_Spacing1(:,i));
    fprintf(fid,'Task1***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC{i},num2str(best_Spacing1(1,i)),num2str(worst_Spacing1(1,i)),num2str(average_Spacing1(1,i)),num2str(variance_Spacing1(1,i)));
    fprintf('Task1***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC{i},num2str(best_Spacing1(1,i)),num2str(worst_Spacing1(1,i)),num2str(average_Spacing1(1,i)),num2str(variance_Spacing1(1,i)));
    best_Spacing2(1,i) = min(Index_Spacing2(:,i));
    worst_Spacing2(1,i) = max(Index_Spacing2(:,i));
    average_Spacing2(1,i) = mean(Index_Spacing2(:,i));
    variance_Spacing2(1,i) = var(Index_Spacing2(:,i));
    fprintf(fid,'Task2***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC{i},num2str(best_Spacing2(1,i)),num2str(worst_Spacing2(1,i)),num2str(average_Spacing2(1,i)),num2str(variance_Spacing2(1,i)));
    fprintf('Task2***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC{i},num2str(best_Spacing2(1,i)),num2str(worst_Spacing2(1,i)),num2str(average_Spacing2(1,i)),num2str(variance_Spacing2(1,i)));
    
    
    best_Span1(1,i) = max(Index_Span1(:,i));
    worst_Span1(1,i) = min(Index_Span1(:,i));
    average_Span1(1,i) = mean(Index_Span1(:,i));
    variance_Span1(1,i) = var(Index_Span1(:,i));
    fprintf(fid,'Task1***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC{i},num2str(best_Span1(1,i)),num2str(worst_Span1(1,i)),num2str(average_Span1(1,i)),num2str(variance_Span1(1,i)));
    fprintf('Task1***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC{i},num2str(best_Span1(1,i)),num2str(worst_Span1(1,i)),num2str(average_Span1(1,i)),num2str(variance_Span1(1,i)));
    best_Span2(1,i) = max(Index_Span2(:,i));
    worst_Span2(1,i) = min(Index_Span2(:,i));
    average_Span2(1,i) = mean(Index_Span2(:,i));
    variance_Span2(1,i) = var(Index_Span2(:,i));
    fprintf(fid,'Task2***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC{i},num2str(best_Span2(1,i)),num2str(worst_Span2(1,i)),num2str(average_Span2(1,i)),num2str(variance_Span2(1,i)));
    fprintf('Task2***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC{i},num2str(best_Span2(1,i)),num2str(worst_Span2(1,i)),num2str(average_Span2(1,i)),num2str(variance_Span2(1,i)));
    
    best_PD1(1,i) = max(Index_PD1(:,i));
    worst_PD1(1,i) = min(Index_PD1(:,i));
    average_PD1(1,i) = mean(Index_PD1(:,i));
    variance_PD1(1,i) = var(Index_PD1(:,i));
    fprintf(fid,'Task1***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC{i},num2str(best_PD1(1,i)),num2str(worst_PD1(1,i)),num2str(average_PD1(1,i)),num2str(variance_PD1(1,i)));
    fprintf('Task1***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC{i},num2str(best_PD1(1,i)),num2str(worst_PD1(1,i)),num2str(average_PD1(1,i)),num2str(variance_PD1(1,i)));
    best_PD2(1,i) = max(Index_PD2(:,i));
    worst_PD2(1,i) = min(Index_PD2(:,i));
    average_PD2(1,i) = mean(Index_PD2(:,i));
    variance_PD2(1,i) = var(Index_PD2(:,i));
    fprintf(fid,'Task2***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC{i},num2str(best_PD2(1,i)),num2str(worst_PD2(1,i)),num2str(average_PD2(1,i)),num2str(variance_PD2(1,i)));
    fprintf('Task2***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC{i},num2str(best_PD2(1,i)),num2str(worst_PD2(1,i)),num2str(average_PD2(1,i)),num2str(variance_PD2(1,i)));
end

%% �洢���
filename = ['Result_MOMFEA'];
save(filename,'Result_MEC','Alg_set_EC','Index_Spacing1','Index_Span1','Index_PD1','Index_Spacing2','Index_Span2','Index_PD2','Index_time');

%% �����ʾ����
figure;
hold on;
grid on;
for i = 1:length(Alg_set_EC)
    T1 = extract_fit(Result_MEC{1,i},1);
    if size(T1,2) == 2
        Front_fig(i) = plot(T1(:,1),T1(:,2),'o');
    elseif size(T1,2) == 3
        Front_fig(i) = plot3(T1(:,1),T1(:,2),T1(:,3),'o');
    end
end
title(['���ڸ��㷨��Pareto Front']);
xlabel('��ʱ');
ylabel('����');
if size(T1,2) == 3
    zlabel('���ؾ���');
end
legend([Front_fig(1:length(Alg_set_EC))],Alg_set_EC);

figure;
hold on;
grid on;
for i = 1:length(Alg_set_EC)
    T2 = extract_fit(Result_MEC{1,i},2);
    if size(T2,2) == 2
        Front_fig(i) = plot(T2(:,1),T2(:,2),'o');
    elseif size(T2,2) == 3
        Front_fig(i) = plot3(T2(:,1),T2(:,2),T2(:,3),'o');
    end
end
title(['���ڸ��㷨��Pareto Front']);
xlabel('��ʱ');
ylabel('����');
if size(T2,2) == 3
    zlabel('���ؾ���');
end
legend([Front_fig(1:length(Alg_set_EC))],Alg_set_EC);
%%%%% This code is used for Edge Computing Service Deployment based on intelligent optimization algorithm %%%%%

close all;
clear all;
clc;

global Alg_set_MEC_offloading EC_Offloading_para_setting;

%% load files path
addPath;

%% ����ģ�Ͳ���
EC_Offloading_para_setting = [];
EC_Offloading_para_setting = para_setting_1(EC_Offloading_para_setting); 
% ��ȡ��������Χ��ά��
[lb,ub,dim,EC_Offloading_para_setting] = getPara_Model_offloading(EC_Offloading_para_setting);

%% �㷨�Ż�����
% Alg_set_MEC_offloading = {'MOPSO','NSGA-2','NSGA-3','MOGWO','MOEAD','RVEA'};
% Alg_set_MEC_offloading = {'RVEA'};
Alg_set_MEC_offloading = {'NSGA-III','KnEA','MOEAD','RVEA'};   % 'NSGA-III','KnEA','MOEAD','RVEA'
runs = 30;
n_algs = length(Alg_set_MEC_offloading);
Result_MEC_Offloading = cell(runs,n_algs);
fid = fopen(['MEC_Offloading_results.txt'],'w+');
for i = 1:length(Alg_set_MEC_offloading)
    fprintf(fid,'%s�㷨���:  \n',Alg_set_MEC_offloading{i});
    fprintf('%s�㷨���:  \n',Alg_set_MEC_offloading{i});
    for j = 1:runs
        fprintf('run %s *****\n',num2str(j));
        switch Alg_set_MEC_offloading{i}
            case 'MOPSO'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = MOPSO_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
            case 'NSGA-III'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = NSGA2_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
            case 'RVEA'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = NSGA3_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
            case 'KnEA'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = MOGWO_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
            case 'MOEAD'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = MOEAD_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
            case 'RVEA'
                SearchAgents_no = 100;
                max_iter = 500;
                [Offloading_sol,Index,time] = RVEA_Offloading(SearchAgents_no,max_iter,lb,ub,dim,EC_Offloading_para_setting);
        end
%         fprintf(fid,'***%s�㷨���:  ��ʱΪ%s, SpacingΪ%s, SpanΪ%s, PDΪ%s ****\n',Alg_set_MEC_offloading{i},num2str(time),num2str(Index.Spacing),num2str(Index.Span),num2str(Index.PD));
        fprintf('***%s�㷨���:  ��ʱΪ%s, SpacingΪ%s, SpanΪ%s, PDΪ%s ****\n',Alg_set_MEC_offloading{i},num2str(time),num2str(Index.Spacing),num2str(Index.Span),num2str(Index.PD));
        results_temp = [];
        results_temp.Offloading_sol = Offloading_sol;
        results_temp.Index = Index;
        results_temp.time = time;
        Result_MEC_Offloading{j,i} = results_temp;
        
        Index_Spacing(j,i) = Index.Spacing;
        Index_Span(j,i) = Index.Span;
        Index_PD(j,i) = Index.PD;
        Index_time(j,i) = time;
    end
    average_time(1,i) = mean(Index_time(:,i));
    fprintf(fid,'***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_MEC_offloading{i},num2str(average_time(1,i)));
    fprintf('***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_MEC_offloading{i},num2str(average_time(1,i)));
    
    best_Spacing(1,i) = min(Index_Spacing(:,i));
    worst_Spacing(1,i) = max(Index_Spacing(:,i));
    average_Spacing(1,i) = mean(Index_Spacing(:,i));
    variance_Spacing(1,i) = var(Index_Spacing(:,i));
    fprintf(fid,'***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_Spacing(1,i)),num2str(worst_Spacing(1,i)),num2str(average_Spacing(1,i)),num2str(variance_Spacing(1,i)));
    fprintf('***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_Spacing(1,i)),num2str(worst_Spacing(1,i)),num2str(average_Spacing(1,i)),num2str(variance_Spacing(1,i)));
    
    best_Span(1,i) = max(Index_Span(:,i));
    worst_Span(1,i) = min(Index_Span(:,i));
    average_Span(1,i) = mean(Index_Span(:,i));
    variance_Span(1,i) = var(Index_Span(:,i));
    fprintf(fid,'***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_Span(1,i)),num2str(worst_Span(1,i)),num2str(average_Span(1,i)),num2str(variance_Span(1,i)));
    fprintf('***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_Span(1,i)),num2str(worst_Span(1,i)),num2str(average_Span(1,i)),num2str(variance_Span(1,i)));
    
    best_PD(1,i) = max(Index_PD(:,i));
    worst_PD(1,i) = min(Index_PD(:,i));
    average_PD(1,i) = mean(Index_PD(:,i));
    variance_PD(1,i) = var(Index_PD(:,i));
    fprintf(fid,'***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_PD(1,i)),num2str(worst_PD(1,i)),num2str(average_PD(1,i)),num2str(variance_PD(1,i)));
    fprintf('***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_MEC_offloading{i},num2str(best_PD(1,i)),num2str(worst_PD(1,i)),num2str(average_PD(1,i)),num2str(variance_PD(1,i)));
end

%% �洢���
filename = ['Result_Task_Offloading_all'];
save(filename,'Result_MEC_Offloading','Alg_set_MEC_offloading','Index_Spacing','Index_Span','Index_PD','Index_time');

%% �����ʾ����
figure;
hold on;
grid on;
for i = 1:length(Alg_set_MEC_offloading)
    if size(Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit,2) == 2
        Front_fig(i) = plot(Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit(:,1),Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit(:,2),'o');
    elseif size(Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit,2) == 3
        Front_fig(i) = plot3(Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit(:,1),Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit(:,2),Result_MEC_Offloading{1,i}.Offloading_sol.pos_fit(:,3),'o');
    end
end
title(['���ڸ��㷨��Pareto Front']);
xlabel('��ʱ');
ylabel('����');
if size(Result_MEC_Offloading{1,1}.Offloading_sol.pos_fit,2) == 3
    zlabel('���ؾ���');
end
legend([Front_fig(1:length(Alg_set_MEC_offloading))],Alg_set_MEC_offloading);

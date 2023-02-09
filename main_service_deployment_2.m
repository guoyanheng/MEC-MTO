%%%%% This code is used for Edge Computing Service Deployment based on intelligent optimization algorithm %%%%%

close all;
clear all;
clc;

global Alg_set_EC_Deployment EC_Deployment_para_setting;

%% load files path
addPath;

%% ����ģ�Ͳ���
EC_Deployment_para_setting = [];
EC_Deployment_para_setting = para_setting(EC_Deployment_para_setting);
% ��ȡ��������Χ��ά��
[lb,ub,dim] = getPara_Model(EC_Deployment_para_setting);

%% �㷨�Ż�����
% Alg_set_EC_Deployment = {'MOPSO','NSGA-2','NSGA-3','MOGWO','MOEAD','RVEA'};
% Alg_set_EC_Deployment = {'MOPSO','NSGA-2''MOEAD','RVEA'};
% Alg_set_EC_Deployment = {'MOGWO'};
Alg_set_EC_Deployment = {'NSGA-III','KnEA','MOEAD','RVEA'};   % 'NSGA-III','KnEA','MOEAD','RVEA'
runs = 30;
n_algs = length(Alg_set_EC_Deployment);
Result_MEC_Deployment = cell(runs,n_algs);
fid = fopen(['MEC_Deployment_results.txt'],'w+');

for i = 1:length(Alg_set_EC_Deployment)
    fprintf(fid,'%s�㷨���:  \n',Alg_set_EC_Deployment{i});
    fprintf('%s�㷨���:  \n',Alg_set_EC_Deployment{i});
    for j = 1:runs
        fprintf('run %s *****\n',num2str(j));
        switch Alg_set_EC_Deployment{i}
            case 'MOPSO'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = MOPSO_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
            case 'NSGA-III'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = NSGA2_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
        %             [Deployment_sol,Index,time] = NSGA2_Deployment_1(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
            case 'NSGA-3'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = NSGA3_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
            case 'KnEA'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = MOGWO_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
            case 'MOEAD'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = MOEAD_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
            case 'RVEA'
                SearchAgents_no = 100;
                max_iter = 500;
                [Deployment_sol,Index,time] = RVEA_Deployment(SearchAgents_no,max_iter,lb,ub,dim,EC_Deployment_para_setting);
        end
        %         fprintf(fid,'***%s�㷨���:  ��ʱΪ%s, SpacingΪ%s, SpanΪ%s, PDΪ%s ****\n',Alg_set_EC_Deployment{i},num2str(time),num2str(Index.Spacing),num2str(Index.Span),num2str(Index.PD));
        fprintf('***%s�㷨���:  ��ʱΪ%s, SpacingΪ%s, SpanΪ%s, PDΪ%s ****\n',Alg_set_EC_Deployment{i},num2str(time),num2str(Index.Spacing),num2str(Index.Span),num2str(Index.PD));
        results_temp = [];
        results_temp.Deployment_sol = Deployment_sol;
        results_temp.Index = Index;
        results_temp.time = time;
        Result_MEC_Deployment{j,i} = results_temp;
        
        Index_Spacing(j,i) = Index.Spacing;
        Index_Span(j,i) = Index.Span;
        Index_PD(j,i) = Index.PD;
        Index_time(j,i) = time;
    end
    average_time(1,i) = mean(Index_time(:,i));
    fprintf(fid,'***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_EC_Deployment{i},num2str(average_time(1,i)));
    fprintf('***%s�㷨���:  ƽ����ʱΪ%s ****\n',Alg_set_EC_Deployment{i},num2str(average_time(1,i)));
    
    best_Spacing(1,i) = min(Index_Spacing(:,i));
    worst_Spacing(1,i) = max(Index_Spacing(:,i));
    average_Spacing(1,i) = mean(Index_Spacing(:,i));
    variance_Spacing(1,i) = var(Index_Spacing(:,i));
    fprintf(fid,'***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_Spacing(1,i)),num2str(worst_Spacing(1,i)),num2str(average_Spacing(1,i)),num2str(variance_Spacing(1,i)));
    fprintf('***%s�㷨���:  best SpacingΪ%s, worst SpacingΪ%s, average SpacingΪ%s, variance SpacingΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_Spacing(1,i)),num2str(worst_Spacing(1,i)),num2str(average_Spacing(1,i)),num2str(variance_Spacing(1,i)));
    
    best_Span(1,i) = max(Index_Span(:,i));
    worst_Span(1,i) = min(Index_Span(:,i));
    average_Span(1,i) = mean(Index_Span(:,i));
    variance_Span(1,i) = var(Index_Span(:,i));
    fprintf(fid,'***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_Span(1,i)),num2str(worst_Span(1,i)),num2str(average_Span(1,i)),num2str(variance_Span(1,i)));
    fprintf('***%s�㷨���:  best SpanΪ%s, worst SpanΪ%s, average SpanΪ%s, variance SpanΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_Span(1,i)),num2str(worst_Span(1,i)),num2str(average_Span(1,i)),num2str(variance_Span(1,i)));
    
    best_PD(1,i) = max(Index_PD(:,i));
    worst_PD(1,i) = min(Index_PD(:,i));
    average_PD(1,i) = mean(Index_PD(:,i));
    variance_PD(1,i) = var(Index_PD(:,i));
    fprintf(fid,'***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_PD(1,i)),num2str(worst_PD(1,i)),num2str(average_PD(1,i)),num2str(variance_PD(1,i)));
    fprintf('***%s�㷨���:  best PDΪ%s, worst PDΪ%s, average PDΪ%s, variance PDΪ%s; ****\n',Alg_set_EC_Deployment{i},num2str(best_PD(1,i)),num2str(worst_PD(1,i)),num2str(average_PD(1,i)),num2str(variance_PD(1,i)));
end

%% �洢���
filename = ['Result_Service_Deployment_all'];
save(filename,'Result_MEC_Deployment','Alg_set_EC_Deployment','Index_Spacing','Index_Span','Index_PD','Index_time');

%% �����ʾ����
figure;
hold on;
grid on;
for i = 1:length(Alg_set_EC_Deployment)
    Front_fig(i) = plot(Result_MEC_Deployment{1,i}.Deployment_sol.pos_fit(:,1),Result_MEC_Deployment{1,i}.Deployment_sol.pos_fit(:,2),'o');
end
title(['���ڸ��㷨��Pareto Front']);
xlabel('����');
ylabel('������ʱ');
legend([Front_fig(1:length(Alg_set_EC_Deployment))],Alg_set_EC_Deployment);
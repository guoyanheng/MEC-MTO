clc;
clear;
close all;

addPath;

Para_Setting = [];
Para_Setting.edge_nodes = 1;   
Para_Setting.usr_nodes = 10;   
Para_Setting.case_flag = 2;
if Para_Setting.case_flag == 1
    Para_Setting.task_nodes = Para_Setting.usr_nodes;

    Para_Setting.B_min = 7e6; % b
    Para_Setting.B_max = 40e6; % b
    Para_Setting.B_value = rand(1,Para_Setting.task_nodes).*(Para_Setting.B_max-Para_Setting.B_min)+Para_Setting.B_min;

    Para_Setting.f_min = 800; % cycle/b
    Para_Setting.f_max = 1200; % cycle/b
    Para_Setting.f_i = rand(1,Para_Setting.task_nodes).*(Para_Setting.f_max-Para_Setting.f_min)+Para_Setting.f_min;

    Para_Setting.f_local_min = 1e9;   % Hz
    Para_Setting.f_local_max = 3e9;   % Hz
    Para_Setting.f_local = rand(1,Para_Setting.task_nodes).*(Para_Setting.f_local_max-Para_Setting.f_local_min)+Para_Setting.f_local_min;

    Para_Setting.f_edge_min = 4e9;  % Hz
    Para_Setting.f_edge_max = 8e9;  % Hz
    Para_Setting.f_edge = rand(1,Para_Setting.edge_nodes).*(Para_Setting.f_edge_max-Para_Setting.f_edge_min)+Para_Setting.f_edge_min;

    Para_Setting.W = 5e6; % Hz

    Para_Setting.P_min = 50e-3; % W
    Para_Setting.P_max = 150e-3; % W
    Para_Setting.P_power = rand(1,Para_Setting.task_nodes).*(Para_Setting.P_max-Para_Setting.P_min)+Para_Setting.P_min;

    Para_Setting.P_local_cal_min = 100e-3; % W
    Para_Setting.P_local_cal_max = 300e-3; % W
    Para_Setting.P_local_cal_power = rand(1,Para_Setting.task_nodes).*(Para_Setting.P_local_cal_max-Para_Setting.P_local_cal_min)+Para_Setting.P_local_cal_min;

    Para_Setting.P_edge_cal_min = 10e-3; % W
    Para_Setting.P_edge_cal_max = 70e-3; % W
    Para_Setting.P_edge_cal_power = rand(1,Para_Setting.edge_nodes).*(Para_Setting.P_edge_cal_max-Para_Setting.P_edge_cal_min)+Para_Setting.P_edge_cal_min;

    % 移动终端传输速率
    Para_Setting.nd_coord = rand(Para_Setting.edge_nodes,2)*100;  %初始化节点的位置
    link_threshold = 50;
    link_pair = [];
    Para_Setting.network_topology = [];
    Para_Setting.Distance = [];
    Para_Setting.W_N_0 = 1e-9;
    Para_Setting.yeta = 1e-4;
    Para_Setting.rho = 2;
    for i = 1:Para_Setting.edge_nodes
        for j = 1:Para_Setting.edge_nodes
            Para_Setting.Distance(i,j) = norm(Para_Setting.nd_coord(i,:)-Para_Setting.nd_coord(j,:));
            if Para_Setting.Distance(i,j) <=  link_threshold
                Para_Setting.network_topology(i,j) = 1;
                link_pair = [link_pair; [Para_Setting.nd_coord(i,:) Para_Setting.nd_coord(j,:)]];
            else
                Para_Setting.network_topology(i,j) = 0;
            end
            if Para_Setting.Distance(i,j) == 0
                Para_Setting.H(i,j) = 0;
            else
                Para_Setting.H(i,j) = Para_Setting.rho.*Para_Setting.Distance(i,j).^(-Para_Setting.yeta);
            end
        end
    end
    figure;
    hold on;
    for i = 1:size(link_pair,1)
        edge_link(i) = plot(link_pair(i,[1 3]),link_pair(i,[2 4]),'b-');
    end
    for i = 1:Para_Setting.edge_nodes
        edge(i) = plot(Para_Setting.nd_coord(i,1),Para_Setting.nd_coord(i,2),'Marker','^','Color','r','MarkerSize',5,'MarkerFaceColor','r');
    end

    Para_Setting.u_loc = rand(Para_Setting.usr_nodes,2)*100;  %初始化用户的位置
    for i = 1:Para_Setting.usr_nodes
        for j = 1:Para_Setting.edge_nodes
            Para_Setting.D_user_edge(i,j) = norm(Para_Setting.u_loc(i,:)-Para_Setting.nd_coord(j,:));
            if Para_Setting.D_user_edge(i,j) <= 1
                Para_Setting.H_user_edge(i,j) = 0;
                print('重新初始化');
            else
                Para_Setting.H_user_edge(i,j) = Para_Setting.rho.*Para_Setting.D_user_edge(i,j).^(-Para_Setting.yeta);
            end
            Para_Setting.r_i(i,j) = Para_Setting.W*log2(1+(Para_Setting.P_power(1,i)*(Para_Setting.H_user_edge(i,j))/Para_Setting.W_N_0));
        end
    end
    for i = 1:Para_Setting.usr_nodes
        usr(i) = plot(Para_Setting.u_loc(i,1),Para_Setting.u_loc(i,2),'Marker','o','Color','m','MarkerSize',5,'MarkerFaceColor','m');
    end

    Para_Setting.access_flag = 1; % 如果移动设备接入点为最近边缘节点，则access_flag = 1；如果移动设备可以任意直接接入所有点，则access_flag = 0
    if Para_Setting.access_flag == 1
        link_usr_edge = [];
        link_usr_AP_flag = [];
        for i = 1:Para_Setting.usr_nodes
            [~,access_point] = min(Para_Setting.D_user_edge(i,:));
            link_usr_edge = [link_usr_edge; [Para_Setting.u_loc(i,:) Para_Setting.nd_coord(access_point(1),:)]];
            link_usr_AP_flag = [link_usr_AP_flag; access_point(1)];
        end
        Para_Setting.link_usr_AP_flag = link_usr_AP_flag;
        for i = 1:size(link_usr_edge,1)
            edge_usr_link(i) = plot(link_usr_edge(i,[1 3]),link_usr_edge(i,[2 4]),'c--');
        end
        legend([edge(1),usr(1),edge_link(1),edge_usr_link(1)],'边缘节点','用户','边缘节点之间的连接','边缘节点与用户之间的连接');
    else
        legend([edge(1),usr(1),edge_link(1)],'边缘节点','用户','边缘节点之间的连接');
    end

    Para_Setting.shortest_path = [];
    for i = 1:Para_Setting.edge_nodes
        for j = 1:Para_Setting.edge_nodes
            if Para_Setting.network_topology(i,j) == 1
                D_edge(i,j) = norm(Para_Setting.nd_coord(i,:)-Para_Setting.nd_coord(j,:));
            else 
                if norm(Para_Setting.nd_coord(i,:)-Para_Setting.nd_coord(j,:)) == 0
                    D_edge(i,j) = 0;
                else
                    D_edge(i,j) = inf;
                end
            end
        end
    end
    for i = 1:Para_Setting.edge_nodes
        for j = 1:Para_Setting.edge_nodes
            [dist,path,Distance] = dijkstra_self(D_edge,i,j);
            Para_Setting.shortest_path_dist(i,j) = dist;
            path_index = print_path(path,i,j);
            Para_Setting.shortest_path_index{i,j} = path_index;
        end
    end
elseif Para_Setting.case_flag == 2
 
    Para_Setting.capacitym1 = 0.2*10^6; 
    Para_Setting.capacitym2 = 1*10^6;
    for i=1:Para_Setting.usr_nodes
        Para_Setting.capacitym(i) = Para_Setting.capacitym1 + (Para_Setting.capacitym2 - Para_Setting.capacitym1)*rand; 
    end
    
    
    Para_Setting.Pcomp1 = 100*10^(-3);
    Para_Setting.Pcomp2 = 300*10^(-3);
    for i=1:Para_Setting.usr_nodes
        Para_Setting.Pcomp(i) = Para_Setting.Pcomp1 + rand*(Para_Setting.Pcomp2-Para_Setting.Pcomp1);
    end
    
   
    
   
    Para_Setting.Psend1 = 50*10^(-3);
    Para_Setting.Psend2 = 150*10^(-3);
    for i=1:Para_Setting.usr_nodes
        Para_Setting.Psend(i) = Para_Setting.Psend1 + rand*(Para_Setting.Psend2-Para_Setting.Psend1);
    end
    
    %移动终端网络接口空闲状态下的功率初始化
    Para_Setting.Pinet1 = 8*10^(-3);
    Para_Setting.Pinet2 = 15*10^(-3);
    for i=1:Para_Setting.usr_nodes
        Para_Setting.Pinet(i) = Para_Setting.Pinet1 + rand*(Para_Setting.Pinet2-Para_Setting.Pinet1);
    end
    
    
    Para_Setting.d1 = 10; 
    Para_Setting.d2 = 200; 
    for i=1:Para_Setting.usr_nodes
        Para_Setting.dis(i) = Para_Setting.d1 + (Para_Setting.d2-Para_Setting.d1)*rand; 
    end
    
    Para_Setting.delta = 10^(-13);
    Para_Setting.B = 5*10^6;
    Para_Setting.yeta = 10^(-4);
    Para_Setting.rho = 2;
    for i=1:Para_Setting.usr_nodes
        Para_Setting.ri(i) = Para_Setting.B*log2(1+(Para_Setting.Psend(i)*(Para_Setting.rho*Para_Setting.dis(i)^(-Para_Setting.yeta)))/Para_Setting.delta);
    end
    

    Para_Setting.nu = 3; 
    Para_Setting.nl = 3; 
    for i=1:Para_Setting.usr_nodes
        Para_Setting.components(i) = Para_Setting.nl + round((Para_Setting.nu-Para_Setting.nl)*rand); 
    end
    
    Para_Setting.Tdelayij = [];
    Para_Setting.t1 = 0.01; 
    Para_Setting.t2 = 0.2;  
    for i=1:Para_Setting.usr_nodes
        for j=1:Para_Setting.components(i)
            Para_Setting.Tdelayij = [Para_Setting.Tdelayij,Para_Setting.t1 + (Para_Setting.t2-Para_Setting.t1)*rand];
        end
    end
    
    
    
  
    Para_Setting.capacityv1 = 5*10^6;
    Para_Setting.capacityv2 = 6*10^6;
    for i=1:Para_Setting.edge_nodes
        Para_Setting.capacityv(i) = Para_Setting.capacityv1 + (Para_Setting.capacityv2 - Para_Setting.capacityv1)*rand;
    end
    
    Para_Setting = data_model(Para_Setting);
end
    
save('Para_Setting_Task_Offloading.mat','Para_Setting');
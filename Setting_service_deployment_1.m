clc;
clear;
close all;

addPath;

Para_Setting = [];

Para_Setting.edge_nodes = 20;   
Para_Setting.edge_comp = (rand(Para_Setting.edge_nodes,1)*8+20)*1e9 ;  
Para_Setting.P_edge_comp = rand(Para_Setting.edge_nodes,1)*0.8 + 0.8;   
Para_Setting.AP_res = 2.5*1e9 ;  
Para_Setting.nd_coord = rand(Para_Setting.edge_nodes,2)*3;  
link_threshold = 1.5;
link_pair = [];
for i = 1:Para_Setting.edge_nodes
    for j = 1:Para_Setting.edge_nodes
        if norm(Para_Setting.nd_coord(i,:)-Para_Setting.nd_coord(j,:)) <=  link_threshold
            network_topology(i,j) = 1;
            link_pair = [link_pair; [Para_Setting.nd_coord(i,:) Para_Setting.nd_coord(j,:)]];
        else
            network_topology(i,j) = 0;
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

Para_Setting.usr_nodes = 50; 
Para_Setting.task_AP = rand(1, Para_Setting.usr_nodes)*18;     
Para_Setting.task_edge = rand(1, Para_Setting.usr_nodes)*15;  
Para_Setting.task_cycle = rand(1, Para_Setting.usr_nodes)*500+500;    
Para_Setting.tran_speed_D2A = (rand(Para_Setting.usr_nodes,1)*40+140)*1e3;  
Para_Setting.tran_speed_A2A = (rand(Para_Setting.edge_nodes,1)*40+140)*1e3;  
Para_Setting.range = 1.2 ;  %用户和接入节点之间的距离限制,大于这个1.2就不考虑接入
Para_Setting.u_loc = rand(Para_Setting.usr_nodes,2)*3;  %初始化用户的位置
for i = 1:Para_Setting.usr_nodes
    usr(i) = plot(Para_Setting.u_loc(i,1),Para_Setting.u_loc(i,2),'Marker','o','Color','m','MarkerSize',5,'MarkerFaceColor','m');
end

Para_Setting.D = sqrt((repmat(Para_Setting.nd_coord(:,1),1,Para_Setting.usr_nodes) - repmat(Para_Setting.u_loc(:,1),1,Para_Setting.edge_nodes)').^2 ...
    +(repmat(Para_Setting.nd_coord(:,2),1,Para_Setting.usr_nodes) - repmat(Para_Setting.u_loc(:,2),1,Para_Setting.edge_nodes)').^2 ) ;  %计算用户节点和边缘服务器节点之间的距离
link_usr_edge = [];
link_usr_AP_flag = [];
for i = 1:Para_Setting.usr_nodes
    [~,access_point] = min(Para_Setting.D(:,i));
    link_usr_edge = [link_usr_edge; [Para_Setting.u_loc(i,:) Para_Setting.nd_coord(access_point,:)]];
    link_usr_AP_flag = [link_usr_AP_flag; access_point];
end
Para_Setting.link_usr_AP_flag = link_usr_AP_flag;
for i = 1:size(link_usr_edge,1)
    edge_usr_link(i) = plot(link_usr_edge(i,[1 3]),link_usr_edge(i,[2 4]),'c--');
end
legend([edge(1),usr(1),edge_link(1),edge_usr_link(1)],'边缘节点','用户','边缘节点之间的连接','边缘节点与用户之间的连接');

Para_Setting.shortest_path = [];
for i = 1:Para_Setting.edge_nodes
    for j = 1:Para_Setting.edge_nodes
        if network_topology(i,j) == 1
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
        Para_Setting.shortest_path(i,j) = dist;
    end
end

save('Para_Setting_Service_Deployment.mat','Para_Setting');



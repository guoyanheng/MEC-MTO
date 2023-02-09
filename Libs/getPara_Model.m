function [lb,ub,dim] = getPara_Model(EC_Deployment_para_setting)
% getPara_Model函数功能主要用来获取搜索粒子的搜索范围

dim = EC_Deployment_para_setting.usr_nodes;
lb = repmat(1,1,dim);
ub = repmat(EC_Deployment_para_setting.edge_nodes,1,dim);

end
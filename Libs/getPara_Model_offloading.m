function [lb,ub,dim,EC_Offloading_para_setting] = getPara_Model_offloading(EC_Offloading_para_setting)
% getPara_Model函数功能主要用来获取搜索粒子的搜索范围

if EC_Offloading_para_setting.case_flag == 1
    EC_Offloading_para_setting.rate_offloading_flag = 0;
    if EC_Offloading_para_setting.rate_offloading_flag == 0
        dim = EC_Offloading_para_setting.usr_nodes;
        lb = repmat(0,1,dim);
        ub = repmat(EC_Offloading_para_setting.edge_nodes,1,dim); 
    else
        dim = EC_Offloading_para_setting.usr_nodes*2;
        lb = [repmat(0,1,EC_Offloading_para_setting.usr_nodes) repmat(0,1,EC_Offloading_para_setting.usr_nodes)];
        ub = [repmat(EC_Offloading_para_setting.edge_nodes,1,EC_Offloading_para_setting.usr_nodes) repmat(1,1,EC_Offloading_para_setting.usr_nodes)]; 
    end
elseif EC_Offloading_para_setting.case_flag == 2
    uesrN = EC_Offloading_para_setting.usr_nodes;% 用户个数
    nlist= EC_Offloading_para_setting.components; % 用户任务个数
    WNumber = sum(nlist);
    EC_Offloading_para_setting.WNumber = WNumber;
    dim = 3*WNumber;
    ch3_ub = [];
    for i = 1:uesrN
        ch3_ub = [ch3_ub repmat(nlist(i),1,nlist(i))];
    end
    lb = [repmat(0,1,WNumber) repmat(1,1,WNumber) repmat(1,1,WNumber)];
    ub = [repmat(1,1,WNumber) repmat(WNumber,1,WNumber) ch3_ub]; % 比例层 服务器加工顺序层 本地各用户加工顺序层 
    
    EC_Offloading_para_setting.obj_n = 3;
end
EC_Offloading_para_setting.lb = lb;
EC_Offloading_para_setting.ub = ub;
EC_Offloading_para_setting.dim = dim;

end
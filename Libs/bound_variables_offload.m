function Position = bound_variables_offload(Position,EC_Offloading_para_setting)
%%%% bound_variables_offload函数主要是用来处理越界问题

if EC_Offloading_para_setting.case_flag == 1
    if EC_Offloading_para_setting.rate_offloading_flag == 1
        Position = min(max(Position,EC_Offloading_para_setting.lb),EC_Offloading_para_setting.ub);
        Position(1,1:EC_Offloading_para_setting.usr_nodes) = round(Position(1,1:EC_Offloading_para_setting.usr_nodes));
        local_n_index = find(Position(1,1:EC_Offloading_para_setting.usr_nodes)==0);
        if ~isempty(local_n_index)
            Position(1,local_n_index+EC_Offloading_para_setting.usr_nodes) = 1;
        end

        edge_n_index = find(Position(1,1:EC_Offloading_para_setting.usr_nodes)>=1);
        if ~isempty(edge_n_index)
            zeros_rate_edge_n_index = find(Position(1,EC_Offloading_para_setting.usr_nodes+edge_n_index)==0);
            while ~isempty(zeros_rate_edge_n_index)
                Position(1,EC_Offloading_para_setting.usr_nodes+edge_n_index(zeros_rate_edge_n_index)) = EC_Offloading_para_setting.lb(1,EC_Offloading_para_setting.usr_nodes+edge_n_index(zeros_rate_edge_n_index))+...
                    rand(1,length(zeros_rate_edge_n_index)).*(EC_Offloading_para_setting.ub(1,EC_Offloading_para_setting.usr_nodes+edge_n_index(zeros_rate_edge_n_index))...
                    -EC_Offloading_para_setting.lb(1,EC_Offloading_para_setting.usr_nodes+edge_n_index(zeros_rate_edge_n_index)));
                zeros_rate_edge_n_index = find(Position(1,EC_Offloading_para_setting.usr_nodes+edge_n_index)==0);
            end
        end
    else
        Position = min(max(Position,EC_Offloading_para_setting.lb),EC_Offloading_para_setting.ub);
        Position(1,1:EC_Offloading_para_setting.usr_nodes) = round(Position(1,1:EC_Offloading_para_setting.usr_nodes));
    end
elseif EC_Offloading_para_setting.case_flag == 2
    Position = min(max(Position,EC_Offloading_para_setting.lb),EC_Offloading_para_setting.ub);    
end

end
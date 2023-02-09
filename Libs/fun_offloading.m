function Cost = fun_offloading(Position,EC_Offloading_para_setting)
%%%% 计算目标值，其中obj_time、obj_energy和obj_num分别为要优化的三个目标
if EC_Offloading_para_setting.case_flag == 1
    [obj_time,obj_energy] = obj_time_energy_fun(Position,EC_Offloading_para_setting);
    obj_num = obj_num_fun(Position,EC_Offloading_para_setting);
    Cost = [];
    Cost = [obj_time; obj_energy; obj_num];
    % Cost = [obj_time; obj_energy];
elseif EC_Offloading_para_setting.case_flag == 2
    if EC_Offloading_para_setting.obj_n == 2
        [obj_time,obj_energy] = obj_time_energy_fun_new(Position,EC_Offloading_para_setting);
        Cost = [];
        Cost = [obj_time; obj_energy];
    elseif EC_Offloading_para_setting.obj_n == 3
        [obj_time,obj_energy,obj_load] = obj_time_energy_fun_new3(Position,EC_Offloading_para_setting);
        Cost = [];
        Cost = [obj_time; obj_energy; obj_load];
    end
end

end
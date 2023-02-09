function Cost=fun(Position,EC_Deployment_para_setting)
%%%% 计算目标值，其中obj_energy_n和obj_delay_n分别为要优化的两个目标
obj_energy = obj_ene(Position,EC_Deployment_para_setting);
obj_delay = obj_del(Position,EC_Deployment_para_setting);
Cost = [];
Cost = [obj_energy; obj_delay];

end

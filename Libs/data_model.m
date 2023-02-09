function Paras = data_model(Paras)

% dataij %% 各组件的数据量
% capacityv 服务器的计算能力
% capacitym 本地的计算能力

% 边缘服务器
numberserver = 1;

% 组件计算时间
JmNumber = numberserver + Paras.usr_nodes;
localIndex = numberserver+ 1: 1 : numberserver + Paras.usr_nodes; % 本地处理器的索引
arrayT = zeros(size(Paras.dataij,2),numberserver + Paras.usr_nodes);
components2 = cumsum(Paras.components);
u = 1;
i = 1;
dataNumcell = cell(1,Paras.usr_nodes);
while u <= Paras.usr_nodes
    Da = [];
    while i<= components2(u)
        % 进入到用户中的组件
        arrayT(i,numberserver) = Paras.dataij(i)./Paras.capacityv(numberserver);
        arrayT(i,numberserver + u) = Paras.dataij(i)./Paras.capacitym(u);
        Da =[Da,Paras.dataij(i)];
        i = i + 1;
    end
    dataNumcell(u) = {Da};
    u = u +1;
end

Paras.dataNumcell = dataNumcell;
Paras.arrayT=arrayT;
Paras.JmNumber=JmNumber;
Paras.localIndex=localIndex;
Paras.numberserver=numberserver;
c = 1;
for i = 1:length(Paras.components)
    for j = 1: Paras.components(i)
        user_compon_V(c) = Paras.ri(i);
        c = c + 1;
    end
end
Paras.user_compon_V = user_compon_V;

end
function path_index = print_path(path,start,dest)
% 输出结果
fprintf('找到的最短路径为：');
path_index = [];
path_index = [path_index start];
while start ~= dest    %到达终点时结束
    fprintf('%d-->',start);  %打印当前点编号
    next = path(2,start);    %与当前点相连的下一顶点
    start = next;            %更新当前点
    path_index = [path_index start];
end
fprintf('%d\n',dest);

end
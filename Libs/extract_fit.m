function T = extract_fit(Result,no_obj)
T1 = [];
T1_f1=[];
T1_f2=[];
T1_f3=[];
T2 = [];
T2_f1=[];
T2_f2=[];
T2_f3=[];
for i=1:length(Result.sol)
    switch Result.sol(i).skill_factor
        case 1
            no_of_objs_T1 = length(Result.sol(i).objs_T1);
            if no_of_objs_T1 == 2
                T1_f1=[T1_f1,Result.sol(i).objs_T1(1)];
                T1_f2=[T1_f2,Result.sol(i).objs_T1(2)];
            else
                T1_f1=[T1_f1,Result.sol(i).objs_T1(1)];
                T1_f2=[T1_f2,Result.sol(i).objs_T1(2)];
                T1_f3=[T1_f3,Result.sol(i).objs_T1(3)];
            end
            T1 = [T1; Result.sol(i).objs_T1];
        case 2
            no_of_objs_T2 = length(Result.sol(i).objs_T2);
            if no_of_objs_T2 == 2
                T2_f1=[T2_f1,Result.sol(i).objs_T2(1)];
                T2_f2=[T2_f2,Result.sol(i).objs_T2(2)];
            else
                T2_f1=[T2_f1,Result.sol(i).objs_T2(1)];
                T2_f2=[T2_f2,Result.sol(i).objs_T2(2)];
                T2_f3=[T2_f3,Result.sol(i).objs_T2(3)];
            end
            T2 = [T2; Result.sol(i).objs_T2];
    end
end
if no_obj == 1
    T = T1;
elseif no_obj == 2
    T = T2;
end

end
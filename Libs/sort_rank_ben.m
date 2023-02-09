function ben_chrom = sort_rank_ben(ch_pos3,Paras)

ben_chrom = [];
nlist = Paras.components;
n2 = cumsum(nlist);
for i = 1:Paras.usr_nodes
    if i == 1
        temp1 = sort_rank(ch_pos3(1,1:n2(i)));
    else
        temp1 = sort_rank(ch_pos3(1,n2(i-1)+1:n2(i)));
        temp1 = temp1+n2(i-1);
    end
    ben_chrom = [ben_chrom temp1];
end

end
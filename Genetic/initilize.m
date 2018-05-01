%初始化种群
%pop_size: 种群大小
%chromo_size: 染色体长度

function initilize(pop_size, chromo_size)
global pop;
for i=1:pop_size
    for j=1:chromo_size
        pop(i,j) = round(rand);
    end
end
clear i;
clear j;
end
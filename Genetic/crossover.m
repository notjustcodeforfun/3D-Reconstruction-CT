
%单点交叉操作
%pop_size: 种群大小
%chromo_size: 染色体长度
%cross_rate: 交叉概率



function crossover(pop_size, chromo_size, cross_rate)
global pop;

for i=1:2:pop_size
    if i == pop_size
        continue
    end
        cross_pos(1) = 1;
        cross_pos(2) = round(rand * chromo_size);
        cross_pos(3) = round(rand * chromo_size);
        cross_pos(4) = chromo_size;
        if cross_pos(2) > cross_pos(3)
            temp = cross_pos(2);
            cross_pos(2) = cross_pos(3);
            cross_pos(3) = temp;
        end
        if (cross_pos(2) == 0 && cross_pos(3) == chromo_size)||(cross_pos(2) == 0 && cross_pos(3) == 0)||(cross_pos(2) == chromo_size && cross_pos(3) == chromo_size)
            continue;
        end
        if cross_pos(2) == 0
            cross_pos(2) = 1;
        end
        
        for k = 1:3
            if(rand < cross_rate && cross_pos(k)~=cross_pos(k+1))
                temp = pop(i,cross_pos(k):cross_pos(k+1));
                pop(i,cross_pos(k):cross_pos(k+1)) = pop(i+1,cross_pos(k):cross_pos(k+1));
                pop(i+1,cross_pos(k):cross_pos(k+1)) = temp;
            end
        end
end

end

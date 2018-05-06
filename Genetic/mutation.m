function grupp_out = mutation(grupp, pop_size, chromo_size, mutate_rate)

for i=1:pop_size
    if rand < mutate_rate
        mutate_pos = round(rand*chromo_size);
        if mutate_pos == 0
            continue;
        end
        grupp.pop(i,mutate_pos) = 1 - grupp.pop(i, mutate_pos);
    end
end
grupp_out = grupp;
end

function grupp_out = selection(grupp, pop_size, elitism)
pop_new = zeros(size(grupp.pop));
for i=1:pop_size
    r = rand * grupp.fitness_table(pop_size);
    first = 1;
    last = pop_size;
    mid = round((last+first)/2);
    idx = -1;
    while (first <= last) && (idx == -1)
        if r > grupp.fitness_table(mid)
            first = mid;
        elseif r < grupp.fitness_table(mid)
            last = mid;
        else
            idx = mid;
            break;
        end
        mid = round((last+first)/2);
        if (last - first) == 1
            idx = last;
            break;
        end
    end
    pop_new(i,:)=grupp.pop(idx,:);
end
if elitism
    grupp.pop(1:end-1,:) = pop_new(1:end-1,:);
else
    grupp.pop = pop_new;
end
    grupp_out = grupp;
end

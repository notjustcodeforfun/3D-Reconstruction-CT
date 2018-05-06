function [grupp_out] = rank(grupp, pop_size)
global G

for i=1:pop_size
    min = i;
    for j = (i+1):pop_size
        if grupp.fitness_value(j)<grupp.fitness_value(min)
            min = j;
        end
    end
    if min~=i
        temp = grupp.fitness_value(i);
        grupp.fitness_value(i) = grupp.fitness_value(min);
        grupp.fitness_value(min) = temp;
        temp1 = grupp.pop(i,:);
        grupp.pop(i,:) = grupp.pop(min,:);
        grupp.pop(min,:) = temp1;
    end
    
end


if grupp.fitness_value(pop_size) > grupp.best_fitness
    grupp.best_fitness = grupp.fitness_value(pop_size);
    grupp.best_generation = G;
    grupp.best_individual= grupp.pop(pop_size,:);
end
grupp_out = grupp;
end

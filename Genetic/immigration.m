function grupp_out = immigration(grupp_output,grupp_input, pop_size)
global G
if(grupp_output.fitness_value(pop_size) > grupp_input.fitness_value(1))
    grupp_input.pop(1,:) = grupp_output.pop(pop_size,:);
end
for i=1:pop_size
    grupp_input.fitness_table(i) = 0.;
end

for i=1:pop_size
    if i==1
        grupp_input.fitness_table(i) = grupp_input.fitness_table(i) + grupp_input.fitness_value(i);
    else
        grupp_input.fitness_table(i) = grupp_input.fitness_table(i-1) + grupp_input.fitness_value(i);
    end
end
grupp_input.fitness_avg(G) = grupp_input.fitness_table(pop_size)/pop_size;
grupp_out = grupp_input;
end
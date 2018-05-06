function plotGA(generation_size,grupp)
x = 1:1:generation_size;
y = grupp.fitness_avg;
plot(x,y)
end

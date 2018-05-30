% Genetic Algorithm

function merk_out = GeneticAlgorithm(para,img_stack)

global G ; %µ±Ç°´ú
global img_stack_after

pop_size = para.genetic.pop_size;
chromo_size = 13;
generation_size = para.genetic.generation_size;
cross_rate = para.genetic.cross_rate;
mutate_rate = para.genetic.mutate_rate;
elitism = para.genetic.elitism;

img_stack_after = img_stack;
grupp_1 = initilize(pop_size, chromo_size);
grupp_2 = initilize(pop_size, chromo_size);
grupp_3 = initilize(pop_size, chromo_size);
for G = 1:generation_size
    fprintf(['Generation: ',num2str(G)])
    grupp_1 = fitness(grupp_1,pop_size,para);  
    grupp_2 = fitness(grupp_2,pop_size,para); 
    grupp_3 = fitness(grupp_3,pop_size,para);  
    grupp_1 = rank(grupp_1,pop_size);  
    grupp_2 = rank(grupp_2,pop_size);  
    grupp_3 = rank(grupp_3,pop_size);  
    grupp_1 = immigration(grupp_3, grupp_1, pop_size);
    grupp_2 = immigration(grupp_1, grupp_2, pop_size);
    grupp_3 = immigration(grupp_2, grupp_3, pop_size);
    grupp_1 = selection(grupp_1, pop_size, elitism);
    grupp_2 = selection(grupp_2, pop_size, elitism);
    grupp_3 = selection(grupp_3, pop_size, elitism);
    grupp_1 = crossover(grupp_1, pop_size, chromo_size, cross_rate);
    grupp_2 = crossover(grupp_2, pop_size, chromo_size, cross_rate);
    grupp_3 = crossover(grupp_3, pop_size, chromo_size, cross_rate);
    grupp_1 = mutation(grupp_1, pop_size, chromo_size, mutate_rate);
    grupp_2 = mutation(grupp_2, pop_size, chromo_size, mutate_rate);
    grupp_3 = mutation(grupp_3, pop_size, chromo_size, mutate_rate);
end
if grupp_1.best_fitness>grupp_2.best_fitness
    if grupp_1.best_fitness>grupp_3.best_fitness
        best_grupp = grupp_1;
    else
        best_grupp = grupp_3;
    end
elseif grupp_2.best_fitness<grupp_3.best_fitness
    best_grupp = grupp_3;
else 
    best_grupp = grupp_2;
end
plotGA(generation_size,best_grupp);
m = best_grupp.best_individual;
outputData.para.Kth = (2^6*m(1)+2^5*m(2)+2^4*m(3)+2^3*m(4)+2^2*m(5)+2^1*m(6)+2^0*m(7))/100+0.6;
outputData.para.Elementsize = 2^2*m(8)+2^1*m(9)+2^0*m(10); 
outputData.para.MinVolume = (2^2*m(11)+2^1*m(12)+2^0*m(13))*100;
outputData.best_fitness = best_grupp.best_fitness;
outputData.bestGeneration = best_grupp.best_generation;
merk_out = callPrototyp(outputData.para.Kth,outputData.para.Elementsize,outputData.para.MinVolume,para);
merk_out.para = [outputData.para.Kth,outputData.para.Elementsize,outputData.para.MinVolume];
clear global
end
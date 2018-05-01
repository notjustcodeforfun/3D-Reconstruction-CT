% Genetic Algorithm

function outputData = GeneticAlgorithm(para,img_stack)

global G ; %当前代
global fitness_value;%当前代适应度矩阵
global best_fitness;%历代最佳适应值
global fitness_avg;%历代平均适应值矩阵
global best_individual;%历代最佳个体
global best_generation;%最佳个体出现代
global img_stack_after

pop_size = para.genetic.pop_size;
chromo_size = 13;
generation_size = para.genetic.generation_size;
cross_rate = para.genetic.cross_rate;
mutate_rate = para.genetic.mutate_rate;
elitism = para.genetic.elitism;

img_stack_after = img_stack;
fitness_avg = zeros(generation_size,1);
fitness_value(pop_size) = 0.;
best_fitness = 0;
best_generation = 0;
initilize(pop_size, chromo_size);%初始化
for G = 1:generation_size
    fprintf(['Generation: ',num2str(G)])
    fitness(pop_size,para);  %计算适应度
    rank(pop_size, chromo_size);  %对个体按适应度大小进行排序
    selection(pop_size, chromo_size, elitism);%选择操作
    crossover(pop_size, chromo_size, cross_rate);%交叉操作
    mutation(pop_size, chromo_size, mutate_rate);%变异操作
end
plotGA(generation_size);%打印算法迭代过程
m = best_individual;%获得最佳个体
outputData.para.Kth = (2^4*m(1)+2^3*m(2)+2^2*m(3)+2^1*m(4)+2^0*m(5))/10+0.1;
outputData.para.Elementsize = 2^3*m(6)+2^2*m(7)+2^1*m(8)+2^0*m(9)+1;
outputData.para.MinVolume = (2^3*m(10)+2^2*m(11)+2^1*m(12)+2^0*m(13))*20+20;
outputData.bestDistance = 1/best_fitness;%获得最佳适应度
outputData.bestGeneration = best_generation;%获得最佳个体出现代
[outputData.merkmal.porositaet,outputData.merkmal.endKnoten,outputData.merkmal.stegLaenge,outputData.merkmal.objectAnzahl]= callPrototyp(outputData.para.Kth,outputData.para.Elementsize,outputData.para.MinVolume,para);
clear global
end
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
%计算种群个体适应度，对不同的优化目标，此处需要改写
%pop_size: 种群大小
%chromo_size: 染色体长度


function fitness(pop_size, chromo_size)
global fitness_value;
global pop;
global G;
for i=1:pop_size
    fitness_value(i) = 0.;
end

for i=1:pop_size
    for j=1:chromo_size
        if pop(i,j) == 1
            fitness_value(i) = fitness_value(i)+2^(j-1);
        end
    end
    fitness_value(i) = -1+fitness_value(i)*(3.-(-1.))/(2^chromo_size-1);
    fitness_value(i) = -(fitness_value(i)-1).^2+4;
end

clear i;
clear j;
end
%对个体按适应度大小进行排序，并且保存最佳个体
%pop_size: 种群大小
%chromo_size: 染色体长度


function rank(pop_size, chromo_size)
global fitness_value;
global fitness_table;
global fitness_avg;
global best_fitness;
global best_individual;
global best_generation;
global pop;
global G;

for i=1:pop_size
    fitness_table(i) = 0.;
end

min = 1;
temp = 1;
temp1(chromo_size)=0;
for i=1:pop_size
    min = i;
    for j = i+1:pop_size
        if fitness_value(j)<fitness_value(min);
            min = j;
        end
    end
    if min~=i
        temp = fitness_value(i);
        fitness_value(i) = fitness_value(min);
        fitness_value(min) = temp;
        for k = 1:chromo_size
            temp1(k) = pop(i,k);
            pop(i,k) = pop(min,k);
            pop(min,k) = temp1(k);
        end
    end
    
end

for i=1:pop_size
    if i==1
        fitness_table(i) = fitness_table(i) + fitness_value(i);
    else
        fitness_table(i) = fitness_table(i-1) + fitness_value(i);
    end
end
fitness_avg(G) = fitness_table(pop_size)/pop_size;


if fitness_value(pop_size) > best_fitness
    best_fitness = fitness_value(pop_size);
    best_generation = G;
    for j=1:chromo_size
        best_individual(j) = pop(pop_size,j);
    end
end


clear i;
clear j;
clear k;
clear min;
clear temp;
clear temp1;
end

%轮盘赌选择操作
%pop_size: 种群大小
%chromo_size: 染色体长度
%cross_rate: 是否精英选择



function selection(pop_size, chromo_size, elitism)
global pop;
global fitness_table;

for i=1:pop_size
    r = rand * fitness_table(pop_size);
    first = 1;
    last = pop_size;
    mid = round((last+first)/2);
    idx = -1;
    while (first <= last) && (idx == -1)
        if r > fitness_table(mid)
            first = mid;
        elseif r < fitness_table(mid)
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
    
    for j=1:chromo_size
        pop_new(i,j)=pop(idx,j);
    end
end
if elitism
    p = pop_size-1;
else
    p = pop_size;
end
for i=1:p
    for j=1:chromo_size
        pop(i,j) = pop_new(i,j);
    end
end

clear i;
clear j;
clear pop_new;
clear first;
clear last;
clear idx;
clear mid;
end

%单点交叉操作
%pop_size: 种群大小
%chromo_size: 染色体长度
%cross_rate: 交叉概率



function crossover(pop_size, chromo_size, cross_rate)
global pop;
for i=1:2:pop_size
    if(rand < cross_rate)
        cross_pos = round(rand * chromo_size);
        if or (cross_pos == 0, cross_pos == 1)
            continue;
        end
        for j=cross_pos:chromo_size
            temp = pop(i,j);
            pop(i,j) = pop(i+1,j);
            pop(i+1,j) = temp;
        end
    end
end


clear i;
clear j;
clear temp;
clear cross_pos;
end

%单点变异操作
%pop_size: 种群大小
%chromo_size: 染色体长度
%cross_rate: 变异概率
function mutation(pop_size, chromo_size, mutate_rate)
global pop;

for i=1:pop_size
    if rand < mutate_rate
        mutate_pos = round(rand*chromo_size);
        if mutate_pos == 0
            continue;
        end
        pop(i,mutate_pos) = 1 - pop(i, mutate_pos);
    end
end

clear i;
clear mutate_pos;
end



%打印算法迭代过程
%generation_size: 迭代次数
function plotGA(generation_size)
global fitness_avg;
x = 1:1:generation_size;
y = fitness_avg;
plot(x,y)
end

%遗传算法主函数
%pop_size: 输入种群大小
%chromo_size: 输入染色体长度
%generation_size: 输入迭代次数
%cross_rate: 输入交叉概率
%cross_rate: 输入变异概率
%elitism: 输入是否精英选择
%m: 输出最佳个体
%n: 输出最佳适应度
%p: 输出最佳个体出现代
%q: 输出最佳个体自变量值

function [m,n,p,q] = GeneticAlgorithm(pop_size, chromo_size, generation_size, cross_rate, mutate_rate, elitism)

global G ; %当前代
global fitness_value;%当前代适应度矩阵
global best_fitness;%历代最佳适应值
global fitness_avg;%历代平均适应值矩阵
global best_individual;%历代最佳个体
global best_generation;%最佳个体出现代



fitness_avg = zeros(generation_size,1);

disp "hhee"

fitness_value(pop_size) = 0.;
best_fitness = 0.;
best_generation = 0;
initilize(pop_size, chromo_size);%初始化
for G=1:generation_size
    fitness(pop_size, chromo_size);  %计算适应度
    rank(pop_size, chromo_size);  %对个体按适应度大小进行排序
    selection(pop_size, chromo_size, elitism);%选择操作
    crossover(pop_size, chromo_size, cross_rate);%交叉操作
    mutation(pop_size, chromo_size, mutate_rate);%变异操作
end
plotGA(generation_size);%打印算法迭代过程
m = best_individual;%获得最佳个体
n = best_fitness;%获得最佳适应度
p = best_generation;%获得最佳个体出现代
%获得最佳个体变量值，对不同的优化目标，此处需要改写
q = 0.;
for j=1:chromo_size
    if best_individual(j) == 1
        q = q+2^(j-1);
    end
end
q = -1+q*(3.-(-1.))/(2^chromo_size-1);

clear i;
clear j;
end
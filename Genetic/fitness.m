

function fitness(pop_size,para)
global fitness_value;
global pop;
for i=1:pop_size
    fitness_value(i) = 0;
end
target_vector = [para.soll.porositaet,para.soll.nodesEnd,para.soll.lLink,para.soll.nObjects ]; % [porositaet [%], Endknoten [%], durchschnitte Steglange [Pixel], Objektanzahl]
for i=1:pop_size
    kth = (2^4*pop(i,1)+2^3*pop(i,2)+2^2*pop(i,3)+2^1*pop(i,4)+2^0*pop(i,5))/10+0.1;
    ele = 2^3*pop(i,6)+2^2*pop(i,7)+2^1*pop(i,8)+2^0*pop(i,9)+1;
    minV = (2^3*pop(i,10)+2^2*pop(i,11)+2^1*pop(i,12)+2^0*pop(i,13))*20+20;
%     sigma_gauss = pop(i,12)*2^1+ pop(i,13)*2^0+3;
    [poros,endKnoten,steg,objectsize] = callPrototyp(kth,ele,minV,para);
    diff_vector = [para.factors.porositaet*abs((target_vector(1)-poros)),para.factors.nodesEnd*abs((target_vector(2)-endKnoten)),para.factors.lLink*abs((target_vector(3)-steg)),para.factors.nObjects *abs((target_vector(4)-objectsize))];  %[1 0.05 0.5 0.05]
    distance_temp = sqrt(diff_vector(1)^2+1*diff_vector(2)^2+diff_vector(3)^2+diff_vector(4)^2); % gewichtet Eu. distance
    fitness_value(i) = 1/distance_temp;
end
end
function grupp_out = fitness(grupp,pop_size,para)
for i=1:pop_size
    grupp.fitness_value(i) = 0;
end
target_vector = [para.soll.porositaet,para.soll.nodesEnd,para.soll.lLink,para.soll.nObjects,para.soll.sizePoren ]; % [porositaet [%], Endknoten [%], durchschnitte Steglange [Pixel], Objektanzahl, Porengrosse]
for i=1:pop_size
    kth = (2^4*grupp.pop(i,1)+2^3*grupp.pop(i,2)+2^2*grupp.pop(i,3)+2^1*grupp.pop(i,4)+2^0*grupp.pop(i,5))/10+0.1;
    ele = 2^3*grupp.pop(i,6)+2^2*grupp.pop(i,7)+2^1*grupp.pop(i,8)+2^0*grupp.pop(i,9)+1;
    minV = (2^3*grupp.pop(i,10)+2^2*grupp.pop(i,11)+2^1*grupp.pop(i,12)+2^0*grupp.pop(i,13))*20+20;
    %     sigma_gauss = pop(i,12)*2^1+ pop(i,13)*2^0+3;
    merkmal = callPrototyp(kth,ele,minV,para);
    diff_vector = [para.factors.porositaet*abs((target_vector(1)-merkmal.porenraum.porositaet)),...
        para.factors.nodesEnd * abs((target_vector(2)-merkmal.steg.endKnoten)),...
        para.factors.lLink * abs((target_vector(3)-merkmal.steg.lengthKnoten)),...
        para.factors.nObjects * abs((target_vector(4)-merkmal.ObjektAnzahl)),...
        para.factors.sizePoren * abs((target_vector(5)-merkmal.porenraum.porengroesse))];  %[1 0.05 0.5 0.05 0]
    distance_temp = sqrt(diff_vector(1)^2+1*diff_vector(2)^2+diff_vector(3)^2+diff_vector(4)^2+diff_vector(5)^2); % gewichtet Eu. distance
    grupp.fitness_value(i) = 1/distance_temp;
end
grupp_out = grupp;
end
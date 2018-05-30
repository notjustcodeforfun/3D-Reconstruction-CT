function grupp_out = fitness(grupp,pop_size,para)
for i=1:pop_size
    grupp.fitness_value(i) = 0;
end
for i=1:pop_size
    kth = (2^6*grupp.pop(i,1)+2^5*grupp.pop(i,2)+2^4*grupp.pop(i,3)+2^3*grupp.pop(i,4)+2^2*grupp.pop(i,5)+2^1*grupp.pop(i,6)+2^0*grupp.pop(i,7))/100+0.6;
    ele = 2^2*grupp.pop(i,8)+2^1*grupp.pop(i,9)+2^0*grupp.pop(i,10);
    minV = (2^2*grupp.pop(i,11)+2^1*grupp.pop(i,12)+2^0*grupp.pop(i,13))*100;
    merkmal = callPrototyp(kth,ele,minV,para);
    
    fitness_porositaet = merkmal.porenraum.porositaet;
    if fitness_porositaet>para.soll.porositaet_max||fitness_porositaet<para.soll.porositaet_min
        fitness_porositaet = 0;
    else
        fitness_porositaet=...
            1-abs(para.soll.porositaet-fitness_porositaet)/(para.soll.porositaet_max-para.soll.porositaet_min);
    end
    
    fitness_nObjects = merkmal.ObjektAnzahl;
    if fitness_nObjects>500
        fitness_nObjects = 0;
    else
        fitness_nObjects=...
            1-(fitness_nObjects-1)/500;
    end
    
    fitness_sizePoren = merkmal.porenraum.porengroesse;
    if fitness_sizePoren>para.soll.sizePoren_max||fitness_sizePoren<para.soll.sizePoren_min
        fitness_sizePoren = 0;
    else
        fitness_sizePoren =...
            1-abs(para.soll.sizePoren-fitness_sizePoren)/(para.soll.sizePoren_max-para.soll.sizePoren_min);
    end
    
    fitness_lLink = merkmal.steg.lengthKnoten;
    if fitness_lLink>para.soll.lLink_max||fitness_lLink<para.soll.lLink_min
        fitness_lLink = 0;
    else
        fitness_lLink =...
            1-abs(para.soll.lLink-fitness_lLink)/(para.soll.lLink_max-para.soll.lLink_min);
    end
    grupp.fitness_value(i) = sqrt(1/(para.factors.porositaet+para.factors.nObjects+para.factors.sizePoren+para.factors.lLink)*(para.factors.porositaet*fitness_porositaet.^2+para.factors.nObjects*fitness_nObjects.^2+...
    para.factors.sizePoren*fitness_sizePoren.^2+para.factors.lLink*fitness_lLink.^2));
end
grupp_out = grupp;
end
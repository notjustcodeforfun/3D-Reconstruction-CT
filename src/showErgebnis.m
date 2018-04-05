function showErgebnis(img_bin,para,merkmal)
%% ****************************************************************
% ---------------------------- Endergebnisse --------------------------------
% ***************************************************************************

% ------------------------ Porenverteilung und Median
if (para.SwitchPorenV)
    img_pore = poroverteil(img_bin(1:300,1:300,30:70));
    poren_median = median(img_pore(img_pore>0));
    fprintf(['Radiusmedian der Poren ist:  ' num2str(poren_median) '  \n']);
    % ------------------------Anschauen der Porenverteilung
    img_pore = uint8(img_pore*10);
    figure;
    imagesc(img_pore(:,:,5));axis equal ;title('binar');set(gca,'FontSize',15); colorbar
    h = histogram(double(img_pore),'Normalization','probability');set(gca,'FontSize',15);hold on
    plot(r,h.Values,'r')
    xlabel('Radius  [voxel]')
    ylabel('Normierte Frequenz')
    title('Normierte Porenverteilung')
end

% ------------------------Anschauen der Porositaet   
knotenanzahl = [];
sum_knoten = [];
w = size(merkmal.skelett,1);
l = size(merkmal.skelett,2);
h = size(merkmal.skelett,3);
if merkmal.issteg
    for i = 1:length(merkmal.steg.link)
        sum_temp = 0;
        for k=1:length(merkmal.steg.link(i).point)-1
            [x1,y1,z1]=ind2sub([w,l,h],merkmal.steg.link(i).point(k));
            [x2,y2,z2]=ind2sub([w,l,h],merkmal.steg.link(i).point(k+1));
            xx = x1-x2;
            yy = y1-y2;
            zz = z1-z2;
            sum_temp = sum_temp+sqrt(xx*xx+yy*yy+zz*zz);
        end
        sum_knoten = [sum_knoten; sum_temp];
    end
    
    for i = 1:length(merkmal.steg.node)
        knotenanzahl = [knotenanzahl;length(merkmal.steg.node(i).links)];
    end
    Endknoten = sum(knotenanzahl ==1)/length(knotenanzahl)*100;
    Dreiknoten = sum(knotenanzahl ==3)/length(knotenanzahl)*100;
    Vierknoten = sum(knotenanzahl ==4)/length(knotenanzahl)*100;
    Funfknoten = sum(knotenanzahl ==5)/length(knotenanzahl)*100;

    fprintf(['Final result ---------\n1.  Porositaet = ' num2str(merkmal.porositaet*100) ' %%\n']);
    fprintf(['2.  Anzahl der Objekte = ' num2str(merkmal.ObjektAnzahl),'\n']);
    fprintf(['3.  Knotenanzahl (Ausschnitt) = ', num2str(length(merkmal.steg.node)) ', davon ' num2str(Endknoten) '%% Endpunkte, ',num2str(Dreiknoten) '%% Knoten mit 3 Stegen, ',num2str(Vierknoten) '%% mit 4 Stegen, ',num2str(Funfknoten), '%% mit 5 Stegen\n']);
    fprintf(['4.  Durchschnittliche Knotenlaenge (Ausschnitt) = ' num2str(sum(sum_knoten)/length(sum_knoten)),'\n']);
else
    fprintf('Es gibt keine Stege')
end
% ------------------------ 3D-Darstellung

end
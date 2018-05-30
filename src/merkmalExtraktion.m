function m_out = merkmalExtraktion(img_in,para)
% ****************************************************************
% ------------------------- Merkmale Extraktion -----------------------------
% ***************************************************************************

% ------------------------ Porositaet
m_out.porenraum.porositaet  = porost(img_in)*100;  % [%]

% ------------------------ Porenverteilung und Porengroesse
if (para.SwitchPorenV)
    porenraum = porverteil(img_in,para);
    histPoren = 2*porenraum(porenraum>0)+1;
    [muHat,sigmaHat] = normfit(histPoren);
    m_out.porenraum.porengroesse = muHat;
    m_out.porenraum.porengroesse_sigma = sigmaHat;

else
    m_out.porenraum.porengroesse_sigma = false;
    m_out.porenraum.porengroesse = false;
end

% ------------------------Spezifische Oberflaeche (Marching Cubes)
if para.SwitchSpezOber
    x = 0:para.resolution_ref:para.resolution_ref*(size(img_in,1)-1);
    y = 0:para.resolution_ref:para.resolution_ref*(size(img_in,2)-1);
    z = 0:para.resolution_ref:para.resolution_ref*(size(img_in,3)-1);
    [X,Y,Z] = meshgrid(x,y,z);
    [F,V] = MarchingCubes(X,Y,Z,img_in,0.5);
    S = 0;
    for i = 1:length(F)    % Heron's formula
        A = V(F(i,1),:);
        B = V(F(i,2),:);
        C = V(F(i,3),:);
        a = sqrt((A(1)-B(1))^2+(A(2)-B(2))^2+(A(3)-B(3))^2);
        b = sqrt((C(1)-B(1))^2+(C(2)-B(2))^2+(C(3)-B(3))^2);
        c = sqrt((A(1)-C(1))^2+(A(2)-C(2))^2+(A(3)-C(3))^2);
        p = (a+b+c)/2;
        S = S + sqrt(p*(p-a)*(p-b)*(p-c));
    end
    m_out.SpezOberf = S/((para.resolution_ref*para.resolution_ref*para.resolution_ref)*(sum(sum(sum(img_in==1)))));
else
    m_out.SpezOberf = false;
end
% ------------------------Anzahl frei schwebender Objekte
cc = bwconncomp(img_in,6);
m_out.ObjektAnzahl = cc.NumObjects;
% ------------------------Steganalyse
skel = Skeleton3D(img_in);
[~,node,link] = Skel2Graph3D(skel,5);
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);
% total length of network
if isstruct(node)
    wl = sum(cellfun('length',{node.links}));
    
    skel2 = Graph2Skel3D(node,link,w,l,h);
    [~,node2,link2] = Skel2Graph3D(skel2,5);
    if isstruct(node2)
        % calculate new total length of network
        wl_new = sum(cellfun('length',{node2.links}));
        
        % iterate the same steps until network length changed by less than 0.5%
        while(wl_new~=wl)
            
            wl = wl_new;
            
            skel2 = Graph2Skel3D(node2,link2,w,l,h);
            [~,node2,link2] = Skel2Graph3D(skel2,5);
            
            wl_new = sum(cellfun('length',{node2.links}));
            
        end
    end
    knotenanzahl = [];
    sum_knoten = [];
    angle_xyz = [0 0 0];
    for i = 1:length(link2)
        sum_temp = 0;
        for k=1:length(link2(i).point)-1
            [x1,y1,z1]=ind2sub([w,l,h],link2(i).point(k));
            [x2,y2,z2]=ind2sub([w,l,h],link2(i).point(k+1));
            xx = (x1-x2)*para.resolution_ref;
            yy = (y1-y2)*para.resolution_ref;
            zz = (z1-z2)*para.resolution_ref;
            sum_temp = sum_temp+sqrt(xx*xx+yy*yy+zz*zz);
        end
        sum_knoten = [sum_knoten; sum_temp];
        [steg_1(1),steg_1(2),steg_1(3)] = ind2sub([w,l,h],link2(i).point(1));
        [steg_2(1),steg_2(2),steg_2(3)] = ind2sub([w,l,h],link2(i).point(end));
        vector_temp = abs(steg_1-steg_2);
        angle_xyz(vector_temp==max(vector_temp)) = angle_xyz(vector_temp==max(vector_temp))+1;
        %if vector_temp(3) < 0
%             vector_temp = -vector_temp;
%         end
%         angle_xy = atan2(vector_temp(2),vector_temp(1))*180/pi; %0¡ã positive x-Richtung, 90¡ãpositive y-Richtung, 180¡ã/-180¡ã negative x-Richtung, -90¡ã negative y-Richtung
%         angle_z = atan2(sqrt(vector_temp(1)^2+vector_temp(2)^2),vector_temp(3))*180/pi; % 0¡ã entspricht Steg in z-Richtung, 90¡ã entspricht Steg in xy-Richtung
%         angle = [angle;angle_xy,angle_z];
       
    end
%     angle_xyz = zeros(length(angle),1);
%     for i = 1:size(angle,1)
%         if angle(i,2) < 45
%             angle_xyz(i) = 3;
%         elseif (45^2-(angle(i,2)-90)^2)>angle(i,1)^2 || (45^2-(angle(i,2)-90)^2)>(angle(i,1)-180)^2 || (45^2-(angle(i,2)-90)^2)>(angle(i,1)+180)^2
%             angle_xyz(i) = 1;
%         elseif (45^2-(angle(i,2)-90)^2)>(angle(i,1)-90)^2 || (45^2-(angle(i,2)-90)^2)>(angle(i,1)+90)^2
%             angle_xyz(i) = 2;
%         end
%     end
    m_out.steg.orientation(1) = angle_xyz(1)/sum(angle_xyz)*100;
    m_out.steg.orientation(2) = angle_xyz(2)/sum(angle_xyz)*100;
    m_out.steg.orientation(3) = angle_xyz(3)/sum(angle_xyz)*100;
    
    for i = 1:length(node2)
        knotenanzahl = [knotenanzahl;length(node2(i).links)];
    end
    m_out.steg.lengthKnoten = sum(sum_knoten)/length(sum_knoten);
    m_out.steg.anzahlKnoten = length(node2);
    m_out.steg.endKnoten = sum(knotenanzahl ==1)/length(knotenanzahl)*100;
    m_out.steg.dreiKnoten = sum(knotenanzahl ==3)/length(knotenanzahl)*100;
    m_out.steg.vierKnoten = sum(knotenanzahl ==4)/length(knotenanzahl)*100;
    m_out.steg.fuenfKnoten = sum(knotenanzahl ==5)/length(knotenanzahl)*100;
    m_out.skelett = skel2;
    m_out.struktur = img_in;
    m_out.issteg = true;
else
    m_out.steg.orientation = [false false false];
    m_out.steg.lengthKnoten = 0;
    m_out.steg.anzahlKnoten = 0;
    m_out.steg.endKnoten = 0;
    m_out.steg.dreiKnoten = 0;
    m_out.steg.vierKnoten = 0;
    m_out.steg.fuenfKnoten = 0;
    m_out.issteg = false;
end

end

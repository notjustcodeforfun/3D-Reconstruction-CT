function m_out = merkmalExtraktion(img_in,para)
% ****************************************************************
% ------------------------- Merkmale Extraktion -----------------------------
% ***************************************************************************

% ------------------------Porenidentifikation
m_out.porositaet  = porost(img_in);
% ------------------------Spezifische Oberflaeche (Marching Cubes)
x = 0:para.scaling:para.scaling*(size(img_in,1)-1);
y = 0:para.scaling:para.scaling*(size(img_in,2)-1);
z = 0:para.spacing:para.spacing*(size(img_in,3)-1);
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
m_out.SpezOberf = S/((para.scaling*para.scaling*para.spacing)*(sum(sum(sum(img_in==1)))));
% ------------------------Anzahl frei schwebender Objekte
cc = bwconncomp(img_in,6);
m_out.ObjektAnzahl = cc.NumObjects;
% ------------------------Steganalyse
skel = Skeleton3D(img_in);
[~,node,link] = Skel2Graph3D(skel,0);
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);
% total length of network
if isstruct(node)
    wl = sum(cellfun('length',{node.links}));
    
    skel2 = Graph2Skel3D(node,link,w,l,h);
    [A2,node2,link2] = Skel2Graph3D(skel2,0);
    if isstruct(node2)
        % calculate new total length of network
        wl_new = sum(cellfun('length',{node2.links}));
        
        % iterate the same steps until network length changed by less than 0.5%
        while(wl_new~=wl)
            
            wl = wl_new;
            
            skel2 = Graph2Skel3D(node2,link2,w,l,h);
            [A2,node2,link2] = Skel2Graph3D(skel2,3);
            
            wl_new = sum(cellfun('length',{node2.links}));
            
        end
    end
    m_out.steg.A = A2;
    m_out.steg.node = node2;
    m_out.steg.link = link2;
    m_out.skelett = skel2;
    m_out.ausschnitt = img_in;
    m_out.issteg = true;
else
    m_out.issteg = false;
end
% addpath('C:\Users\fuxia\Documents\Thesis\code\Moritz')
% m_out = callCLSM(img_in);
if(para.ShowDetails && para.switchMode == 0)
    fprintf(['Actuelle Porositaet ist:  ' num2str(m_out.porositaet*100) ' %%.\n']);
end
end

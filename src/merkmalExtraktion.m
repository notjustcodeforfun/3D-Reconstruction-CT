function m_out = merkmalExtraktion(img_in,para)
% ****************************************************************
% ------------------------- Merkmale Extraktion -----------------------------
% ***************************************************************************

% ------------------------Porenidentifikation
m_out.porositaet  = porost(img_in);
% ------------------------Steganalyse
img_ausschnitt = img_in (151:200,151:200,1:50);
skel = Skeleton3D(img_ausschnitt);
[~,node,link] = Skel2Graph3D(skel,0);
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);
% total length of network
if isstruct(node)
    wl = sum(cellfun('length',{node.links}));
    
    skel2 = Graph2Skel3D(node,link,w,l,h);
    [A2,node2,link2] = Skel2Graph3D(skel2,0);
    
    % calculate new total length of network
    wl_new = sum(cellfun('length',{node2.links}));
    
    % iterate the same steps until network length changed by less than 0.5%
    while(wl_new~=wl)
        
        wl = wl_new;
        
        skel2 = Graph2Skel3D(node2,link2,w,l,h);
        [A2,node2,link2] = Skel2Graph3D(skel2,3);
        
        wl_new = sum(cellfun('length',{node2.links}));
        
    end
    m_out.steg.A = A2;
    m_out.steg.node = node2;
    m_out.steg.link = link2;
    m_out.skelett = skel2;
    m_out.ausschnitt = img_ausschnitt;
    m_out.issteg = true;
else
    m_out.issteg = false;
end
% addpath('C:\Users\fuxia\Documents\Thesis\code\Moritz')
% m_out = callCLSM(img_in);
if(para.ShowDetails)
    fprintf(['Actuelle Porositaet ist:  ' num2str(m_out.porositaet*100) ' %%.\n']);
end
end
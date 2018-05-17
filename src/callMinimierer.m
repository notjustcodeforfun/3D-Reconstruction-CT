function merkmalsraum = callMinimierer(para,filename)
%% Reads the features from an excel file that are created with the feature extractor (Xiaoyu)
% This features are then evaluated by a optimization function, that
% minimizes the error

%% Inputs:
% Path and Filename of the Excel file:
pathExcel = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\';
filenameExcel = filename;

%% Import data from spreadsheet

% Import the data
[~, ~, importRaw] = xlsread(filenameExcel);
% Create table
merkmalsraum = cell2table(importRaw(2:end,:));
% Set variable names
% merkmalsraum.Properties.VariableNames = importRaw(1,:); doesnt work, because of :
% and % in variable names so you have to set it by hand

variableNames = {'Probe','Kth','ElementSize','MinVolume','Porositaet','SpeOberflaeche','NObjects','NNodes','NodesEnd','Nodes3','Nodes4','Nodes5','LinkLength','Porengroesse','PorengroesseAnteil','xRichtung','yRichtung','zRichtung'};
merkmalsraum.Properties.VariableNames = variableNames;
% Clear temporary variables
clearvars importRaw variableNames;

%% Add minimization Row to table:
merkmalsraum.fMin = ones(size(merkmalsraum,1),1)*(-1);
%% Normierung
fitness_porositaet = merkmalsraum.Porositaet;
fitness_porositaet(fitness_porositaet>para.soll.porositaet_max) = 0;
fitness_porositaet(fitness_porositaet<para.soll.porositaet_min) = 0;
fitness_porositaet(fitness_porositaet>0) =...
    1-abs(para.soll.porositaet-fitness_porositaet(fitness_porositaet>0))/(para.soll.porositaet_max-para.soll.porositaet_min);

fitness_nObjects = merkmalsraum.NObjects;
fitness_nObjects(fitness_nObjects>500) = 0;
fitness_nObjects(fitness_nObjects>0) =...
    1-(fitness_nObjects(fitness_nObjects>0)-1)/500;

fitness_sizePoren = merkmalsraum.Porengroesse;
fitness_sizePoren(fitness_sizePoren>para.soll.sizePoren_max) = 0;
fitness_sizePoren(fitness_sizePoren<para.soll.sizePoren_min) = 0;
fitness_sizePoren(fitness_sizePoren>0) =...
    1-abs(para.soll.sizePoren-fitness_sizePoren(fitness_sizePoren>0))/(para.soll.sizePoren_max-para.soll.sizePoren_min);

fitness_lLink = merkmalsraum.LinkLength;
fitness_lLink(fitness_lLink>para.soll.lLink_max) = 0;
fitness_lLink(fitness_lLink<para.soll.lLink_min) = 0;
fitness_lLink(fitness_lLink>0) =...
    1-abs(para.soll.lLink-fitness_lLink(fitness_lLink>0))/(para.soll.lLink_max-para.soll.lLink_min);

%% Create minimization function
% fmax = @(x,y,z,k,l) para.factors.porositaet*(x-para.soll.porositaet)^2+...
%     para.factors.nObjects*(y-para.soll.nObjects)^2+...
%     para.factors.nodesEnd*(z-para.soll.nodesEnd)^2+...
%     para.factors.sizePoren*(k-para.soll.sizePoren)^2+...
%     para.factors.lLink*(l-para.soll.lLink)^2;
%
% for i = 1:size(merkmalsraum,1)
%     merkmalsraum.fMax(i)= fmax(merkmalsraum.Porositaet(i), merkmalsraum.NObjects(i), merkmalsraum.NodesEnd(i),Porengroesse_normiert(i),LinkLength_normiert(i));
% end
merkmalsraum.fMax = sqrt(1/(para.factors.porositaet+para.factors.nObjects+para.factors.sizePoren+para.factors.lLink)*(para.factors.porositaet*fitness_porositaet.^2+para.factors.nObjects*fitness_nObjects.^2+...
    para.factors.sizePoren*fitness_sizePoren.^2+para.factors.lLink*fitness_lLink.^2));
end
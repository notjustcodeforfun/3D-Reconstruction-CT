close all;clear
addpath('D:\Projekte\Poroese_Materialien\Matlab\Xiaoyu\3D-Reconstruction-CT-master','BaSiC-master','BaSiC-master\dcttool','skel2graph3d','skeleton3d','src','MarchingCubes','Genetic','C:\Users\fuxia\Documents\Thesis\code\Moritz')
formatOut = 'yymmddhhMM';
startzeit = datestr(datetime, formatOut);
para = param;   % 1 : CLSM , 0 : CT
load(para.datapath);
img_stack_after = bildvorverarbeitung(img_stack, para);
% PID Regler
if para.switchMode == 0
    fprintf('PID Regler start...\n')
    for times = 1:para.Zyklen
        img_bin = bildverarbeitung(img_stack_after, para);
        merkmal = merkmalExtraktion(img_bin, para);
        if abs(merkmal.porenraum.porositaet-para.soll.porositaet)<para.ab
            break
        end
        para = vergleichSWG(merkmal, para);
    end
    ergebnis = showErgebnis(para,merkmal);
    
% Pool Berechnung
elseif para.switchMode == 1 % Parameterpool
    fprintf('Pool Berechnung start...\n')
    filename = callPool(para,img_stack_after,startzeit);
    merkmalsraum = callMinimierer(para,filename);

% Genetische Algorithmus
elseif para.switchMode == 2
    fprintf('Genetic Algorithm start...\n')
    tic
    outputData = GeneticAlgorithm(para,img_stack_after);
    toc
end
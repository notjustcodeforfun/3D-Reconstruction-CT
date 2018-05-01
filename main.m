close all;clear
addpath('D:\Projekte\Poroese_Materialien\Matlab\Xiaoyu\3D-Reconstruction-CT-master','BaSiC-master','BaSiC-master\dcttool','skel2graph3d','skeleton3d','src','MarchingCubes','Genetic','C:\Users\fuxia\Documents\Thesis\code\Moritz')
formatOut = 'yymmddhhMM';
startzeit = datestr(datetime, formatOut);
para = param(0);   % 1 : CLSM , 0 : CT
load(para.datapath);
img_stack_after = bildvorverarbeitung(img_stack, para);
% PID Regler
if para.switchMode == 0
    fprintf('PID Regler start...\n')
    for times = 1:para.Zyklen
        img_bin = bildverarbeitung(img_stack_after, para);
        merkmal = merkmalExtraktion(img_bin, para);
        if abs(merkmal.porositaet-para.porositaet_soll)<para.ab
            break
        end
        para = vergleichSWG(merkmal, para);
    end
    ergebnis = showErgebnis(img_bin,para,merkmal);
    
% Pool Berechnung
fprintf('Pool Berechnung start...\n')
elseif para.switchMode == 1 % Parameterpool
    filename = callPool(para,img_stack_after,startzeit);
    callMinimierer(para,filename);

% Genetische Algorithmus
elseif para.switchMode == 2
    fprintf('Genetic Algorithm start...\n')
    outputData = GeneticAlgorithm(para,img_stack_after);
end
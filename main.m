close all;clear
addpath('Data','skel2graph3d','skeleton3d')
para = param;
load(para.datapath);
img_stack_after = bildvorverarbeitung(img_stack, para);
fprintf('Digitales Modell automatisch rekonstruieren ...\n');
for times = 1:para.Zyklen
    img_bin = bildverarbeitung(img_stack_after, para);
    merkmal = merkmalExtraktion(img_bin, para);
    if abs(merkmal.porositaet-para.porositaet_soll)<para.ab
        break
    end
    para = vergleichSWG(merkmal, para);
end
showErgebnis(img_bin,img_stack_after,para,merkmal)
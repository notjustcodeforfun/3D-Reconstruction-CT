close all;clear
addpath('C:\Users\fuxia\Documents\Thesis\code\prototyp\Data','BaSiC-master','BaSiC-master\dcttool','skel2graph3d','skeleton3d','src')
para = param;
load(para.datapath);
img_stack_after = bildvorverarbeitung(img_stack, para);
for times = 1:para.Zyklen
    img_bin = bildverarbeitung(img_stack_after, para);
    merkmal = merkmalExtraktion(img_bin, para);
    if abs(merkmal.porositaet-para.porositaet_soll)<para.ab
        break
    end
    para = vergleichSWG(merkmal, para);
end
showErgebnis(img_bin,para,merkmal)
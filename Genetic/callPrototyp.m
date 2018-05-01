function [poros,endKnoten,steg,objektanzahl] = callPrototyp(kth,ele,minV,para)
global img_stack_after
para.Kth = kth;
% para.sigma_gauss = sigma_gauss;
para.Elementsize = ele;
para.MinVolume = minV;
img_bin = bildverarbeitung(img_stack_after, para);
merkmal = merkmalExtraktion(img_bin, para);
ergebnis = showErgebnis(img_bin,para,merkmal);
poros = ergebnis(1);
objektanzahl = ergebnis(3);
endKnoten = ergebnis(5);
steg = ergebnis(end);
end
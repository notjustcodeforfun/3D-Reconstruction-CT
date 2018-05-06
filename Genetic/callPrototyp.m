function merkmal = callPrototyp(kth,ele,minV,para)
global img_stack_after
para.Kth = kth;
% para.sigma_gauss = sigma_gauss;
para.Elementsize = ele;
para.MinVolume = minV;
img_bin = bildverarbeitung(img_stack_after, para);
merkmal = merkmalExtraktion(img_bin, para);
if para.genetic.ShowDetails
showErgebnis(para,merkmal);
end
end
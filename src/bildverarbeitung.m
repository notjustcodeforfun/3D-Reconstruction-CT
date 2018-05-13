function img_out = bildverarbeitung(img_in,para)
% ****************************************************************
% ------------------------- Bildverarbeitung --------------------------------
% ***************************************************************************
% ------------------------ Otsu-Thresholding
global thresh_inter
if isempty(thresh_inter)
     thresh_inter = threshregress(img_in,para.skip_thresh);
end
img_out = false(size(img_in));
for i = 1:size(img_in,3)
    img_out(:,:,i) = imbinarize(img_in(:,:,i),(para.Kth*graythresh(img_in(:,:,i))));
end

% ------------------------- Morph. Operation
if para.Elementsize
img_out = imclose(img_out,strel('sphere',para.Elementsize));
end
% img_out = imopen(img_out,strel('sphere',1));
% ------------------------- Optimierung nach Volumen
if para.SwitchVolume
    img_out = volumenfilt(img_out,para.MinVolume,6);
end
end


function thresh_regress = threshregress(img_stack,n)
% img_stack, input image.
% n, Abtastfrequenz 
[~, ~, sizeZ] = size(img_stack);
zz = round(linspace(1,sizeZ,round(sizeZ/n)));
thresh = zeros(1,length(zz));
j = 1;
for i = zz
    thresh(j) = graythresh(img_stack(:,:,i));
    j = j+1;
end
X_regress = zz';
b = regress(thresh',[ones(size(X_regress)) X_regress X_regress.^2 X_regress.^3]);
thresh_regress = b(1)+b(2)*(1:sizeZ)+b(3)*(1:sizeZ).^2+b(4)*(1:sizeZ).^3;
end

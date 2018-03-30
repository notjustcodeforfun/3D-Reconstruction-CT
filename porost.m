function poro = porost(img_bin)
% img_bin bin. image
[sizeX, sizeY, sizeZ] = size(img_bin);
poro = sum(sum(sum(img_bin==0)))/(sizeX*sizeY*sizeZ);
end
function img_out = volumenfilter(img_in,MinVol,n)
if nargin ==2
    n = 6;
end
cc = bwconncomp(img_in,n);
stats = regionprops3(cc, 'Volume');
idx = find([stats.Volume] > MinVol);
img_out = ismember(labelmatrix(cc), idx);

end
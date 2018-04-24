function img_out = bildvorverarbeitung(img_in,para)
%% ****************************************************************
% ----------------------- Bildvorverarbeitung  ------------------------------
% ***************************************************************************
fprintf('Bildvorverarbeitung ...\n');
sigma_gauss = 5;
gaussian1 = fspecial('Gaussian', 21, sigma_gauss);
gaussian2 = fspecial('Gaussian', 21, sigma_gauss*1.6);  %imgaussfilt
dog_filter = gaussian1-gaussian2;
img_temp = zeros(abs(para.x1-para.x2)+1,abs(para.y1-para.y2)+1,size(img_in,3));
fprintf('--------Bilddrehen und -beschneiden ...\n');
for i = 1:size(img_in,3)
    %------------------------ Bilddrehen und Bildbeschneiden
    if para.rot
        img_cut = imrotate(img_in(:,:,i), para.rot);
    else
        img_cut = img_in(:,:,i);
    end
    img_temp(:,:,i) = img_cut(para.x1:para.x2,para.y1:para.y2);
end

%------------------------ Beleuchtungseffektkorrektur
if para.SwitchBaSiC
    fprintf('--------Beleuchtungseffektkorrektur ...\n');
    % estimate flatfield and darkfield
    [flatfield, darkfield] = BaSiC(img_temp,'darkfield','true','lambda',2.0,'lambda_dark',2.0);
    basefluor =  BaSiC_basefluor(img_temp,flatfield,darkfield);
    % image correction
    img_out = zeros(size(img_temp));
    for i = 1:size(img_temp,3)
        img_out(:,:,i) = (double(img_temp(:,:,i))-darkfield)./flatfield - basefluor(i);
    end
else
    img_out = img_temp;
end
%------------------------ Difference of Gaussians filter
if para.switchDOG
    fprintf('--------Schaerfen ...\n');
    for i = 1:size(img_out,3)
        img_out(:,:,i) = imfilter(double(img_out(:,:,i)), dog_filter, 'replicate');
    end
end
img_out = uint8(img_out);
fprintf('Digitales Modell automatisch rekonstruieren ...\n');
end
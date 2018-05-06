function img_out = bildvorverarbeitung(img_in,para)
%%****************************************************************
% ----------------------- Bildvorverarbeitung  ------------------------------
% ***************************************************************************
fprintf('Bildvorverarbeitung ...\n');
gaussian1 = fspecial('Gaussian', 21, para.sigma_gauss);
gaussian2 = fspecial('Gaussian', 21, para.sigma_gauss*1.6);  %imgaussfilt
dog_filter = gaussian1-gaussian2;

%------------------------ Beleuchtungseffektkorrektur (BaSiC Tool)
if para.dataTyp
    fprintf('--------Beleuchtungseffektkorrektur ...\n');
    % estimate flatfield and darkfield
    [flatfield, darkfield] = BaSiC(img_in,'darkfield','true','lambda',2.0,'lambda_dark',2.0);
    basefluor =  BaSiC_basefluor(img_in,flatfield,darkfield);
    % image correction
    for i = 1:size(img_in,3)
        img_in(:,:,i) = (double(img_in(:,:,i))-darkfield)./flatfield - basefluor(i);
    end
end

%------------------------ Bilddrehen und Bildbeschneiden
if para.switchRotCut
    fprintf('--------Bilddrehen und -beschneiden ...\n');
    img_temp = uint8(zeros((para.x2-para.x1)+1,(para.y2-para.y1)+1,(para.z2-para.z1)+1));
    for i = para.z1:para.z2
        if para.rot
            img_cut = imrotate(img_in(:,:,i), para.rot);
        else
            img_cut = img_in(:,:,i);
        end
        img_temp(:,:,i) = img_cut(para.x1:para.x2,para.y1:para.y2);
    end
else
    img_temp = img_in;
end
img_out = img_temp;

%------------------------ Difference of Gaussians filter
if para.switchDOG
    fprintf('--------Schaerfen ...\n');
    for i = 1:size(img_out,3)
        img_out(:,:,i) = imfilter((img_out(:,:,i)), dog_filter, 'replicate');
    end
end
fprintf('Digitales Modell automatisch rekonstruieren ...\n');
end
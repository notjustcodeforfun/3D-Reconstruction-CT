function img_out = bildvorverarbeitung(img_in,para)
%%****************************************************************
% ----------------------- Bildvorverarbeitung  ------------------------------
% ***************************************************************************
fprintf('Bildvorverarbeitung ...\n');

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
    
    if para.switchResolution
        resolutionFaktor = 240/para.resolution;
        halfinterval = ceil((resolutionFaktor*(para.x2-para.x1+1))/2);                 %240 nm as standard resolution
        mid = round((para.x2+para.x1)/2);
        if (mid-halfinterval)<1
            x1 = 1;
            x2 = halfinterval*2;
        elseif mid+halfinterval>size(img_in,1)
            x2 = size(img_in,1);
            x1 = x2 - halfinterval*2+1;
        else
            x1 = mid-halfinterval;
            x2 = x1 + halfinterval*2-1;
        end
        
        halfinterval = ceil((resolutionFaktor*(para.y2-para.y1+1))/2);                 %240 nm as standard resolution
        mid = round((para.y2+para.y1)/2);
        if (mid-halfinterval)<1
            y1 = 1;
            y2 = halfinterval*2;
        elseif mid+halfinterval>size(img_in,1)
            y2 = size(img_in,1);
            y1 = y2 - halfinterval*2+1;
        else
            y1 = mid-halfinterval;
            y2 = y1 + halfinterval*2-1;
        end
        
        halfinterval = ceil((resolutionFaktor*(para.z2-para.z1+1))/2);                 %240 nm as standard resolution
        mid = round((para.z2+para.z1)/2);
        if (mid-halfinterval)<1
            z1 = 1;
            z2 = halfinterval*2;
        elseif mid+halfinterval>size(img_in,1)
            z2 = size(img_in,1);
            z1 = z2 - halfinterval*2+1;
        else
            z1 = mid-halfinterval;
            z2 = z1 + halfinterval*2-1;
        end
    else
        x1 = para.x1;
        x2 = para.x2;
        y1 = para.y1;
        y2 = para.y2;
        z1 = para.z1;
        z2 = para.z2;
    end
    
    if para.rot
        img_cut = imrotate3(img_in,para.rot,[0 0 1]);
        img_temp = img_cut(x1:x2,y1:y2,z1:z2);
    else
        img_temp = img_in(x1:x2,y1:y2,z1:z2);
    end
else
    img_temp = img_in;
end

if para.switchResolution
    [Xq,Yq,Zq] = meshgrid(linspace(1,x2-x1,para.x2-para.x1+1),linspace(1,y2-y1,para.y2-para.y1+1),linspace(1,z2-z1,para.z2-para.z1+1));
    img_out = uint8(interp3(double(img_temp),Xq,Yq,Zq));
else
    img_out = uint8(img_temp);
end

%------------------------ Difference of Gaussians filter
if para.switchDOG
    gaussian1 = fspecial('Gaussian', 21, para.sigma_gauss);
    gaussian2 = fspecial('Gaussian', 21, para.sigma_gauss*1.6);
    dog_filter = gaussian1-gaussian2;
    fprintf('--------DoG-Filter ...\n');
    for i = 1:size(img_out,3)
        img_out(:,:,i) = imfilter((img_out(:,:,i)), dog_filter, 'replicate');
    end
end

if para.switchGauss
    fprintf('--------Gaussfiltern ...\n');
    img_out = imgaussfilt3(img_out, 1.5);
end

fprintf('Digitales Modell automatisch rekonstruieren ...\n');
end
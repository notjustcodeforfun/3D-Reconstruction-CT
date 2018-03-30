function img_out = bildvorverarbeitung(img_in,para)
%% ****************************************************************
% ----------------------- Bildvorverarbeitung  ------------------------------
% ***************************************************************************
fprintf('Bildvorverarbeitung ...\n');
%------------------------ Bild neu aufbauen, Rechenaufwand zu reduzieren
if para.dataTyp
    [xpixel,ypixel,zpixel] = size(img_in);
    img_out =img_in(1:round((xpixel-1)*para.por),1:round((ypixel-1)*para.por),1:round((zpixel-1)*para.por));
else
    img_out = img_in(1:1024,1:1024,:);
    sigma_gauss = 5;
    gaussian1 = fspecial('Gaussian', 21, sigma_gauss);
    gaussian2 = fspecial('Gaussian', 21, sigma_gauss*1.6);
    dog_filter = gaussian1-gaussian2;
    for i = 1:size(img_out,3)
        img_out(:,:,i) = conv2(double(img_out(:,:,i)), dog_filter, 'same');
    end
end
img_out = uint8(img_out);

% Adjust histogram of 3-D image to match histogram of reference image
% img_out = imhistmatchn(uint8(img_out),uint8(img_out(:,:,end)));

end

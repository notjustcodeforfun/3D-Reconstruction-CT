function out = porverteil(img_in,para)
% element of img_out is the pore size in corresponding position
% img_in must be binar image stack.
img_pore = ~img_in;

hist = double(img_pore);
poratio_temp = 1;
% poratio_temp_vor = 1;
r = 1;
Posum = sum(sum(sum(img_pore == 1)));
% i = 1;
while poratio_temp > 0.01 && Posum>0
    se = strel('cube',r);
%     poratio_r(i) = r;
    img_temp = double(imopen(img_pore,se))*r;
    hist(img_temp>hist) = r;
    poratio_temp = (sum(sum(sum(img_temp>0))))/Posum;
%     poratio(i) = -(poratio_temp-poratio_temp_vor);
%     poratio_temp_vor = poratio_temp;
%     if max(poratio)>(1-sum(poratio))
%         break
%     elseif (2*r+1)*para.resolution_ref>8||Posum == 0   %9um
%         clear poratio hist poratio_r
%         hist = false;
%         poratio = false;
%         poratio_r = false;
%         break
%     end
    r = r+1;
%     i = i+1;
end
% out.poratio_r = poratio_r;
out = hist*para.resolution_ref;
% out.poratio = poratio;

end

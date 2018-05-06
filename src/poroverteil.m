function out = poroverteil(img_in)
% element of img_out is the pore size in corresponding position
% img_in must be binar image stack.
img_pore = ~img_in;
hist = zeros(size(img_in));
poratio_temp = 1;
poratio_temp_vor = 1;
r = 1;
Posum = sum(sum(sum(img_pore == 1)));
while poratio_temp > 0.05
    se = strel('sphere',r);
    img_temp = imopen(img_pore,se)*(r*2+1);
    hist(img_temp>hist) = (r*2+1);
    poratio_temp = (sum(sum(sum(img_temp>0))))/Posum;
    poratio(r) = -(poratio_temp-poratio_temp_vor);
    poratio_temp_vor = poratio_temp;
    r = r+1;
end
out.hist = hist;
out.poratio = poratio;

end

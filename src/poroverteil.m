function img_out = poroverteil(img_in)
% element of img_out is the pore size in corresponding position
% img_in must be binar image stack.
img_pore = ~img_in;
img_out = zeros(size(img_in));
poratio = 1;
r = 1;
Posum = sum(sum(sum(img_pore == 1)));

while poratio > 0.05
    se = strel('sphere',r);
    img_temp = imopen(img_pore,se)*r;
    img_out(img_temp>img_out) = r;
    poratio = (sum(sum(sum(img_temp>0))))/Posum;
    r = r+1;
end

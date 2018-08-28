function [DoH] = imDoH(Gxx,Gyy, Gxy)
% [DoH] = imDoH(Gxx,Gyy, Gxy)
% [DoH] = imDoH(I)
% 

if nargin == 1
    I = Gxx;
    [Gxx, Gyy, Gxy] = imhessian(I);
end

DoH = Gxx.*Gyy - Gxy.^2;
DoH = (DoH-min(DoH(:)))./max(DoH(:));
    
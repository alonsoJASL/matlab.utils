function [Lmax, Lmin] = imeigenhessian(Gxx, Gyy, Gxy)
% [Lmax, Lmin] = imeigenhessian(Gxx, Gyy, Gxy)
% [Lmax, Lmin] = imeigenhessian(I)
%

if nargin == 1
    I=Gxx;
    [Gxx, Gyy, Gxy] = imhessian(I);
end

Lmax = (Gxx+Gyy+sqrt(Gxx.^2+Gyy.^2-2.*(Gxx.*Gyy)+4.*(Gxy.^2)));
if nargout > 1
    Lmin = (Gxx+Gyy-sqrt(Gxx.^2+Gyy.^2-2.*(Gxx.*Gyy)+4.*(Gxy.^2)));
end
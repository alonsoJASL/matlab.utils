function [boolNearValue] = near(vector, testValue, tol)
%

if nargin < 3
    tol = 1e-10;
end

boolNearValue = (abs(vector-testValue) <= tol);


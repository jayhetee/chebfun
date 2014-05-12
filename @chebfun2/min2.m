function [Y, X] = min2( f )
%MIN2   Global minimum of a CHEBFUN2. 
%   Y = MIN2(F) returns the global minium of F.
% 
%   [Y, X] = MIN2(F) returns the global minimum of F and its coordinates in X =
%   (X(1), X(2)).
%
% For certain problems this problem can be slow if the MATLAB Optimization
% Toolbox is not available.
%
% See also MAX2, MINANDMAX2.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Call MINANDMAX2():
[Y, X] = minandmax2(f);

% Extract out minimum:
Y = Y(1); 
X = X(1,:);  

end

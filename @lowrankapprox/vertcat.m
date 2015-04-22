function F = vertcat(varargin)
%VERTCAT   Vertical concatenation of LOWRANKAPPROX objects.
%
% VERTCAT(F, G) is the vertical concatenation of LOWRANKAPPROX objects F and G. 
% This function returns a CHEBFUN2V object. 
% 
% [F; G] is equivalent to VERTCAT(F, G).
%
% VERTCAT(F) returns the LOWRANKAPPROX F. 
% 
% See also CHEBFUN2V.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if ( nargin == 1 ) 
    % VERTCAT of one argument just returns the same thing back to the user:
    F = varargin{1}; 
elseif ( nargin > 1 )
    if ( isa(varargin{2}, 'chebfun2v') )
        f = varargin{1}; 
        F = varargin{2}; 
        if ( F.nComponents > 2 ) 
            error('CHEBFUN:LOWRANKAPPROX:vertcat:tooManyComponents', ...
                'Only CHEBFUN2V objects with 2 or 3 components are valid.');
        else
            Fc = F.components; 
            g = Fc{1};
            h = Fc{2};
            F = chebfun2v({f, g, h});
        end
    elseif ( isa(varargin{ 2 }, 'LOWRANKAPPROX' ) )
        % call the CHEBFUN2V constructor.
        F = chebfun2v( varargin{:} );
    end
else
    error('CHEBFUN:LOWRANKAPPROX:vertcat:tooManyInputs', ...
        'Cannot vertically concatenate more than three LOWRANKAPPROX objects.');
end
    
end
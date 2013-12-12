function varargout = matrix(disc,dimension,domain)
%  Copyright 2013 by The University of Oxford and The Chebfun Developers.
%  See http://www.chebfun.org for Chebfun information.
% TODO: error checking on inputs
if ( nargin > 1 )
    disc.dimension = dimension;
    if ( nargin > 2 )
        disc.domain = domain;
    end
end

A = disc.source;
%            validate(disc);
if ( isa(A, 'chebmatrix') )
    c = disc.coeffs;
    outputSpaces = disc.outputSpace;
    L = cell(size(A));
    S = cell(size(A));
    for j = 1:size(A, 1)
        disc.outputSpace = outputSpaces(j);
        for k = 1:size(A, 2)
            disc.coeffs = c{j,k};
            [L{j,k}, S{j,k}] = blockDiscretize(disc, A.blocks{j,k});
        end
    end
    out{1} = L;
    if ( isa(A,'linop') )
        [out{1:3}] = useConstraints(disc,L);
        out{2} = out{2}*cell2mat(S);
    end
    varargout{1} = L;
    m = max(1,nargout);
    varargout(1:m) = out(1:m);    
else
    disc.coeffs = disc.coeffs{1};
    [varargout{1:nargout}] = blockDiscretize(disc, A);
end
end
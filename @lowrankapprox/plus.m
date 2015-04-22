function h = plus(f, g)
%+   Plus for LOWRANKAPPROX objects.
%
% F + G adds F and G. F and G can be scalars or LOWRANKAPPROX objects.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if ( ~isa(f, 'lowrankapprox') ) % ??? + LOWRANKAPPROX
    
    h = plus(g, f);
    
elseif ( isempty(g) ) % LOWRANKAPPROX + []
    
    h = g; 
    
elseif ( isempty(f) ) % [] + LOWRANKAPPROX
    
    h = f; 
    
elseif ( isa( g, 'double' ) )           % LOWRANKAPPROX + DOUBLE
    
    g = compose( 0*f,@plus, g);   % promote double to object class.  
    h = plus(f, g); 
    
elseif ( ~isa(g, 'lowrankapprox') )          % LOWRANKAPPROX + ???
    
    error( 'CHEBFUN:LOWRANKAPPROX:plus:unknown', ...
        ['Undefined function ''plus'' for input arguments of type %s ' ...
        'and %s.'], class(f), class(g));
    
else                                     % LOWRANKAPPROX + LOWRANKAPPROX
    
    % Domain Check:
    if ( ~domainCheck(f, g) )
        error('CHEBFUN:LOWRANKAPPROX:plus:domain', 'Inconsistent domains.');
    end
    
    % Check for zero LOWRANKAPPROX objects:
    if ( iszero(f) )
        h = g;
    elseif ( iszero(g) )
        h = f;
    else
        % Add together two nonzero LOWRANKAPPROX objects:
        h = compression_plus(f, g);

    end 
    
end

end

function h = compression_plus(f, g)
% Add CHEBFUN2 objects together by a compression algorithm.

% The algorithm is as follows:
% If A = XY^T and B = WZ^T, then A + B = [X W]*[Y Z]^T,
% [Qleft, Rleft] = qr([X W])
% [Qright, Rright] = qr([Y Z])
% A + B = Qleft * (Rleft * Rright') * Qright'
% [U, S, V] = svd( Rleft * Rright' )
% A + B = (Qleft * U) * S * (V' * Qright')     -> new low rank representation

% Hack: Ensure g has the smaller pivot values.
if ( norm(f.pivotValues, -inf) < norm(g.pivotValues, -inf) )
    % [TODO]: Understand why this works!
    h = compression_plus(g, f);
    return
end

fScl = diag(1./f.pivotValues);
gScl = diag(1./g.pivotValues);
cols = [f.cols, g.cols];
rows = [f.rows, g.rows];

[Qcols, Rcols] = qr(cols);
[Qrows, Rrows] = qr(rows);

Z = zeros(length(fScl), length(gScl));
D = [ fScl, Z ; Z.', gScl ];
[U, S, V] = svd(Rcols * D * Rrows.');
% If V is complex-valued, then conjugate: 
V = conj( V ); 
% Take diagonal from SIGMA:
s = diag(S);

% Compress the format if possible.
% [TODO]: What should EPS be in the tolerance check below? Can we base it on
% EPSLEVELS?
vf = vscale(f); 
vg = vscale(g);
vscl = max(vf, vg); 
% Remove singular values that fall below eps*vscale: 
idx = find( s > eps * vscl, 1, 'last');
if ( isempty(idx) )
    % return 0 chebfun2
    h = chebfun2(0, f.domain);
else
    U = U(:,1:idx);
    V = V(:,1:idx);
    s = s(1:idx);
    h = f;
    h.cols = Qcols * U;
    h.rows = Qrows * V;
    % [TODO]: PivotValues have very little meaning after this compression step.
    % For now we assign the singular values as the pivot values. 
    h.pivotValues = 1./s;
end

end
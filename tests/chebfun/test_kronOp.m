function pass = test_kronOp(pref) 
% Test the chebfun/kron() command, resulting in OPERATORBLOCK objects. 

if ( nargin < 1 ) 
    pref = chebfunpref(); 
end 

tol = 200*pref.eps; 
d = [0,1];
x = chebfun(@(x) x, d); 
xx1 = chebpts(200, d, 1);
xx2 = chebpts(200, d, 2);
xxe = trigpts(200, d);
%% Simple outer product, only single column CHEBFUNs involved
f = sin(x);
g = tanh(x);
h = cos(x);
A = kron(f, g', 'op');
Ah = f * (g'*h);
AC = chebmatrix(A);
% Operational form
pass(1) = norm(Ah - A*h) < tol;
% Discrete form
pass(2) = norm(Ah(xx1) - matrix(AC, 200, @chebcolloc1)*h(xx1)) < tol;
pass(3) = norm(Ah(xx2) - matrix(AC, 200, @chebcolloc2)*h(xx2)) < tol;
%% Single column CHEBFUNs, periodic to test trigcolloc as well
f = exp(sin(4*pi*x));
g = tanh(.5*cos(2*pi*x));
h = cos(2*pi*x);
A = kron(f, g', 'op');
Ah = f * (g'*h);
AC = chebmatrix(A);
% Operational form
pass(4) = norm(Ah - A*h) < tol;
% Discrete form
pass(5) = norm(Ah(xx1) - matrix(AC, 200, @chebcolloc1)*h(xx1)) < tol;
pass(6) = norm(Ah(xx2) - matrix(AC, 200, @chebcolloc2)*h(xx2)) < tol;
pass(7) = norm(Ah(xxe) - matrix(AC, 200, @trigcolloc)*h(xxe)) < tol;
%% Multiple columns/rows (taken from v4 test)
f = [ exp(x), tanh(x) ];
g = [ exp(x), x./(1+x.^2) ];
u = x;

A = kron(f,g','op');
AC = chebmatrix(A);
Au = (exp(x) + (1-pi/4)*tanh(x));

% Operational form
pass(8) = norm( Au - A*u ) < tol;
% Discrete form
pass(9)  = norm( Au(xx1) - matrix(AC, 200, @chebcolloc1)*u(xx1) ) < tol;
pass(10) = norm( Au(xx2) - matrix(AC, 200, @chebcolloc2)*u(xx2) ) < tol;

end
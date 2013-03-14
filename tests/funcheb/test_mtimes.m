% Test file for funcheb/mtimes.

function pass = test_mtimes(pref)

% Get preferences.
if ( nargin < 1 )
    pref = funcheb.pref;
end

% Generate a few random points to use as test values.
rngstate = rng();
rng(6178);
x = 2 * rand(100, 1) - 1;

% A random number to use as an arbitrary scalar multiplier.
alpha = randn() + 1i*randn();

for ( n = 1:2 )
    if ( n == 1 )
        testclass = funcheb1();
    else 
        testclass = funcheb2();
    end

    %%
    % Check operation in the face of empty arguments.
    
    f = testclass.make(@(x) sin(x), pref);
    g = testclass.make();
    pass(n, 1) = isempty(f*[]) && isempty([]*f) && isempty(2*g) && isempty(g*2);
    
    %%
    % Check operation for scalar funcheb objects.
    
    f = testclass.make(@(x) sin(x), pref);
    g1 = alpha*f;
    g2 = f*alpha;
    pass(n, 2) = isequal(g1, g2);
    g_exact = @(x) alpha*sin(x);
    pass(n, 3) = norm(feval(g1, x) - g_exact(x), 'inf') < 10*g1.epslevel;
    
    g = 0*f;
    pass(n, 4) = all(g.values == 0) && all(g.coeffs == 0);
    
    %%
    % Check operation for vectorized funcheb objects.
    
    f = testclass.make(@(x) [sin(x) cos(x) exp(x)], pref);
    g1 = alpha*f;
    g2 = f*alpha;
    pass(n, 5) = isequal(g1, g2);
    g_exact = @(x) alpha*[sin(x) cos(x) exp(x)];
    err = abs(feval(g1, x) - g_exact(x));
    pass(n, 6) = max(err(:)) < 10*g1.epslevel;
    
    g = 0*f;
    pass(n, 7) = all(g.values == 0) && all(g.coeffs == 0);
    
    A = randn(3, 3);
    g = f*A;
    g_exact = @(x) [sin(x) cos(x) exp(x)]*A;
    err = abs(feval(g, x) - g_exact(x));
    pass(n, 8) = max(err(:)) < 10*g.epslevel;
    
    %%
    % Verify error handling and corner cases.
    
    % Multiply non-scalar double and funcheb.
    try
        f = testclass.make(@(x) exp(x));
        disp([1 2 3]*f)
    catch ME
        pass(n, 9) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB:mtimes:size') ...
            && strcmp(ME.message, 'Inner matrix dimensions must agree.');
    end
    
    % Multiply funcheb and non-sclar double with mismatching dimensions.
    try
        f = testclass.make(@(x) [sin(x) cos(x)]);
        disp(f*[1 ; 2 ; 3]);
        pass(n, 10) = false;
    catch ME
        pass(n, 10) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB:mtimes:size2') ...
            && strcmp(ME.message, 'Inner matrix dimensions must agree.');
    end
    
    % Using * for multiplication of two funcheb objects.
    try
        g = testclass.make(@(x) x);
        disp(f*g);
        pass(n, 11) = false;
    catch ME
        pass(n, 11) = strcmp(ME.message, 'Use .* to multiply FUNCHEB objects.');
    end
    
    % Using * to multiply a funcheb and something else.
    try
        disp(f*uint8(128));
        pass(n, 12) = false;
    catch ME
        pass(n, 12) = strcmp(ME.message, ...
            'mtimes does not know how to multiply a FUNCHEB and a uint8.');
    end
end

%%
% Restore the RNG state.

rng(rngstate);

end

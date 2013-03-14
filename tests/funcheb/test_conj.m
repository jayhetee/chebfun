function pass = test_conj(pref)

if ( nargin < 1 )
    pref = funcheb.pref;
end

for ( n = 1:2 )
    if (n == 1)
        testclass = funcheb1();
    else 
        testclass = funcheb2();
    end

    tol = 10*pref.funcheb.eps;
    
    % Test a scalar-valued function:
    f = testclass.make(@(x) cos(x) + 1i*sin(x), 0, pref);
    g = testclass.make(@(x) cos(x) - 1i*sin(x), 0, pref);
    h = conj(f);
    pass(n, 1) = norm(h.values - g.values, inf) < tol;
    
    % Test a multi-valued function:
    f = testclass.make(@(x) [cos(x) + 1i*sin(x), -exp(1i*x)], 0, pref);
    g = testclass.make(@(x) cos(x) - 1i*sin(x), 0, pref);
    h = conj(f);
    pass(n, 2) = norm(h.values - [g.values, -(g.values)], inf) < tol;
end

end
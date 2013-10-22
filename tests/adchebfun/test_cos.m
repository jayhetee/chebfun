% Test file for adchebfun/sin

function pass = test_cos

% Call the taylorTesting method
[order1, order2] = taylorTesting(@cos,7);

% We expect all elements of ORDER1 to be close to 1, and of ORDER2 to be close
% to 2.
pass = ( max(abs(order1-1)) < .01 ) & ( max(abs(order2-2)) < .01 );

end


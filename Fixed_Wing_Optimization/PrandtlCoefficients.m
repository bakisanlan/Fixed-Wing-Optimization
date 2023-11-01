%Returns derivative of Fourier Coefficients w.r.t AoA in Prandtl Lifting Line Theory
function B = PrandtlCoefficients(b,cr,lambda,aerofoilParams,n)

beta = linspace(0,pi/2,n+1)';
beta = beta(2:end);
y = b*cos(beta);
c = (lambda-1)*cr*y/b+cr;

N = 1:2:2*n-1;

M = 8*b*sin(N.*beta)./(c*aerofoilParams.ClAlpha)+N.*sin(N.*beta)./sin(beta);

B = M\ones(n,1);
end
%Copyright 2022 The MathWorks, Inc.

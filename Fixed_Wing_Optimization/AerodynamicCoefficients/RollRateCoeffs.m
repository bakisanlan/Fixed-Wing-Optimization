%Compute roll rate derivative coefficients
function coeffs = RollRateCoeffs(xv, zv, bh, b, Sh, Sv, S, aircraft_Cd0, VTail_CFBeta, CYBeta)

% Tail moment arm
zvs = cosd(5)*zv - sind(5)*xv;
xvs = cosd(5)*xv + sind(5)*zv;

% Roll Rate Derivatives
CYp = -2*VTail_CFBeta*zvs/b*Sv/S;

% compute ClP
% assume angle of attack of 5 deg - better approach is to use Lookup Table
Clpw = -0.51-0.125*aircraft_Cd0;
Clph = -0.336*(Sh/S)*(bh/b)^2;
Clpv = 2/b^2*zvs*(zvs-zv)*CYBeta;           % CYBetav = CYBeta as wing contribution is small
Clp = Clpw + Clph + Clpv;

Cnp = 2*VTail_CFBeta*zvs/b*xvs/b*Sv/S;      % ignore wing contribution as it is small

coeffs = [CYp Clp Cnp];
%Copyright 2022 The MathWorks, Inc.

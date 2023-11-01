%Compute sideslip angle derivative coefficients
function coeffs = BetaCoeffs(Sh, Sv, S, bh, b, xv, zv, VTail_CFBeta, Wing_ClAlpha, HTail_ClAlpha, CL0)

% Sideslip Angle Derivatives
CYBeta = VTail_CFBeta*Sv/S;
CnBeta = VTail_CFBeta*Sv*xv/(S*b);

% compute wing CL
CLw = CL0+(Wing_ClAlpha-Sh*bh/(S*b)*HTail_ClAlpha)*deg2rad(5);

% compute ClBeta
% assume angle of attack of 5 deg - better approach is to use Lookup Table
zvs = cosd(5)*zv - sind(5)*xv;
Clbwf = -57.3*0.001*CLw;                                    % wing-fuselage contribution
Clbh = -57.3*0.001*(HTail_ClAlpha*deg2rad(5))*Sh*bh/(S*b);  % horizontal tail contribution
Clbv = -VTail_CFBeta*Sv*zvs/(S*b);                          % vertical tail contribution
ClBeta = Clbwf + Clbh + Clbv;

coeffs = [CYBeta ClBeta CnBeta];
%Copyright 2022 The MathWorks, Inc.

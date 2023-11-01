%Compute yaw rate derivative coefficients
function coeffs = YawRateCoeffs(xv, zv, bh, b, Sh, Sv, S, HTail_ClAlpha, VTail_CFBeta, CL0, CYBeta, ...
                                Wing_ClAlpha, Wing_TaperRatio, Wing_Cd0)

% Tail moment arm
zvs = cosd(5)*zv - sind(5)*xv;
xvs = cosd(5)*xv + sind(5)*zv;

% compute wing CL
CLw = CL0 + (Wing_ClAlpha-Sh*bh/(S*b)*HTail_ClAlpha)*deg2rad(5);

% Yaw Rate Derivatives
CYr = VTail_CFBeta*(2*xvs/b)*Sv/S;

% compute Clr
Clrw = CLw*(0.16 + 0.09*Wing_TaperRatio);
Clrv = -2/b^2*xvs*zvs*CYBeta;               % CYBetav = CYBeta as wing contribution is small
Clr = Clrw + Clrv;

% compute Cnr
Cnrw = -0.03*CLw^2 - 0.35*Wing_Cd0;         % numbers taken from tables and approximate for this design
Cnrv = 2/b^2*xv^2*CYBeta;                   % CYBetav = CYBeta as wing contribution is small
Cnr = Cnrw + Cnrv;

coeffs = [CYr Clr Cnr];
%Copyright 2022 The MathWorks, Inc.

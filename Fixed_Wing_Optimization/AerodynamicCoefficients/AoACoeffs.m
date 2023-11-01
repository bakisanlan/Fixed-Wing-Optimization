%Compute angle of attack derivative coefficients
function coeffs = AoACoeffs(aircraft_ClAlpha, Wing_AspectRatio, Wing_K, Wing_MeanChord, ...
                            aircraft_Xcg, aircraft_NeutralPoint, CL0)

CL = CL0 + deg2rad(5)*aircraft_ClAlpha;
% Angle of Attack Derivatives
e = 1/(1+Wing_K);
CDAlpha = 2/(pi*Wing_AspectRatio*e)*aircraft_ClAlpha*CL;

CMAlpha = aircraft_ClAlpha*(aircraft_Xcg-aircraft_NeutralPoint)/Wing_MeanChord;

coeffs = [CDAlpha aircraft_ClAlpha CMAlpha];
%Copyright 2022 The MathWorks, Inc.

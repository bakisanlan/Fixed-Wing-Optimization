%Compute pitch rate derivative coefficients
function coeffs = PitchRateCoeffs(HTail_ClAlpha, HTail_Xac, Wing_MeanChord, aircraft_Xcg, Sh, S)

% Volumetric factor tail to wing
Vbarh = Sh/S*(HTail_Xac-aircraft_Xcg)/Wing_MeanChord;

% Pitch Rate Derivatives
CLq = 2*HTail_ClAlpha*Vbarh;
CMq = -2.2*HTail_ClAlpha*Vbarh*(HTail_Xac - aircraft_Xcg)/Wing_MeanChord;

coeffs = [0 CLq CMq];
%Copyright 2022 The MathWorks, Inc.

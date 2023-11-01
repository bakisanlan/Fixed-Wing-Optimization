%Compute zero-lift derivative coefficients
function coeffs = ZeroLiftCoeffs(Wing_ClAlpha, Wing_Aerofoil, Wing_MeanChord, aircraft_Cd0, ...
                                 aircraft_Xcg, aircraft_NeutralPoint)

CL0 = -Wing_Aerofoil.Alpha0L*Wing_ClAlpha;
CM0 = CL0*(aircraft_Xcg-aircraft_NeutralPoint)/Wing_MeanChord;

coeffs = [aircraft_Cd0 CL0 CM0];
%Copyright 2022 The MathWorks, Inc.

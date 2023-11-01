%Compute angle of attack rate derivative coefficients
function coeffs = AoARateCoeffs(AR, Wing_TaperRatio, Wing_MeanChord, S, b,...
                                Sh, HTail_ClAlpha, HTail_Xac, aircraft_Xcg)

% Angle of Attack Rate Derivatives

% Volumetric Factor Horizontal Tail to Wing
Vbarh = Sh/S*(HTail_Xac-aircraft_Xcg)/Wing_MeanChord;

% compute downwash gradient of horizontal tail
KA = 1/AR - 1/(1+AR^1.7);
Kl = (10 - 3*Wing_TaperRatio)/7;
Kh = 1/(2*HTail_Xac/b);

downwashGradient = 4.44*KA*Kl*Kh;

CLAlphaDot = 2*HTail_ClAlpha*Vbarh*downwashGradient;
CMAlphaDot = -CLAlphaDot*(HTail_Xac - aircraft_Xcg)/Wing_MeanChord;

coeffs = [0 CLAlphaDot CMAlphaDot];
%Copyright 2022 The MathWorks, Inc.

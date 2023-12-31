%Model and add aerodynamic coefficients and constraints to the optimization problem.
function [aircraft, wing, fuselage, hTail, vTail, designprob] = ...
        addAerodynamics(aircraft, wing,payload , fuselage, hTail, vTail, designprob)
%% Wing Aerodynamics
%Use Prandtl lifing-line theory to estimate the wing's lift and drag 
% coefficients. This theory is valid for wings of high enough aspect ratio,
% and so requires some additional constraints.
numcoeff = 10;
B = fcn2optimexpr(@PrandtlCoefficients,wing.HalfSpan,...
    wing.RootChord,wing.TaperRatio,wing.Airfoil, ...
    numcoeff,'OutputSize',[numcoeff,1],'ReuseEvaluation',true);             % Prandtl Lifting Line Coefficients
wing.ClAlpha = B(1)*pi*wing.AspectRatio;                                    % Lift Slope
wing.Cd0 = wing.Airfoil.Cd0;                                                % Parasitic Drag
wing.K = (1:2:2*numcoeff-1)*(B./B(1)).^2 ...
                /(pi*wing.AspectRatio);                                     % Induced Drag               
wing.K = wing.K+wing.Airfoil.K;                                             % Lift Dependent Drag

%Introduce an aspect ratio constraint for validity of Prandtl lifting-line
% theory. Put upper bound on aspect ratio for structural strength.
designprob.Constraints.WingAR = wing.AspectRatio>=6;
designprob.Constraints.HTailAR = wing.AspectRatio<=12;

%Aerodynamic Effect of Wing on Horizontal Tail
%Add the effect of downwash from the wing to the horizontal tail, which reduces its efficiency.
hTail.Efficiency = 1;                                                       % Horizontal Tail Dynamic Pressure Ratio
hTail.Downwash = 2/(2+wing.AspectRatio);                                    % Horizontal Tail Downwash gradient

%% Horizontal Tail Aerodynamics
%Use Prandtl lifing-line theory to estimate the horizontal tail's lift and 
% drag coefficients. 
numcoeff = 10;
B = fcn2optimexpr(@PrandtlCoefficients,hTail.HalfSpan,...
    hTail.Chord,1,hTail.Airfoil, numcoeff,...
    'OutputSize',[numcoeff,1],'ReuseEvaluation',true);                      % Prandtl lifting-line Coefficients
hTail.ClAlpha = B(1)*pi*hTail.AspectRatio;                                  % Lift Slope
hTail.Cd0 = hTail.Airfoil.Cd0;                                              % Parastic Drag

%Introduce an aspect ratio constraint for validity of Prandtl lifting-line 
% theory. Put upper bound on aspect ratio for structural strength.
designprob.Constraints.HTailAR = hTail.AspectRatio>=4;
designprob.Constraints.HTailAR = hTail.AspectRatio<=8;

%% Vertical Tail Aerodynamics
%Use Prandtl lifing-line theory to estimate the vertical tail's lift and 
% drag coefficients. 
numcoeff = 10;
B = fcn2optimexpr(@PrandtlCoefficients,vTail.HalfSpan/2,...
    vTail.Chord,1,vTail.Airfoil, numcoeff,...
    'OutputSize',[numcoeff,1],'ReuseEvaluation',true);                      % Prandtl lifting-line Coefficients
vTail.CFBeta = B(1)*pi*vTail.AspectRatio;                                   % Side Force Slope
vTail.Cd0 = vTail.Airfoil.Cd0;                                              % Parastic Drag

%Unlike for the wing, the vertical tail often has a lower aspect ratio, 
% resulting in the underestimation of the tail's lift induced drag. Put 
% upper bound on aspect ratio for structural strength.
designprob.Constraints.VTailAR = vTail.AspectRatio>=3;
designprob.Constraints.HTailAR = vTail.AspectRatio<=6;

%% Fuselage Aerodynamics
%Estimate the fuselage drag by approximating it to be equal to the skin 
% friction drag. Ignore interference and other harder to model phenomena.
% The turbulent flat-plate skin friction drag coefficient is based on 
% numerical data for existing subsonic aircraft.


Cf = (3.46*log10(aircraft.RePerLength*fuselage.Length)-5.6)^(-2);           % Skin Friction Coefficient
cs1 = -0.825885*(2*fuselage.CornerRadius/fuselage.SideLength)^0.411795 + 4.0001;
cs2 = -0.340977*(2*fuselage.CornerRadius/fuselage.SideLength)^7.54327 - 2.2792;
cs3 = -0.013846*(2*fuselage.CornerRadius/fuselage.SideLength)^1.34253 + 1.11029;
FF = cs1*(fuselage.Fineness)^cs2 + cs3;                                     % Form Factor
fuselage.Cd = Cf*FF*fuselage.WettedArea/aircraft.ReferenceArea;             % Skin Friction Drag

Cfp = (3.46*log10(aircraft.RePerLength*payload.Boxed.Length)-5.6)^(-2);     % Skin Friction Coefficient
cs1p =  4.0001;
cs2p = -2.2792;
cs3p = 1.11029;
FFp = cs1p*(payload.Fineness)^cs2p + cs3p;                                     % Form Factor
payload.Cd = Cfp*FFp*payload.WettedArea/aircraft.ReferenceArea;               % Skin Friction Drag

%% Whole Aircraft Aerodynamics
aircraft.Cd0 = wing.Cd0 + fuselage.Cd + payload.Cd...
    +hTail.Cd0*hTail.Efficiency*(hTail.PlanformArea/aircraft.ReferenceArea)...
    +vTail.Cd0*(vTail.PlanformArea/aircraft.ReferenceArea);                 % Parastic Drag
aircraft.K = wing.K;                                                        % Lift Dependent Drag
aircraft.ClAlpha = wing.ClAlpha;                                            % Lift Slope
aircraft.ClMax = aircraft.ClAlpha*aircraft.StallAoA;                        % Max Lift
end

%Copyright 2022 The MathWorks, Inc.

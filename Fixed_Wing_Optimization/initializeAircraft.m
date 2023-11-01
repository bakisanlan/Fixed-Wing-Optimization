%Initialize structures for storing aircraft parameters.
function [aircraft, wing, fuselage, hTail, vTail, payload, initialValues] = initializeAircraft
%% Wing Parameters
%For the wing, choose a cambered high lift airfoil.
wing.Airfoil.Name = 'Selig 1223';                                      % Airfoil Name
wing.Airfoil.ClAlpha = 0.145*180/pi;                                   % Airfoil Lift Slope [per deg]
wing.Airfoil.Cd0 = 0.04;                                               % Airfoil Zero Lift Drag Coefficient
wing.Airfoil.Cl0 = 1.2;                                                % Airfoil Lift at 0 AoA
wing.Airfoil.Alpha0L = -5*pi/180;                                      % Airfoil Zero Lift AoA
wing.Airfoil.K = 0;                                                    % Airfoil Parasitic Drag efficiency 
wing.Airfoil.StallAoA = 15*pi/180;                                     % Airfoil Aerodynamic Stall Angle of Attack [deg]
%Assume the wing has a constant area density. This assumption simplifies the computation but favors a shorter wingspan.
wing.Density = 1.5;                                                    % Mass per unit area [kg/m^2]
wing.HalfSpan = optimvar('b_w','LowerBound',0,'UpperBound',1.5);       % Half Span [m]
initialValues.b_w = 0.8;                                               % Half Span Initial Value [m]
wing.RootChord = optimvar('cr_w','LowerBound',0);                      % Root Chord [m]
initialValues.cr_w = 0.2;                                              % Root Chord Initial Value [m]
wing.TaperRatio = optimvar('lambda_w','LowerBound',0,'UpperBound',1);  % Taper Ratio
initialValues.lambda_w = 0.99;                                         % Taper Ratio Initial Value
wing.MeanChord = (1+wing.TaperRatio)...
    *wing.RootChord/2;                                                 % Mean Chord [m]
wing.AspectRatio = 2*wing.HalfSpan/wing.MeanChord;                     % Aspect Ratio
wing.PlanformArea = (1+wing.TaperRatio)...
    *wing.RootChord*wing.HalfSpan;                                     % Planform Area [m^2]
wing.XLoc = optimvar('X_w','LowerBound', 0.15);                        % Placement Location in X-dir [m]
initialValues.X_w = 0.31;                                              % X Location Initial Value [m]
wing.Xac = wing.XLoc+0.25*wing.RootChord;                              % Aerodynamic Center [m]
%% Payload Parameters
aircraft.Avionics.Mass = 1.5;                                          % Weight of Electronics [kg]
aircraft.Avionics.Xcg = 0.05;                                          % CG Location of Electronics [m]
aircraft.Avionics.Length = 0.25;                                       % Length of fuselage occupied by Electronics [m]
% payload.Spherical.Mass = 0.625;                                      % Mass of spherical payload [kg]
% payload.Spherical.Diameter = 0.22;                                   % Radius of spherical payload [m]
payload.Boxed.Length = 0.5;                                            % Length of boxed payload [m]
% initialValues.l_pb = 0.01;                                           % Length of boxed payload Initial Value [m]
payload.Boxed.Height = 0.1;                                            % Height of boxed payload [m]
payload.Boxed.SideLengt = 0.1;                                         % Side Lenght of boxed payload [m]
payload.Boxed.PayLoadHeight = ...
    optimvar('h_pb','LowerBound',0,'UpperBound',payload.Boxed.Height); % Height of boxed payload [m]
initialValues.h_pb = 0.03;                                             % Height of boxed payload Initial Value [m]
payload.Boxed.SandDensity = 2000;                                      % Density of boxed payload [kg/m^3]
payload.XLoc = optimvar('X_p','LowerBound',0.25);                      % Start Location of cargo bay [m]
initialValues.X_p = 0.4;                                               % Start Location Initial Value [m]
payload.Boxed.EmptyMass = 0.2;                                         % Empty box mass [kg]
payload.Fineness = payload.Boxed.Length...
    /sqrt(4/pi*payload.Boxed.SideLength^2);                            % Fineness Ratio
payload.WettedArea = payload.Boxed.Length*payload.Boxed.SideLength...
    *2*payload.Boxed.Length*payload.Boxed.Height;                      % Wetted/Surface Area [m^2]
%% Fuselage Parameters
fuselage.SideLength = 0.23;                                            % Side Length of Square Fuselage Cross-section [m]
fuselage.Length = optimvar('l_f','LowerBound',0);                      % Length of Fuselage [m]
initialValues.l_f = 0.75;                                              % Length Initial value [m]
fuselage.LengthBody = optimvar('l_body','LowerBound',0); 
initialValues.l_body = 0.50; 
fuselage.Fineness = fuselage.LengthBody...
    /sqrt(4/pi*fuselage.SideLength^2);                                 % Fineness Ratio
fuselage.WettedArea = 4*fuselage.SideLength...
    *fuselage.LengthBody -payload.Boxed.Length*payload.Boxed.SideLengt;% Wetted/Surface Area [m^2]
fuselage.Density = 2;                                                  % Fuselage mass per unit surface area [kg/m^2]
fuselage.Xcg = fuselage.LengthBody/2;                                  % CG Location in X-dir [m]
fuselage.Volume = fuselage.LengthBody...
    *fuselage.SideLength^2;                                            % Volume [m^3]
%% Horizontal Tail Parameters
hTail.Airfoil.Name = 'NACA 0012';                                      % Airfoil Name
hTail.Airfoil.ClAlpha = 0.1*180/pi;                                    % Airfoil Lift Slope [per deg]
hTail.Airfoil.Cd0 = 0.03;                                              % Airfoil Zero Lift Drag Coefficient
hTail.Airfoil.K = 0;                                                   % Airfoil Drag efficiency 
hTail.Density = 2;                                                     % Tail mass per unit area [kg/m^2]
hTail.Airfoil.StallAoA = 10.5*pi/180;                                  % Airfoil Aerodynamic Stall Angle of Attack [deg]
hTail.HalfSpan = optimvar('b_ht','LowerBound',0.2,'UpperBound',0.42);  % Half Span [m]
initialValues.b_ht = 0.3;                                              % Half Span Initial Value [m]
hTail.Chord = optimvar('c_ht','LowerBound',0.08);                      % Chord Length [m]
initialValues.c_ht = 0.12;                                             % Chord Length Initial Value [m]
hTail.AspectRatio = 2*hTail.HalfSpan/hTail.Chord;                      % Aspect Ratio
hTail.PlanformArea = 2*hTail.Chord*hTail.HalfSpan;                     % Planform Area [m^2]
hTail.Xac = fuselage.Length-0.75*hTail.Chord;                          % Aerodynamic Center [m]
hTail.XLoc = fuselage.Length-hTail.Chord;                              % Leading Edge Location [m]

%% Vertical Tail Parameters
vTail.Airfoil.Name = 'NACA 0012';                                      % Airfoil Name
vTail.Airfoil.ClAlpha = 0.1*180/pi;                                    % Airfoil Lift Slope [per deg]
vTail.Airfoil.Cd0 = 0.03;                                              % Airfoil Zero Lift Drag Coefficient
vTail.Airfoil.K = 0;                                                   % Airfoil Drag efficiency 
vTail.Density = 2;                                                     % Tail mass per unit area [kg/m^2]
vTail.Airfoil.StallAoA = 10.5*pi/180;                                  % Airfoil Aerodynamic Stall Angle of Attack [deg]
vTail.HalfSpan = optimvar('b_vt','LowerBound',0.2,'UpperBound',0.42);  % Half Span [m]
initialValues.b_vt = 0.3;                                              % Half Span Initial Value [m]
vTail.Chord = optimvar('c_vt','LowerBound',0.08);                      % Chord Length [m]
initialValues.c_vt = 0.12;                                             % Chord Length Initial Value [m]
vTail.AspectRatio = vTail.HalfSpan/vTail.Chord;                        % Aspect Ratio
vTail.PlanformArea = vTail.Chord*vTail.HalfSpan;                       % Planform Area [m^2]
vTail.Xac = fuselage.Length-0.75*vTail.Chord;                          % Aerodynamic Center [m]
vTail.XLoc = fuselage.Length-vTail.Chord;                              % Leading Edge Location [m]
%% Thrust Parameters
%The competition sets a power limit of 1kW to the motor, limiting static thrust to around 40N.
aircraft.MaxThrust = 40.0;                                             % Max Thrust [N]
aircraft.DynamicThrustQuad = -0.0006;                                  % Quadratic Term Dynamic Thrust Coefficient [kg*m]

%% General Aircraft Parameters
aircraft.RePerLength = 5e5;                                            % Reynolds Number per unit length [per m]
aircraft.ReferenceArea = wing.PlanformArea;                            % Reference Area [m^2]
aircraft.StallAoA = wing.Airfoil.StallAoA;                             % Stall Aerodynamic Angle of Attack [deg]
aircraft.RollingResistance = 0.004;                                    % Rolling Resistance
aircraft.TakeOffAoA = 5*pi/180;                                        % Aerodynamic Angle of Attack at Take off [deg]
end
%Copyright 2022 The MathWorks, Inc.

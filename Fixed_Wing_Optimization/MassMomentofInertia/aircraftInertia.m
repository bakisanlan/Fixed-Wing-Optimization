%Compute aircraft mass moment of inertia from its components.
function Iair = aircraftInertia(Iw, Ih, Iv, Ip, If, Avionics, aircraft_Xcg)

% Compute Avionics inertia by approximating it to point mass
Iaxx = 0;
Iayy = Avionics.Mass*(Avionics.Xcg - aircraft_Xcg)^2;
Iazz = Iayy;
Ia = diag([Iaxx Iayy Iazz]);

Iair = Iw + Ih + Iv + Ip + If + Ia;
%Copyright 2022 The MathWorks, Inc.

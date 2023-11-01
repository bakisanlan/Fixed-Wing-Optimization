%Compute fuselage mass moment of inertia.
function I = fuselageInertia(Fuselage_Mass, Fuselage_SideLength, Fuselage_Length, ...
                             Fuselage_Xcg, aircraft_Xcg)

% Fuselage is a rectangular prism, so formulas are well defined
Ifxx = 1/12*Fuselage_Mass*(2*Fuselage_SideLength.^2);
Ifyy = 1/12*Fuselage_Mass*(Fuselage_Length.^2 + Fuselage_SideLength.^2);
Ifzz = 1/12*Fuselage_Mass*(Fuselage_Length.^2 + Fuselage_SideLength.^2);

% Use parallel axis theorem
Ifyy = Ifyy + (Fuselage_Xcg-aircraft_Xcg)^2*Fuselage_Mass;
Ifzz = Ifzz + (Fuselage_Xcg-aircraft_Xcg)^2*Fuselage_Mass;

% Combine
I = diag([Ifxx Ifyy Ifzz]);
%Copyright 2022 The MathWorks, Inc.

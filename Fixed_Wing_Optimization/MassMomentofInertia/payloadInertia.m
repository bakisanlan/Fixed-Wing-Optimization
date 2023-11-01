%Compute spherical and boxed payloads mass moment of inertia.
function I = payloadInertia(Payload_XLoc, ...
                            Payload_Boxed_SandMass,Payload_Boxed_EmptyMass, ...
                            Payload_Boxed_Height, Payload_Boxed_SandHeight, ...
                            Payload_Boxed_Length,Fuselage_SideLength, ...
                            aircraft_Xcg)

% Sand + Empty Box Inertia in below of boxed
m_emptbox_at_sand = Payload_Boxed_EmptyMass * ((Payload_Boxed_Height-Payload_Boxed_SandHeight)/Payload_Boxed_Height);
mass_below = Payload_Boxed_SandMass + m_emptbox_at_sand;

Iabxx = 1/12*mass_below*(Payload_Boxed_SandHeight^2 + Fuselage_SideLength.^2);
Iabyy = 1/12*mass_below*(Payload_Boxed_SandHeight^2 + Payload_Boxed_Length.^2);
Iabzz = 1/12*mass_below*(Payload_Boxed_Length.^2 + Fuselage_SideLength.^2);

% Use parallel axis theorem
Xcgf = Payload_XLoc + Payload_Boxed_Length/2;
Zcg = Payload_Boxed_Height - Payload_Boxed_SandHeight/2;
Iabxx = Iabxx + (Zcg + Fuselage_SideLength/2)^2*mass_below;
Iabyy = Iabyy + ((Zcg + Fuselage_SideLength/2)^2 + (Xcgf - aircraft_Xcg)^2)*mass_below;
Iabzz = Iabzz + (Xcgf - aircraft_Xcg)^2*mass_below;
Iab = diag([Iabxx Iabyy Iabzz]);

% Just Empty Box Inertia in above of Boxed
m_emptbox_at_above = Payload_Boxed_EmptyMass - m_emptbox_at_sand;

Ibexx = 1/12*m_emptbox_at_above*((Payload_Boxed_Height-Payload_Boxed_SandHeight)^2 + Fuselage_SideLength.^2);
Ibeyy = 1/12*m_emptbox_at_above*((Payload_Boxed_Height-Payload_Boxed_SandHeight)^2 + Payload_Boxed_Length.^2);
Ibezz = 1/12*m_emptbox_at_above*(Payload_Boxed_Length.^2 + Fuselage_SideLength.^2);

% Use parallel axis theorem
Xcgf = Payload_XLoc + Payload_Boxed_Length/2;
Zcg = (Payload_Boxed_Height - Payload_Boxed_SandHeight)/2;
Ibexx = Ibexx + (Zcg + Fuselage_SideLength/2)^2*m_emptbox_at_above;
Ibeyy = Ibeyy + ((Zcg + Fuselage_SideLength/2)^2 + (Xcgf - aircraft_Xcg)^2)*m_emptbox_at_above;
Ibezz = Ibezz + (Xcgf - aircraft_Xcg)^2*m_emptbox_at_above;
Ibe = diag([Ibexx Ibeyy Ibezz]);

I = Iab + Ibe;


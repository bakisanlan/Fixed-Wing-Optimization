%Compute spherical and boxed payloads mass moment of inertia.
function I = payloadInertia(Payload_Spherical, Payload_XLoc, Payload_Boxed_Length, ...
                            Payload_Boxed_Mass, Payload_Boxed_Height, Fuselage_SideLength, ...
                            aircraft_Xcg)


% Payload contribution
% % Spherical Payload: Spherical Shell has well define inertia
% Isxx = 2/3*Payload_Spherical.Mass*Payload_Spherical.Diameter^2;
% Isyy = Isxx;
% 
% % Use parallel axis theorem
% Xcg_sphere = Payload_XLoc + Payload_Boxed_Length/2 + Payload_Spherical.Diameter/2;
% Isyy = Isyy + (Xcg_sphere - aircraft_Xcg)^2*Payload_Spherical.Mass;
% Iszz = Isyy;
% Is = diag([Isxx Isyy Iszz]);

% % Boxed Payload Forward
% Ipfxx = 1/12*Payload_Boxed_Mass/2*(Payload_Boxed_Height^2 + Fuselage_SideLength.^2);
% Ipfyy = 1/12*Payload_Boxed_Mass/2*(Payload_Boxed_Height^2 + Payload_Boxed_Length.^2/4);
% Ipfzz = 1/12*Payload_Boxed_Mass/2*(Payload_Boxed_Length.^2/4 + Fuselage_SideLength.^2);
% 
% % Use parallel axis theorem
% Xcgf = Payload_XLoc + Payload_Boxed_Length/4;
% Zcg = Payload_Boxed_Height/2;
% Ipfxx = Ipfxx + (Zcg - Fuselage_SideLength/2)^2*Payload_Boxed_Mass/2;
% Ipfyy = Ipfyy + ((Zcg - Fuselage_SideLength/2)^2 + (Xcgf - aircraft_Xcg)^2)*Payload_Boxed_Mass/2;
% Ipfzz = Ipfzz + (Xcgf - aircraft_Xcg)^2*Payload_Boxed_Mass/2;
% Ipf = diag([Ipfxx Ipfyy Ipfzz]);

% Boxed Payload Aft
% Same as Forward

% % Use parallel axis theorem
% Xcga = Payload_XLoc + Payload_Spherical.Diameter + Payload_Boxed_Length*3/4;
% Ipaxx = Ipfxx + (Zcg - Fuselage_SideLength/2)^2*Payload_Boxed_Mass/2;
% Ipayy = Ipfyy + ((Zcg - Fuselage_SideLength/2)^2 + (Xcga - aircraft_Xcg)^2)*Payload_Boxed_Mass/2;
% Ipazz = Ipfzz + (Xcga - aircraft_Xcg)^2*Payload_Boxed_Mass/2;
% Ipa = diag([Ipaxx Ipayy Ipazz]);
% 
% Ip = Ipf + Ipa;
% I = Ip + Is;
%Copyright 2022 The MathWorks, Inc.

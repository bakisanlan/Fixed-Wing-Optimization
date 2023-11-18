function [t_Flight Battery_mAh RPM] = addEngineAndBattery(CruiseSpeed, Drag)

coef = load("coef.mat"); % Coefficients for 14x7 propeller
% coef.P(N,:) means RPM powers and coef.P(:,N) means V powers.
% My coefficient matrix is 5x7 which is observed as more than fine when
% compared with experiment results. If my coef matrix is 5x7;
% This means first row is for the RPM equation for V^4 power and the first
% column is RPM^6 with others changing V^4 V^3 V^2 V 1 which means if I add
% them together I have the total RPM^6 coefficient and if I use this for
% every orhet RPM^N power I would end up with a 6 degree polynomial where
% Thrust = Thrust(RPM) with coefficients known.

Thrust = 0;
% Thrust eq. with respect to RPM, not cruise speed. 
for i = 1:size(coef.P,1)
    Thrust = Thrust + coef.P(i,:)*CruiseSpeed^(size(coef.P,1)-i); % Ci*RPM^(end-i)
end

% Since my Thrust for cruise is known as my drag, and my Thrust equation
% with respect to RPM must be equal to this drag, I simply substract it
% from my equation and find the real root of my 6th degree polynomial. The
% roots are often imaginary, so I only take the real parts of the solution.
% Since there are two real solutions the question for which one should I
% pick is about my RPM ranges. For this equations I only used RPM values
% above 3000, so the root must be bigger than 3000. 
RPM_solutions = roots([Thrust(1:end-1) , Thrust(end)-Drag]);

for i = 1: length(RPM_solutions)
    if isreal(RPM_solutions(i)) && RPM_solutions(i) > 3000
        RPM = RPM_solutions(i);
    end
end

% a, b, c are the coefficients for my Current = Current(RPM) equation.
a = 0.992;
b = 0.0004307;
c = -1.065;
Current = a*exp(b*RPM)+c; % in A

FlightPath = 5000; % in m
SF_FlightPath = 1.2; % Using a safety factor in case of flying more than
% 5000 meters which is maximum value.
t_flight = FlightPath/CruiseSpeed; % in s
SF_error = 1.1; % Using a safety factor for any errors in calculations
% The errors are around 2-3 percent, using 10 percent is more than enough.
Battery_percent = 0.8; % Using 80 percent of the battery  
Battery_mAh = SF_FlightPath*SF_error/Battery_percent*Current*t_flight/3.6; % in mAh
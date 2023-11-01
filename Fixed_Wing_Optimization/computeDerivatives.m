%Compute the static stability derivatives for input aircraft.
%Return only the 10 derivatives relevant for stability analysis:
%CD_U, Cm_U, CY_V, CL_W, Cm_Alpha, Cl_Beta, Cn_Beta, Cl_P, Cm_Q, Cn_R
function stabilityDerivatives = computeDerivatives(...
        myAircraft, BodyCoefficients, CruiseState, inertiaMatrix, ...
        aircraft_Xcg, aircraft_NeutralPoint, Wing_PlanformArea, Wing_HalfSpan, ...
        HTail_Xac, HTail_Chord, aircraft_Mass)

% Update myAircraft and CruiseState parameters
myAircraft.ReferenceArea = Wing_PlanformArea;
myAircraft.ReferenceSpan = 2*Wing_HalfSpan;
myAircraft.ReferenceLength = HTail_Xac + 3/4*HTail_Chord;

CruiseState.Mass = aircraft_Mass;
CruiseState.Inertia.Variables = inertiaMatrix;

BodyCoefficientsCell = {
    'CD', 'Zero',       BodyCoefficients(1);
    'CL', 'Zero',       BodyCoefficients(2);
    'Cm', 'Zero',       BodyCoefficients(3);
    'CD', 'Alpha',      BodyCoefficients(4);
    'CL', 'Alpha',      BodyCoefficients(5);
    'Cm', 'Alpha',      BodyCoefficients(6);
    'CD', 'AlphaDot',   BodyCoefficients(7);
    'CL', 'AlphaDot',   BodyCoefficients(8);
    'Cm', 'AlphaDot',   BodyCoefficients(9);
    'CD', 'Q',          BodyCoefficients(10);
    'CL', 'Q',          BodyCoefficients(11);
    'Cm', 'Q',          BodyCoefficients(12);
    'CY', 'Beta',       BodyCoefficients(13);
    'Cl', 'Beta',       BodyCoefficients(14);
    'Cn', 'Beta',       BodyCoefficients(15);
    'CY', 'P',          BodyCoefficients(16);
    'Cl', 'P',          BodyCoefficients(17);
    'Cn', 'P',          BodyCoefficients(18);
    'CY', 'R',          BodyCoefficients(19);
    'Cl', 'R',          BodyCoefficients(20);
    'Cn', 'R',          BodyCoefficients(21);
};

myAircraft = setCoefficient(myAircraft, BodyCoefficientsCell(:, 1), BodyCoefficientsCell(:, 2), BodyCoefficientsCell(:, 3));

% setup State object
CruiseState.CenterOfGravity = aircraft_Xcg;
CruiseState.CenterOfPressure = aircraft_NeutralPoint;
CruiseState.Environment = aircraftEnvironment(myAircraft,"ISA",CruiseState.AltitudeMSL);

% compute the stability derivatives
[~, ds] = staticStability(myAircraft, CruiseState);
stabilityDerivatives = [ds{1,1}; ds{5,1}; ds{2,2}; ds{3,3}; ds{5,4}; ds{4,5}; ds{6,5}; ds{4,6}; ds{5,7}; ds{6,8}];

end
%Copyright 2022 The MathWorks, Inc.

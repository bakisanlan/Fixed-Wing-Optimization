
%To optimize the aircraft geometry, use the problem-based approach.
% Start by defining problem constants and the optimization variables 
% using the helper function initializeAircraft, which is included with this 
% example. Organize these variables into six structures: aircraft, wing,
% hTail, vTail, fuselage, and payload. See a list of the optimization
% variables and their physical representation below.
[aircraft, wing, fuselage, hTail, vTail, payload, initialValues] = initializeAircraft;
        
%Set up the design optimization problem
%Define an empty optimization problem and set maximization as its objective.
designprob = optimproblem('ObjectiveSense','maximize');

%Estimate lift and drag coefficients for the wing, tail, and fuselage. 
[aircraft, wing, fuselage, hTail, vTail, designprob] = ...
    addAerodynamics(aircraft, wing, fuselage, hTail, vTail, designprob);

%Use the component build-up method to formulate the aircraft mass and introduce the gross takeoff weight constraint.
[aircraft, wing, fuselage, hTail, vTail, payload, designprob] = ... 
    addWeightAndSizing(aircraft, wing, fuselage, hTail, vTail, payload, designprob);

%To compute the static stability derivatives, create an instance of the Aero.FixedWing and Aero.FixedWing.State objects.
[myAircraft, CruiseState] = createFixedWing(aircraft.Mass, wing, hTail, initialValues);

%Add the static stability constraints to the optimization problem. The following ten derivatives play a major role in an aircraft response to external disturbances and so are used as constraints: , , , , , , , , , .
%To compute these derivatives, the addStability function calculates all aerodynamic coefficients and the mass moment of inertia matrix for the aircraft. With this information, use the staticStability method of the Aero.FixedWing object to obtain the ten stability derivatives.
[aircraft, wing, vTail, designprob] = ...
    addStability(aircraft, wing, fuselage, hTail, vTail, payload, designprob, myAircraft, CruiseState);

%Estimate takeoff performance and include maximum takeoff distance, or ground roll, constraint.
[aircraft,designprob] = addPerformance(aircraft, wing.PlanformArea, wing.MeanChord, designprob);

%Write the objective function to match the SAE Aero Design Regular Class flight score. Units are converted to metric.
designprob.Objective = 3*(2+2.2*payload.Boxed.Mass)/((2*wing.HalfSpan+payload.Length));

%Set options for optimization solver
%Let the solver run to completion by setting the maximum number of function evaluations and iterations to infinity.
options = optimoptions(designprob);
options.MaxFunctionEvaluations = Inf;
options.MaxIterations = Inf;

%If steps become too small, stop the optimization early.
options.StepTolerance = 1e-4;

%Have the solver automatically plot the results of each iteration while it runs.
options.PlotFcn = {'optimplotconstrviolation', 'optimplotfvalconstr'};

%Use a parallel pool to speed up the computation.
options.UseParallel = true;
options.Display = 'off';

%Solve the optimization problem
%Solving the problem returns both the maximum flight score for this design and the corresponding values of the 12 optimization variables.
[finalValues, maxScore] = solve(designprob, initialValues, 'Options', options);

%The solution quickly gets close to the optimal value, and most steps are spent on the final improvements. Due to the nonlinearity of this problem, the solution might not be globally optimal. Different initial conditions might result in a predicted flight score better than 18.754. The optimized design has a final geometry with a large tapered wing and a moderately sized tail placed at the end of the fuselage.
% References
% [1] Roskam, Jan. Airplane Design, Part VI: Preliminary Calculation of Aerodynamic, Thurst and Power Characteristics. Lawrence, KA: DAR Corporation, 2008.
% [2] Roskam, Jan. Airplane Flight Dynamics and Automatic Flight Controls, Part I. Lawrence, KA: DAR Corporation, 2003.
% [3] Raymer, Daniel P. Aircraft Design: A Conceptual Approach. Washington, DC: AIAA, 1992.
%Copyright 2022-2023 The MathWorks, Inc.

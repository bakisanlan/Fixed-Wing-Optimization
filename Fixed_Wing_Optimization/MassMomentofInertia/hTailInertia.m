%Compute horizontal tail mass moment of inertia.
function I = hTailInertia(Tail_HalfSpan, Tail_Chord, Tail_Density, Tail_XLoc, Xcg)

% Spanwise mass distribution
n = 10;
y = linspace(0, Tail_HalfSpan, n+1);
dy = y(2)-y(1);
cy = Tail_Chord.*ones(size(y));
Ay = dy*(cy(1:end-1) + cy(2:end))/2;
my = Ay*Tail_Density;

% Chordwise mass distribution
% Quadratic, with CG at 3/10 chord length from leading edge
p = polyfit([0 0.3 1], [1 0.5 0], 2);
x = linspace(0, 1, n+1);
mx = polyval(p, x);
mx = mx(1:end-1) - mx(2:end);

% build matrix with nxn points with x location, y location, mass
ymid = (y(1:end-1) + y(2:end))/2;
ymid = repmat(ymid, 10, 1);
xc = (cy'*x)';
xmid = (xc(1:end-1, 1:end-1)+xc(2:end, 2:end))/2;

m = (my'*mx)';

xdist = abs(Tail_XLoc + xmid - Xcg);

Mw = [reshape(xdist, [1 numel(xdist)]); reshape(ymid, [1 numel(ymid)]); reshape(m, [1 numel(m)])];

% calculations done for half tail, so need to multiply by 2
Ixxw = 2*sum(Mw(2, :).^2.*Mw(3, :));
Iyyw = 2*sum(Mw(1, :).^2.*Mw(3, :));
Izzw = 2*sum((Mw(1, :).^2 + Mw(2, :).^2).*Mw(3, :));
I = diag([Ixxw Iyyw Izzw]);
%Copyright 2022 The MathWorks, Inc.

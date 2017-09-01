%4 pt bending test MATLAB script
% For general load and with or without mass
%Using updated lengths of 0.5m increments
%currently calculates moment, deflection and stress from 0 to 2m at 0.1m
%increments

P = 4000; % insert load
mass = 0; %1 or 0
E = 200e9; %Pa
Ixx = 2.08e-06; %m^4
NA = 0.0292; %m
ymax = 0.1-NA; %dist for max stress
w = mass*17.7*9.81;
R = P+3*w;
C = 0.292*P +(1/3)*w - (2/3)*R;

x = [0:0.5:2]'; %specify point along beam
d1 = zeros(size(x));
d2 = zeros(size(x));
for i = 1:length(x)
    if x(i)<=0.5
        d1(i) = 0;
    else
        d1(i) = x(i)-0.5;
    end
    if x(i)<=1.5
        d2(i) = 0;
    else 
        d2(i) = x(i)-1.5;
    end
end


%Moment, Slope and Deflection Function
M = (R.*x - (w/2).*x - P.*d1 - P.*d2);
Slope = ((R/2).*x.^2 - (w/6).*x.^3 - (P/2).*d1.^2 - (P/2).*d2.^2 + C)/(E*Ixx);
V = ((R/6).*x.^3 -(w/24).*x.^4 - (P/6).*(d1.^3 +d2.^3) + C.*x)/(E*Ixx);

%Secondary quantities
maxStress = (M.*ymax./Ixx)*(1e-6);
y = 0;
stressY = M.*y./Ixx;

A = [x (M.*(1e-3)) V maxStress];

fp = fopen('calc.txt', 'w');
fprintf(fp, '%4s   %6s   %6s   %6s \r\n', 'x', 'M(Nm)', 'V(m)', 'stress');
for i=1:length(x);
    fprintf(fp, '%4.3f  %6.3f  %6.5f  %6.4f \r\n', A(i,1), A(i,2), A(i,3), A(i,4));
end
fclose(fp);


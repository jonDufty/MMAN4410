%4 pt bend test
% NUmerical method

%Create Elemental Matrices
P = 4000; %N
E = 200e9; %GPa
I = 2.10013e-06; %m^4
L = 0.5;%m
DOF = 14;

A = toeplitz([12*E*I/(L^3) 6*E*I/(L^2) -12*E*I/(L^3) 6*E*I/(L^2)]);
A(2,2) = 4*E*I/(L); A(4,4) = A(2,2);
A(2,3) = -A(2,3); A(3,2) = A(2,3); A(3,4) = A(2,3); A(4,3) = A(2,3);
A(2,4) = 2*E*I/L; A(4,2) = A(2,4);

%Assemble into global matrix
G1 = zeros(DOF); G1(1:4,1:4)=A; 
G2 = zeros(DOF); G2(3:6,3:6)=A; 
G3 = zeros(DOF); G3(5:8,5:8)=A;
G4 = zeros(DOF); G4(7:10,7:10)=A;
G5 = zeros(DOF); G5(9:12,9:12)=A;
G6 = zeros(DOF); G6(11:14, 11:14)=A;
G = G1 + G2 + G3 + G4 +G5 +G6;
%G

%create Force and Disp Vectors
F = zeros(DOF,1); u = ones(DOF,1);
F(5) = P; F(9) = P; %F(1) = P; F(9) = P;
u(1) = 0; u(9)=0;
%create constrained matrix
Gcon = G;
Gcon(3,:) = 0; Gcon(:,3)=0; Gcon(11,:)= 0; Gcon(:,11)= 0;
Gcon(3,3) = 1; Gcon(11,11) =1;
%invert G and left multiply with F to solve for u
Ginv = inv(Gcon);
u = Ginv*F
%alternatively
u1 = Gcon\F;

%Calculate force vector
F = G*u

%print soln into text doc
fp = fopen('calc.txt','a');
fprintf(fp,'\n %s \n','--------------------');
fprintf(fp,'%s\n', 'numerical displacements');
fprintf(fp,'%s\n',' --------------------');
fprintf(fp, '%6.5f %6.5f %6.5f %6.5f %6.5f %6.5f %6.5f %6.5f %6.5f %6.5f \n', u);
fclose(fp);




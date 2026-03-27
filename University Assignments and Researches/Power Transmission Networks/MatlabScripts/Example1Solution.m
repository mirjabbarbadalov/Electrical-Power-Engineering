clc; clear; format short eng

%% Point 3 Calculations

P3 = 175e6;    %W
U3_LL = 220e3;  %V
cos_Phi3 = 0.85;  % in degree

Phi3 = acosd(cos_Phi3);

U3_LN = U3_LL / sqrt(3);
fprintf('U3_LN is %.2f V\n', abs(U3_LN));

I3_Mag = P3 / (3 * U3_LN * cos_Phi3);
fprintf('I3_Mag ia %.2f A\n', abs(I3_Mag));

U3 = U3_LN * exp(1j * deg2rad(0));
I3 = I3_Mag * exp(1j * deg2rad(-Phi3));
fprintf('I3 is %.2f A < %.2f degree\n\n\n', abs(I3), rad2deg(angle(I3)) );

x_3 = [U3 ; I3];
%% Line 2 calculations With Distributed Params

Zk_2 = 0.421 * exp(1j * deg2rad(90));
Yk_2 = 2.64e-6 * exp(1j * deg2rad(90));
l_2 = 70;

Zv = sqrt(Zk_2 / Yk_2);
gamma = sqrt(Zk_2 * Yk_2);


fprintf('Zv is %.6e  <  %.2f degree\n', abs(Zv), rad2deg(angle(Zv)))
fprintf('Gamma is %.6e  <  %.2f degree\n', abs(gamma), rad2deg(angle(gamma)))

A_2 = cosh(gamma * l_2);
B_2 = Zv * sinh(gamma * l_2);
C_2 = 1/Zv * sinh(gamma * l_2);
D_2 = A_2;

fprintf('A_2 is %.6e < %.2f deg\n', abs(A_2), rad2deg(angle(A_2)));
fprintf('B_2 is %.6e < %.2f deg\n', abs(B_2), rad2deg(angle(B_2)));
fprintf('C_2 is %.6e < %.2f deg\n', abs(C_2), rad2deg(angle(C_2)));
fprintf('D_2 is %.6e < %.2f deg\n\n\n', abs(D_2), rad2deg(angle(D_2)));

M_2 = [A_2, B_2 ; C_2, D_2];



%% Line 1 Calculations with T-circut parameters

Zk_1 = 0.41 * exp(1j * deg2rad(85));
Yk_1 = 2.64e-6 * exp(1j * deg2rad(90));

l_1 = 70;

Z_1 = Zk_1 * l_1;
Y_1 = Yk_1 * l_1;

A_1 = 1 + (Z_1 * Y_1) / 2;
B_1 = Z_1 * (1 + Z_1 * Y_1 / 4);
C_1 = Y_1;
D_1 = A_1;

fprintf('A_1 is %.6e < %.2f deg\n', abs(A_1), rad2deg(angle(A_1)));
fprintf('B_1 is %.6e < %.2f deg\n', abs(B_1), rad2deg(angle(B_1)));
fprintf('C_1 is %.6e < %.2f deg\n', abs(C_1), rad2deg(angle(C_1)));
fprintf('D_1 is %.6e < %.2f deg\n\n', abs(D_1), rad2deg(angle(D_1)));

M_1 = [A_1, B_1 ; C_1, D_1];

M_overall = M_1 * M_2;

A_overall = M_overall(1,1);
B_overall = M_overall(1,2);
C_overall = M_overall(2,1);
D_overall = M_overall(2,2);

fprintf('A_OVERALL %.6e < %.2f deg\n', abs(A_overall), rad2deg(angle(A_overall)));
fprintf('B_OVERALL %.6e < %.2f deg\n', abs(B_overall), rad2deg(angle(B_overall)));
fprintf('C_OVERALL %.6e < %.2f deg\n', abs(C_overall), rad2deg(angle(C_overall)));
fprintf('D_OVERALL %.6e < %.2f deg\n', abs(D_overall), rad2deg(angle(D_overall)));


x_1 = M_overall * x_3;

U1 = x_1(1);
I1= x_1(2);

fprintf('U1 %.2f < %.2f deg\n', abs(U1), rad2deg(angle(U1)));
fprintf('U1 %.2f < %.2f deg\n', abs(I1), rad2deg(angle(I1)));
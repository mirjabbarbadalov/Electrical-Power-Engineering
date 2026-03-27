P3 = 100e6;
U3ll = 220e3;
cos_Phi3 = 0.95;

U3ln = U3ll / sqrt(3);
U3 = U3ln * exp(1j*0);
I3 = (P3 / (3 * abs(U3ln) * cos_Phi3)) * exp(-1j * acos(cos_Phi3));

fprintf('I3 is %.2f A < %.2f deg\n', abs(I3), rad2deg(angle(I3)));
fprintf('U3 is %.2f V < %.2f deg\n\n', abs(U3), rad2deg(angle(U3)));

l = 40;

Z_k2 = 0.4 * exp(1j * deg2rad(80));
Y_k2 = 2.64e-6 * exp(1j * deg2rad(90));
gamma = sqrt(Z_k2 * Y_k2);
Zv = sqrt(Z_k2 / Y_k2);
gl = gamma * l;

M2 = [cosh(gl), Zv * sinh(gl); (1/Zv) * sinh(gl), cosh(gl)];

fprintf('Gamma = %.6e < %.2f deg \n', abs(gamma), rad2deg(angle(gamma)));
fprintf('Zc    = %.6e < %.2f deg \n\n', abs(Zv), rad2deg(angle(Zv)));
fprintf(' ABCD\n');
fprintf('  A2 = %.6e < %.2f \n', abs(M2(1,1)), rad2deg(angle(M2(1,1))));
fprintf('  B2 = %.6e < %.2f \n', abs(M2(1,2)), rad2deg(angle(M2(1,2))));
fprintf('  C2 = %.6e < %.2f \n', abs(M2(2,1)), rad2deg(angle(M2(2,1))));
fprintf('  D2 = %.6e < %.2f \n\n', abs(M2(2,2)), rad2deg(angle(M2(2,2))));

Z_k1 = 0.4 * exp(1j* deg2rad(85));
Y_k1 = 2.64e-6 * exp(1j* deg2rad(88));
Z_1 = Z_k1 * l;
Y_1 = Y_k1 * l;

M1 = [1 + (Z_1 * Y_1)/2, Z_1; Y_1 * (1 + (Z_1 * Y_1 ) / 4), 1 + (Z_1 * Y_1)/2];


fprintf('  A1 = %.6e < %.2f \n', abs(M1(1,1)), rad2deg(angle(M1(1,1))));
fprintf('  B1 = %.6e < %.2f \n', abs(M1(1,2)), rad2deg(angle(M1(1,2))));
fprintf('  C1 = %.6e < %.2f \n', abs(M1(2,1)), rad2deg(angle(M1(2,1))));
fprintf('  D1 = %.6e < %.2f \n\n', abs(M1(2,2)), rad2deg(angle(M1(2,2))));

M_over = M1 * M2;


fprintf('  A_over = %.6e < %.2f \n', abs(M_over(1,1)), rad2deg(angle(M_over(1,1))));
fprintf('  B_over = %.6e < %.2f \n', abs(M_over(1,2)), rad2deg(angle(M_over(1,2))));
fprintf('  C_over = %.6e < %.2f \n', abs(M_over(2,1)), rad2deg(angle(M_over(2,1))));
fprintf('  D_over = %.6e < %.2f \n\n', abs(M_over(2,2)), rad2deg(angle(M_over(2,2))));

x1 = M_over * [U3; I3];
U1 = x1(1);
I1 = x1(2);

fprintf('I1 is %.2f A < %.2f deg\n', abs(I1), rad2deg(angle(I1)));
fprintf('U1 is %.2f V < %.2f deg\n\n', abs(U1), rad2deg(angle(U1)));

P1 = 3 * U1 * I1 * cos_Phi3;
P2 = 3 * U3 * I3 * cos_Phi3;

fprintf('P1 IS %.2f\n', abs(P1))
fprintf('P2 IS %.2f\n', abs(P2))
clc; clear; format short eng

%% Point 3 calculations

P3 = 100e6;
U3ll = 220e3;
cos_Phi3 = 0.95;
Phi3 = acosd(cos_Phi3);            

U3ln = U3ll / sqrt(3);             
U3   = U3ln * exp(1j*0);          

I3mag = P3 / (3 * abs(U3ln) * cos_Phi3);  
I3    = I3mag * exp(1j*deg2rad(-Phi3));  

fprintf('I3 is %.2f A < %.2f deg\n', abs(I3), rad2deg(angle(I3)));
fprintf('U3 is %.2f V < %.2f deg\n\n', abs(U3), rad2deg(angle(U3)));

x3 = [U3; I3];


%% Distributed Parameters

l    = 40;
Z_k2 = 0.4   * exp(1j * deg2rad(80));   
Y_k2 = 2.64e-6 * exp(1j * deg2rad(90));    

gamma = sqrt(Z_k2 * Y_k2);   
Zv    = sqrt(Z_k2 / Y_k2);  

A2 = cosh(gamma * l);
B2 = Zv * sinh(gamma * l);
C2 = (1 / Zv) * sinh(gamma * l);
D2 = A2;

M2 = [A2 , B2 ; C2, D2];     
fprintf(' (Distributed) parameters ---\n');
fprintf('Gamma = %.6e < %.2f deg \n', abs(gamma), rad2deg(angle(gamma)));
fprintf('Zc    = %.6e < %.2f deg \n\n',  abs(Zv),   rad2deg(angle(Zv)));


fprintf(' ABCD\n');
fprintf('  A2 = %.6e < %.2f \n', abs(A2), rad2deg(angle(A2)));
fprintf('  B2 = %.6e < %.2f\n',           abs(B2), rad2deg(angle(B2)));
fprintf('  C2 = %.6e < %.2f \n',             abs(C2), rad2deg(angle(C2)));
fprintf('  D2 = %.6e < %.2f n\n', abs(D2), rad2deg(angle(D2)));



%% Pi circut

Z_k1 = 0.4 * exp(1j* deg2rad(85));
Y_k1 = 2.64e-6 * exp(1j* deg2rad(88));


Z_1 = Z_k1 * l;
Y_1 = Y_k1* l;

A1 = 1 + (Z_1 * Y_1)/2;
B1 = Z_1;
C1 = Y_1 * (1 + (Z_1 * Y_1 ) / 4);

D1 = A1;

M1 = [A1, B1; C1, D1];

fprintf('\nPI CIRCUT PARAMETERS\n')
fprintf('\nABCD\n');
fprintf('  A1 = %.6e < %.2f \n', abs(A1), rad2deg(angle(A1)));
fprintf('  B1 = %.6e < %.2f\n',  abs(B1), rad2deg(angle(B1)));
fprintf('  C1 = %.6e < %.2f \n', abs(C1), rad2deg(angle(C1)));
fprintf('  D1 = %.6e < %.2f n\n', abs(D1), rad2deg(angle(D1)));


%% Overall Parameters

M_over = M1 * M2;

A_over = M_over(1,1);
B_over = M_over(1,2);
C_over = M_over(2,1);
D_over = M_over(2,2);

fprintf('\nOverall Parameters\n')
fprintf('\nABCD\n');
fprintf('  A_over = %.6e < %.2f \n', abs(A_over), rad2deg(angle(A_over)));
fprintf('  B_over = %.6e < %.2f\n',  abs(B_over), rad2deg(angle(B_over)));
fprintf('  C_over = %.6e < %.2f \n', abs(C_over), rad2deg(angle(C_over)));
fprintf('  D_over = %.6e < %.2f n\n', abs(D_over), rad2deg(angle(D_over)));

x1 = M_over * x3;

U1 = x1(1);
I1 = x1(2);


fprintf('\n\nI1 is %.2f A < %.2f deg\n', abs(I1), rad2deg(angle(I1)));
fprintf('U1 is %.2f V < %.2f deg\n\n', abs(U1), rad2deg(angle(U1)));

P1 = 3 * U1 * I1 * cos_Phi3;
P2 = 3 * U3* I3 *cos_Phi3;

fprintf('P1 IS %.2f\n' ,abs(P1))
fprintf('P2 IS %.2f' ,abs(P2))

clc; clear; format short eng

%% Point 3 (Load end)
P3 = 175e6; U3ll = 220e3; cosPhi3 = 0.85; l = 70;  % km
Phi3 = acosd(cosPhi3);
U3 = U3ll/sqrt(3);
I3 = (P3/(3*U3*cosPhi3)) * exp(-1j*deg2rad(Phi3));
x3 = [U3; I3];

fprintf('U3 is %.2f V < %.2f deg\n', abs(U3), rad2deg(angle(U3)));
fprintf('I3 is %.2f A < %.2f deg\n', abs(I3), rad2deg(angle(I3)));

%% Line 2 (Distributed)
Z_k2 = 0.421*exp(1j*deg2rad(90));      % ohm/km
Y_k2 = 2.64e-6*exp(1j*deg2rad(90));    % S/km
gamma = sqrt(Z_k2*Y_k2); Zc = sqrt(Z_k2/Y_k2);

A2 = cosh(gamma*l); B2 = Zc*sinh(gamma*l); C2 = (1/Zc)*sinh(gamma*l); D2 = A2;
M2 = [A2 B2; C2 D2];

fprintf('\n--- LINE 2 (Distributed) parameters ---\n');
fprintf('Gamma = %.6e < %.2f deg  [1/km]\nZc    = %.6e < %.2f deg  [ohm]\n\n', ...
        abs(gamma), rad2deg(angle(gamma)), abs(Zc), rad2deg(angle(Zc)));
fprintf('Line 2 ABCD (polar):\n');
names = {'A2','B2','C2','D2'}; vals = [A2 B2 C2 D2]; units = {'(dimensionless)','[ohm]','[S]','(dimensionless)'};
for k=1:4, fprintf('  %s = %.6e < %.2f %s\n', names{k}, abs(vals(k)), rad2deg(angle(vals(k))), units{k}); end
fprintf('\n');

x2 = M2*x3; U2 = x2(1); I2 = x2(2);
fprintf('U2 is %.2f V < %.2f deg\nI2 is %.2f A < %.2f deg\n', abs(U2), rad2deg(angle(U2)), abs(I2), rad2deg(angle(I2)));

%% Line 1 (Nominal-T)
Z_k1 = 0.41*exp(1j*deg2rad(85)); Y_k1 = 2.64e-6*exp(1j*deg2rad(90));
Z_1 = Z_k1*l; Y_1 = Y_k1*l;
A1 = 1 + (Z_1*Y_1)/2; B1 = Z_1*(1 + (Z_1*Y_1)/4); C1 = Y_1; D1 = A1;
M1 = [A1 B1; C1 D1];

fprintf('\n--- LINE 1 (Nominal-T) parameters ---\nLine 1 ABCD (polar):\n');
names = {'A1','B1','C1','D1'}; vals = [A1 B1 C1 D1];
for k=1:4, fprintf('  %s = %.6e < %.2f %s\n', names{k}, abs(vals(k)), rad2deg(angle(vals(k))), units{k}); end
fprintf('\n');

%% Overall cascade and sending-end
M_overall = M1*M2;
A = M_overall(1,1); B = M_overall(1,2); C = M_overall(2,1); D = M_overall(2,2);

fprintf('=== OVERALL (Line1 ∘ Line2) ABCD ===\n');
names = {'A','B','C','D'}; vals = [A B C D];
for k=1:4, fprintf('  %s  = %.6e < %.2f %s\n', names{k}, abs(vals(k)), rad2deg(angle(vals(k))), units{k}); end
fprintf('\n');

x1 = M_overall*x3; U1 = x1(1); I1 = x1(2);
fprintf('U1 is %.2f V < %.2f deg\nI1 is %.2f A < %.2f deg\n', abs(U1), rad2deg(angle(U1)), abs(I1), rad2deg(angle(I1)));
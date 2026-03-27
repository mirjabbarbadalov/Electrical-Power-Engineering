clc; clear; format short eng

%% Point 3 (Load end) Calculations
P3      = 175e6;       % W
U3ll    = 220e3;       % V (line-to-line)
cosPhi3 = 0.85;        % power factor (lagging assumed)

Phi3 = acosd(cosPhi3);             % power factor angle in degrees

U3ln = U3ll / sqrt(3);             % line-to-neutral voltage (magnitude)
U3   = U3ln * exp(1j*0);           % reference voltage phasor at 0°

I3mag = P3 / (3 * abs(U3ln) * cosPhi3);    % current magnitude
I3    = I3mag * exp(1j*deg2rad(-Phi3));    % lagging => negative angle

x3 = [U3; I3];  % receiving-end state vector [V3; I3]

fprintf('U3 is %.2f V < %.2f deg\n', abs(U3), rad2deg(angle(U3)));
fprintf('I3 is %.2f A < %.2f deg\n', abs(I3), rad2deg(angle(I3)));

%% Line 2 (long line with distributed parameters)
l    = 70;  % km

Z_k2 = 0.421   * exp(1j * deg2rad(90));     % ohm/km (j0.421)
Y_k2 = 2.64e-6 * exp(1j * deg2rad(90));     % S/km   (j2.64 uS)

gamma = sqrt(Z_k2 * Y_k2);   % propagation constant [1/km]
Zc    = sqrt(Z_k2 / Y_k2);   % surge (characteristic) impedance [ohm]

A2 = cosh(gamma * l);
B2 = Zc       * sinh(gamma * l);
C2 = (1 / Zc) * sinh(gamma * l);
D2 = A2;

M2 = [A2 , B2 ; C2, D2];     % ABCD matrix of line 2
fprintf('\n--- LINE 2 (Distributed) parameters ---\n');
fprintf('Gamma = %.6e < %.2f deg  [1/km]\n', abs(gamma), rad2deg(angle(gamma)));
fprintf('Zc    = %.6e < %.2f deg  [ohm]\n\n',  abs(Zc),   rad2deg(angle(Zc)));

% Print ABCD for Line 2 (polar)
fprintf('Line 2 ABCD (polar):\n');
fprintf('  A2 = %.6e < %.2f (dimensionless)\n', abs(A2), rad2deg(angle(A2)));
fprintf('  B2 = %.6e < %.2f [ohm]\n',           abs(B2), rad2deg(angle(B2)));
fprintf('  C2 = %.6e < %.2f [S]\n',             abs(C2), rad2deg(angle(C2)));
fprintf('  D2 = %.6e < %.2f (dimensionless)\n\n', abs(D2), rad2deg(angle(D2)));

x2 = M2 * x3;  % sending end of line 2 (i.e., bus 2)
U2 = x2(1);
I2 = x2(2);

fprintf('U2 is %.2f V < %.2f deg\n', abs(U2), rad2deg(angle(U2)));
fprintf('I2 is %.2f A < %.2f deg\n', abs(I2), rad2deg(angle(I2)));

%% Line 1 (medium line with nominal T-equivalent)
Z_k1 = 0.41     * exp(1j * deg2rad(85));    % ohm/km
Y_k1 = 2.64e-6  * exp(1j * deg2rad(90));    % S/km

Z_1 = Z_k1 * l;   % series impedance of the whole line
Y_1 = Y_k1 * l;   % shunt admittance of the whole line

% Nominal-T ABCD parameters:
A1 = 1 + (Z_1 * Y_1) / 2;
B1 = Z_1 * (1 + (Z_1 * Y_1) / 4);
C1 = Y_1;
D1 = A1;

M1 = [A1, B1; C1, D1];

fprintf('\n--- LINE 1 (Nominal-T) parameters ---\n');
fprintf('Line 1 ABCD (polar):\n');
fprintf('  A1 = %.6e < %.2f (dimensionless)\n', abs(A1), rad2deg(angle(A1)));
fprintf('  B1 = %.6e < %.2f [ohm]\n',           abs(B1), rad2deg(angle(B1)));
fprintf('  C1 = %.6e < %.2f [S]\n',             abs(C1), rad2deg(angle(C1)));
fprintf('  D1 = %.6e < %.2f (dimensionless)\n\n', abs(D1), rad2deg(angle(D1)));

%% Cascade the two lines: from bus 3 -> 2 -> 1
M_overall = M1 * M2;

A_overall = M_overall(1,1);
B_overall = M_overall(1,2);
C_overall = M_overall(2,1);
D_overall = M_overall(2,2);

fprintf('=== OVERALL (Line1 ∘ Line2) ABCD ===\n');
fprintf('  A  = %.6e < %.2f (dimensionless)\n', abs(A_overall), rad2deg(angle(A_overall)));
fprintf('  B  = %.6e < %.2f [ohm]\n',           abs(B_overall), rad2deg(angle(B_overall)));
fprintf('  C  = %.6e < %.2f [S]\n',             abs(C_overall), rad2deg(angle(C_overall)));
fprintf('  D  = %.6e < %.2f (dimensionless)\n\n', abs(D_overall), rad2deg(angle(D_overall)));

x1 = M_overall * x3; % state at bus 1 (sending end of the whole system)
U1 = x1(1);
I1 = x1(2);

fprintf('U1 is %.2f V < %.2f deg\n', abs(U1), rad2deg(angle(U1)));
fprintf('I1 is %.2f A < %.2f deg\n', abs(I1), rad2deg(angle(I1)));

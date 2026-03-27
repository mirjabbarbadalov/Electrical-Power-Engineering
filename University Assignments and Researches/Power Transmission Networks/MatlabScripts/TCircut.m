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

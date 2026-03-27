%% Line 2 (long line with distributed parameters)
l    = 40; 

Z_k2 = 0.4   * exp(1j * deg2rad(80));   
Y_k2 = 2.64e-6 * exp(1j * deg2rad(90));    

gamma = sqrt(Z_k2 * Y_k2);   
Zc    = sqrt(Z_k2 / Y_k2);  

A2 = cosh(gamma * l);
B2 = Zc       * sinh(gamma * l);
C2 = (1 / Zc) * sinh(gamma * l);
D2 = A2;

M2 = [A2 , B2 ; C2, D2];     
fprintf('\n--- LINE 2 (Distributed) parameters ---\n');
fprintf('Gamma = %.6e < %.2f deg  [1/km]\n', abs(gamma), rad2deg(angle(gamma)));
fprintf('Zc    = %.6e < %.2f deg  [ohm]\n\n',  abs(Zc),   rad2deg(angle(Zc)));


fprintf('Line 2 ABCD (polar):\n');
fprintf('  A2 = %.6e < %.2f (dimensionless)\n', abs(A2), rad2deg(angle(A2)));
fprintf('  B2 = %.6e < %.2f [ohm]\n',           abs(B2), rad2deg(angle(B2)));
fprintf('  C2 = %.6e < %.2f [S]\n',             abs(C2), rad2deg(angle(C2)));
fprintf('  D2 = %.6e < %.2f (dimensionless)\n\n', abs(D2), rad2deg(angle(D2)));
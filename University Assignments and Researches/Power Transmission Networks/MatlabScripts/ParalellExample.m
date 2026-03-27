clc; clear; format short eng

%% Given (from the figure)
P3 = 250e6;            % W (3-phase active power at bus 1)
U1LL = 400e3;          % V (line-to-line, angle 0°)
cosphi = 0.85;         % lagging
phi = acosd(cosphi);

% Per-phase sending-end phasors
U1 = (U1LL/sqrt(3))*exp(1j*0);            % V1 (phase)
S3 = P3/cosphi;                           % three-phase apparent power
I1 = (S3/(sqrt(3)*U1LL)) * exp(-1j*deg2rad(phi));   % lagging current

fprintf('--- Sending end ---\n');
fprintf('U1 = %.2f V < %.2f deg\n', abs(U1), rad2deg(angle(U1)));
fprintf('I1 = %.2f A < %.2f deg  (answer for I1)\n\n', abs(I1), rad2deg(angle(I1)));

%% ABCD of the two lines (from the figure)
% Line I
A1 = 1.000*exp(1j*0);
B1 = 21.049*exp(1j*deg2rad(90));         % ohm
C1 = (0.132e-3)*exp(1j*deg2rad(90));     % S (0.132 mS)
D1 = 0.997*exp(1j*0);

% Line II
A2 = 1.000*exp(1j*0);
B2 = 10.525*exp(1j*deg2rad(90));         % ohm
C2 = (0.066e-3)*exp(1j*deg2rad(90));     % S (0.066 mS)
D2 = 1.000*exp(1j*0);

%% Convert each ABCD -> Y using: Y = (1/B) * [ D  -1 ; -1  A ]
Y1 = (1/B1) * [ D1, -1 ; -1, A1 ];
Y2 = (1/B2) * [ D2, -1 ; -1, A2 ];

% Parallel combination: Y_eq = Y1 + Y2
Yeq = Y1 + Y2;

% Convert Y_eq back to ABCD (optional, but nice to report)
Y11 = Yeq(1,1); Y12 = Yeq(1,2); Y21 = Yeq(2,1); Y22 = Yeq(2,2);
Aeq = -Y22 / Y21;
Beq = -1   / Y21;
Ceq = -(Y11*Y22 - Y12*Y21) / Y21;
Deq = -Y11 / Y21;

fprintf('=== Equivalent ABCD of the parallel pair ===\n');
fprintf('Aeq = %.6e < %.2f\n', abs(Aeq), rad2deg(angle(Aeq)));
fprintf('Beq = %.6e < %.2f [ohm]\n', abs(Beq), rad2deg(angle(Beq)));
fprintf('Ceq = %.6e < %.2f [S]\n', abs(Ceq), rad2deg(angle(Ceq)));
fprintf('Deq = %.6e < %.2f\n\n', abs(Deq), rad2deg(angle(Deq)));

%% Receiving end from ABCD: [V1; I1] = [A B; C D]*[V2; -I2]
M = [Aeq, Beq; Ceq, Deq];
x2 = M \ [U1; I1];          % solves M*[V2; -I2] = [V1; I1]
V2 = x2(1);
I2 = -x2(2);

fprintf('--- Receiving end ---\n');
fprintf('U2 (phase) = %.2f V < %.2f deg\n', abs(V2), rad2deg(angle(V2)));
fprintf('I2 (phase) = %.2f A < %.2f deg\n', abs(I2), rad2deg(angle(I2)));
U2LL = sqrt(3)*V2;
fprintf('U2 (line-line) = %.2f V < %.2f deg\n', abs(U2LL), rad2deg(angle(U2LL)));
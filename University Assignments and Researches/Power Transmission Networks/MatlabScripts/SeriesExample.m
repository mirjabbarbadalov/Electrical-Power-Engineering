%% Example 1: Cascade connection (CLEAN, matrix form, no functions)
clc; clear; format short eng

%% ------------------ Input Data ------------------
% Line I (given ABCD)
A1 = 1.000 * exp(1j*deg2rad(0));
B1 = 21.049 * exp(1j*deg2rad(90));       % ohm
C1 = 0.132e-3 * exp(1j*deg2rad(90));     % siemens (0.132 mS)
D1 = 0.997 * exp(1j*deg2rad(0));
M1 = [A1, B1; C1, D1];                    % ABCD (Line I)

% Line II (distributed parameters per km)
Zp  = 0.421      * exp(1j*deg2rad(90));   % Ω/km
Yp  = 2.6389e-6  * exp(1j*deg2rad(90));   % S/km
lkm = 70;                                 % km

% Receiving-end (bus 3) operating point
P3      = 175e6;                          % W
U3_LL   = 220e3;                          % V (line-to-line)
cosphi3 = 0.85;                           % lagging

%% ------------------ Bus 3 (receiving end): x3 = [U3; I3] ------------------
U3 = (U3_LL/sqrt(3)) * exp(1j*0);         % per-phase voltage, ∠0°
phi3  = acosd(cosphi3);                   % pf angle (deg)
I3mag = P3 / (3 * abs(U3) * cosphi3);     % per-phase current magnitude
I3    = I3mag * exp(1j*deg2rad(-phi3));   % lagging current (-phi)
x3 = [U3; I3];                            % column vector

fprintf('--- Bus 3 (receiving) ---\n');
fprintf('U3_phase = %.3f V  ∠ %6.2f°\n', abs(U3), rad2deg(angle(U3)));
fprintf('U3_LL    = %.3f kV (mag)\n', abs(U3)*sqrt(3)/1e3);
fprintf('I3       = %.3f A  ∠ %6.2f°\n\n', abs(I3), rad2deg(angle(I3)));

%% ------------------ Line II ABCD (long line) ------------------------------
gamma = sqrt(Zp * Yp);                    % 1/km
Zc    = sqrt(Zp / Yp);                    % ohm
gl    = gamma * lkm;                      % dimensionless

A2 = cosh(gl);
sh = sinh(gl);
B2 = Zc * sh;                             % ohm
C2 = (1/Zc) * sh;                         % siemens
D2 = A2;

M2 = [A2, B2; C2, D2];                    % ABCD (Line II)

%% ------------------ Overall ABCD of cascade -------------------------------
Mcel = M1 * M2;                           % overall ABCD
Acel = Mcel(1,1); Bcel = Mcel(1,2);
Ccel = Mcel(2,1); Dcel = Mcel(2,2);

fprintf('--- Overall ABCD (cascade) ---\n');
fprintf('Acel = %.6f  ∠ %7.3f°\n', abs(Acel), rad2deg(angle(Acel)));
fprintf('Bcel = %.6f Ω ∠ %7.3f°\n', abs(Bcel), rad2deg(angle(Bcel)));
fprintf('Ccel = %.6e S ∠ %7.3f°\n', abs(Ccel), rad2deg(angle(Ccel)));
fprintf('Dcel = %.6f  ∠ %7.3f°\n\n', abs(Dcel), rad2deg(angle(Dcel)));

%% ------------------ Propagate with matrices only --------------------------
% Bus 2 (between lines): x2 = M2 * x3
x2 = M2 * x3;
U2 = x2(1); I2 = x2(2);

% Bus 1 (sending, sequential): x1_seq = M1 * x2
x1_seq = M1 * x2;
U1_seq = x1_seq(1); I1_seq = x1_seq(2);

% Bus 1 (sending, direct via overall): x1 = Mcel * x3
x1 = Mcel * x3;
U1 = x1(1); I1 = x1(2);

%% ------------------ Essential outputs -------------------------------------
fprintf('--- Bus 2 (between lines) ---\n');
fprintf('U2_phase = %.3f V  ∠ %6.2f°\n', abs(U2), rad2deg(angle(U2)));
fprintf('U2_LL    = %.3f kV (mag)\n', abs(U2)*sqrt(3)/1e3);
fprintf('I2       = %.3f A  ∠ %6.2f°\n\n', abs(I2), rad2deg(angle(I2)));

fprintf('--- Bus 1 (sending, via overall Mcel) ---\n');
fprintf('U1_phase = %.3f V  ∠ %6.2f°\n', abs(U1), rad2deg(angle(U1)));
fprintf('U1_LL    = %.3f kV (mag)\n', abs(U1)*sqrt(3)/1e3);
fprintf('I1       = %.3f A  ∠ %6.2f°\n\n', abs(I1), rad2deg(angle(I1)));

%% ------------------ (Optional) Consistency check --------------------------
% Sequential (M1*(M2*x3)) must equal direct (Mcel*x3)
dU = U1_seq - U1;  dI = I1_seq - I1;
fprintf('Consistency check (should be ~0): ΔU1 = %.3e + j%.3e V,  ΔI1 = %.3e + j%.3e A\n', ...
        real(dU), imag(dU), real(dI), imag(dI));
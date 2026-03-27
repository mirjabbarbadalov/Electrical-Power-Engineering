% MPA-PRS Test II - Example 1 Solution
clc; clear; close all;

% --- Input Parameters ---
% General
c = 1.1;                    % Voltage factor
U_ref = 6000;               % Reference voltage at fault (V)

% Feeder S1
SkQ = 750e6;                % Short circuit power (VA)
UnQ = 22000;                % Nominal voltage (V)
RQ = 0;                     % Resistance (Ohm)

% Transformer T1
SrT = 15e6;                 % Rated power (VA)
ukT_percent = 10;           % Short circuit voltage (%)
RT = 0;                     % Resistance (Ohm)
trT = 22000/6000;           % Ratio

% Overhead Line V1
RV1 = 0;
XV1 = 0.485;                % Reactance (Ohm)

% Generator G
SrG = 25e6;                 % Rated power (VA)
xdG = 0.135;                % Subtransient reactance (pu)
UrG = 6000;                 % Rated voltage (V)
RG = 0;

% Overhead Line V2 (Connects to passive load - ignored for Ik'')
XV2 = 0.364;

% --- Calculations ---

% 1. Feeder Impedance (Referenced to 6 kV)
% Formula: Z = c * U^2 / Sk
Z_Q_mag = (c * U_ref^2) / SkQ;
Z_Q = complex(0, Z_Q_mag);

% 2. Transformer Impedance (Referenced to 6 kV)
% Formula: Z = (uk%/100) * U^2 / Sr
Z_T_mag = (ukT_percent / 100) * (U_ref^2 / SrT);
Z_T = complex(0, Z_T_mag);

% 3. Generator Impedance
% Formula: Z = xd * U^2 / Sr
Z_G_mag = xdG * (UrG^2 / SrG);
Z_G = complex(0, Z_G_mag);

% 4. Line V1 Impedance
Z_V1 = complex(RV1, XV1);

% --- Branch Analysis ---
% Branch 1: Feeder + Transformer
Z_Branch1 = Z_Q + Z_T;

% Branch 2: Generator + Line V1
Z_Branch2 = Z_G + Z_V1;

% Total Impedance Zk (Branches in parallel)
% Zk = (Z1 * Z2) / (Z1 + Z2)
Z_k = (Z_Branch1 * Z_Branch2) / (Z_Branch1 + Z_Branch2);

% --- Current Calculation ---
% Ik'' = c * Un / (sqrt(3) * |Zk|)
Ik_double_prime = (c * U_ref) / (sqrt(3) * abs(Z_k));

% --- Display Results ---
fprintf('--- Calculation Results ---\n');

% Function to print in polar form
print_polar = @(name, val) fprintf('%s = %.3f /_ %.2f deg Ohm\n', name, abs(val), rad2deg(angle(val)));

print_polar('Z_Q (Feeder)', Z_Q);
print_polar('Z_T (Transformer)', Z_T);
print_polar('Z_G (Generator)', Z_G);
print_polar('Z_k (Total Impedance)', Z_k);

fprintf('---------------------------\n');
fprintf('Initial Symmetrical Short-Circuit Current Ik'':\n');
fprintf('Ik'' = %.3f kA\n', Ik_double_prime / 1000);
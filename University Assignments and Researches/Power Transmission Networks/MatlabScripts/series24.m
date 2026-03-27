clc, clear all 
format shorteng

%Point 3 data:

P3=175e6;                       %W
U3l=220e3;                      %V
cosf3=0.85;                     %-

%Point 3 mesurements calculations:

f3=acos(cosf3);                 %rad
sinf=sin(f3);                   %-
Q3=tan(f3)*P3;                  %VAr
S3=P3+Q3*1j;                    %VA
U3f=U3l/sqrt(3);                %V
I3=conj(S3/(U3l*sqrt(3)));      %A

%Line 2 parameters:

z2=0.421j;                      %Ω/km
y2=2.64e-6j;                    %S/km
x2=70;                           %km

%Line 2 ABCD matrix calculation (use distributed parameters model):

g=sqrt(z2*y2);                  %km^-1
Zc=sqrt(z2/y2);                 %Ω
A2=cosh(g*x2);                  %-
B2=sinh(g*x2)*Zc;               %Ω
C2=(sinh(g*x2))/Zc;             %S
D2=A2;                          %-
ABCD2=[A2 B2; C2 D2];

%Point 2 Voltage and current calculation:

U3I3=[U3f; I3];                 %Using phase voltage!
U2I2=ABCD2*U3I3;

%Line 1 parameters:

z1=0.41*exp(1j*(85*pi/180));     %Ω/km
y1=2.64e-6j;                     %S/km
x1=70;                           %km

%Line 1 ABCD matrix calculation (Use T-line model):

Z=z1*x1;
Y=y1*x1;
A1=1+((Z*Y)/2);
B1=1+((Z*Y)/4);
C1=Y;
D1=A1;
ABCD1=[A1 B1; C1 D1];

%Point 1 Voltage and current calculation:

U1I1=ABCD1*U2I2;                %Using ABCD1 and point 2 current and voltage

ABCDcel=ABCD1*ABCD2;            %Using ABCDcel and piont 3 current and voltage
U1I1cel=ABCDcel*U3I3;

fprintf('Phase voltage at point 3:  ')
fprintf('%.2f ∠ %.2f° V\n', abs(U3I3(1:1)), rad2deg(angle(U3I3(1:1))))
fprintf('Line voltage at point 3:   ')
fprintf('%.2f ∠ %.2f° V\n', abs(U3I3(1:1)*sqrt(3)), rad2deg(angle(U3I3(1:1))))
fprintf('Current at point 3:        ')
fprintf('%.2f ∠ %.2f° A\n\n', abs(U3I3(2:2)), rad2deg(angle(U3I3(2:2))))

fprintf('Phase voltage at point 2:  ')
fprintf('%.2f ∠ %.2f° V\n', abs(U2I2(1:1)), rad2deg(angle(U2I2(1:1))))
fprintf('Line voltage at point 2:   ')
fprintf('%.2f ∠ %.2f° V\n', abs(U2I2(1:1)*sqrt(3)), rad2deg(angle(U2I2(1:1))))
fprintf('Current at point 2:        ')
fprintf('%.2f ∠ %.2f° A\n\n', abs(U2I2(2:2)), rad2deg(angle(U2I2(2:2))))

fprintf('Usig ABCD2 than ABCD1\n')
fprintf('Phase voltage at point 1:  ')
fprintf('%.2f ∠ %.2f° V\n', abs(U1I1(1:1)), rad2deg(angle(U1I1(1:1))))
fprintf('Line voltage at point 1:   ')
fprintf('%.2f ∠ %.2f° V\n', abs(U1I1(1:1)*sqrt(3)), rad2deg(angle(U1I1(1:1))))
fprintf('Current at point 1:        ')
fprintf('%.2f ∠ %.2f° A\n\n', abs(U1I1(2:2)), rad2deg(angle(U1I1(2:2))))

fprintf('Using ABCDcel\n')
fprintf('Phase voltage at point 1:  ')
fprintf('%.2f ∠ %.2f° V\n', abs(U1I1cel(1:1)), rad2deg(angle(U1I1cel(1:1))))
fprintf('Line voltage at point 1:   ')
fprintf('%.2f ∠ %.2f° V\n', abs(U1I1cel(1:1)*sqrt(3)), rad2deg(angle(U1I1cel(1:1))))
fprintf('Current at point 1:        ')
fprintf('%.2f ∠ %.2f° A\n', abs(U1I1cel(2:2)), rad2deg(angle(U1I1cel(2:2))))

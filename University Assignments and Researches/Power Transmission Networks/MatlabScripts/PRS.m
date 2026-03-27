
clc, clear all 
format short 
Ur=220e3;  %V
fp=0.85; %Power factor at lag
P=175e6; %Active power
phi=acos(0.85); %Power Factor angle in radians
phideg=rad2deg(phi); %Power Factor angle in degrees

% Calculations

S=P/cos(phi); %Aparent Power
Scomplex=S*exp(1j*phi); % Complex aparent power in polar format
fprintf('%.2f ∠ %.2f°\n', abs(Scomplex), rad2deg(angle(Scomplex)))

I3=conj(Scomplex)/(Ur*sqrt(3)); %I3 computation
fprintf('%.2f ∠ %.2f°\n', abs(I3), rad2deg(angle(I3)))
VrIr=[Ur;I3];
%

z=-0.421j;           %Ω=km
y=2.6389e-6j;       %S/km
x=70;              %km
%S=P/cosf;
%Ir=S/Ur*sqrt(3);

g=sqrt(z*y);
Zc=sqrt(z/y);
A2=cosh(g*x);
B2=Zc*sinh(g*x);
C2=(1/Zc)*sinh(g*x);
D2=A2;

M21=[A2 B2; C2 D2]
%M22=[Ur; Ir]; % First Mistake 
%M2=M21*M22;

A1=1;
B1=21.049j;
C1=0.132e-3j;
D1=0.997;

M11=[A1 B1; C1 D1];
ABCDcel=M11*M21

VsIs=ABCDcel*VrIr;

% Print in polar
fprintf('VsIs en polar:\n');
for k = 1:length(VsIs)
    fprintf('%.2f ∠ %.2f°\n', abs(VsIs(k)), rad2deg(angle(VsIs(k))));
end

% Print in rectangular
fprintf('VsIs in rectangular:\n');
for k = 1:length(VsIs)
    fprintf('%.2f + %.2fj\n', real(VsIs(k)), imag(VsIs(k)));
end






function [ xNext ] = plant_step( xOld, u, Ts, k, pars )
%PLANT_STEP returns the next state of the plant.
%   This is the simulation function of the plant.
% INPUTS:
%   x   : current state of the plant
%   u   : input
%   Ts  : sampling time in seconds
%   k   : current time step
%   pars: parameters of the plant model
%
% OUTPUTS:
%  xNext: state of the plant at step k+1

syms x(t) y(t) X(t) Y(t) p(t);

% Initialization of working variables
x_value = xOld(1);
Dx_value = xOld(2);
y_value = xOld(3);
Dy_value = xOld(4);
p_value = xOld(5);
Dp_value = xOld(6);
X_value = xOld(7);
Y_value = xOld(8);

% Initialization of car's geometrics
m = pars.m; % 1000?
I = pars.I; % 300?
g = pars.g; % 9.81?
a = pars.a; % 1?
b = pars.b; % 1?

% Nominal forces on front and rear wheels
F_z_f = (b*m*g) / (2*(a+b));
F_z_r = (a*m*g) / (2*(a+b));

delta_f = u; % Front axis steering angle
delta_r = 0; % Rear axis steering angle

% Wheel's equations update
v_y_f = Dy_value+a*Dp_value;
v_y_r = Dy_value-b*Dp_value;
v_x_f = Dx_value;
v_x_r = Dx_value;

v_l_f = v_y_f*sind(delta_f)+v_x_f*cosd(delta_f);
v_l_r = v_y_r*sind(delta_r)+v_x_r*cosd(delta_r);
v_c_f = v_y_f*cosd(delta_f)-v_x_f*sind(delta_f);
v_c_r = v_y_r*cosd(delta_r)-v_x_r*sind(delta_r);

%disp(v_y_f);

% Parameters for Pacejka tire model (l: longitudinal, c: lateral)
% Taken from: http://www.edy.es/dev/docs/pacejka-94-parameters-explained-a-comprehensive-guide/

% % Lateral force at the car's front
% a0_c_f = 1.4;
% a1_c_f = 0;
% a2_c_f = 1.100;
% a3_c_f = 1100;
% a4_c_f = 0.01;
% a5_c_f = 0;
% a6_c_f = 0;
% a7_c_f = -2;
% a8_c_f = 0;
% a9_c_f = 0;
% a10_c_f = 0;
% a11_c_f = 0;
% a12_c_f = 0;
% a13_c_f = 0;
% a14_c_f = 0;
% a15_c_f = 0;
% a16_c_f = 0;
% a17_c_f = 0;
% slipAngle_c_f = atand(v_c_f/v_l_f);
% H_c_f = a8_c_f*F_z_f+a9_c_f+a10_c_f*delta_f;
% C_c_f = a0_c_f;
% D_c_f = F_z_f*(a1_c_f*F_z_f+a2_c_f)*(1-a15_c_f*delta_f);
% B_c_f = (a3_c_f*sind(atand(F_z_f/a4_c_f)*2)*(1-a5_c_f*abs(delta_f)));
% E_c_f = (a6_c_f*F_z_f+a7_c_f)*(1-(a16_c_f*delta_f+a17_c_f)*sign(slipAngle_c_f+H_c_f));
% Bx1_c_f = B_c_f*(slipAngle_c_f+H_c_f);
% V_c_f = a11_c_f*F_z_f+a12_c_f+(a13_c_f*F_z_f+a14_c_f)*delta_f*F_z_f;
% F_c_f = D_c_f * sind(C_c_f * atand(Bx1_c_f - E_c_f * (Bx1_c_f - atand(Bx1_c_f)))) + V_c_f;
% 
% % Lateral force at the car's rear
% a0_c_r = 1.4;
% a1_c_r = 0;
% a2_c_r = 1.100;
% a3_c_r = 1100;
% a4_c_r = 0.01;
% a5_c_r = 0;
% a6_c_r = 0;
% a7_c_r = -2;
% a8_c_r = 0;
% a9_c_r = 0;
% a10_c_r = 0;
% a11_c_r = 0;
% a12_c_r = 0;
% a13_c_r = 0;
% a14_c_r = 0;
% a15_c_r = 0;
% a16_c_r = 0;
% a17_c_r = 0;
% slipAngle_c_r = atand(v_c_r/v_l_r);
% H_c_r = a8_c_r*F_z_r+a9_c_r+a10_c_r*delta_r;
% C_c_r = a0_c_r;
% D_c_r = F_z_r*(a1_c_r*F_z_r+a2_c_r)*(1-a15_c_r*delta_r);
% B_c_r = (a3_c_r*sind(atand(F_z_r/a4_c_r)*2)*(1-a5_c_r*abs(delta_r)));
% E_c_r = (a6_c_r*F_z_r+a7_c_r)*(1-(a16_c_r*delta_r+a17_c_r)*sign(slipAngle_c_r+H_c_r));
% Bx1_c_r = B_c_r*(slipAngle_c_r+H_c_r);
% V_c_r = a11_c_r*F_z_r+a12_c_r+(a13_c_r*F_z_r+a14_c_r)*delta_r*F_z_r;
% F_c_r = D_c_r * sind(C_c_r * atand(Bx1_c_r - E_c_r * (Bx1_c_r - atand(Bx1_c_r)))) + V_c_r;
% 
% % Longitudinal force at the car's rear
% a0_l_r = 1.5;
% a1_l_r = 0;
% a2_l_r = 1.100;
% a3_l_r = 0;
% a4_l_r = 300;
% a5_l_r = 0;
% a6_l_r = 0;
% a7_l_r = -0;
% a8_l_r = -2;
% a9_l_r = 0;
% a10_l_r = 0;
% a11_l_r = 0;
% a12_l_r = 0;
% a13_l_r = 0;
% slipAngle_l_r = atand(v_c_r/v_l_r);
% H_l_r = a9_l_r*F_z_r+a10_l_r;
% C_l_r = a0_l_r;
% D_l_r = F_z_r*(a1_l_r*F_z_r+a2_l_r);
% B_l_r = ((a3_l_r*F_z_r^2+a4_l_r*F_z_r)*exp(-a5_l_r*F_z_r))/(C_l_r*D_l_r);
% E_l_r = (a6_l_r*F_z_r^2+a7_l_r*F_z_r+a8_l_r)*(1-a13_l_r*sign(slipAngle_l_r+H_l_r));
% Bx1_l_r = B_l_r*(slipAngle_l_r+H_l_r);
% V_l_r = a11_l_r*F_z_r+a12_l_r;
% F_l_r = D_l_r * sind(C_l_r * atand(Bx1_l_r - E_l_r * (Bx1_l_r - atand(Bx1_l_r)))) + V_l_r;
% 
% % Longitudinal force at the car's rear
% a0_l_f = 1.5;
% a1_l_f = 0;
% a2_l_f = 1.100;
% a3_l_f = 0;
% a4_l_f = 300;
% a5_l_f = 0;
% a6_l_f = 0;
% a7_l_f = -0;
% a8_l_f = -2;
% a9_l_f = 0;
% a10_l_f = 0;
% a11_l_f = 0;
% a12_l_f = 0;
% a13_l_f = 0;
% slipAngle_l_f = atand(v_c_f/v_l_f);
% H_l_f = a9_l_f*F_z_f+a10_l_f;
% C_l_f = a0_l_f;
% D_l_f = F_z_f*(a1_l_f*F_z_f+a2_l_f);
% B_l_f = ((a3_l_f*F_z_f^2+a4_l_f*F_z_f)*exp(-a5_l_f*F_z_f))/(C_l_f*D_l_f);
% E_l_f = (a6_l_f*F_z_f^2+a7_l_f*F_z_f+a8_l_f)*(1-a13_l_f*sign(slipAngle_l_f+H_l_f));
% Bx1_l_f = B_l_f*(slipAngle_l_f+H_l_f);
% V_l_f = a11_l_f*F_z_f+a12_l_f;
% F_l_f = D_l_f * sind(C_l_f * atand(Bx1_l_f - E_l_f * (Bx1_l_f - atand(Bx1_l_f)))) + V_l_f;

% Lateral / front
a1_c = -22.1;
a2_c = 1011;
a3_c = 1078;
a4_c = 1.82;
a5_c = 0.208;
a6_c = 0.000;
a7_c = -0.354;
a8_c = 0.707;
a9_c = 0.028;
a10_c = 0.000;
a11_c = 14.8;
C_c_f = 1.3;
D_c_f = a1_c*F_z_f^2+a2_c*F_z_f;
B_c_f = (a3_c*sind(a4_c*atand(a5_c*F_z_f)))/(C_c_f*D_c_f);
E_c_f = a6_c*F_z_f^2+a7_c*F_z_f+a8_c;
Sh_c_f = a9_c*delta_f;
Sv_c_f = (a10_c*F_z_f^2+a11_c*F_z_f)*delta_f;
slip_c_f = atand(v_c_f/v_l_f);
phi_c_f = (1-E_c_f)*(slip_c_f+Sh_c_f)+atand(B_c_f*(slip_c_f+Sh_c_f))*(E_c_f/B_c_f);
F_c_f = D_c_f*sind(C_c_f*atand(B_c_f*phi_c_f))+Sv_c_f;

% Lateral / rear
C_c_r = 1.3;
D_c_r = a1_c*F_z_r^2+a2_c*F_z_r;
B_c_r = (a3_c*sind(a4_c*atand(a5_c*F_z_r)))/(C_c_r*D_c_r);
E_c_r = a6_c*F_z_r^2+a7_c*F_z_r+a8_c;
Sh_c_r = a9_c*delta_r;
Sv_c_r = (a10_c*F_z_r^2+a11_c*F_z_r)*delta_r;
slip_c_r = atand(v_c_r/v_l_r);
phi_c_r = (1-E_c_r)*(slip_c_r+Sh_c_r)+atand(B_c_r*(slip_c_r+Sh_c_r))*(E_c_r/B_c_r);
F_c_r = D_c_r*sind(C_c_r*atand(B_c_r*phi_c_r))+Sv_c_r;

% Longitudinal / front
a1_l = 21.3;
a2_l = 1144;
a3_l = 49.6;
a4_l = 226;
a5_l = 0.069;
a6_l = -0.006;
a7_l = 0.056;
a8_l = 0.486;
C_l_f = 1.65;
D_l_f = a1_l*F_z_f^2+a2_l*F_z_f;
B_l_f = (a3_l*F_z_f^2+a4_l*F_z_f)/(exp(a5_l*F_z_f)*C_l_f*D_l_f);
E_l_f = a6_l*F_z_f^2+a7_l*F_z_f+a8_l;
slip_l_f = atand(v_c_f/v_l_f);
phi_l_f = (1-E_l_f)*slip_l_f+atand(B_l_f*slip_l_f*(E_l_f/B_l_f));
F_l_f = D_l_f*sind(C_l_f*atand(B_l_f*phi_l_f));

% Longitudinal / rear
C_l_r = 1.65;
D_l_r = a1_l*F_z_r^2+a2_l*F_z_r;
B_l_r = (a3_l*F_z_r^2+a4_l*F_z_r)/(exp(a5_l*F_z_r)*C_c_r*D_l_r);
E_l_r = a6_l*F_z_r^2+a7_l*F_z_r+a8_l;
slip_l_r = atand(v_c_r/v_l_r);
phi_l_r = (1-E_l_r)*slip_l_r+atand(B_l_r*slip_l_r*(E_l_r/B_l_r));
F_l_r = D_l_r*sind(C_l_r*atand(B_l_r*phi_l_r));

% Complete force formulas
F_x_f = F_l_f*cosd(delta_f)-F_c_f*sind(delta_f);
F_x_r = F_l_r*cosd(delta_r)-F_c_r*sind(delta_r);
F_y_f = F_l_f*sind(delta_f)+F_c_f*cosd(delta_f);
F_y_r = F_l_r*sind(delta_r)+F_c_r*cosd(delta_r);

% Physical equations
eq1 = m*diff(x, 2) == m*diff(y)*diff(p)+2*F_x_f+2*F_x_r;
eq2 = m*diff(y, 2) == -m*diff(x)*diff(p)+2*F_y_f+2*F_y_r;
eq3 = I*diff(p, 2) == -m*diff(x)*diff(p)+2*F_y_f+2*F_y_r;
eq4 = diff(X) == diff(x)*cos(p)*(pi/180)-diff(y)*sin(p)*(pi/180);
eq5 = diff(Y) == diff(x)*sin(p)*(pi/180)+diff(y)*cos(p)*(pi/180);

[rightSideOfODE, subs] = odeToVectorField(eq1, eq2, eq3, eq4, eq5);
func = matlabFunction(rightSideOfODE, 'vars', {'t','Y'});

%disp(subs);

t_horizon = [k k+Ts];
init_values = [p_value; Dp_value; x_value; Dx_value; y_value; Dy_value; X_value; Y_value];
[tout, Yout] = ode45(func, t_horizon, init_values);

% Update the working variables
x_values = Yout(:, 3);
xNext(1) = x_values(end);
disp(Yout);
Dx_values = Yout(:, 4);
xNext(2) = Dx_values(end);
y_values = Yout(:, 5); 
xNext(3) = y_values(end);
Dy_values = Yout(:, 6);
xNext(4) = Dy_values(end);
p_values = Yout(:, 1);
xNext(5) = p_values(end);
Dp_values = Yout(:, 2);
xNext(6) = Dp_values(end);
X_values = Yout(:, 7);
xNext(7) = X_values(end);
Y_values = Yout(:, 8);
xNext(8) = Y_values(end);

end


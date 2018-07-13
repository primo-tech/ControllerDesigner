clear;
clc;

data = importdata('TFData.txt');
t = [0:0.01:0.74];
y = -1*data(1:75);
figure(1)
plot(t,y);
grid on;

x = t';

figure(2)
data = [x,y];
a0=[0; 1]; % initial value
a = lsqnonlin(@(a)myfunction(a,data),a0);
ybar =  a(1)*(1 - exp(-1*a(2)*x)); % calculate the values from the fitted model
plot(x,y,'r+',x, ybar,'b-','LineWidth',1, 'MarkerSize',10); 
grid on;
% simultaneously display the experimental 

%%
Tra = 0.1;
K = 22;

%% Calculating The Transfer Function
zeta = 2.5;
%wn = (2.16*zeta + 0.6)/2.16  %when 0.3<= zeta <=0.7
wn = 2.5*pi/Tra;             %when 0.7<= zeta <=4
A = (wn^2)*K;
B = 2*zeta*wn;
C = wn^2;

G = tf(A,[1 B C]);

figure(3)
step(G*100)
grid on;

%% Determining The PI Controller Gains

PO = 10;    %Percentage overshoot
Tr = 0.005;   % rise-time

Zeta = sqrt((log(PO/100)^2)/((log(PO/100)^2)+(pi^2))); %Damping Ratio
Wn = (2.16*Zeta + 0.6)/Tr; %Natural Frequency
Po = 10*Zeta*Wn;

%% PID

Kd = ((Po+(2*Zeta*Wn)-B)/A);
Kp = (((2*Zeta*Wn*Po)+(Wn^2) - C)/A);
Ki = (((Po)*(Wn^2))/A);

%% PI
%Ki = (((Wn^2)*Po)/(A));  % Integral Gain
%Kp = (2*Zeta*Wn*(Po));               % Proportional gain
%%
Gc = tf([Kd Kp Ki],[1 0]);

X = ((G*Gc)/(1+(G*Gc)));
figure(4)
step(X)
stepinfo(X)

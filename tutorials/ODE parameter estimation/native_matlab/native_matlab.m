%% native matlab ODE solvers
% first investigate which solver is best for your problem.
% stiff problem
mu = 1e6;
odefcn = @(t,y) vdp(t,y,mu);
tspan = [0.0 5.0];
y0 = [0.0 2.0];
%Non-stiff solver
tic
[t,y] = ode45(odefcn, tspan, y0);
toc
figure
plot(t,y)
ylim([-4,4])
%Stiff solver
tic
[t,y] = ode15s(odefcn, tspan, y0);
toc
hold on 
plot(t,y)
% Which solver is better can vary in the parameter space
% non-stiff problem
mu = 15;
odefcn = @(t,y) vdp(t,y,mu);
tspan = [0.0 5.0];
y0 = [0.0 2.0];
%Non-stiff solver
tic
[t,y] = ode45(odefcn, tspan, y0);
toc
figure
plot(t,y)
ylim([-4,4])
%Stiff solver
tic
[t,y] = ode15s(odefcn, tspan, y0);
toc
hold on
plot(t,y)
%% native matlab parameter estimation
% generate some data
mu = 15; % real parameter
odefcn = @(t,y) vdp(t,y,mu);
tspan = 0:0.05:5;
y0 = [0.0 2.0];
[t,y] = ode45(odefcn, tspan, y0);
rng(1234) % fix rng for repreducability
noise = randn(size(y))*0.05;
y_m = y+noise; % measured y
figure 
plot(t,y_m,'*');
hold on 
plot(t,y)
ylim([-4,4]);
% estimate mu
obj = @(mu) lsq(mu,tspan,y0,y_m);

mu_guess = 50
mu_est = fmincon(obj,mu_guess,[],[]) % goes wrong...

mu_guess = 12
mu_est = fmincon(obj,mu_guess,[],[]) % only works when you have a good initial guess

obj_plot = [];
theta_plot = 0:0.01:50;
for k = theta_plot
    obj_plot = [obj_plot;obj(k)];
end
figure
plot(theta_plot,obj_plot) % tons of local minima => global optimization needed



    
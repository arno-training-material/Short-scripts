% This tutorial does not work on matlab 2018a and higher, nor does it work on 2016b and below.
% I've specifically tested 2017b on windows 10 
mex -setup -v % check if you have a compiler installed.
% if no compiler is found install Visual Studio 17 community:
% https://visualstudio.microsoft.com/vs/older-downloads/
% The latest edition visual studio 19 does not seem to work.
% windows 7 does not work

% make sure the working directory is set to the folder containing this file 

system_description = 'vdp_syms'; % name of the file you describe the system in
addpath(genpath(pwd())); % make sure matlab knows where AMICI and MEIGO are located
name_compiled = 'vdp'; %used for the name of the generated file
store_location = pwd(); % location where compiled file is stored
amiwrap(name_compiled,system_description,store_location)

% simuluate the system
Int_opts.sensi = 0; % Sensitivity order.
% first order sensitivities are needed for gradient based optimization,
% enhanced scatter search does not absolutely require it,
% since it is a zero'th order method during the global part of the algorithm,
% but it could help during the local part of the algorithm, but that is more complicated
mu_true = [15];
time_measurements = 0:0.05:5; % times at which measurements are taken
tic 
sol = simulate_vdp(time_measurements,mu_true,[],[],Int_opts);
toc
y = sol.x;
figure
plot(time_measurements,y)
ylim([-4,4]);
% parameter estimiation example
rng(1234) % fix rng for repreducability
noise = randn(size(y))*0.05;
y_m = y+noise; % measured y
hold on
plot(time_measurements,y_m,'*')
MEIGO_options.maxeval = 1000; % Maximum number of function evaluations. (scaler)
MEIGO_options.local.solver = 'dhc'; % Local solver.

problem.f = 'lsq'; % optimization objective
problem.x_L = [0]; % most global solvers need a lower and upper bound for the parameters
problem.x_U = [100];
problem.x_0 = [50]; % Initial guess.

Results = MEIGO(problem, MEIGO_options, 'ESS', time_measurements,y_m, Int_opts);

% much larger noise
rng(1234) % fix rng for repreducability
noise = randn(size(y));
y_m = y+noise; % measured y
figure,
plot(time_measurements,y)
ylim([-4,4]);
hold on
plot(time_measurements,y_m,'*')
MEIGO_options.maxeval = 1000; % Maximum number of function evaluations. (scaler)
MEIGO_options.local.solver = 'dhc'; % Local solver.

problem.f = 'lsq'; % optimization objective
problem.x_L = [0]; % most global solvers need a lower and upper bound for the parameters
problem.x_U = [100];
problem.x_0 = [50]; % Initial guess.

Results = MEIGO(problem, MEIGO_options, 'ESS', time_measurements,y_m, Int_opts);


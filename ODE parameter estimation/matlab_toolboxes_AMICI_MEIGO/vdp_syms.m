function [model] = vdp_syms()
% The following two options are to calculate parameter sensitivities needed for gradient based optimization
% The enhanced scatter search algorithm we will use for optimization only
% slightly benifits from having gradients available, thus we do not use it
% for this tutorial.
%model.forward = false; 
%model.adjoint = false;

% define dynamical states
syms state1 state2
model.sym.x = [state1 state2];

% define parameters to be estimated
syms mu
model.sym.p = [mu];

% if you have additional known parameters you can also define:

% syms const1 const2
% model.sym.k = [const1, const2]

% if your differential equation explicitly depends on time you also need

%syms t 
% you can use this for functions like heaviside(t-3600) if you have some
% step input that happens after 1 hour
%http://icb-dcm.github.io/AMICI/symbolic__functions_8cpp.html

% define system dynamics
model.sym.xdot(1) = [mu*((1-state2^2)*state1 -state2)];
model.sym.xdot(2) = [state1];

%define initial conditions
model.sym.x0 = [0.0, 2.0];

%define observables 
%Often not all dyanmic states are measured (but in our easy example they are)
%or they are not directly measured

%model.sym.y(1) = [state1 + state2];
model.sym.y = [];
end


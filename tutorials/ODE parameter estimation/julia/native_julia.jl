## native julia ODE solvers
using Pkg
Pkg.add("DifferentialEquations")
Pkg.add("DiffEqParamEstim")
Pkg.add("NLopt")
Pkg.add("Random")

using DifferentialEquations
using DiffEqParamEstim
using NLopt
using Random

function vdp(dydt,y,mu,t)
    dydt[1] = mu[1]*((1-y[2]^2)*y[1] - y[2])
    dydt[2] = y[1]
end
mu_stiff = [1e6]
mu_non_stiff = [10.0]
tspan = (0.0, 5.0)
y0 = [0.0 2.0]

prob_stiff = ODEProblem(vdp,y0,tspan,mu_stiff)
prob_non_stiff = ODEProblem(vdp,y0,tspan,mu_non_stiff)

sol_stiff = solve(prob_stiff,AutoTsit5(Rosenbrock23()))
sol_non_stiff = solve(prob_non_stiff,AutoTsit5(Rosenbrock23()))

@time solve(prob_stiff,Tsit5()); #Tsit5 does not work on stiff problems
@time solve(prob_stiff,Rosenbrock23()); #Rosenbrock23 works on stiff problems

@time solve(prob_non_stiff,Tsit5()); #does work on non-stiff problems
@time solve(prob_non_stiff,Rosenbrock23()); #Rosenbrock23 is slow on non-stiff problems

@time solve(prob_stiff,AutoTsit5(Rosenbrock23()));
@time solve(prob_non_stiff,AutoTsit5(Rosenbrock23())); #AutoTsit5(Rosenbrock23()) works for both stiff and non-stiff problems

## parameter estimation
mu = [15.0] #real mu
tspan = (0.0,5.0)
y0 = [0.0 2.0];
prob = ODEProblem(vdp,y0,tspan,mu)
sol = solve(prob, AutoTsit5(Rosenbrock23()), saveat = 0.0:0.05:5.0)
t = sol.t
y = vcat(sol.u...)
Random.seed!(1234) # fix rng for repreducability
noise = randn(size(y))*0.05
y_m = y+noise; # measured y

cost_function = build_loss_objective(prob,AutoTsit5(Rosenbrock23()),L2Loss(t,y_m'), maxiters=10000,verbose=false)

#local optimization
opt = Opt(:LN_COBYLA, 1)
min_objective!(opt, cost_function)
(minf,mu_est,ret) = NLopt.optimize(opt,[50.0]) #does not work
(minf,mu_est,ret) = NLopt.optimize(opt,[12.0]) #works
#global optimization
opt = Opt(:GN_ESCH, 1)
min_objective!(opt, cost_function)
lower_bounds!(opt,[0.0])
upper_bounds!(opt,[100.0])
maxeval!(opt, 1000)
(minf,mu_est,ret) = NLopt.optimize(opt,[50.0]) #WORKS
